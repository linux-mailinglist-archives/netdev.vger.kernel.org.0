Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3144B1DF3C0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 03:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgEWBH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 21:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387465AbgEWBH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 21:07:57 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A871C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:07:57 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u13so1604292wml.1
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 18:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiqSi+xY3gUP3p/pOnNA6TC3IyMfO2CH4Q4oZK5IQeg=;
        b=BSgYUuRTNpbG0SGm+d2uVpdR5Dt0beVFyCalp9QfMfIEqAihAaYeuYvekpnwpDgyrw
         /XMg5gw4LRmkhQ/3/zQfOgBBgbRNt5yhPkSJ5mVG7Gpng3KAELcRlgC9SECsg35gbI5I
         LaLNDCIK2bDRbcAakBtH3pnxNEZcd08L1hUD8CM7VMGiN09CB/kpq31QEZcWJMzsmLA1
         6GTfH6Nh8E2JTcLt3oDkvvti56XU6ZGaxklHTkgZYQb9qxiyV4s1dyCAfznwR9YGSYm0
         mO+lrAB3R2QPpHC97EXKRaYGmTTzy6mJDirwv0BseahXHFRkJ4ePU6aS57Aw7vj1u/nF
         X/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jiqSi+xY3gUP3p/pOnNA6TC3IyMfO2CH4Q4oZK5IQeg=;
        b=rZX9/G3vfLX96O55m11aAagx8Oti3ch/mCpoIwraxiiuSucqvBpfc7lwLra9ltoiMA
         EjoU0pjEZdMLA8ju0o4zWSwCCdqW0udA+DOz1sGq2er8Wnu9rpWzacD1L40EzsvGuszA
         OAowENnqXVBXilSphhGG7XG78ccvwkw2h/w72chlnaFkFRuowrxyILXl32A0dcqnKJka
         YZk2pYfokG1dnp+Si+Pew7yikSnz6yriIvxsu2jmC+vNfSWWHKPBR32DKvQjEIcA+50n
         HqMzvz7p9YqjKvz1amW4oBxE/UExeO45fdj5joyA6tbPD2rneX9Sep03BDs4k5/Gni+v
         vuGA==
X-Gm-Message-State: AOAM53201Bzulr3Bx0aU4AbYnN05nry749GLTjVJX+ITgS1yrnZeYmZQ
        Kkki0KOPbxK7pRly2womvg8qWg==
X-Google-Smtp-Source: ABdhPJyhzsKUNSD9prp+Uh4JLj+4KQKhf46FZO0TXMog5Hv+t5bj0zOYXXV4QDmdcV/2HMIWdMRmcw==
X-Received: by 2002:a1c:6884:: with SMTP id d126mr3413221wmc.121.1590196075956;
        Fri, 22 May 2020 18:07:55 -0700 (PDT)
Received: from localhost.localdomain ([194.53.184.60])
        by smtp.gmail.com with ESMTPSA id z132sm12016973wmc.29.2020.05.22.18.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 18:07:55 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next] tools: bpftool: clean subcommand help messages
Date:   Sat, 23 May 2020 02:07:51 +0100
Message-Id: <20200523010751.23465-1-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a clean-up for the formatting of the do_help functions for
bpftool's subcommands. The following fixes are included:

- Do not use argv[-2] for "iter" help message, as the help is shown by
  default if no "iter" action is selected, resulting in messages looking
  like "./bpftool bpftool pin...".

- Do not print unused HELP_SPEC_PROGRAM in help message for "bpftool
  link".

- Andrii used argument indexing to avoid having multiple occurrences of
  bin_name and argv[-2] in the fprintf() for the help message, for
  "bpftool gen" and "bpftool link". Let's reuse this for all other help
  functions. We can remove up to thirty arguments for the "bpftool map"
  help message.

