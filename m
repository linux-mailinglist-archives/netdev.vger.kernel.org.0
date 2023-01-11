Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B60E66631B
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239063AbjAKSxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238657AbjAKSwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:46 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F073D5C5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:39 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y1so17754744plb.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=seQBv597aySKCSnQbv5mdUEhyvgG5REi9mmE1tug4Cs=;
        b=5vSOFQ70YV6TaL7lizmKURQ55xDbLQYdUIX9lOQ2m1KXxK5cfzotawfXVsYGc68j/P
         9cqugqY7UgegrsZU0xdehoY3CodV6cGWYYJQWG5GV/CUjedArjP9ZgcF2e0DNgeVkdRy
         +4v1DWIwQFyR8nXsCQEqNCdjSeP4fe15UxBDmjQ1HcSFpiuEGFKjzoxokjnGSSiYXd7X
         RxCL1WB1wiJHb2xTQWmilgTcprImhwrrY9NR1VCUDgLBG6GPpG7yIC3uKB3VsAKj5Yng
         2LRBOkRppJ4Mv86ggA9xCQuQSCQz8R2MLC68vQVGDuOFmxZVa3yB3F5m0ziaSh4OLpbV
         kP2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=seQBv597aySKCSnQbv5mdUEhyvgG5REi9mmE1tug4Cs=;
        b=JbUmEl9REi2E8I5IurJYGfSMot8AQbaCkQRgoZ3ZP9RZy73ILVPNdQJAOoiAfQRTT0
         gspN8Bkv7IxMDL7Pg56WqRSBfweHLwyxm/qR/veYrG86pcSpqBc7KBUgg1uPPnQ972G3
         maYETrdPSKsE88goRktJsBdeiUgYQ6YT4kZnyecoM6ZwRHrgSboZVXMoDuSzdo3Semdc
         LrI3Miyo9BERa/p3gu0+vNvZ9EF99u+9echDRIGHtRJQdQEfEZIkUMYHkJv2FcR2CwyJ
         GD+08814pgPtF49tsUMPiCZKWE8Q3KnWigevExevAMrtPceLLof/jGESmi8ERLoZtJDI
         RLRg==
X-Gm-Message-State: AFqh2kq9P0iZKqm44g/VKDFJDyIK8KGCWjOKDfw263NT0zmV6vijbQ69
        dIzL+day5oQYGaueru8xvF7JUHWhuvQ/V6bMkUg=
X-Google-Smtp-Source: AMrXdXuF9pyaopcv0jMHTSnUYGmbT1Qxcpf7fD6APEcnMT/ZOvb2w3TxPq/l3vNOfERiOwzDh+QMKQ==
X-Received: by 2002:a17:90a:d58a:b0:219:7d75:de7b with SMTP id v10-20020a17090ad58a00b002197d75de7bmr73923099pju.35.1673463157486;
        Wed, 11 Jan 2023 10:52:37 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:37 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 09/11] tc: use SPDX
