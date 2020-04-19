Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC71AF74B
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 07:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgDSFk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 01:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgDSFk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 01:40:28 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB5DC061A0C;
        Sat, 18 Apr 2020 22:40:27 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y22so2688889pll.4;
        Sat, 18 Apr 2020 22:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bPVIUnhpn5RHDI8r11G3ie7ZaiM3eFgs6kxLFDlrSS0=;
        b=a5ZDLaMToUSJucKTJFWpoBiiWt8BJR2lWFsODuf3v4guFyptJPyzwiMveSZ/uigpxV
         cssE/tU2GKr78BSSNBtaINtFNja7PrvVT9/I21dKYYj46j54mL9QpuGAII/C4PDyxgiN
         D3lFa/Dpz+SerJ5Pqyj/7Lt0TDuyurpxquIHa/y1dJq/Zifkud9wHUFKndFB/i+nTh4F
         f0wXMY5xXzUhUAfCcIk90PL1iwHOBRM3bmLsR3IeHTwW2aWrsKZ/bbpSmBSiRAmNBXaZ
         ZMXwTCx0345eX1DeOfRafA7Q3i1Y71O9pCw2TD/CWE2IdfD2yOKVU37EokOU1XJ0E+1A
         12HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bPVIUnhpn5RHDI8r11G3ie7ZaiM3eFgs6kxLFDlrSS0=;
        b=mWaon5nxx/GvUakLuUqS7mkj7pJCg3x4Gve2SHgLgIrtkcQi+F/LH3Y7zKsQnQ0eug
         zBLYER6/jappd7J3zEGaZgAmb+Rxm13esWvxn/iajLzrK4gmPgDcufef8wB5OEhrTEoF
         EIJwoEcGztMPegKCJEO6CpiZ0H1LMo+y+kUZX/4ILIo0mXAztowl34K/EWYD90bvaZww
         fde1uNkV+DzntqVPMEn6V4do4dZq1cz4/lXKPIHJH2NwDXRR8a7yKraxVN4Nlg6Z/BQk
         jNPflhBPfC8if+kG9ztlhgJOxe2icyHI87pqVFgo+mSkb0ndlvYTkPtlKc2efyInB8BP
         QRQQ==
X-Gm-Message-State: AGi0PuYiK49T0PglwZ9y7uoq9VCP116pIkt1YdVdG5yyEKqbxZgGG0I5
        WXN3hYca5zrNAnvMgfWakgE=
X-Google-Smtp-Source: APiQypLNVqmeUiARA55otEbpzxjO4AJ7ocoR2hG8ioSsB47tHuE3Dl8WThUnJ/a2sB78usPVrEZfBw==
X-Received: by 2002:a17:90a:1ae9:: with SMTP id p96mr13624600pjp.75.1587274826841;
        Sat, 18 Apr 2020 22:40:26 -0700 (PDT)
Received: from CentOS76.localdomain.localdomain ([27.59.158.48])
        by smtp.gmail.com with ESMTPSA id t5sm6437224pjo.19.2020.04.18.22.40.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 Apr 2020 22:40:26 -0700 (PDT)
From:   jagdsh.linux@gmail.com
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, kuba@kernel.org,
        quentin@isovalent.com, jolsa@kernel.org, toke@redhat.com,
        paul.chaignon@orange.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jagadeesh Pagadala <jagdsh.linux@gmail.com>
Subject: [PATCH] tools/bpf/bpftool: Remove duplicate headers
Date:   Sun, 19 Apr 2020 11:09:17 +0530
Message-Id: <1587274757-14101-1-git-send-email-jagdsh.linux@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jagadeesh Pagadala <jagdsh.linux@gmail.com>

Code cleanup: Remove duplicate headers which are included twice.

Signed-off-by: Jagadeesh Pagadala <jagdsh.linux@gmail.com>
---
 tools/bpf/bpftool/btf.c        | 1 -
 tools/bpf/bpftool/gen.c        | 1 -
 tools/bpf/bpftool/jit_disasm.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index bcaf55b..41a1346 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -15,7 +15,6 @@
 #include <linux/hashtable.h>
 #include <sys/types.h>
 #include <sys/stat.h>
-#include <unistd.h>
 
 #include "json_writer.h"
 #include "main.h"
diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index f8113b3..0e5f023 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -17,7 +17,6 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
-#include <unistd.h>
 #include <bpf/btf.h>
 
 #include "bpf/libbpf_internal.h"
diff --git a/tools/bpf/bpftool/jit_disasm.c b/tools/bpf/bpftool/jit_disasm.c
index f7f5885..e7e7eee 100644
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -15,7 +15,6 @@
 #include <stdio.h>
 #include <stdarg.h>
 #include <stdint.h>
-#include <stdio.h>
 #include <stdlib.h>
 #include <assert.h>
 #include <unistd.h>
-- 
1.8.3.1