- Harmonise all functions, e.g. use ending quotes-comma on a separate
  line.

Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/btf.c        |  8 +++----
 tools/bpf/bpftool/cgroup.c     | 14 +++++-------
 tools/bpf/bpftool/feature.c    |  6 ++---
 tools/bpf/bpftool/gen.c        |  6 ++---
 tools/bpf/bpftool/iter.c       |  8 +++----
 tools/bpf/bpftool/link.c       |  1 -
 tools/bpf/bpftool/map.c        | 41 +++++++++++++++-------------------
 tools/bpf/bpftool/net.c        | 12 +++++-----
 tools/bpf/bpftool/perf.c       |  2 +-
 tools/bpf/bpftool/prog.c       | 27 ++++++++++------------
 tools/bpf/bpftool/struct_ops.c | 15 ++++++-------
 11 files changed, 64 insertions(+), 76 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 41a1346934a1..c134666591a6 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -951,9 +951,9 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s btf { show | list } [id BTF_ID]\n"
-		"       %s btf dump BTF_SRC [format FORMAT]\n"
-		"       %s btf help\n"
+		"Usage: %1$s %2$s { show | list } [id BTF_ID]\n"
+		"       %1$s %2$s dump BTF_SRC [format FORMAT]\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       BTF_SRC := { id BTF_ID | prog PROG | map MAP [{key | value | kv | all}] | file FILE }\n"
 		"       FORMAT  := { raw | c }\n"
@@ -961,7 +961,7 @@ static int do_help(int argc, char **argv)
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name, bin_name, bin_name);
+		bin_name, "btf");
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 27931db421d8..d901cc1b904a 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -491,20 +491,18 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } CGROUP [**effective**]\n"
-		"       %s %s tree [CGROUP_ROOT] [**effective**]\n"
-		"       %s %s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
-		"       %s %s detach CGROUP ATTACH_TYPE PROG\n"
-		"       %s %s help\n"
+		"Usage: %1$s %2$s { show | list } CGROUP [**effective**]\n"
+		"       %1$s %2$s tree [CGROUP_ROOT] [**effective**]\n"
+		"       %1$s %2$s attach CGROUP ATTACH_TYPE PROG [ATTACH_FLAGS]\n"
+		"       %1$s %2$s detach CGROUP ATTACH_TYPE PROG\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		HELP_SPEC_ATTACH_TYPES "\n"
 		"       " HELP_SPEC_ATTACH_FLAGS "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2]);
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
index 1b73e63274b5..f05e9e57b593 100644
--- a/tools/bpf/bpftool/feature.c
+++ b/tools/bpf/bpftool/feature.c
@@ -937,12 +937,12 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
-		"       %s %s help\n"
+		"Usage: %1$s %2$s probe [COMPONENT] [full] [unprivileged] [macros [prefix PREFIX]]\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       COMPONENT := { kernel | dev NAME }\n"
 		"",
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2]);
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 0e5f0236cc76..a3c4bb86c05a 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -586,12 +586,12 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %1$s gen skeleton FILE\n"
-		"       %1$s gen help\n"
+		"Usage: %1$s %2$s skeleton FILE\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name);
+		bin_name, "gen");
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
index eb5987a0c3b6..33240fcc6319 100644
--- a/tools/bpf/bpftool/iter.c
+++ b/tools/bpf/bpftool/iter.c
@@ -68,10 +68,10 @@ static int do_pin(int argc, char **argv)
 static int do_help(int argc, char **argv)
 {
 	fprintf(stderr,
-		"Usage: %s %s pin OBJ PATH\n"
-		"       %s %s help\n"
-		"\n",
-		bin_name, argv[-2], bin_name, argv[-2]);
+		"Usage: %1$s %2$s pin OBJ PATH\n"
+		"       %1$s %2$s help\n"
+		"",
+		bin_name, "iter");
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index b6a0b35c78ae..670a561dc31b 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -312,7 +312,6 @@ static int do_help(int argc, char **argv)
 		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_LINK "\n"