Date:   Wed, 11 Jan 2023 10:52:25 -0800
Message-Id: <20230111185227.69093-10-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
References: <20230111185227.69093-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace GPL boilerplate with SPDX.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tc/e_bpf.c        |  6 +-----
 tc/em_canid.c     |  6 +-----
 tc/em_cmp.c       |  6 +-----
 tc/em_ipset.c     |  5 +----
 tc/em_ipt.c       |  5 +----
 tc/em_meta.c      |  6 +-----
 tc/em_nbyte.c     |  6 +-----
 tc/em_u32.c       |  6 +-----
 tc/emp_ematch.y   |  1 +
 tc/f_basic.c      |  7 +------
 tc/f_bpf.c        |  6 +-----
 tc/f_cgroup.c     |  7 +------
 tc/f_flow.c       |  6 +-----
 tc/f_flower.c     |  6 +-----
 tc/f_fw.c         |  7 +------
 tc/f_matchall.c   |  7 +------
 tc/f_route.c      |  7 +------
 tc/f_rsvp.c       |  7 +------
 tc/f_u32.c        |  6 +-----
 tc/m_action.c     |  6 +-----
 tc/m_bpf.c        |  6 +-----
 tc/m_connmark.c   | 13 +------------
 tc/m_csum.c       |  6 +-----
 tc/m_ematch.c     |  6 +-----
 tc/m_estimator.c  |  7 +------
 tc/m_gact.c       |  7 +------
 tc/m_ife.c        |  7 +------
 tc/m_ipt.c        |  6 +-----
 tc/m_mirred.c     |  7 +------
 tc/m_nat.c        |  7 +------
 tc/m_pedit.c      |  7 +------
 tc/m_pedit.h      |  5 +----
 tc/m_police.c     | 10 +---------
 tc/m_sample.c     |  7 +------
 tc/m_simple.c     |  6 +-----
 tc/m_skbedit.c    | 14 +-------------
 tc/m_skbmod.c     |  7 +------
 tc/m_tunnel_key.c |  6 +-----
 tc/m_vlan.c       |  6 +-----
 tc/m_xt.c         |  6 +-----
 tc/m_xt_old.c     |  6 +-----
 tc/p_eth.c        |  6 +-----
 tc/p_icmp.c       |  7 +------
 tc/p_ip.c         |  7 +------
 tc/p_ip6.c        |  7 +------
 tc/p_tcp.c        |  7 +------
 tc/p_udp.c        |  7 +------
 tc/q_atm.c        |  1 -
 tc/q_cbq.c        |  7 +------
 tc/q_cbs.c        |  7 +------
 tc/q_choke.c      |  6 +-----
 tc/q_drr.c        |  7 +------
 tc/q_dsmark.c     |  1 -
 tc/q_etf.c        |  7 +------
 tc/q_fifo.c       |  7 +------
 tc/q_gred.c       |  6 +-----
 tc/q_hfsc.c       |  7 +------
 tc/q_ingress.c    |  6 +-----
 tc/q_mqprio.c     |  6 +-----
 tc/q_multiq.c     | 13 +------------
 tc/q_pie.c        | 12 +-----------
 tc/q_prio.c       |  7 +------
 tc/q_qfq.c        |  6 +-----
 tc/q_red.c        |  7 +------
 tc/q_sfb.c        |  9 +--------
 tc/q_sfq.c        |  7 +------
 tc/q_skbprio.c    |  7 +------
 tc/q_taprio.c     |  6 +-----
 tc/q_tbf.c        |  7 +------
 tc/tc.c           | 10 +---------
 tc/tc_cbq.c       |  7 +------
 tc/tc_class.c     |  7 +------
 tc/tc_core.c      |  7 +------
 tc/tc_estimator.c |  7 +------
 tc/tc_exec.c      |  6 +-----
 tc/tc_filter.c    |  7 +------
 tc/tc_monitor.c   |  7 +------
 tc/tc_qdisc.c     |  6 +-----
 tc/tc_red.c       |  7 +------
 tc/tc_stab.c      |  7 +------
 tc/tc_util.c      |  7 +------
 81 files changed, 79 insertions(+), 467 deletions(-)

diff --git a/tc/e_bpf.c b/tc/e_bpf.c
index 517ee5b35734..79cddace96a4 100644
--- a/tc/e_bpf.c
+++ b/tc/e_bpf.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * e_bpf.c	BPF exec proxy
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Daniel Borkmann <daniel@iogearbox.net>
  */
 
diff --git a/tc/em_canid.c b/tc/em_canid.c
index 197c707f43bf..6d06b66a5944 100644
--- a/tc/em_canid.c
+++ b/tc/em_canid.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * em_canid.c  Ematch rule to match CAN frames according to their CAN identifiers
  *
- *             This program is free software; you can distribute it and/or
- *             modify it under the terms of the GNU General Public License
- *             as published by the Free Software Foundation; either version
- *             2 of the License, or (at your option) any later version.
- *
  * Idea:       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
  * Copyright:  (c) 2011 Czech Technical University in Prague
  *             (c) 2011 Volkswagen Group Research
diff --git a/tc/em_cmp.c b/tc/em_cmp.c
index e051656f0bbb..dfd123df1e10 100644
--- a/tc/em_cmp.c
+++ b/tc/em_cmp.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * em_cmp.c		Simple comparison Ematch
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
  */
 
