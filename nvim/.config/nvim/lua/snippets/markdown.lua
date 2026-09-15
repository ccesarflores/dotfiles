local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local rep = require("luasnip.extras").rep

-- Función para obtener la fecha/hora como ID
local function get_id()
	return os.date("%Y%m%d%H%M")
end

-- Función auxiliar para obtener la fecha actual en formato YYYY-MM-DD
local function date_str()
	return os.date("%Y-%m-%d")
end

ls.add_snippets("markdown", {

	-- snippet para template frontmatter
	s("yaml", {
		t({ "---", "id: " }),
		f(get_id),
		t({ "", "title: " }),
		i(1, "título"),
		t({ "", "aliases: [" }),
		i(2),
		t({ "]", "tags: [" }),
		i(3),
		t({ "]", "created: " }),
		f(date_str),
		t({ "", "---", "" }),
		i(0),
	}),

	-- snippet para template de moc para una unidades de una materia o curso
	s("unitmoc", {
		-- Frontmatter YAML
		t({ "---", "id: " }),
		f(get_id),
		t({ "", 'title: "Unit ' }),
		i(1, "1"),
		t({ ": " }),
		i(2, "Unit Name"),
		t({ '"', 'course: "' }),
		i(3, "Course Name"),
		t({ '"', "type: moc", "created: " }),
		f(date_str),
		t({ "", "tags:", "  - moc", "  - cs/" }),
		i(4, "topic"),
		t({ "", "  - university", "status: draft", "---", "", "" }),

		-- Encabezado principal (repite dinámicamente el nodo 1 y 2 sin errores de nil)
		t("# Unit "),
		rep(1),
		t(": "),
		rep(2),
		t({ "", "", "## Overview & Objectives", "" }),
		i(5, "- Main goal or summary of this unit."),
		t({ "", "", "## Key Concepts & Zettels", "" }),
		t("- [["),
		i(6, "Concept_or_Note_1"),
		t("]] - "),
		i(7, "Brief explanation"),
		t({ "", "- [[" }),
		i(8, "Concept_or_Note_2"),
		t("]] - "),
		i(9, "Brief explanation"),
		t({ "", "", "## Core Topics", "", "### 1. Theoretical Foundations", "" }),
		i(10, "Definitions, theorems, or mathematical bounds (e.g., $O(n \\log n)$)."),
		t({ "", "", "### 2. Algorithms & Data Structures", "" }),
		i(11, "Pseudocode, complexity analysis, edge cases."),
		t({ "", "", "## Practice & Labs", "" }),
		t("- [ ] "),
		i(12, "Problem Set / Lab Assignment"),
		t({ "", "", "## References & Further Reading", "" }),
		t("- "),
		i(13, "Book / Paper / Lecture Slide reference"),
		t({ "", "" }),
	}),

	-- snippet para template de moc para una materia o curso
	s("course", {
		-- Frontmatter YAML para la materia global
		t({ "---", "id: " }),
		f(get_id),
		t({ "", 'title: "' }),
		i(1, "Course Name"),
		t({ '"', 'code: "' }),
		i(2, "CC101"),
		t({ '"', "type: course-overview", "created: " }),
		f(date_str),
		t({ "", "tags:", "  - course", "  - cs/" }),
		i(3, "category"),
		t({ "", "status: active", "---", "", "" }),

		-- Título de la materia y descripción
		t("# "),
		rep(1),
		t(" ("),
		rep(2),
		t({ ")", "", "", "## Description & Syllabus" }),
		t({ "", "" }),
		i(4, "Brief description of the course, main objectives, and evaluation methods."),
		t({ "", "", "## Units / MOCs", "" }),
		t("- [["),
		i(5, "Unit_01_Name"),
		t("]] - "),
		i(6, "Unit description or main topics"),
		t({ "", "- [[" }),
		i(7, "Unit_02_Name"),
		t("]] - "),
		i(8, "Unit description or main topics"),
		t({ "", "- [[" }),
		i(9, "Unit_03_Name"),
		t("]] - "),
		i(10, "Unit description or main topics"),
		t({ "", "", "## Resources & Bibliography", "" }),
		t("- "),
		i(11, "Main textbook or official course website"),
		t({ "", "", "## Useful Links", "" }),
		t("- [["),
		i(12, "Exam_Dates_and_Notes"),
		t("]]", ""),
	}),

	-- snippet para template de moc para una carrera
	s("hub", {
		-- Frontmatter YAML
		t({ "---", "id: " }),
		f(get_id),
		t({ "", 'title: "' }),
		i(1, "Computer Science Index"),
		t({ '"', "type: hub", "created: " }),
		f(date_str),
		t({ "", "tags:", "  - hub", "  - university/cs", "status: active", "---", "", "" }),

		-- Título principal
		t("# "),
		rep(1),
		t({ "", "", "## Overview", "" }),
		i(2, "Master Index for all Computer Science courses and degree progress."),
		t({ "", "", "## Courses by Term / Year", "" }),

		-- Año 1
		t({ "### First Year", "" }),
		t("- [["),
		i(3, "Course_Name_1"),
		t("]] - "),
		i(4, "Code/Short Info"),
		t({ "", "" }),
		t("- [["),
		i(5, "Course_Name_2"),
		t("]] - "),
		i(6, "Code/Short Info"),
		t({ "", "", "" }),

		-- Año 2
		t({ "### Second Year", "" }),
		t("- [["),
		i(7, "Course_Name_3"),
		t("]] - "),
		i(8, "Code/Short Info"),
		t({ "", "" }),
		t("- [["),
		i(9, "Course_Name_4"),
		t("]] - "),
		i(10, "Code/Short Info"),
		t({ "", "", "" }),

		-- Año 3
		t({ "### Third Year", "" }),
		t("- [["),
		i(11, "Course_Name_5"),
		t("]] - "),
		i(12, "Code/Short Info"),
		t({ "", "", "" }),

		-- Tabla dinámica automática mediante Dataview (Obsidian)
		t({ "## Automatic Course Index (Dataview)", "" }),
		t({ "```dataview", 'TABLE code AS "Code", status AS "Status", tags AS "Tags"' }),
		t({ "", "FROM #course OR [[]]", 'WHERE type = "course-overview"' }),
		t({ "", "SORT code ASC", "```", "" }),
	}),

	s("lecture", {
		-- Frontmatter YAML
		t({ "---", "id: " }),
		f(get_id),
		t({ "", 'title: "' }),
		i(1, "Topic / Main Subject"),
		t({ '"', 'course: "' }),
		i(2, "Course Name"),
		t({ '"', "aliases: [" }),
		i(3, "Lecture 01, Clase 1"),
		t({ "]", "type: lecture", "date: " }),
		f(date_str),
		t({ "", "tags:", "  - lecture", "  - cs/" }),
		i(4, "topic"),
		t({ "", "status: raw", "---", "", "" }),

		-- Título y contexto
		t("# "),
		rep(1),
		t({ "", "", "**Course:** [[" }),
		rep(2),
		t("]] | **Unit:** [["),
		i(5, "Unit_MOC"),
		t({ "]]", "", "" }),

		-- Resumen rápido / Cues (Método Cornell)
		t({ "## Summary & Key Cues", "" }),
		t("> [!summary] Key Concepts"),
		t({ "", "> - " }),
		i(6, "Main takeaway 1"),
		t({ "", "> - " }),
		i(7, "Main takeaway 2"),
		t({ "", "", "" }),

		-- Notas de la clase
		t({ "## Class Notes", "" }),
		i(8, "Write live lecture notes, proofs, code snippets, or diagrams here."),
		t({ "", "", "" }),

		-- Dudas / Preguntas para revisar
		t({ "## Questions & To Review", "" }),
		t("- [ ] "),
		i(9, "Question to ask or topic to clarify"),
		t({ "", "", "" }),

		-- Enlaces a Zettels / Notas Atómicas generadas a partir de esta clase
		t({ "## Refactored Zettels", "" }),
		t("- [["),
		i(10, "Atomic_Note_Created_From_Lecture"),
		t("]]", ""),
	}),
})
