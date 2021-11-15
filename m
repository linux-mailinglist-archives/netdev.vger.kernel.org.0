Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E13D451FD5
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 01:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352300AbhKPApg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 19:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355474AbhKPAl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 19:41:58 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9E4C073AE6
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:59:01 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id y196so15277748wmc.3
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 14:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nAJx7EdAneB2lJub8VevoB5opbG/2S93s6eur1gM+dw=;
        b=5ZLnWlVJe9mPEB5qvSEOk4SqwWROx8dRteDty6PbJ300KRrxQSqijwYOtl1LMbyaAH
         xVVqMdPffSWLYpAzdcpeCJzUlM0jzmHfJj33fUeFP3ZId/n7FSPd+h4mBARc163VrilN
         UBZTyV1xrsWVJzAyxnANfAJAu60+PQNbQpoQhWj4TodWTHsiB0Y3Mu2CLVIRW/TlAFln
         1bYskXCHJBGRN6FnY+Lg4b+59Nv/y9JEluusfad5wIa+lMG+dAhehLfN7kFgDvjKg/Y0
         CutjC1RtTrA/mqqUre0OHoqfCAtI5zmkDsqXWhCK0xnoDLJS70RPzUIpzz3joKbR+Eqe
         SNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nAJx7EdAneB2lJub8VevoB5opbG/2S93s6eur1gM+dw=;
        b=X6/ErlPJf5L04l9cHc9uxc7Fe6xDgE4UXhAI2TpwoaTWlkhPH1FMUZz4FIPwo71AlY
         3MmfN565pd2AIuMaRTFJbbcEeYSl36QREv7VGPE0h80YZFiXY6p3a0WUTSFNV0IcMIn+
         TYp8ki62WzY1gnA91v9GXEw7/MQO1pPCe5ANAfSOz67P3pSgA3w4ylKYrkV8qprMHp99
         kv1/5r7/AhHScAkiKSfkmYz+ZrlcOudjy/f4YI3kiJpVCRyUjg552xgCowLf+Snu30YB
         4Wv5nBnipgcXr1TdI9Y0yw44Ok6XfuKkF2iFgMAz+hv3YrzLSA6woVWZ2ALTPvPl/eTm
         1noQ==
X-Gm-Message-State: AOAM531ysz0MkKeorrlWWq03A12tQVaMSsnXuHzro2hIZ9iLcJ89pb1p
        BEsrJ0a/Zj0XAhihRlB8RrCHEQ==
X-Google-Smtp-Source: ABdhPJwuIHxXPf6QVF40JYKPBzovTLbbjTLA86ixBKg2bW/1I/U0btZlMqS+VFXoS+shGd2adWNvpA==
X-Received: by 2002:a05:600c:1c87:: with SMTP id k7mr65649629wms.103.1637017140476;
        Mon, 15 Nov 2021 14:59:00 -0800 (PST)
Received: from localhost.localdomain ([149.86.89.157])
        by smtp.gmail.com with ESMTPSA id y12sm15467619wrn.73.2021.11.15.14.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 14:59:00 -0800 (PST)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next 2/3] bpftool: Update doc (use susbtitutions) and test_bpftool_synctypes.py
Date:   Mon, 15 Nov 2021 22:58:43 +0000
Message-Id: <20211115225844.33943-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211115225844.33943-1-quentin@isovalent.com>
References: <20211115225844.33943-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_bpftool_synctypes.py helps detecting inconsistencies in bpftool
between the different list of types and options scattered in the
sources, the documentation, and the bash completion. For options that
apply to all bpftool commands, the script had a hardcoded list of
values, and would use them to check whether the man pages are
up-to-date. When writing the script, it felt acceptable to have this
list in order to avoid to open and parse bpftool's main.h every time,
and because the list of global options in bpftool doesn't change so
often.

However, this is prone to omissions, and we recently added a new
-l|--legacy option which was described in common_options.rst, but not
listed in the options summary of each manual page. The script did not
complain, because it keeps comparing the hardcoded list to the (now)
outdated list in the header file.

To address the issue, this commit brings the following changes:

- Options that are common to all bpftool commands (--json, --pretty, and
  --debug) are moved to a dedicated file, and used in the definition of
  a RST substitution. This substitution is used in the sources of all
  the man pages.

- This list of common options is updated, with the addition of the new
  -l|--legacy option.