diff --git a/tc/em_ipset.c b/tc/em_ipset.c
index 48b287f5ba3b..f97abaf3cfb7 100644
--- a/tc/em_ipset.c
+++ b/tc/em_ipset.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * em_ipset.c		IPset Ematch
  *
@@ -8,10 +9,6 @@
  *                         Patrick Schaaf <bof@bof.de>
  *                         Martin Josefsson <gandalf@wlug.westbo.se>
  * Copyright (C) 2003-2010 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <stdbool.h>
diff --git a/tc/em_ipt.c b/tc/em_ipt.c
index b15c3ba56df4..69efefd8c5e3 100644
--- a/tc/em_ipt.c
+++ b/tc/em_ipt.c
@@ -1,11 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * em_ipt.c		IPtables extensions matching Ematch
  *
  * (C) 2018 Eyal Birger <eyal.birger@gmail.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
  */
 
 #include <getopt.h>
diff --git a/tc/em_meta.c b/tc/em_meta.c
index 2ddc65ed6cb6..6a5654f3a28b 100644
--- a/tc/em_meta.c
+++ b/tc/em_meta.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * em_meta.c		Metadata Ematch
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
  */
 
diff --git a/tc/em_nbyte.c b/tc/em_nbyte.c
index 274d713ffac8..9f421fb423a6 100644
--- a/tc/em_nbyte.c
+++ b/tc/em_nbyte.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * em_nbyte.c		N-Byte Ematch
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
  */
 
diff --git a/tc/em_u32.c b/tc/em_u32.c
index ea2bf882a12f..a83382ba4417 100644
--- a/tc/em_u32.c
+++ b/tc/em_u32.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * em_u32.c		U32 Ematch
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
  */
 
