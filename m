Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0924387B31
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 15:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407100AbfHINdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 09:33:18 -0400
Received: from mail-pg1-f169.google.com ([209.85.215.169]:34529 "EHLO
        mail-pg1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405928AbfHINdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 09:33:18 -0400
Received: by mail-pg1-f169.google.com with SMTP id n9so39661852pgc.1
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 06:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qLab/dzi1IiP5tJHqIV24vxngwjpLjGN2Bds0gCjb30=;
        b=tAhfyyPNiNRZWS0mtTOZGG5nBy4cB7+DBcEBjDcvsK9sed5L39tzwoFWiwD9g1BBb3
         jyhQBYN3mEldHM8MjKUwh51Cb1kTYiXIXqN0fheOJSQRc9Kd0i6308jAejATvsn6h9T9
         ILZnIsPVdHyPuiFi+cI3yv8sacd30wiB0C2CT9NjlN3xYsSgaK7pGz7rnjUpraLU9grl
         8CB3DGUpMYwTVtyJpz6UNc2+dWpdisFoJBPVmM2omdPZ/bQ1EKG862dBeEq4HlWslVjP
         EIRJ93GyGNT00z0Yok0r68pkjQ7rTM5UUpZA/TTolmarn02R9N8Npn8jujVu3MtItDS1
         KWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLab/dzi1IiP5tJHqIV24vxngwjpLjGN2Bds0gCjb30=;
        b=m8OS3TbriHgLeivdCsEUbmK3KRjVbO2l6Ipdlyd93Wnu6eowNKCrQNAF2ZeRY4uAmT
         lL473JaTQWguiaMWOITQqkfSJB1Hr1AhdP6EYX6MJRV7jYIkk7+wT2gIaefRCC3TbZJQ
         cunPfLxh3yrdTi7kYqzfaxErE417KPVwACiacKsogJb3483oR6OQmlSMbzXDYx6kndUn
         Wf9fVgKMPnuT2Bo08CYCHhT99VCyr8Us4xNCgmfSnKVIa5tNJmhKyR2Zk/kwc+Q3CULb
         wQCqBX1gjI6EPjUtJ8Rmd6DwwetsUCMQGKO1Jo6n/NgjtGdsDVWGFf0KmC00LrGWmACK
         WjvA==
X-Gm-Message-State: APjAAAVQBGgUPGXoSusT/JMf2OYQbHWo6gUxGVCs343FjxMVz6QhrHiY
        n5UxMgTmdswLpyBGggE9fw==
X-Google-Smtp-Source: APXvYqxFj2fYfejkS8Y6Mpoba1Au1wq9fb32JfAoJwIZigvH4LFPhOxtFeJs/3I1NCu7Z4AhDoMsBw==
X-Received: by 2002:a65:4489:: with SMTP id l9mr18005007pgq.207.1565357597567;
        Fri, 09 Aug 2019 06:33:17 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id f15sm7242912pje.17.2019.08.09.06.33.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 06:33:16 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v4,4/4] tools: bpftool: add documentation for net attach/detach
Date:   Fri,  9 Aug 2019 22:32:48 +0900
Message-Id: <20190809133248.19788-5-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190809133248.19788-1-danieltimlee@gmail.com>
References: <20190809133248.19788-1-danieltimlee@gmail.com>
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

