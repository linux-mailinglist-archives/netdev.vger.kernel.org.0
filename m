Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0C8666631C
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235757AbjAKSwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238088AbjAKSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:38 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBDC35939
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:36 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id y1so17754608plb.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ziUbJeTFsQYm5JeFZurTZRkyo/IR+1XCeqcNEjCGOY=;
        b=ymGkfAncQJ+wJW6inedp5P6GBTdFdvk5a3iNLFkTC27Ufhy6JkHIBP38jKdkcjeldB
         3MzeipUTPQyHykvBW7M7aOSrsgKwxnnyJg5U8qZOq/hi+7zMVp0t5DE2ADRhz5HxLgQ+
         x3mcmOYcqxKmTFkUDjvGVYYx3BebsoUjv6/byMc29kT+ZwfOxxpVCwSqYk0iWh+a8rhz
         ADQc47qTO/axmtKffoB+MEUjr3fzezy9w+D/K3D7QASFY8fmvaIIHVGBjCzbjbMMF1t/
         zIkkQnGAu2fJACcCRTtgHvw7CoZd6bVGsL/Ua91Z6azOhbczSs0UhFAU73WIK9neBILw
         IowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ziUbJeTFsQYm5JeFZurTZRkyo/IR+1XCeqcNEjCGOY=;
        b=zoXc0opxj+3M4TvuRs3S8wHGbhZ81x37PKv0kqK5gwEgCqMUj0AW1iK0+7/Y1toNNs
         rdrAjCz2V0K8+hx+9+xKoYm4nJCeSABCo2bDq/rUd4DILLPznuSeIpTeINdlgQ2NLhh5
         aBHaADACgCYDWo6tE2g223Hok3VQjOO57ziqxklxqbglYRpuBr8CFIe1cGLRNkcxl5oZ
         D/JuZ38aek/OL7QaL2jrlQ+qpBvqMJW3UbvRg3ogQ/8cw0iseWTgC0sjvKsVAtVHDcfD
         9z7/c4eYYylUmru5ckjRKvQgNgUe5tudfjEgOETCsJ57ko74b/xVzAxRKpLDSc7zBsgG
         xXfg==
X-Gm-Message-State: AFqh2kqto6HIXLm6sGTCBRZKZCAe5FxB+hpKSsmjlWxl/ydGm1WyPoNV
        anjaTEgFPwj5W13PtGZyLRy/OC8JzdDLjkIS2zw=
X-Google-Smtp-Source: AMrXdXvMYC2t+eMw/ud1N6dN330Os+6S5bdpLdcyVnI3isYDN34+DtYxfSttzdeivDj1cP+k+XUvJg==
X-Received: by 2002:a05:6a20:d909:b0:ad:db18:e94 with SMTP id jd9-20020a056a20d90900b000addb180e94mr4177169pzb.49.1673463155532;
        Wed, 11 Jan 2023 10:52:35 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:34 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 07/11] tipc: use SPDX
Date:   Wed, 11 Jan 2023 10:52:23 -0800
Message-Id: <20230111185227.69093-8-stephen@networkplumber.org>
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