diff --git a/tc/emp_ematch.y b/tc/emp_ematch.y
index 4da3daed095c..716877b6fc41 100644
--- a/tc/emp_ematch.y
+++ b/tc/emp_ematch.y
@@ -1,4 +1,5 @@
 %{
+/* SPDX-License-Identifier: GPL-2.0-or-later */
  #include <stdio.h>
  #include <stdlib.h>
  #include <malloc.h>
diff --git a/tc/f_basic.c b/tc/f_basic.c
index 9055370e90b9..1ceb15d404f3 100644
--- a/tc/f_basic.c
+++ b/tc/f_basic.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_basic.c		Basic Classifier
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index 96e4576aa2f8..a6d4875fc057 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_bpf.c	BPF-based Classifier
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Daniel Borkmann <daniel@iogearbox.net>
  */
 
diff --git a/tc/f_cgroup.c b/tc/f_cgroup.c
index 633700e66aa8..a4fc03d1432e 100644
--- a/tc/f_cgroup.c
+++ b/tc/f_cgroup.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_cgroup.c		Control Group Classifier
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@infradead.org>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_flow.c b/tc/f_flow.c
index 9dd50df2e492..2445aaef51b3 100644
--- a/tc/f_flow.c
+++ b/tc/f_flow.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_flow.c		Flow filter
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Patrick McHardy <kaber@trash.net>
  */
 #include <stdio.h>
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 4c0a194836f5..48cfafdbc3c0 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_flower.c		Flower Classifier
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  */
 
diff --git a/tc/f_fw.c b/tc/f_fw.c
index 3c6ea93d2944..38bec492b49a 100644
--- a/tc/f_fw.c
+++ b/tc/f_fw.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_fw.c		FW filter.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_matchall.c b/tc/f_matchall.c
index 231d749e1f43..38b68d7e2450 100644
--- a/tc/f_matchall.c
+++ b/tc/f_matchall.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_matchall.c		Match-all Classifier
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Jiri Pirko <jiri@mellanox.com>, Yotam Gigi <yotamg@mellanox.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_route.c b/tc/f_route.c
index ad516b382ac0..e92c798574d8 100644
--- a/tc/f_route.c
+++ b/tc/f_route.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * f_route.c		ROUTE filter.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_rsvp.c b/tc/f_rsvp.c
index 0211c3f5e74b..84187d6207ca 100644
--- a/tc/f_rsvp.c
+++ b/tc/f_rsvp.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_rsvp.c		RSVP filter.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/f_u32.c b/tc/f_u32.c
index e4e0ab121c57..bfe9e5f98de4 100644
--- a/tc/f_u32.c
+++ b/tc/f_u32.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_u32.c		U32 filter.
  *
- *		This program is free software; you can u32istribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  *		Match mark added by Catalin(ux aka Dino) BOIE <catab at umbrella.ro> [5 nov 2004]
  *
diff --git a/tc/m_action.c b/tc/m_action.c
index b3fd019350b2..7b12b6fc51d8 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_action.c		Action Management
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  *
  * TODO:
diff --git a/tc/m_bpf.c b/tc/m_bpf.c
index af5ba5ce45dc..4eadcb6daac4 100644
--- a/tc/m_bpf.c
+++ b/tc/m_bpf.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_bpf.c	BPF based action module
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  *              Daniel Borkmann <daniel@iogearbox.net>
  */
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index 640bba9da18e..8506d95af5ec 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -1,19 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * m_connmark.c		Connection tracking marking import
  *
  * Copyright (c) 2011 Felix Fietkau <nbd@openwrt.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, see <http://www.gnu.org/licenses>.
  */
 
 #include <stdio.h>
diff --git a/tc/m_csum.c b/tc/m_csum.c
index 23c5972535c6..ba1e3e33b763 100644
--- a/tc/m_csum.c
+++ b/tc/m_csum.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_csum.c	checksum updating action
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors: Gregoire Baron <baronchon@n7mm.org>
  */
 
diff --git a/tc/m_ematch.c b/tc/m_ematch.c
index 8840a0dc62a1..e30ee20542d4 100644
--- a/tc/m_ematch.c
+++ b/tc/m_ematch.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_ematch.c		Extended Matches
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Thomas Graf <tgraf@suug.ch>
  */
 
diff --git a/tc/m_estimator.c b/tc/m_estimator.c
index b5f4c860c606..98fc5e73f3c6 100644
--- a/tc/m_estimator.c
+++ b/tc/m_estimator.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_estimator.c	Parse/print estimator module options.
  *
- *		This program is free software; you can u32istribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_gact.c b/tc/m_gact.c
index 2ef52cd10559..e294a701bfd1 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_gact.c		generic actions module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 70ab1d754fc5..162607ce7415 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_ife.c	IFE actions module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (jhs@mojatatu.com)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_ipt.c b/tc/m_ipt.c
index 046b310e64ab..465d1b8073d0 100644
--- a/tc/m_ipt.c
+++ b/tc/m_ipt.c
@@ -1,12 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_ipt.c	iptables based targets
  *		utilities mostly ripped from iptables <duh, its the linux way>
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  */
 
diff --git a/tc/m_mirred.c b/tc/m_mirred.c
index 38d8043baa46..e5653e67f791 100644
--- a/tc/m_mirred.c
+++ b/tc/m_mirred.c
@@ -1,15 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_egress.c		ingress/egress packet mirror/redir actions module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  *
  * TODO: Add Ingress support
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_nat.c b/tc/m_nat.c
index 654f9a3bd95e..583151254f73 100644
--- a/tc/m_nat.c
+++ b/tc/m_nat.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_nat.c		NAT module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Herbert Xu <herbert@gondor.apana.org.au>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 54949e431953..afdd020b92bc 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -1,18 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit.c		generic packet editor actions module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  *
  * TODO:
  *	1) Big endian broken in some spots
  *	2) A lot of this stuff was added on the fly; get a big double-double
  *	and clean it up at some point.
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_pedit.h b/tc/m_pedit.h
index 549bcf86a91f..8f3771e16255 100644
--- a/tc/m_pedit.h
+++ b/tc/m_pedit.h
@@ -1,10 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit.h		generic packet editor actions module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
  *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  *
diff --git a/tc/m_police.c b/tc/m_police.c
index f38ab90a3039..46c39a818761 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -1,16 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_police.c		Parse/print policing module options.
  *