- The script test_bpftool_synctypes.py is updated to compare:
    - Options specific to a command, found in C files, for the
      interactive help messages, with the same specific options from the
      relevant man page for that command.
    - Common options, checked just once: the list in main.h is
      compared with the new list in substitutions.rst.

Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst |  5 +-
 .../bpftool/Documentation/bpftool-cgroup.rst  |  5 +-
 .../bpftool/Documentation/bpftool-feature.rst |  4 +-
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  5 +-
 .../bpftool/Documentation/bpftool-iter.rst    |  4 +-
 .../bpftool/Documentation/bpftool-link.rst    |  5 +-
 .../bpf/bpftool/Documentation/bpftool-map.rst |  5 +-
 .../bpf/bpftool/Documentation/bpftool-net.rst |  4 +-
 .../bpftool/Documentation/bpftool-perf.rst    |  4 +-
 .../bpftool/Documentation/bpftool-prog.rst    |  4 +-
 .../Documentation/bpftool-struct_ops.rst      |  4 +-
 tools/bpf/bpftool/Documentation/bpftool.rst   |  5 +-
 .../bpftool/Documentation/substitutions.rst   |  3 +
 .../selftests/bpf/test_bpftool_synctypes.py   | 70 +++++++++++++++++--
 14 files changed, 102 insertions(+), 25 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/substitutions.rst

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 2d2ceb7163f6..342716f74ec4 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -9,13 +9,14 @@ tool for inspection of BTF data
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **btf** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | {**-d** | **--debug** } |
-	{ **-B** | **--base-btf** } }
+	*OPTIONS* := { |COMMON_OPTIONS| | { **-B** | **--base-btf** } }
 
 	*COMMANDS* := { **dump** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index b954faeb0f07..a17e9aa314fd 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -9,13 +9,14 @@ tool for inspection and simple manipulation of eBPF progs
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **cgroup** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-	{ **-f** | **--bpffs** } }
+	*OPTIONS* := { |COMMON_OPTIONS| | { **-f** | **--bpffs** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **tree** | **attach** | **detach** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index b1471788a15f..4ce9a77bc1e0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -9,12 +9,14 @@ tool for inspection of eBPF-related parameters for Linux kernel or net device
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **feature** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { |COMMON_OPTIONS| }
 
 	*COMMANDS* := { **probe** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 51e2e8de5208..bc276388f432 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -9,13 +9,14 @@ tool for BPF code-generation
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **gen** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-	{ **-L** | **--use-loader** } }
+	*OPTIONS* := { |COMMON_OPTIONS| | { **-L** | **--use-loader** } }
 
 	*COMMAND* := { **object** | **skeleton** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index 51914c9e8a54..84839d488621 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -9,12 +9,14 @@ tool to create BPF iterators
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **iter** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { |COMMON_OPTIONS| }
 
 	*COMMANDS* := { **pin** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index 31371bcf605a..52a4eee4af54 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -9,13 +9,14 @@ tool for inspection and simple manipulation of eBPF links
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **link** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	*OPTIONS* := { |COMMON_OPTIONS| | { **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* := { **show** | **list** | **pin** | **help** }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index e22c918c069c..7c188a598444 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -9,13 +9,14 @@ tool for inspection and simple manipulation of eBPF maps
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **map** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
-	{ **-f** | **--bpffs** } | { **-n** | **--nomount** } }
+	*OPTIONS* := { |COMMON_OPTIONS| | { **-f** | **--bpffs** } | { **-n** | **--nomount** } }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 6d1aa374529f..f4e0a516335a 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -9,12 +9,14 @@ tool for inspection of netdev/tc related bpf prog attachments
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **net** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { |COMMON_OPTIONS| }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **attach** | **detach** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index ad554806faa2..5fea633a82f1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -9,12 +9,14 @@ tool for inspection of perf related bpf prog attachments
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **perf** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { |COMMON_OPTIONS| }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index d31148571403..a2e9359e554c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -9,12 +9,14 @@ tool for inspection and simple manipulation of eBPF progs
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **prog** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } |
+	*OPTIONS* := { |COMMON_OPTIONS| |
 	{ **-f** | **--bpffs** } | { **-m** | **--mapcompat** } | { **-n** | **--nomount** } |
 	{ **-L** | **--use-loader** } }
 
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index 77b845b5ac61..ee53a122c0c7 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -9,12 +9,14 @@ tool to register/unregister/introspect BPF struct_ops
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
 	**bpftool** [*OPTIONS*] **struct_ops** *COMMAND*
 
-	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { |COMMON_OPTIONS| }
 
 	*COMMANDS* :=
 	{ **show** | **list** | **dump** | **register** | **unregister** | **help** }
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 1248b35e67ae..7084dd9fa2f8 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -9,6 +9,8 @@ tool for inspection and simple manipulation of eBPF programs and maps
 
 :Manual section: 8
 
+.. include:: substitutions.rst
+
 SYNOPSIS
 ========
 
@@ -20,8 +22,7 @@ SYNOPSIS
 
 	*OBJECT* := { **map** | **program** | **cgroup** | **perf** | **net** | **feature** }
 
-	*OPTIONS* := { { **-V** | **--version** } |
-	{ **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } }
+	*OPTIONS* := { { **-V** | **--version** } | |COMMON_OPTIONS| }
 
 	*MAP-COMMANDS* :=
 	{ **show** | **list** | **create** | **dump** | **update** | **lookup** | **getnext** |
diff --git a/tools/bpf/bpftool/Documentation/substitutions.rst b/tools/bpf/bpftool/Documentation/substitutions.rst
new file mode 100644
index 000000000000..ccf1ffa0686c
--- /dev/null
+++ b/tools/bpf/bpftool/Documentation/substitutions.rst
@@ -0,0 +1,3 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+.. |COMMON_OPTIONS| replace:: { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-d** | **--debug** } | { **-l** | **--legacy** }
diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
index be54b7335a76..3f6e562565ec 100755
--- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
+++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
@@ -242,12 +242,6 @@ class FileExtractor(object):
         end_marker = re.compile('}\\\\n')
         return self.__get_description_list(start_marker, pattern, end_marker)
 
-    def default_options(self):
-        """
-        Return the default options contained in HELP_SPEC_OPTIONS
-        """
-        return { '-j', '--json', '-p', '--pretty', '-d', '--debug' }
-
     def get_bashcomp_list(self, block_name):
         """
         Search for and parse a list of type names from a variable in bash
@@ -274,7 +268,56 @@ class SourceFileExtractor(FileExtractor):
     defined in children classes.
     """
     def get_options(self):
-        return self.default_options().union(self.get_help_list_macro('HELP_SPEC_OPTIONS'))
+        return self.get_help_list_macro('HELP_SPEC_OPTIONS')
+
+class MainHeaderFileExtractor(SourceFileExtractor):
+    """
+    An extractor for bpftool's main.h
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'main.h')
+
+    def get_common_options(self):
+        """
+        Parse the list of common options in main.h (options that apply to all
+        commands), which looks to the lists of options in other source files
+        but has different start and end markers:
+
+            "OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy}"
+
+        Return a set containing all options, such as:
+
+            {'-p', '-d', '--legacy', '--pretty', '--debug', '--json', '-l', '-j'}
+        """
+        start_marker = re.compile(f'"OPTIONS :=')
+        pattern = re.compile('([\w-]+) ?(?:\||}[ }\]"])')
+        end_marker = re.compile('#define')
+
+        parser = InlineListParser(self.reader)
+        parser.search_block(start_marker)
+        return parser.parse(pattern, end_marker)
+
+class ManSubstitutionsExtractor(SourceFileExtractor):
+    """
+    An extractor for substitutions.rst
+    """
+    filename = os.path.join(BPFTOOL_DIR, 'Documentation/substitutions.rst')
+
+    def get_common_options(self):
+        """
+        Parse the list of common options in substitutions.rst (options that
+        apply to all commands).
+
+        Return a set containing all options, such as:
+
+            {'-p', '-d', '--legacy', '--pretty', '--debug', '--json', '-l', '-j'}
+        """
+        start_marker = re.compile('\|COMMON_OPTIONS\| replace:: {')
+        pattern = re.compile('\*\*([\w/-]+)\*\*')
+        end_marker = re.compile('}$')
+
+        parser = InlineListParser(self.reader)
+        parser.search_block(start_marker)
+        return parser.parse(pattern, end_marker)
 
 class ProgFileExtractor(SourceFileExtractor):
     """
@@ -580,6 +623,19 @@ def main():
     verify(help_main_options, man_main_options,
             f'Comparing {source_main_info.filename} (do_help() OPTIONS) and {man_main_info.filename} (OPTIONS):')
 
+    # Compare common options (options that apply to all commands)
+
+    main_hdr_info = MainHeaderFileExtractor()
+    source_common_options = main_hdr_info.get_common_options()
+    main_hdr_info.close()
+
+    man_substitutions = ManSubstitutionsExtractor()
+    man_common_options = man_substitutions.get_common_options()
+    man_substitutions.close()
+
+    verify(source_common_options, man_common_options,
+            f'Comparing common options from {main_hdr_info.filename} (HELP_SPEC_OPTIONS) and {man_substitutions.filename}:')
+
     sys.exit(retval)
 
 if __name__ == "__main__":
-- 
2.32.0

