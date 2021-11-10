Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4E544C04D
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 12:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhKJLt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 06:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbhKJLt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 06:49:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56472C061767
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:40 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id y84-20020a1c7d57000000b00330cb84834fso4376622wmc.2
        for <netdev@vger.kernel.org>; Wed, 10 Nov 2021 03:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xKjwFhBQSI7LBT94YR7j5voYDL7V60GODHnD8sNb0VA=;
        b=U0G4KC8fi0rqH4UNf50TsZUJW8VA5IHAPSOrXRktg9DfrZFRW9fRrdR4AqTHCVSMTR
         ZZfJ1j86C7AeSVm7Dey2cvXVgncxI77qUkDOnYlqzexQamfJg6BSqiq5xYg8bu5xJskN
         hErHHd3w1H3zpPYV3xvJhSfpTG1jK3z2xJ+seSA/P6FNS6TbofxiYpK39iX+JyCK059Q
         kAkdB6M3e0qmQ1pptXLDyk4v8UpUOjo+mTfBtHPCPpCVSN61vJXVRehr1BQO9uI2FJpi
         toSNk67/S2OqXoIz0i8FnKeFdQqH7VDkM5lmLZaKlUsOMu9ldJA1r9vz2apnaQWqfDdJ
         wV6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xKjwFhBQSI7LBT94YR7j5voYDL7V60GODHnD8sNb0VA=;
        b=3/FnZZle4Es3liMRZTWaxihVTtrP3aUa1l5xQtyh17IwPXiaZk70UEjkQO++d/7HnX
         LUkMdy3KlwQUuc/QLVrmWzWoziiDYxPbRFXo/Qk9X8lz3U0yVWkwRXjDq0GMgT4jF334
         34FXsgBlaohCrDitJBdWJ6IocEXr5CfcaTlmrK3ifTRr81sBcdsAL3onWEUhUv3A6Ux6
         79qS7NG8hcbTALpc5z3ubXtRZz/lJfncmoUMiwscF7hzDRYwLfWCXa1tdcFBH/imfQj5
         +cu+CjP4qYJglmgxctNea/ILG06M56waqXtsacftQY7Q1+qXQbBnkGaPAnD9AKVlfh8T
         1n1g==
X-Gm-Message-State: AOAM531FGW5Rrw+bffSW9kfckwMFe1/Vkpksj3t1z6iuHPVE+hNlY0Mc
        EAU6hnOflKaYzsJYGepV+1Lz5Q==
X-Google-Smtp-Source: ABdhPJywio37gAXUeAlgc2fMqGZkFs+eby6R/oTQiZbSRzC34obMp28KRzPMuGA2EIpzi2ieu8LW6w==
X-Received: by 2002:a05:600c:4e94:: with SMTP id f20mr15303616wmq.77.1636544798959;
        Wed, 10 Nov 2021 03:46:38 -0800 (PST)
Received: from localhost.localdomain ([149.86.79.190])
        by smtp.gmail.com with ESMTPSA id i15sm6241152wmq.18.2021.11.10.03.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 03:46:38 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 4/6] bpftool: Fix indent in option lists in the documentation
Date:   Wed, 10 Nov 2021 11:46:30 +0000
Message-Id: <20211110114632.24537-5-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211110114632.24537-1-quentin@isovalent.com>
References: <20211110114632.24537-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mixed indentation levels in the lists of options in bpftool's
documentation produces some unexpected results. For the "bpftool" man
page, it prints a warning:

    $ make -C bpftool.8
      GEN     bpftool.8
    <stdin>:26: (ERROR/3) Unexpected indentation.

For other pages, there is no warning, but it results in a line break
appearing in the option lists in the generated man pages.

RST paragraphs should have a uniform indentation level. Let's fix it.

Fixes: c07ba629df97 ("tools: bpftool: Update and synchronise option list in doc and help msg")
Fixes: 8cc8c6357c8f ("tools: bpftool: Document and add bash completion for -L, -B options")
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   | 2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    | 6 +++---
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   | 8 ++++----
 tools/bpf/bpftool/Documentation/bpftool.rst        | 6 +++---
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 88b28aa7431f..4425d942dd39 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **btf** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } |
-		{ **-B** | **--base-btf** } }
+	{ **-B** | **--base-btf** } }
 
 	*COMMANDS* := { **dump** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 3e4395eede4f..13a217a2503d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } }
+	{ **-f** | **--bpffs** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 2ef2f2df0279..2a137f8a4cea 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **gen** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-L** | **--use-loader** } }
+	{ **-L** | **--use-loader** } }
 
 	*COMMAND* := { **object** | **skeleton** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index 0de90f086238..9434349636a5 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -13,7 +13,7 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **link** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* := { **show** | **list** | **pin** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index d0c4abe08aba..1445cadc15d4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -13,11 +13,11 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **map** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* :=
-	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext**
-	| **delete** | **pin** | **help** }
+	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
+	**delete** | **pin** | **help** }
 
 MAP COMMANDS
 =============
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 91608cb7e44a..f27265bd589b 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -13,12 +13,12 @@ SYNOPSIS
 	**bpftool** [*OPTIONS*] **prog** *COMMAND*
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-		{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
-		{ **-L** | **--use-loader** } }
+	{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
+	{ **-L** | **--use-loader** } }
 
 	*COMMANDS* :=
-	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load**
-	| **loadall** | **help** }
+	{ **show** | **list** | **dump xlated** | **dump jited** | **pin** | **load** |
+	**loadall** | **help** }
 
 PROG COMMANDS
 =============
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index bb23f55bb05a..8ac86565c501 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -19,14 +19,14 @@ SYNOPSIS
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
 	*OPTIONS* := { { **-V** | **--version** } |
-		{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
 
 	*MAP-COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
-		**delete** | **pin** | **event_pipe** | **help** }
+	**delete** | **pin** | **event_pipe** | **help** }
 
 	*PROG-COMMANDS* := { **show** | **list** | **dump jited** | **dump xlated** | **pin** |
-		**load** | **attach** | **detach** | **help** }
+	**load** | **attach** | **detach** | **help** }
 
 	*CGROUP-COMMANDS* := { **show** | **list** | **attach** | **detach** | **help** }
 
-- 
2.32.0