- *		This program is free software; you can u32istribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- * FIXES:       19990619 - J Hadi Salim (hadi@cyberus.ca)
- *		simple addattr packaging fix.
- *		2002: J Hadi Salim - Add tc action extensions syntax
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_sample.c b/tc/m_sample.c
index 696d76095ae6..769de144cbe0 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_sample.c		ingress/egress packet sampling module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Yotam Gigi <yotamg@mellanox.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_simple.c b/tc/m_simple.c
index bc86be27cbcc..fe2bca21ae46 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_simple.c	simple action
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	J Hadi Salim <jhs@mojatatu.com>
  *
  * Pedagogical example. Adds a string that will be printed every time
diff --git a/tc/m_skbedit.c b/tc/m_skbedit.c
index 46d92b25582f..d55a6128494e 100644
--- a/tc/m_skbedit.c
+++ b/tc/m_skbedit.c
@@ -1,22 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * m_skbedit.c		SKB Editing module
  *
  * Copyright (c) 2008, Intel Corporation.
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- *
  * Authors:	Alexander Duyck <alexander.h.duyck@intel.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_skbmod.c b/tc/m_skbmod.c
index 8d8bac5bc481..b1c8d00dfe47 100644
--- a/tc/m_skbmod.c
+++ b/tc/m_skbmod.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_skbmod.c	skb modifier action module
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (jhs@mojatatu.com)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index ca0dff119a49..1b4c8bd640eb 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_tunnel_key.c	ip tunnel manipulation module
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Amir Vadai <amir@vadai.me>
  */
 
diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index 1b2b1d51ed2d..c1dc8b428e61 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_vlan.c		vlan manipulation module
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  */
 
diff --git a/tc/m_xt.c b/tc/m_xt.c
index deaf96a26f75..8a6fd3ce0ffc 100644
--- a/tc/m_xt.c
+++ b/tc/m_xt.c
@@ -1,12 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_xt.c	xtables based targets
  *		utilities mostly ripped from iptables <duh, its the linux way>
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  */
 
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c
index db014898590d..efa084c5441b 100644
--- a/tc/m_xt_old.c
+++ b/tc/m_xt_old.c
@@ -1,12 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_xt.c	xtables based targets
  *		utilities mostly ripped from iptables <duh, its the linux way>
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
  */
 
diff --git a/tc/p_eth.c b/tc/p_eth.c
index 7b6b61f809d3..b35e0c2b7c9a 100644
--- a/tc/p_eth.c
+++ b/tc/p_eth.c
@@ -1,13 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit_eth.c	packet editor: ETH header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
  *
  * Authors:  Amir Vadai (amir@vadai.me)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/p_icmp.c b/tc/p_icmp.c
index 933ca8a5ff1e..074d02f43019 100644
--- a/tc/p_icmp.c
+++ b/tc/p_icmp.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit_icmp.c	packet editor: ICMP header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/p_ip.c b/tc/p_ip.c
index 8eed9e8da57d..7f66ef3143fb 100644
--- a/tc/p_ip.c
+++ b/tc/p_ip.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * p_ip.c		packet editor: IPV4 header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/p_ip6.c b/tc/p_ip6.c
index f855c59e1f6b..3f8c23e46933 100644
--- a/tc/p_ip6.c
+++ b/tc/p_ip6.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * p_ip6.c		packet editor: IPV6 header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  Amir Vadai <amir@vadai.me>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/p_tcp.c b/tc/p_tcp.c
index ec7b08a28c07..43d7fb48c194 100644
--- a/tc/p_tcp.c
+++ b/tc/p_tcp.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit_tcp.c	packet editor: TCP header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/p_udp.c b/tc/p_udp.c
index 742955e6d225..d98224fb3836 100644
--- a/tc/p_udp.c
+++ b/tc/p_udp.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * m_pedit_udp.c	packet editor: UDP header
  *
- *		This program is free software; you can distribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:  J Hadi Salim (hadi@cyberus.ca)
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_atm.c b/tc/q_atm.c
index 77b56825f777..07866ccf2fce 100644
--- a/tc/q_atm.c
+++ b/tc/q_atm.c
@@ -3,7 +3,6 @@
  * q_atm.c		ATM.
  *
  * Hacked 1998-2000 by Werner Almesberger, EPFL ICA
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_cbq.c b/tc/q_cbq.c
index 4619a37b8160..58afdca76a61 100644
--- a/tc/q_cbq.c
+++ b/tc/q_cbq.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_cbq.c		CBQ.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_cbs.c b/tc/q_cbs.c
index 13bb08e97e42..788535c6a022 100644
--- a/tc/q_cbs.c
+++ b/tc/q_cbs.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_cbs.c		CBS.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_choke.c b/tc/q_choke.c
index 570c3599e28b..7653eb7ef9c8 100644
--- a/tc/q_choke.c
+++ b/tc/q_choke.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_choke.c		CHOKE.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Stephen Hemminger <shemminger@vyatta.com>
  */
 