-		"       " HELP_SPEC_PROGRAM "\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, argv[-2]);
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 85cbe9a19170..c5fac8068ba1 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -1561,24 +1561,24 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list }   [MAP]\n"
-		"       %s %s create     FILE type TYPE key KEY_SIZE value VALUE_SIZE \\\n"
-		"                              entries MAX_ENTRIES name NAME [flags FLAGS] \\\n"
-		"                              [dev NAME]\n"
-		"       %s %s dump       MAP\n"
-		"       %s %s update     MAP [key DATA] [value VALUE] [UPDATE_FLAGS]\n"
-		"       %s %s lookup     MAP [key DATA]\n"
-		"       %s %s getnext    MAP [key DATA]\n"
-		"       %s %s delete     MAP  key DATA\n"
-		"       %s %s pin        MAP  FILE\n"
-		"       %s %s event_pipe MAP [cpu N index M]\n"
-		"       %s %s peek       MAP\n"
-		"       %s %s push       MAP value VALUE\n"
-		"       %s %s pop        MAP\n"
-		"       %s %s enqueue    MAP value VALUE\n"
-		"       %s %s dequeue    MAP\n"
-		"       %s %s freeze     MAP\n"
-		"       %s %s help\n"
+		"Usage: %1$s %2$s { show | list }   [MAP]\n"
+		"       %1$s %2$s create     FILE type TYPE key KEY_SIZE value VALUE_SIZE \\\n"
+		"                                  entries MAX_ENTRIES name NAME [flags FLAGS] \\\n"
+		"                                  [dev NAME]\n"
+		"       %1$s %2$s dump       MAP\n"
+		"       %1$s %2$s update     MAP [key DATA] [value VALUE] [UPDATE_FLAGS]\n"
+		"       %1$s %2$s lookup     MAP [key DATA]\n"
+		"       %1$s %2$s getnext    MAP [key DATA]\n"
+		"       %1$s %2$s delete     MAP  key DATA\n"
+		"       %1$s %2$s pin        MAP  FILE\n"
+		"       %1$s %2$s event_pipe MAP [cpu N index M]\n"
+		"       %1$s %2$s peek       MAP\n"
+		"       %1$s %2$s push       MAP value VALUE\n"
+		"       %1$s %2$s pop        MAP\n"
+		"       %1$s %2$s enqueue    MAP value VALUE\n"
+		"       %1$s %2$s dequeue    MAP\n"
+		"       %1$s %2$s freeze     MAP\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       DATA := { [hex] BYTES }\n"
@@ -1593,11 +1593,6 @@ static int do_help(int argc, char **argv)
 		"                 queue | stack | sk_storage | struct_ops }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
 		bin_name, argv[-2]);
 
 	return 0;
diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c5e3895b7c8b..56c3a2bae3ef 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -458,10 +458,10 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } [dev <devname>]\n"
-		"       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
-		"       %s %s detach ATTACH_TYPE dev <devname>\n"
-		"       %s %s help\n"
+		"Usage: %1$s %2$s { show | list } [dev <devname>]\n"
+		"       %1$s %2$s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
+		"       %1$s %2$s detach ATTACH_TYPE dev <devname>\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
 		"       ATTACH_TYPE := { xdp | xdpgeneric | xdpdrv | xdpoffload }\n"
@@ -470,8 +470,8 @@ static int do_help(int argc, char **argv)
 		"      For progs attached to cgroups, use \"bpftool cgroup\"\n"
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
-		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		"      consult iproute2.\n"
+		"",
 		bin_name, argv[-2]);
 
 	return 0;
