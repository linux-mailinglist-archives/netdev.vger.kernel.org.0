Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4635C1CE03B
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgEKQPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 12:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730623AbgEKQPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 12:15:43 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FA3C05BD0A
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:43 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x17so11736914wrt.5
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 09:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bS22eDRgHU808UGO22MolWu9Q5gNbHR9tBG8JMnHYeQ=;
        b=JYS4FGB6tVm2669a+Biy26YFzB6R/P5Zq7D4f9hF6JtAmr2qZde+Wy1Lde20V6m/aP
         1McUCu305R+VYJy6Fz2CCkAPYan7G1p6M3mGA6/GUTnrlk7WDSOU0TxhKD3uiYkBdqHz
         pAkfN5nZTssXAGOALvrwa22ky0bas7iQaQY2OaUuidp6d6CNy19tkHnwwAYkbBdMFXhd
         w+kaZj1nd5e4+0BSoD3x2YADyLpMSnhqPkkn7MNTrJcFcf601gacDVU2gk3txgGcGgom
         0+pUxPkQVIZtHdz46ipObXrnHhxvxTpuWM0txtYPCn0LNhcfNDh6dYJlSVH1N2+bfebA
         K2BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bS22eDRgHU808UGO22MolWu9Q5gNbHR9tBG8JMnHYeQ=;
        b=JPp/rBCpKJfDXV5QHNtffV/M8nIinAG+TcvzBC5gVQEpnLygP1iqiDBofOblNWJ3CL
         kZmNqY8VisyptZOMjJPz7HpShPOkXf5UsWJ/TBjSWAhOLkIWtZSccvXsHUai1b2g5wp4
         MSn2yXV1UanhN3KpERSpGSy4OPq8ng1chvwD919tCsYP3cmLNX9auGKKshX3MBuQp5K3
         xtmOk2u8Nw7ziEvyDAuPM0a3OgwVioLcZNjZkD+Bu55v72fjO9Esk41xUyKsZUCsExBt
         qLhRU4fD/ny4kIgM15YBiToph+I56le9pmDk6TntfgkgxjhNNkf4iMSAgSiYyHq4eUgd
         mVOg==
X-Gm-Message-State: AGi0Pua/bZQXR3q3NGMFw0FxkHzmAiqyT7M9Vvq1mO+Oj4Po2pmPNLyH
        CWONLLP7iSQP1bX+CR4YZZBL+Q==
X-Google-Smtp-Source: APiQypJy+hEtRM4ovjtFSVi1xwqnbxYlbZh/LMCi0LMaBSL10OTCHnXbQWorLT842B6F3K12aFSLqg==
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr8804746wrq.296.1589213741583;
        Mon, 11 May 2020 09:15:41 -0700 (PDT)
Received: from localhost.localdomain ([194.53.185.84])
        by smtp.gmail.com with ESMTPSA id v131sm54734wmb.27.2020.05.11.09.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 09:15:41 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 2/4] tools: bpftool: minor fixes for documentation
Date:   Mon, 11 May 2020 17:15:34 +0100
Message-Id: <20200511161536.29853-3-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200511161536.29853-1-quentin@isovalent.com>
References: <20200511161536.29853-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bring minor improvements to bpftool documentation. Fix or harmonise
formatting, update map types (including in interactive help), improve
description for "map create", fix a build warning due to a missing line
after the double-colon for the "bpftool prog profile" example,
complete/harmonise/sort the list of related bpftool man pages in
footers.

v2:
- Remove (instead of changing) mark-up on "value" in bpftool-map.rst,
  when it does not refer to something passed on the command line.
- Fix an additional typo ("hexadeximal") in the same file.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst | 11 ++++--
 .../bpftool/Documentation/bpftool-cgroup.rst  | 12 ++++--
 .../bpftool/Documentation/bpftool-feature.rst | 12 ++++--
 .../bpf/bpftool/Documentation/bpftool-gen.rst | 21 ++++++-----
 .../bpftool/Documentation/bpftool-iter.rst    | 12 +++---
 .../bpftool/Documentation/bpftool-link.rst    |  9 +++--
 .../bpf/bpftool/Documentation/bpftool-map.rst | 37 ++++++++++++-------
 .../bpf/bpftool/Documentation/bpftool-net.rst | 12 ++++--
 .../bpftool/Documentation/bpftool-perf.rst    | 12 ++++--
 .../bpftool/Documentation/bpftool-prog.rst    | 23 +++++++-----
 .../Documentation/bpftool-struct_ops.rst      | 11 +++---
 tools/bpf/bpftool/Documentation/bpftool.rst   | 11 ++++--
 tools/bpf/bpftool/map.c                       |  3 +-
 13 files changed, 116 insertions(+), 70 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 39615f8e145b..ce3a724f50c1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -230,9 +230,14 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-prog**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