diff --git a/tc/q_drr.c b/tc/q_drr.c
index 4e829ce3331d..03c4744f6f26 100644
--- a/tc/q_drr.c
+++ b/tc/q_drr.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_drr.c		DRR.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Patrick McHardy <kaber@trash.net>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_dsmark.c b/tc/q_dsmark.c
index d3e8292d777c..9adceba59c99 100644
--- a/tc/q_dsmark.c
+++ b/tc/q_dsmark.c
@@ -3,7 +3,6 @@
  * q_dsmark.c		Differentiated Services field marking.
  *
  * Hacked 1998,1999 by Werner Almesberger, EPFL ICA
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_etf.c b/tc/q_etf.c
index c2090589bc64..572e2bc89fc1 100644
--- a/tc/q_etf.c
+++ b/tc/q_etf.c
@@ -1,14 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_etf.c		Earliest TxTime First (ETF).
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
  *		Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_fifo.c b/tc/q_fifo.c
index ce82e74dcc5e..9b2c5348d375 100644
--- a/tc/q_fifo.c
+++ b/tc/q_fifo.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_fifo.c		FIFO.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_gred.c b/tc/q_gred.c
index 01f12eeeffad..f6a3f05eb95e 100644
--- a/tc/q_gred.c
+++ b/tc/q_gred.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_gred.c		GRED.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:    J Hadi Salim(hadi@nortelnetworks.com)
  *             code ruthlessly ripped from
  *	       Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
diff --git a/tc/q_hfsc.c b/tc/q_hfsc.c
index 81c10210c884..609d925a42e5 100644
--- a/tc/q_hfsc.c
+++ b/tc/q_hfsc.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_hfsc.c	HFSC.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Patrick McHardy, <kaber@trash.net>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_ingress.c b/tc/q_ingress.c
index 93313c9c2aec..3df4914c7d64 100644
--- a/tc/q_ingress.c
+++ b/tc/q_ingress.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_ingress.c             INGRESS.
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:    J Hadi Salim
  */
 
diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index 706452d08092..99c43491e0be 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_mqprio.c	MQ prio qdisc
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Author:	John Fastabend, <john.r.fastabend@intel.com>
  */
 
diff --git a/tc/q_multiq.c b/tc/q_multiq.c
index 8ad9e0b2fa3c..b1e6c9a83708 100644
--- a/tc/q_multiq.c
+++ b/tc/q_multiq.c
@@ -1,20 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * q_multiq.c		Multiqueue aware qdisc
  *
  * Copyright (c) 2008, Intel Corporation.
  *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- *
  * Author: Alexander Duyck <alexander.h.duyck@intel.com>
  *
  * Original Authors:	PJ Waskiewicz, <peter.p.waskiewicz.jr@intel.com> (RR)
diff --git a/tc/q_pie.c b/tc/q_pie.c
index 709a78b4c7c4..177cdcae0f2e 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -1,18 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
 /* Copyright (C) 2013 Cisco Systems, Inc, 2013.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
  *
  * Author: Vijay Subramanian <vijaynsu@cisco.com>
  * Author: Mythili Prabhu <mysuryan@cisco.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_prio.c b/tc/q_prio.c
index a723a151bb7f..c8c6477e1a98 100644
--- a/tc/q_prio.c
+++ b/tc/q_prio.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_prio.c		PRIO.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_qfq.c b/tc/q_qfq.c
index eb8fa4b84927..c9955cc96a97 100644
--- a/tc/q_qfq.c
+++ b/tc/q_qfq.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_qfq.c	QFQ.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Stephen Hemminger <shemminger@vyatta.com>
  *		Fabio Checconi <fabio@gandalf.sssup.it>
  *
diff --git a/tc/q_red.c b/tc/q_red.c
index fd50d37d31cb..f760253d13b2 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_red.c		RED.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_sfb.c b/tc/q_sfb.c
index 8af55d98c36a..a2eef281e10f 100644
--- a/tc/q_sfb.c
+++ b/tc/q_sfb.c
@@ -1,17 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_sfb.c	Stochastic Fair Blue.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Juliusz Chroboczek <jch@pps.jussieu.fr>
- *
  */
 
