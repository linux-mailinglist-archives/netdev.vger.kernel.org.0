Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36FC9665239
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbjAKDR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjAKDRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:22 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8750313D66
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:21 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id z4-20020a17090a170400b00226d331390cso15675319pjd.5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ziUbJeTFsQYm5JeFZurTZRkyo/IR+1XCeqcNEjCGOY=;
        b=z+CmJubwIbONojA/WNNq7oI7gTgyWDDec8SdJmt6yTSxLt6mQR3DYFNE3JlW6XK1j6
         k8jDBEYVQsLxIdu3Iz3qFegjC6mV1JXnJN9tttOkcRmITPf3s40tmlzNr0HF2qBI9HXa
         Db9IK9haFfRsQT1w4qXc/sCZ0k0E5dHEtwzRZ323738v0dCI4XW7/3pDtNZ/fQNfHNf4
         SXewOF342sAcWr2v0W8m1LGzleml2mcKDCmzH8hRGbpf7SWfjRgnGppoIvHVKSmSzmn/
         pyJlVJluaCu4zRjryDV/als+8bEcTGwxRo1RPAPN0V8UVGq57xKH197+mY6CqNAxPob4
         wMvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ziUbJeTFsQYm5JeFZurTZRkyo/IR+1XCeqcNEjCGOY=;
        b=s3vOeGcs3JWvJPdGusyVoaOCu32Aq/5uT6NR/QsOIvASB0y1Skv2GfR/jr4T6r9bWF
         CBXF3l10BclswrsKAetUd737AIlM5A/41Dnx/Rd24dc3Ay6EkwmGba1sZiJdrv+FL3rl
         RN1lDzTYmVpU386jRCiWLkaLldhNKtqchLNsNT/WOOEk0HAm6W4jLDufbefAuSZ6/hun
         +wemaDeItQe6Iwt8Gzg+eUI+5CadPVqpyqx7v4fIm0mHMiUjZOe9EJOB+WOXuyK68Fnu
         yQdax+DG6OukiFJ4yKEcLL5YiBBoRJ03xGb/COdVtJGqNaAhmjkD7SJJlgC6ek7pxqL6
         GPqw==
X-Gm-Message-State: AFqh2kq7onrB97iH5Z1oELIUHpj9wjSxzwxhryyJ5NWgFWDQb+ppD/QM
        r/qmbjE8twOvIGyxeGBTdiTWwSgcfHSNouzuR/w=
X-Google-Smtp-Source: AMrXdXu0CvDA/LWY5Ox/cnxl2jVnJfpltgh6ubIUHPY7DBAvs5jrNwQjt3QxK5Yx8AWPZIu2nUfxLw==
X-Received: by 2002:a17:902:e5cd:b0:192:9140:ee76 with SMTP id u13-20020a170902e5cd00b001929140ee76mr71203659plf.37.1673407040572;
        Tue, 10 Jan 2023 19:17:20 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:20 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 07/10] tipc: use SPDX
Date:   Tue, 10 Jan 2023 19:17:09 -0800
Message-Id: <20230111031712.19037-8-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
References: <20230111031712.19037-1-stephen@networkplumber.org>
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

Replace boilerplate GPL text with SPDX

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 tipc/bearer.c    | 6 +-----
 tipc/bearer.h    | 6 +-----
 tipc/cmdl.c      | 6 +-----
 tipc/cmdl.h      | 6 +-----
 tipc/link.c      | 6 +-----
 tipc/link.h      | 6 +-----
 tipc/media.c     | 6 +-----
 tipc/media.h     | 6 +-----
 tipc/misc.c      | 6 +-----
 tipc/misc.h      | 6 +-----
 tipc/msg.c       | 6 +-----
 tipc/msg.h       | 6 +-----
 tipc/nametable.c | 6 +-----
 tipc/nametable.h | 6 +-----
 tipc/node.c      | 6 +-----
 tipc/node.h      | 6 +-----
 tipc/peer.c      | 6 +-----
 tipc/peer.h      | 6 +-----
 tipc/socket.c    | 6 +-----
 tipc/socket.h    | 6 +-----
 tipc/tipc.c      | 6 +-----
 21 files changed, 21 insertions(+), 105 deletions(-)