-	**bpftool-perf**\ (8)
+	**bpftool-perf**\ (8),
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
index 06a28b07787d..e4d9da654e84 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-cgroup.rst
@@ -20,7 +20,7 @@ SYNOPSIS
 CGROUP COMMANDS
 ===============
 
-|	**bpftool** **cgroup { show | list }** *CGROUP* [**effective**]
+|	**bpftool** **cgroup** { **show** | **list** } *CGROUP* [**effective**]
 |	**bpftool** **cgroup tree** [*CGROUP_ROOT*] [**effective**]
 |	**bpftool** **cgroup attach** *CGROUP* *ATTACH_TYPE* *PROG* [*ATTACH_FLAGS*]
 |	**bpftool** **cgroup detach** *CGROUP* *ATTACH_TYPE* *PROG*
@@ -160,9 +160,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
index 1fa755f55e0c..8609f06e71de 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
@@ -28,7 +28,7 @@ DESCRIPTION
 ===========
 	**bpftool feature probe** [**kernel**] [**full**] [**macros** [**prefix** *PREFIX*]]
 		  Probe the running kernel and dump a number of eBPF-related
-		  parameters, such as availability of the **bpf()** system call,
+		  parameters, such as availability of the **bpf**\ () system call,
 		  JIT status, eBPF program types availability, eBPF helper
 		  functions availability, and more.
 
@@ -93,9 +93,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-gen.rst b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
index 94d91322895a..df85dbd962c0 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-gen.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-gen.rst
@@ -14,7 +14,7 @@ SYNOPSIS
 
 	*OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] }
 
-	*COMMAND* := { **skeleton | **help** }
+	*COMMAND* := { **skeleton** | **help** }
 
 GEN COMMANDS
 =============
@@ -36,12 +36,12 @@ DESCRIPTION
 		  etc. Skeleton eliminates the need to lookup mentioned
 		  components by name. Instead, if skeleton instantiation
 		  succeeds, they are populated in skeleton structure as valid
-		  libbpf types (e.g., struct bpf_map pointer) and can be
+		  libbpf types (e.g., **struct bpf_map** pointer) and can be
 		  passed to existing generic libbpf APIs.
 
 		  In addition to simple and reliable access to maps and
-		  programs, skeleton provides a storage for BPF links (struct
-		  bpf_link) for each BPF program within BPF object. When
+		  programs, skeleton provides a storage for BPF links (**struct
+		  bpf_link**) for each BPF program within BPF object. When
 		  requested, supported BPF programs will be automatically
 		  attached and resulting BPF links stored for further use by
 		  user in pre-allocated fields in skeleton struct. For BPF
@@ -82,14 +82,14 @@ DESCRIPTION
 
 		  - **example__open** and **example__open_opts**.
 		    These functions are used to instantiate skeleton. It
-		    corresponds to libbpf's **bpf_object__open()** API.
+		    corresponds to libbpf's **bpf_object__open**\ () API.
 		    **_opts** variants accepts extra **bpf_object_open_opts**
 		    options.
 
 		  - **example__load**.
 		    This function creates maps, loads and verifies BPF
 		    programs, initializes global data maps. It corresponds to
-		    libppf's **bpf_object__load** API.
+		    libppf's **bpf_object__load**\ () API.
 
 		  - **example__open_and_load** combines **example__open** and
 		    **example__load** invocations in one commonly used
@@ -296,10 +296,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-prog**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
index 13b173d93890..8dce698eab79 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
@@ -22,7 +22,6 @@ ITER COMMANDS
 |
 |	*OBJ* := /a/file/of/bpf_iter_target.o
 
-
 DESCRIPTION
 ===========
 	**bpftool iter pin** *OBJ* *PATH*
@@ -65,19 +64,18 @@ EXAMPLES
    Create a file-based bpf iterator from bpf_iter_netlink.o and pin it
    to /sys/fs/bpf/my_netlink
 
-
 SEE ALSO
 ========
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
-	**bpftool-link**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
-	**bpftool-gen**\ (8)
+	**bpftool-prog**\ (8),
 	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
index ee6500d6e6e4..0e43d7b06c11 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-link.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
@@ -109,10 +109,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-map.rst b/tools/bpf/bpftool/Documentation/bpftool-map.rst
index cdeae8ae90ba..31101643e57c 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-map.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-map.rst
@@ -21,7 +21,7 @@ SYNOPSIS
 MAP COMMANDS
 =============
 
-|	**bpftool** **map { show | list }**   [*MAP*]
+|	**bpftool** **map** { **show** | **list** }   [*MAP*]
 |	**bpftool** **map create**     *FILE* **type** *TYPE* **key** *KEY_SIZE* **value** *VALUE_SIZE* \
 |		**entries** *MAX_ENTRIES* **name** *NAME* [**flags** *FLAGS*] [**dev** *NAME*]
 |	**bpftool** **map dump**       *MAP*