-
-
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
diff --git a/tc/q_sfq.c b/tc/q_sfq.c
index d04a440cece7..17bf8f63f105 100644
--- a/tc/q_sfq.c
+++ b/tc/q_sfq.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_sfq.c		SFQ.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_skbprio.c b/tc/q_skbprio.c
index ca81a72cc8b1..b0ba180ab9c4 100644
--- a/tc/q_skbprio.c
+++ b/tc/q_skbprio.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_skbprio.c		SKB PRIORITY QUEUE.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Nishanth Devarajan, <ndev2021@gmail.com>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index a7c01ae0cedb..e00d2aa9a842 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_taprio.c	Time Aware Priority Scheduler
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Vinicius Costa Gomes <vinicius.gomes@intel.com>
  * 		Jesus Sanchez-Palencia <jesus.sanchez-palencia@intel.com>
  */
diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index 4e5bf382fd03..caea6bebd871 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * q_tbf.c		TBF.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc.c b/tc/tc.c
index 7557b9778111..258205004611 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -1,16 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc.c		"tc" utility frontend.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
- * Fixes:
- *
- * Petri Mattila <petri@prihateam.fi> 990308: wrong memset's resulted in faults
  */
 
 #include <stdio.h>
diff --git a/tc/tc_cbq.c b/tc/tc_cbq.c
index f56011ad1d07..7d1a44569f1d 100644
--- a/tc/tc_cbq.c
+++ b/tc/tc_cbq.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_cbq.c		CBQ maintenance routines.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 409af2db7a3d..c1feb0098feb 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_class.c		"tc class".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_core.c b/tc/tc_core.c
index 498d35dca8fb..8276f6a1f60b 100644
--- a/tc/tc_core.c
+++ b/tc/tc_core.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_core.c		TC core library.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_estimator.c b/tc/tc_estimator.c
index f494b7caa44e..275f254949d2 100644
--- a/tc/tc_estimator.c
+++ b/tc/tc_estimator.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_core.c		TC core library.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_exec.c b/tc/tc_exec.c
index 9b912ceb1916..5d8834029a0b 100644
--- a/tc/tc_exec.c
+++ b/tc/tc_exec.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_exec.c	"tc exec".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Daniel Borkmann <daniel@iogearbox.net>
  */
 
diff --git a/tc/tc_filter.c b/tc/tc_filter.c
index 71be2e8119c9..9617d28a831f 100644
--- a/tc/tc_filter.c
+++ b/tc/tc_filter.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_filter.c		"tc filter".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_monitor.c b/tc/tc_monitor.c
index 64f31491607e..2573d744a0ee 100644
--- a/tc/tc_monitor.c
+++ b/tc/tc_monitor.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_monitor.c		"tc monitor".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Jamal Hadi Salim
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index 33a6665eaac0..b97f21822e27 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_qdisc.c		"tc qdisc".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  *		J Hadi Salim: Extension to ingress
  */
diff --git a/tc/tc_red.c b/tc/tc_red.c
index 88f5ff358ce5..700a9212f227 100644
--- a/tc/tc_red.c
+++ b/tc/tc_red.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_red.c		RED maintenance routines.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_stab.c b/tc/tc_stab.c
index 0f944003458d..a773372635e7 100644
--- a/tc/tc_stab.c
+++ b/tc/tc_stab.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_stab.c		"tc qdisc ... stab *".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Jussi Kivilinna, <jussi.kivilinna@mbnet.fi>
- *
  */
 
 #include <stdio.h>
diff --git a/tc/tc_util.c b/tc/tc_util.c
index d2622063a6d4..f72a19ca2757 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tc_util.c		Misc TC utility functions.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdio.h>
-- 
2.39.0