diff --git a/tipc/bearer.c b/tipc/bearer.c
index 968293bc9160..bb434f5f74bc 100644
--- a/tipc/bearer.c
+++ b/tipc/bearer.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * bearer.c	TIPC bearer functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/bearer.h b/tipc/bearer.h
index c0d099630b27..a93446592b26 100644
--- a/tipc/bearer.h
+++ b/tipc/bearer.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * bearer.h	TIPC bearer functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/cmdl.c b/tipc/cmdl.c
index feaac2da175f..152ddb517ebb 100644
--- a/tipc/cmdl.c
+++ b/tipc/cmdl.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * cmdl.c	Framework for handling command line options.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/cmdl.h b/tipc/cmdl.h
index dcade362e692..18fe51bf24a7 100644
--- a/tipc/cmdl.h
+++ b/tipc/cmdl.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * cmdl.h	Framework for handling command line options.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/link.c b/tipc/link.c
index 53f49c8937db..f91c300016f2 100644
--- a/tipc/link.c
+++ b/tipc/link.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link.c	TIPC link functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/link.h b/tipc/link.h
index 6dc95e5b69b9..a0d4603580c5 100644
--- a/tipc/link.h
+++ b/tipc/link.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link.c	TIPC link functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/media.c b/tipc/media.c
index a3fec681cbf4..5ff0c8c489f1 100644
--- a/tipc/media.c
+++ b/tipc/media.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * media.c	TIPC link functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/media.h b/tipc/media.h
index 8584af74b72e..f1b4b54055a2 100644
--- a/tipc/media.h
+++ b/tipc/media.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * media.h	TIPC link functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/misc.c b/tipc/misc.c
index 6175bf07d07c..32d4a5e0b1d1 100644
--- a/tipc/misc.c
+++ b/tipc/misc.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * misc.c	Miscellaneous TIPC helper functions.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/misc.h b/tipc/misc.h
index 59309f68f201..d00d7c9caa2b 100644
--- a/tipc/misc.h
+++ b/tipc/misc.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * misc.h	Miscellaneous TIPC helper functions.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/msg.c b/tipc/msg.c
index 1225691c9a81..731b0fa76784 100644
--- a/tipc/msg.c
+++ b/tipc/msg.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * msg.c	Messaging (netlink) helper functions.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/msg.h b/tipc/msg.h
index 56af5a705fb9..118a26647559 100644
--- a/tipc/msg.h
+++ b/tipc/msg.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * msg.h	Messaging (netlink) helper functions.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/nametable.c b/tipc/nametable.c
index b09ed5fc7280..5162f7fcf479 100644
--- a/tipc/nametable.c
+++ b/tipc/nametable.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * nametable.c	TIPC nametable functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/nametable.h b/tipc/nametable.h
index e0473e18e75b..c4df8d9d209a 100644
--- a/tipc/nametable.h
+++ b/tipc/nametable.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * nametable.h	TIPC nametable functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/node.c b/tipc/node.c
index bf592a074635..e645d374cd82 100644
--- a/tipc/node.c
+++ b/tipc/node.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * node.c	TIPC node functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/node.h b/tipc/node.h
index afee1fd06039..4a986d078bfb 100644
--- a/tipc/node.h
+++ b/tipc/node.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * node.h	TIPC node functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/peer.c b/tipc/peer.c
index ed18efc552fa..5a583fb9185e 100644
--- a/tipc/peer.c
+++ b/tipc/peer.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * peer.c	TIPC peer functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/peer.h b/tipc/peer.h
index 89722616529e..2bd0a2a37b15 100644
--- a/tipc/peer.h
+++ b/tipc/peer.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * peer.h	TIPC peer functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/socket.c b/tipc/socket.c
index 597ffd91af52..4d376e075885 100644
--- a/tipc/socket.c
+++ b/tipc/socket.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * socket.c	TIPC socket functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/socket.h b/tipc/socket.h
index 9d1b64872f53..c4341bb213d6 100644
--- a/tipc/socket.h
+++ b/tipc/socket.h
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * socket.h	TIPC socket functionality.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
diff --git a/tipc/tipc.c b/tipc/tipc.c
index 9f23a4bfd25d..56af052cbbcd 100644
--- a/tipc/tipc.c
+++ b/tipc/tipc.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * tipc.	TIPC utility frontend.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Richard Alpe <richard.alpe@ericsson.com>
  */
 
-- 
2.39.0