@@ -49,7 +49,7 @@ MAP COMMANDS
 |		| **lru_percpu_hash** | **lpm_trie** | **array_of_maps** | **hash_of_maps**
 |		| **devmap** | **devmap_hash** | **sockmap** | **cpumap** | **xskmap** | **sockhash**
 |		| **cgroup_storage** | **reuseport_sockarray** | **percpu_cgroup_storage**
-|		| **queue** | **stack** }
+|		| **queue** | **stack** | **sk_storage** | **struct_ops** }
 
 DESCRIPTION
 ===========
@@ -66,6 +66,13 @@ DESCRIPTION
 		  Create a new map with given parameters and pin it to *bpffs*
 		  as *FILE*.
 
+		  *FLAGS* should be an integer which is the combination of
+		  desired flags, e.g. 1024 for **BPF_F_MMAPABLE** (see bpf.h
+		  UAPI header for existing flags).
+
+		  Keyword **dev** expects a network interface name, and is used
+		  to request hardware offload for the map.
+
 	**bpftool map dump**    *MAP*
 		  Dump all entries in a given *MAP*.  In case of **name**,
 		  *MAP* may match several maps which will all be dumped.
@@ -78,7 +85,7 @@ DESCRIPTION
 		  exists; **noexist** update only if entry doesn't exist.
 
 		  If the **hex** keyword is provided in front of the bytes
-		  sequence, the bytes are parsed as hexadeximal values, even if
+		  sequence, the bytes are parsed as hexadecimal values, even if
 		  no "0x" prefix is added. If the keyword is not provided, then
 		  the bytes are parsed as decimal values, unless a "0x" prefix
 		  (for hexadecimal) or a "0" prefix (for octal) is provided.
@@ -100,10 +107,10 @@ DESCRIPTION
 		  extensions of *bpffs*.
 
 	**bpftool** **map event_pipe** *MAP* [**cpu** *N* **index** *M*]
-		  Read events from a BPF_MAP_TYPE_PERF_EVENT_ARRAY map.
+		  Read events from a **BPF_MAP_TYPE_PERF_EVENT_ARRAY** map.
 
 		  Install perf rings into a perf event array map and dump
-		  output of any bpf_perf_event_output() call in the kernel.
+		  output of any **bpf_perf_event_output**\ () call in the kernel.
 		  By default read the number of CPUs on the system and
 		  install perf ring for each CPU in the corresponding index
 		  in the array.
@@ -116,24 +123,24 @@ DESCRIPTION
 		  receiving events if it installed its rings earlier.
 
 	**bpftool map peek**  *MAP*
-		  Peek next **value** in the queue or stack.
+		  Peek next value in the queue or stack.
 
 	**bpftool map push**  *MAP* **value** *VALUE*
-		  Push **value** onto the stack.
+		  Push *VALUE* onto the stack.
 
 	**bpftool map pop**  *MAP*
-		  Pop and print **value** from the stack.
+		  Pop and print value from the stack.
 
 	**bpftool map enqueue**  *MAP* **value** *VALUE*
-		  Enqueue **value** into the queue.
+		  Enqueue *VALUE* into the queue.
 
 	**bpftool map dequeue**  *MAP*
-		  Dequeue and print **value** from the queue.
+		  Dequeue and print value from the queue.
 
 	**bpftool map freeze**  *MAP*
 		  Freeze the map as read-only from user space. Entries from a
 		  frozen map can not longer be updated or deleted with the
-		  **bpf\ ()** system call. This operation is not reversible,
+		  **bpf**\ () system call. This operation is not reversible,
 		  and the map remains immutable from user space until its
 		  destruction. However, read and write permissions for BPF
 		  programs to the map remain unchanged.
@@ -269,9 +276,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index 8651b00b81ea..aa7450736179 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -20,7 +20,7 @@ SYNOPSIS
 NET COMMANDS
 ============
 
-|	**bpftool** **net { show | list }** [ **dev** *NAME* ]
+|	**bpftool** **net** { **show** | **list** } [ **dev** *NAME* ]
 |	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *NAME* [ **overwrite** ]
 |	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
 |	**bpftool** **net help**
@@ -194,9 +194,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-perf.rst b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
index e252bd0bc434..9c592b7c6775 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-perf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-perf.rst
@@ -20,7 +20,7 @@ SYNOPSIS
 PERF COMMANDS
 =============
 
-|	**bpftool** **perf { show | list }**
+|	**bpftool** **perf** { **show** | **list** }
 |	**bpftool** **perf help**
 
 DESCRIPTION
