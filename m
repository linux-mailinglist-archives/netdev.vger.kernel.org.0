Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6BF8ACD6
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 04:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfHMCqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 22:46:38 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:37345 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfHMCqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 22:46:38 -0400
Received: by mail-pl1-f178.google.com with SMTP id bj8so1631060plb.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 19:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qLab/dzi1IiP5tJHqIV24vxngwjpLjGN2Bds0gCjb30=;
        b=fUjpP48laG38mTdTqZtdwJeIn6A8MEeKWKwLvxtdzhmhNFDNF2AL6zINnV0eaDc6KZ
         uuqLvFQZ2q0EbOrzdopxeFJMzm+9/gLcIL+L4Um44/KMK//FeQjJeNBU4TYjViEZ87io
         iVLVfEhgtSHGwfl4akU2LwAQ//AyEOFuvvUBiE9fwnFvjsZFsbLe45S0RcyjBksZ9ngF
         NSLzmJ0tew0szZ03veJIsU0YTLSGJ7EDYhlGrtXUUX9Ae8loF4iiZR00o57ew26Os5bS
         zhk27uVOTsyIjcbnd/cKwPgA3tYeuiM2rZM9HB0I/5K2Rv4Z32t6u+BPtiJ1omjmu0vw
         Y9gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLab/dzi1IiP5tJHqIV24vxngwjpLjGN2Bds0gCjb30=;
        b=RfmLGMy3Dqq7czx1mKL9+dorc5CWvZw3bpGEh/SVBSwRPPI/4Pk5bUE88SYGJCeK6k
         jtnUIdutgXHogURMTZuwFUpRvW2GJHEvgeCo2YI5g/KLdgwg78r4GL+kk4Kr2kdegHRX
         QX7BZW0KEyMk53rVnBgE6eUTxHv8OSpP/M64R5TS27iaitevKdvRXufxJv0ONzJ7oyBj
         rMKGQKlrSc5Uw2IzmGY6xvPYs5GlUOLzK6a7vBzHNtYTdyOS43ul6e2THNMJmnmMvA3Q
         KUeBFSlgsa6wwu21easOAc8zpk/MoorFv99xRYGUWdpbI+xB+RTFPX2j/rl/Nm9CARUP
         99fg==
X-Gm-Message-State: APjAAAXtl37bVcbxekQ2K9gZTmWP9GT2qalppPUOWwHZdz+e+5ymRpe2
        4BL11/IDRqrLTicA9CpJ/Q==
X-Google-Smtp-Source: APXvYqyST/Zc+8kvUBy7F3cATEcJD53Ysyfbmp2MNBU+9J6KzClyAIICQc9UYhpa83IUPWteIgs9XA==
X-Received: by 2002:a17:902:b08a:: with SMTP id p10mr36198933plr.83.1565664397883;
        Mon, 12 Aug 2019 19:46:37 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id h17sm6359826pfo.24.2019.08.12.19.46.35
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 19:46:37 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v5,4/4] tools: bpftool: add documentation for net attach/detach
Date:   Tue, 13 Aug 2019 11:46:21 +0900
Message-Id: <20190813024621.29886-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813024621.29886-1-danieltimlee@gmail.com>
References: <20190813024621.29886-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since, new sub-command 'net attach/detach' has been added for
attaching XDP program on interface,
this commit documents usage and sample output of `net attach/detach`.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 .../bpf/bpftool/Documentation/bpftool-net.rst | 57 ++++++++++++++++++-
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index d8e5237a2085..8651b00b81ea 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-net.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-net.rst
@@ -15,17 +15,22 @@ SYNOPSIS
 	*OPTIONS* := { [{ **-j** | **--json** }] [{ **-p** | **--pretty** }] }
 
 	*COMMANDS* :=
-	{ **show** | **list** } [ **dev** name ] | **help**
+	{ **show** | **list** | **attach** | **detach** | **help** }
 
 NET COMMANDS
 ============
 
-|	**bpftool** **net { show | list } [ dev name ]**
+|	**bpftool** **net { show | list }** [ **dev** *NAME* ]
+|	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *NAME* [ **overwrite** ]
+|	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
 |	**bpftool** **net help**
+|
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
+|	*ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
 
 DESCRIPTION
 ===========
-	**bpftool net { show | list } [ dev name ]**
+	**bpftool net { show | list }** [ **dev** *NAME* ]
                   List bpf program attachments in the kernel networking subsystem.
 
                   Currently, only device driver xdp attachments and tc filter
@@ -47,6 +52,24 @@ DESCRIPTION
                   all bpf programs attached to non clsact qdiscs, and finally all
                   bpf programs attached to root and clsact qdisc.
 
+	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *NAME* [ **overwrite** ]
+                  Attach bpf program *PROG* to network interface *NAME* with
+                  type specified by *ATTACH_TYPE*. Previously attached bpf program
+                  can be replaced by the command used with **overwrite** option.
+                  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
+
+                  *ATTACH_TYPE* can be of:
+                  **xdp** - try native XDP and fallback to generic XDP if NIC driver does not support it;
+                  **xdpgeneric** - Generic XDP. runs at generic XDP hook when packet already enters receive path as skb;
+                  **xdpdrv** - Native XDP. runs earliest point in driver's receive path;
+                  **xdpoffload** - Offload XDP. runs directly on NIC on each packet reception;
+
+	**bpftool** **net detach** *ATTACH_TYPE* **dev** *NAME*
+                  Detach bpf program attached to network interface *NAME* with
+                  type specified by *ATTACH_TYPE*. To detach bpf program, same
+                  *ATTACH_TYPE* previously used for attach must be specified.
+                  Currently, only XDP-related modes are supported for *ATTACH_TYPE*.
+
 	**bpftool net help**
 		  Print short help message.
 
@@ -137,6 +160,34 @@ EXAMPLES
         }
     ]
 
+|
+| **# bpftool net attach xdpdrv id 16 dev enp6s0np0**
+| **# bpftool net**
+
+::
+
+      xdp:
+      enp6s0np0(4) driver id 16
+
+|
+| **# bpftool net attach xdpdrv id 16 dev enp6s0np0**
+| **# bpftool net attach xdpdrv id 20 dev enp6s0np0 overwrite**
+| **# bpftool net**
+
+::
+
+      xdp:
+      enp6s0np0(4) driver id 20
+
+|
+| **# bpftool net attach xdpdrv id 16 dev enp6s0np0**
+| **# bpftool net detach xdpdrv dev enp6s0np0**
+| **# bpftool net**
+
+::
+
+      xdp:
+
 
 SEE ALSO
 ========
-- 
2.20.1