diff --git a/tools/bpf/bpftool/perf.c b/tools/bpf/bpftool/perf.c
index 3341aa14acda..ad23934819c7 100644
--- a/tools/bpf/bpftool/perf.c
+++ b/tools/bpf/bpftool/perf.c
@@ -231,7 +231,7 @@ static int do_show(int argc, char **argv)
 static int do_help(int argc, char **argv)
 {
 	fprintf(stderr,
-		"Usage: %s %s { show | list | help }\n"
+		"Usage: %1$s %2$s { show | list | help }\n"
 		"",
 		bin_name, argv[-2]);
 
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 245f941fdbcf..a5eff83496f2 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1984,24 +1984,24 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } [PROG]\n"
-		"       %s %s dump xlated PROG [{ file FILE | opcodes | visual | linum }]\n"
-		"       %s %s dump jited  PROG [{ file FILE | opcodes | linum }]\n"
-		"       %s %s pin   PROG FILE\n"
-		"       %s %s { load | loadall } OBJ  PATH \\\n"
+		"Usage: %1$s %2$s { show | list } [PROG]\n"
+		"       %1$s %2$s dump xlated PROG [{ file FILE | opcodes | visual | linum }]\n"
+		"       %1$s %2$s dump jited  PROG [{ file FILE | opcodes | linum }]\n"
+		"       %1$s %2$s pin   PROG FILE\n"
+		"       %1$s %2$s { load | loadall } OBJ  PATH \\\n"
 		"                         [type TYPE] [dev NAME] \\\n"
 		"                         [map { idx IDX | name NAME } MAP]\\\n"
 		"                         [pinmaps MAP_DIR]\n"
-		"       %s %s attach PROG ATTACH_TYPE [MAP]\n"
-		"       %s %s detach PROG ATTACH_TYPE [MAP]\n"
-		"       %s %s run PROG \\\n"
+		"       %1$s %2$s attach PROG ATTACH_TYPE [MAP]\n"
+		"       %1$s %2$s detach PROG ATTACH_TYPE [MAP]\n"
+		"       %1$s %2$s run PROG \\\n"
 		"                         data_in FILE \\\n"
 		"                         [data_out FILE [data_size_out L]] \\\n"
 		"                         [ctx_in FILE [ctx_out FILE [ctx_size_out M]]] \\\n"
 		"                         [repeat N]\n"
-		"       %s %s profile PROG [duration DURATION] METRICs\n"
-		"       %s %s tracelog\n"
-		"       %s %s help\n"
+		"       %1$s %2$s profile PROG [duration DURATION] METRICs\n"
+		"       %1$s %2$s tracelog\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       " HELP_SPEC_MAP "\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -2022,10 +2022,7 @@ static int do_help(int argc, char **argv)
 		"       METRIC := { cycles | instructions | l1d_loads | llc_misses }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2]);
 
 	return 0;
 }
diff --git a/tools/bpf/bpftool/struct_ops.c b/tools/bpf/bpftool/struct_ops.c
index e17738479edc..b58b91f62ffb 100644
--- a/tools/bpf/bpftool/struct_ops.c
+++ b/tools/bpf/bpftool/struct_ops.c
@@ -566,16 +566,15 @@ static int do_help(int argc, char **argv)
 	}
 
 	fprintf(stderr,
-		"Usage: %s %s { show | list } [STRUCT_OPS_MAP]\n"
-		"       %s %s dump [STRUCT_OPS_MAP]\n"
-		"       %s %s register OBJ\n"
-		"       %s %s unregister STRUCT_OPS_MAP\n"
-		"       %s %s help\n"
+		"Usage: %1$s %2$s { show | list } [STRUCT_OPS_MAP]\n"
+		"       %1$s %2$s dump [STRUCT_OPS_MAP]\n"
+		"       %1$s %2$s register OBJ\n"
+		"       %1$s %2$s unregister STRUCT_OPS_MAP\n"
+		"       %1$s %2$s help\n"
 		"\n"
 		"       OPTIONS := { {-j|--json} [{-p|--pretty}] }\n"
-		"       STRUCT_OPS_MAP := [ id STRUCT_OPS_MAP_ID | name STRUCT_OPS_MAP_NAME ]\n",
-		bin_name, argv[-2], bin_name, argv[-2],
-		bin_name, argv[-2], bin_name, argv[-2],
+		"       STRUCT_OPS_MAP := [ id STRUCT_OPS_MAP_ID | name STRUCT_OPS_MAP_NAME ]\n"
+		"",
 		bin_name, argv[-2]);
 
 	return 0;
-- 
2.20.1