@@ -85,9 +85,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 9f19404f470e..5948e9d89c8d 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -21,11 +21,11 @@ SYNOPSIS
 PROG COMMANDS
 =============
 
-|	**bpftool** **prog { show | list }** [*PROG*]
+|	**bpftool** **prog** { **show** | **list** } [*PROG*]
 |	**bpftool** **prog dump xlated** *PROG* [{**file** *FILE* | **opcodes** | **visual** | **linum**}]
 |	**bpftool** **prog dump jited**  *PROG* [{**file** *FILE* | **opcodes** | **linum**}]
 |	**bpftool** **prog pin** *PROG* *FILE*
-|	**bpftool** **prog { load | loadall }** *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
+|	**bpftool** **prog** { **load** | **loadall** } *OBJ* *PATH* [**type** *TYPE*] [**map** {**idx** *IDX* | **name** *NAME*} *MAP*] [**dev** *NAME*] [**pinmaps** *MAP_DIR*]
 |	**bpftool** **prog attach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog tracelog**
@@ -49,7 +49,7 @@ PROG COMMANDS
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
 |	}
-|	*METRIC* := {
+|	*METRICs* := {
 |		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
 |	}
 
@@ -155,7 +155,7 @@ DESCRIPTION
 	**bpftool prog tracelog**
 		  Dump the trace pipe of the system to the console (stdout).
 		  Hit <Ctrl+C> to stop printing. BPF programs can write to this
-		  trace pipe at runtime with the **bpf_trace_printk()** helper.
+		  trace pipe at runtime with the **bpf_trace_printk**\ () helper.
 		  This should be used only for debugging purposes. For
 		  streaming data from BPF programs to user space, one can use
 		  perf events (see also **bpftool-map**\ (8)).
@@ -195,9 +195,9 @@ DESCRIPTION
 
 	**bpftool prog profile** *PROG* [**duration** *DURATION*] *METRICs*
 		  Profile *METRICs* for bpf program *PROG* for *DURATION*
-		  seconds or until user hits Ctrl-C. *DURATION* is optional.
+		  seconds or until user hits <Ctrl+C>. *DURATION* is optional.
 		  If *DURATION* is not specified, the profiling will run up to
-		  UINT_MAX seconds.
+		  **UINT_MAX** seconds.
 
 	**bpftool prog help**
 		  Print short help message.
@@ -267,7 +267,7 @@ EXAMPLES
 
 |
 | **# bpftool prog dump xlated id 10 file /tmp/t**
-| **# ls -l /tmp/t**
+| **$ ls -l /tmp/t**
 
 ::
 
@@ -325,6 +325,7 @@ EXAMPLES
 | **# bpftool prog profile id 337 duration 10 cycles instructions llc_misses**
 
 ::
+
          51397 run_cnt
       40176203 cycles                                                 (83.05%)
       42518139 instructions    #   1.06 insns per cycle               (83.39%)
@@ -335,9 +336,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
index f045cc89dd6d..d93cd1cb8b0f 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
@@ -105,12 +105,13 @@ SEE ALSO
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
 	**bpftool**\ (8),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8)
-	**bpftool-gen**\ (8)
-	
+	**bpftool-prog**\ (8)
diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
index 34239fda69ed..420d4d5df8b6 100644
--- a/tools/bpf/bpftool/Documentation/bpftool.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool.rst
@@ -75,11 +75,14 @@ SEE ALSO
 ========
 	**bpf**\ (2),
 	**bpf-helpers**\ (7),
-	**bpftool-prog**\ (8),
-	**bpftool-map**\ (8),
+	**bpftool-btf**\ (8),
 	**bpftool-cgroup**\ (8),
 	**bpftool-feature**\ (8),
+	**bpftool-gen**\ (8),
+	**bpftool-iter**\ (8),
+	**bpftool-link**\ (8),
+	**bpftool-map**\ (8),
 	**bpftool-net**\ (8),
 	**bpftool-perf**\ (8),
-	**bpftool-btf**\ (8),
-	**bpftool-gen**\ (8),
+	**bpftool-prog**\ (8),
+	**bpftool-struct_ops**\ (8)
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 693a632f6813..85cbe9a19170 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1589,7 +1589,8 @@ static int do_help(int argc, char **argv)
 		"                 percpu_array | stack_trace | cgroup_array | lru_hash |\n"
 		"                 lru_percpu_hash | lpm_trie | array_of_maps | hash_of_maps |\n"
 		"                 devmap | devmap_hash | sockmap | cpumap | xskmap | sockhash |\n"
-		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage }\n"
+		"                 cgroup_storage | reuseport_sockarray | percpu_cgroup_storage |\n"
+		"                 queue | stack | sk_storage | struct_ops }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-- 
2.20.1

