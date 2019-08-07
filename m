Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B748426F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbfHGCZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:25:28 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:46138 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfHGCZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:25:27 -0400
Received: by mail-pf1-f175.google.com with SMTP id c3so19426246pfa.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RL9OfB7Pvpp+2w2uwWJY8ONKEntbC3nG5wDwgLYgTPo=;
        b=MiJ11qAuGMuzmudVRka3iSN5D8CJ2W3bFkbvAD26lzbMtaTAnswj9rCaTlR4n9FOrA
         lbnkrgIC1aAI/mMKz2z/E5rDL9z2l/qfzvxOt/OL+Oo4bK5D2lLtDrkEKrjD8uaW9VWo
         hHiIQ61zPjFsCPxM8m0Sf7Q0PBfnH76A8iRnYe4Ugu+qbnytfTQBT9SD1C8W5BdWlJ71
         mlVAVdhS/90nmONR3J6pOQqg/TNLVL2hbYQqIRZIJX8qT0it5zf2UuDrWjmJPDzav9Sz
         nMgs1kMVq22ddmQPxnsraZFYJEIXPpyjy3tdlGIWx0h7sqsWWDlX7/d5xDCnNhWHsS1P
         TDnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RL9OfB7Pvpp+2w2uwWJY8ONKEntbC3nG5wDwgLYgTPo=;
        b=sF8kIdedyzlrBJfnldtMaD/ZnCxOSrZEy1wPOp5RgF+lnM2gtI9O1LFPFxMu48p2Om
         wZm5PC4rktdSsodsNI4nrTx+hSbaj34LsCyIaiXt5oOjLZ5IxkbYcPrGNphw0K2c1sjC
         aHQW2vnxaC6lmt/Pwlgd6k+eIpWczGjJHclYZDFu915s5XEcr4Ro1pE9xWSWIQQFknsK
         6MEJSQp+X2HbZ1kHqOV0zKQ7sQ0gussCh1kZhJSL2yrWVF5Af2VJyRl7ZA42tCRaRYVO
         nCB9kKyOO2NFAm1a6ODL+rFVTAtWB7rgpHJ01P/04zy21NgBtSk/QDkxAdbLsgj6bzHA
         TdoA==
X-Gm-Message-State: APjAAAUcNhMZvwOfxAHPk2V6jaAFYvyUB8x/bZjfmusx4PI5lcuftkO+
        IL0GIel8UMGsOCUrDQg8Cg==
X-Google-Smtp-Source: APXvYqyPbgHCMxziaGhS+DsaZs3gAv8FtYsOgIvqpSpp0zU2oimmzLAcy41mnJUri+GxHt92NO2LPg==
X-Received: by 2002:a62:1616:: with SMTP id 22mr7063657pfw.120.1565144727106;
        Tue, 06 Aug 2019 19:25:27 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id b126sm129275991pfa.126.2019.08.06.19.25.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 19:25:26 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v3,4/4] tools: bpftool: add documentation for net attach/detach
Date:   Wed,  7 Aug 2019 11:25:09 +0900
Message-Id: <20190807022509.4214-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807022509.4214-1-danieltimlee@gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
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
 .../bpf/bpftool/Documentation/bpftool-net.rst | 51 +++++++++++++++++--
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-net.rst b/tools/bpf/bpftool/Documentation/bpftool-net.rst
index d8e5237a2085..4ad1a380e186 100644
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
+|	**bpftool** **net { show | list }** [ **dev** *name* ]
+|	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
+|	**bpftool** **net detach** *ATTACH_TYPE* **dev** *name*
 |	**bpftool** **net help**
+|
+|	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
+|	*ATTACH_TYPE* := { **xdp** | **xdpgeneric** | **xdpdrv** | **xdpoffload** }
 
 DESCRIPTION
 ===========
-	**bpftool net { show | list } [ dev name ]**
+	**bpftool net { show | list }** [ **dev** *name* ]
                   List bpf program attachments in the kernel networking subsystem.
 
                   Currently, only device driver xdp attachments and tc filter
@@ -47,6 +52,18 @@ DESCRIPTION
                   all bpf programs attached to non clsact qdiscs, and finally all
                   bpf programs attached to root and clsact qdisc.
 
+	**bpftool** **net attach** *ATTACH_TYPE* *PROG* **dev** *name* [ **overwrite** ]
+                  Attach bpf program *PROG* to network interface *name* with
+                  type specified by *ATTACH_TYPE*. Previously attached bpf program
+                  can be replaced by the command used with **overwrite** option.
+                  Currently, *ATTACH_TYPE* only contains XDP programs.
+
+	**bpftool** **net detach** *ATTACH_TYPE* **dev** *name*
+                  Detach bpf program attached to network interface *name* with
+                  type specified by *ATTACH_TYPE*. To detach bpf program, same
+                  *ATTACH_TYPE* previously used for attach must be specified.
+                  Currently, *ATTACH_TYPE* only contains XDP programs.
+
 	**bpftool net help**
 		  Print short help message.
 
@@ -137,6 +154,34 @@ EXAMPLES
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

