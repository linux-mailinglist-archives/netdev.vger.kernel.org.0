Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78EC66631F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbjAKSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbjAKSwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601903C727
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:35 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b17so10233901pld.7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PzRi/OFPd7IUQ4hK8SxYdKVbLg7z+Ng8fCrdtEpWZ0E=;
        b=CI2gX2HJrHC08JN+PRo593OAaImX53x3eLG3QPcgHE0OceEwiopMWh1aHRc18XAQ3H
         aSu8aQDnqbwuMGOTlS9zjQpnfpm8/Q5EDCwiRp+bCggQ5iO6SfY3I1GoQWKV/4z8WZrw
         DHhy+khvu+KOS1thwsk/4h+orUOkFRVbBH31iElSrd1ny71jbTkV2rgcey1zbT9kJ/Zy
         a9QBffQY8DxKGSdjUTefHgtQCZwJzuXqoTGSQT9F3wh+rE//8iraKLezCUTW8ruw500q
         d3M3NKMjeS6IQemRrj1kUJxGlPR/SUtybGcFzsa5ypkUxHelfWueoK6tEohQ1WqvcACC
         VuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PzRi/OFPd7IUQ4hK8SxYdKVbLg7z+Ng8fCrdtEpWZ0E=;
        b=GyZ/uI4q7cKHQrSA5sahu1ryC2MRamnJ6FpJj6FXM9V+QiruRqSnu8aVXzNCYfwIfH
         1kBzKk8CbyfAF/3hkqw3c64ZbztghZsoDsWsh2JUzS828hH2k1mhWH6pJSFvUvTREec2
         grkiDst2dbL3dFMTBkaceExzogeFB/DzlsOL+GPB9wqqXiyPls0VCNmy+N4OYIJLZ3eC
         tXwtOjd1+aLYMTk67hGIapoW4kjbFnbhhKIH2zyt7m7GkFRGJKN1+HRKPDVB9meshCdE
         Tn9MpFn/pS8mieyejio58Z6BF/fUg4osueqOZ4bacexxJszwROJHJPh5gNA4gG86OWZX
         xUDg==
X-Gm-Message-State: AFqh2kqEi16I12sUfAaxzWGmCCgvPSsejO4Ww44pHzD3CtlOf1U0hdjw
        iBxdZVIKMVHs62bfkABol4qkDfsvfJ7mj92ypx8=
X-Google-Smtp-Source: AMrXdXuywvXASAQpinopzXKUXO3YjjAXlpmn3CdGDvo6Xyv94xsL0h4MOmpJMPnDKcrUw3AcsK07Pw==
X-Received: by 2002:a17:90a:5904:b0:227:e10:9a93 with SMTP id k4-20020a17090a590400b002270e109a93mr12849097pji.20.1673463153636;
        Wed, 11 Jan 2023 10:52:33 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:33 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 05/11] ip: use SPDX
Date:   Wed, 11 Jan 2023 10:52:21 -0800
Message-Id: <20230111185227.69093-6-stephen@networkplumber.org>
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

Use SPDX instead of boilerplate text for ip and related
sub commands.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 ip/ip.c                  |  6 +-----
 ip/ip6tunnel.c           | 15 +--------------
 ip/ipaddress.c           |  7 +------
 ip/ipaddrlabel.c         | 16 +---------------
 ip/ipfou.c               |  6 +-----
 ip/ipila.c               |  6 +-----
 ip/ipl2tp.c              |  7 +------
 ip/iplink.c              |  7 +------
 ip/iplink_amt.c          |  6 +-----
 ip/iplink_batadv.c       |  1 +
 ip/iplink_bond.c         |  6 +-----
 ip/iplink_bond_slave.c   |  6 +-----
 ip/iplink_bridge.c       |  6 +-----
 ip/iplink_bridge_slave.c |  6 +-----
 ip/iplink_can.c          |  6 +-----
 ip/iplink_geneve.c       |  6 +-----
 ip/iplink_hsr.c          |  6 +-----
 ip/iplink_ipoib.c        |  6 +-----
 ip/iplink_ipvlan.c       |  6 +-----
 ip/iplink_macvlan.c      |  6 +-----
 ip/iplink_netdevsim.c    |  1 +
 ip/iplink_vlan.c         |  6 +-----
 ip/iplink_vrf.c          |  6 +-----
 ip/iplink_vxcan.c        |  6 +-----
 ip/iplink_vxlan.c        |  6 +-----
 ip/iplink_xdp.c          |  6 +-----
 ip/iplink_xstats.c       |  6 +-----
 ip/ipmacsec.c            |  6 +-----
 ip/ipmaddr.c             |  7 +------
 ip/ipmonitor.c           |  7 +------
 ip/ipmroute.c            |  7 +------
 ip/ipneigh.c             |  7 +------
 ip/ipnetconf.c           |  7 +------
 ip/ipntable.c            | 18 ++----------------
 ip/ipprefix.c            | 17 ++---------------
 ip/iproute.c             |  7 +------
 ip/iproute_lwtunnel.c    |  7 +------
 ip/iprule.c              |  7 +------
 ip/ipseg6.c              |  5 +----
 ip/iptoken.c             |  6 +-----
 ip/iptunnel.c            |  7 +------
 ip/iptuntap.c            |  7 +------
 ip/ipvrf.c               |  7 +------
 ip/ipxfrm.c              | 20 ++------------------
 ip/link_gre.c            |  7 +------
 ip/link_gre6.c           |  7 +------
 ip/link_ip6tnl.c         |  7 +------
 ip/link_iptnl.c          |  7 +------
 ip/link_veth.c           |  7 +------
 ip/link_vti.c            |  6 +-----
 ip/link_vti6.c           |  6 +-----
 ip/rtm_map.c             |  7 +------
 ip/rtmon.c               |  7 +------
 ip/tcp_metrics.c         |  5 +----
 ip/tunnel.c              | 18 ++----------------
 ip/tunnel.h              | 15 +--------------
 ip/xfrm.h                | 17 +----------------
 ip/xfrm_monitor.c        | 20 ++------------------
 ip/xfrm_policy.c         | 20 ++------------------
 ip/xfrm_state.c          | 20 ++------------------
 60 files changed, 67 insertions(+), 432 deletions(-)

diff --git a/ip/ip.c b/ip/ip.c
index 863e42aad9eb..8424736f2904 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ip.c		"ip" utility frontend.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
  */
 
diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 5399f91d3923..347bd46a6d98 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -1,20 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2006 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * Author:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 5e8334823044..c7553bcdbc5e 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipaddress.c		"ip address".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru>
- *
  */
 
 #include <stdarg.h>
diff --git a/ip/ipaddrlabel.c b/ip/ipaddrlabel.c
index beb08da3bfc2..46f68c41130c 100644
--- a/ip/ipaddrlabel.c
+++ b/ip/ipaddrlabel.c
@@ -1,26 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipaddrlabel.c	"ip addrlabel"
  *
  * Copyright (C)2007 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- *
- *
  * Based on iprule.c.
  *
  * Authors:	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
- *
  */
 
 #include <stdio.h>
diff --git a/ip/ipfou.c b/ip/ipfou.c
index 9c6977705c99..ed99a548412e 100644
--- a/ip/ipfou.c
+++ b/ip/ipfou.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipfou.c	FOU (foo over UDP) support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:	Tom Herbert <therbert@google.com>
  */
 
diff --git a/ip/ipila.c b/ip/ipila.c
index 475c35b5c4b0..335d15f68bae 100644
--- a/ip/ipila.c
+++ b/ip/ipila.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipila.c	ILA (Identifier Locator Addressing) support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:	Tom Herbert <tom@herbertland.com>
  */
 
diff --git a/ip/ipl2tp.c b/ip/ipl2tp.c
index f1d574de31e3..87a4b898052d 100644
--- a/ip/ipl2tp.c
+++ b/ip/ipl2tp.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipl2tp.c	       "ip l2tp"
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Original Author:	James Chapman <jchapman@katalix.com>
- *
  */
 
 #include <stdio.h>
diff --git a/ip/iplink.c b/ip/iplink.c
index e94dc6a51353..4ec9e370b107 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink.c		"ip link".
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
diff --git a/ip/iplink_amt.c b/ip/iplink_amt.c
index 48e079f8b781..3a35bd9df9d1 100644
--- a/ip/iplink_amt.c
+++ b/ip/iplink_amt.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_amt.c	AMT device support
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Taehee Yoo <ap420073@gmail.com>
  */
 
diff --git a/ip/iplink_batadv.c b/ip/iplink_batadv.c
index 45bd923f766d..27d316762e70 100644
--- a/ip/iplink_batadv.c
+++ b/ip/iplink_batadv.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_batadv.c	Batman-adv support
  *
diff --git a/ip/iplink_bond.c b/ip/iplink_bond.c
index 7943499e0adf..214244daad2f 100644
--- a/ip/iplink_bond.c
+++ b/ip/iplink_bond.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_bond.c	Bonding device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  *              Scott Feldman <sfeldma@cumulusnetworks.com>
  */
diff --git a/ip/iplink_bond_slave.c b/ip/iplink_bond_slave.c
index 8103704bc9aa..ad6875006950 100644
--- a/ip/iplink_bond_slave.c
+++ b/ip/iplink_bond_slave.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_bond_slave.c	Bonding slave device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  */
 
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 8b0c142294f6..7e4e62c81c0c 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_bridge.c	Bridge device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  */
 
diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index ca4b264e64e7..43b429485502 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_bridge_slave.c	Bridge slave device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Jiri Pirko <jiri@resnulli.us>
  */
 
diff --git a/ip/iplink_can.c b/ip/iplink_can.c
index 9bbe3d95876b..f2967db5d2b6 100644
--- a/ip/iplink_can.c
+++ b/ip/iplink_can.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_can.c	CAN device support
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Wolfgang Grandegger <wg@grandegger.com>
  */
 
diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index 98099cc9eece..62c61bce138b 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_geneve.c	GENEVE device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     John W. Linville <linville@tuxdriver.com>
  */
 
diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index da2d03d4bcbc..76f24a6ac3ed 100644
--- a/ip/iplink_hsr.c
+++ b/ip/iplink_hsr.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_hsr.c	HSR device support
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Arvid Brodin <arvid.brodin@alten.se>
  *
  *		Based on iplink_vlan.c by Patrick McHardy <kaber@trash.net>
diff --git a/ip/iplink_ipoib.c b/ip/iplink_ipoib.c
index b730c5335020..7bf4e3215dd2 100644
--- a/ip/iplink_ipoib.c
+++ b/ip/iplink_ipoib.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_ipoib.c	IPoIB device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Or Gerlitz <ogerlitz@mellanox.com>
  *		copied iflink_vlan.c authored by Patrick McHardy <kaber@trash.net>
  */
diff --git a/ip/iplink_ipvlan.c b/ip/iplink_ipvlan.c
index baae767b82c1..f29fa4f9e3eb 100644
--- a/ip/iplink_ipvlan.c
+++ b/ip/iplink_ipvlan.c
@@ -1,9 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /* iplink_ipvlan.c	IPVLAN/IPVTAP device support
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
  *
  * Authors:     Mahesh Bandewar <maheshb@google.com>
  */
diff --git a/ip/iplink_macvlan.c b/ip/iplink_macvlan.c
index 05e6bc77c8c3..0f13637d8fbc 100644
--- a/ip/iplink_macvlan.c
+++ b/ip/iplink_macvlan.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_macvlan.c	macvlan/macvtap device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Patrick McHardy <kaber@trash.net>
  *		Arnd Bergmann <arnd@arndb.de>
  */
diff --git a/ip/iplink_netdevsim.c b/ip/iplink_netdevsim.c
index 34486081f6d4..5aaa775abad7 100644
--- a/ip/iplink_netdevsim.c
+++ b/ip/iplink_netdevsim.c
@@ -1,3 +1,4 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 #include <stdio.h>
 #include <stdlib.h>
 
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 1426f2afca23..4ac5bc03f2b3 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_vlan.c	VLAN device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Patrick McHardy <kaber@trash.net>
  */
 
diff --git a/ip/iplink_vrf.c b/ip/iplink_vrf.c
index 5d20f29d3526..9474a2b78c5f 100644
--- a/ip/iplink_vrf.c
+++ b/ip/iplink_vrf.c
@@ -1,9 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /* iplink_vrf.c	VRF device support
- *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
  *
  * Authors:     Shrijeet Mukherjee <shm@cumulusnetworks.com>
  */
diff --git a/ip/iplink_vxcan.c b/ip/iplink_vxcan.c
index 8b08c9a70c65..e0f9bacbd3db 100644
--- a/ip/iplink_vxcan.c
+++ b/ip/iplink_vxcan.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_vxcan.c	vxcan device support (Virtual CAN Tunnel)
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Author:	Oliver Hartkopp <socketcan@hartkopp.net>
  * Based on:	link_veth.c from Pavel Emelianov <xemul@openvz.org>
  */
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 01522d6ebd02..c7e0e1c47606 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_vxlan.c	VXLAN device support
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Stephen Hemminger <shemminger@vyatta.com
  */
 
diff --git a/ip/iplink_xdp.c b/ip/iplink_xdp.c
index 4a490bc8fb66..5928dff75b8a 100644
--- a/ip/iplink_xdp.c
+++ b/ip/iplink_xdp.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_xdp.c XDP program loader
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Daniel Borkmann <daniel@iogearbox.net>
  */
 
diff --git a/ip/iplink_xstats.c b/ip/iplink_xstats.c
index 1d180b0bdada..6c184c02cb31 100644
--- a/ip/iplink_xstats.c
+++ b/ip/iplink_xstats.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iplink_stats.c       Extended statistics commands
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
  */
 
diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
index 6dd7382785a3..f3b2e03bdaeb 100644
--- a/ip/ipmacsec.c
+++ b/ip/ipmacsec.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipmacsec.c		"ip macsec".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Sabrina Dubroca <sd@queasysnail.net>
  */
 
diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
index d41ac63a74ec..f8d6b992d254 100644
--- a/ip/ipmaddr.c
+++ b/ip/ipmaddr.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipmaddr.c		"ip maddress".
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
diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index d808369c2898..9b055264ca7b 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipmonitor.c		"ip monitor".
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
diff --git a/ip/ipmroute.c b/ip/ipmroute.c
index 32019c944c52..b6d9e618f284 100644
--- a/ip/ipmroute.c
+++ b/ip/ipmroute.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipmroute.c		"ip mroute".
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
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 0cf7bb60553a..ee14ffcccc46 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipneigh.c		"ip neigh".
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
diff --git a/ip/ipnetconf.c b/ip/ipnetconf.c
index bb0ebe12da93..7ddaefb407ed 100644
--- a/ip/ipnetconf.c
+++ b/ip/ipnetconf.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipnetconf.c		"ip netconf".
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Nicolas Dichtel, <nicolas.dichtel@6wind.com>
- *
  */
 
 #include <stdio.h>
diff --git a/ip/ipntable.c b/ip/ipntable.c
index 762c790d10fc..4ce02a315fe1 100644
--- a/ip/ipntable.c
+++ b/ip/ipntable.c
@@ -1,23 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2006 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on ipneigh.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/ipprefix.c b/ip/ipprefix.c
index 466af2088d90..ddf770146784 100644
--- a/ip/ipprefix.c
+++ b/ip/ipprefix.c
@@ -1,23 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2005 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
  *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on ip.c, iproute.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/iproute.c b/ip/iproute.c
index f34289e836ec..0bab0fdfae13 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iproute.c		"ip route".
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
diff --git a/ip/iproute_lwtunnel.c b/ip/iproute_lwtunnel.c
index bf4468b6db16..52221c6976b3 100644
--- a/ip/iproute_lwtunnel.c
+++ b/ip/iproute_lwtunnel.c
@@ -1,14 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iproute_lwtunnel.c
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Roopa Prabhu, <roopa@cumulusnetworks.com>
  *		Thomas Graf <tgraf@suug.ch>
- *
  */
 
 #include <stdio.h>
diff --git a/ip/iprule.c b/ip/iprule.c
index 8e5a2287ca6f..654ffffe3cc0 100644
--- a/ip/iprule.c
+++ b/ip/iprule.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iprule.c		"ip rule".
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
diff --git a/ip/ipseg6.c b/ip/ipseg6.c
index 4f541ae4232c..305b89614af5 100644
--- a/ip/ipseg6.c
+++ b/ip/ipseg6.c
@@ -1,10 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * seg6.c "ip sr/seg6"
  *
- *	  This program is free software; you can redistribute it and/or
- *	  modify it under the terms of the GNU General Public License
- *	  version 2 as published by the Free Software Foundation;
- *
  * Author: David Lebrun <david.lebrun@uclouvain.be>
  */
 
diff --git a/ip/iptoken.c b/ip/iptoken.c
index 9f35689006cf..f25a7c8b21f5 100644
--- a/ip/iptoken.c
+++ b/ip/iptoken.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iptoken.c    "ip token"
  *
- *              This program is free software; you can redistribute it and/or
- *              modify it under the terms of the GNU General Public License
- *              as published by the Free Software Foundation; either version
- *              2 of the License, or (at your option) any later version.
- *
  * Authors:     Daniel Borkmann, <borkmann@redhat.com>
  */
 
diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index 7a0e723714cc..02c3670b469d 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iptunnel.c	       "ip tunnel"
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
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 8e4e09bff838..ab7d5d87a02d 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * iptunnel.c	       "ip tuntap"
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	David Woodhouse <David.Woodhouse@intel.com>
- *
  */
 
 #include <stdio.h>
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 915780310cf1..0718bea8bba9 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * ipvrf.c	"ip vrf"
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	David Ahern <dsa@cumulusnetworks.com>
- *
  */
 
 #include <sys/types.h>
diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
index 7a1ebc9539b3..b78c712dfd73 100644
--- a/ip/ipxfrm.c
+++ b/ip/ipxfrm.c
@@ -1,25 +1,9 @@
-/* $USAGI: $ */
-
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2004 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on ip.c, iproute.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/link_gre.c b/ip/link_gre.c
index f462a227a507..74a5b5e9652a 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_gre.c	gre driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Herbert Xu <herbert@gondor.apana.org.au>
- *
  */
 
 #include <string.h>
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 232d9bde24d9..b03bd65adb53 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_gre6.c	gre driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Dmitry Kozlov <xeb@mail.ru>
- *
  */
 
 #include <string.h>
diff --git a/ip/link_ip6tnl.c b/ip/link_ip6tnl.c
index 2fcc13ef64d3..b27d696f565a 100644
--- a/ip/link_ip6tnl.c
+++ b/ip/link_ip6tnl.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_ip6tnl.c	ip6tnl driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Nicolas Dichtel <nicolas.dichtel@6wind.com>
- *
  */
 
 #include <string.h>
diff --git a/ip/link_iptnl.c b/ip/link_iptnl.c
index b25855ba2004..1315aebe93f2 100644
--- a/ip/link_iptnl.c
+++ b/ip/link_iptnl.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_iptnl.c	ipip and sit driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Nicolas Dichtel <nicolas.dichtel@6wind.com>
- *
  */
 
 #include <string.h>
diff --git a/ip/link_veth.c b/ip/link_veth.c
index 33e8f2b102e7..6da5b64f73ce 100644
--- a/ip/link_veth.c
+++ b/ip/link_veth.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_veth.c	veth driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Pavel Emelianov <xemul@openvz.org>
- *
  */
 
 #include <string.h>
diff --git a/ip/link_vti.c b/ip/link_vti.c
index 3a52ea870b56..509432543fc5 100644
--- a/ip/link_vti.c
+++ b/ip/link_vti.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_vti.c	VTI driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Herbert Xu <herbert@gondor.apana.org.au>
  *          Saurabh Mohan <saurabh.mohan@vyatta.com> Modified link_gre.c for VTI
  */
diff --git a/ip/link_vti6.c b/ip/link_vti6.c
index 0b080fa9f4dd..5764221ebb89 100644
--- a/ip/link_vti6.c
+++ b/ip/link_vti6.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * link_vti6.c	VTI driver module
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Herbert Xu <herbert@gondor.apana.org.au>
  *		Saurabh Mohan <saurabh.mohan@vyatta.com> Modified link_gre.c for VTI
  *		Steffen Klassert <steffen.klassert@secunet.com> Modified link_vti.c for IPv6
diff --git a/ip/rtm_map.c b/ip/rtm_map.c
index 8d8eafe0ae99..29463baedda0 100644
--- a/ip/rtm_map.c
+++ b/ip/rtm_map.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * rtm_map.c
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
diff --git a/ip/rtmon.c b/ip/rtmon.c
index b021f773d071..aad9968f967b 100644
--- a/ip/rtmon.c
+++ b/ip/rtmon.c
@@ -1,13 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * rtmon.c		RTnetlink listener.
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
diff --git a/ip/tcp_metrics.c b/ip/tcp_metrics.c
index acbd745ab09e..9c8fb07240bf 100644
--- a/ip/tcp_metrics.c
+++ b/ip/tcp_metrics.c
@@ -1,10 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * tcp_metrics.c	"ip tcp_metrics/tcpmetrics"
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		version 2 as published by the Free Software Foundation;
- *
  * Authors:	Julian Anastasov <ja@ssi.bg>, August 2012
  */
 
diff --git a/ip/tunnel.c b/ip/tunnel.c
index 224c81e42e9b..75cb0b51e4c0 100644
--- a/ip/tunnel.c
+++ b/ip/tunnel.c
@@ -1,23 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2006 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * split from ip_tunnel.c
- */
-/*
+ *
  * Author:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/tunnel.h b/ip/tunnel.h
index 604f8cbfd6db..0c9852e32364 100644
--- a/ip/tunnel.h
+++ b/ip/tunnel.h
@@ -1,20 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2006 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * Author:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/xfrm.h b/ip/xfrm.h
index 6f251603f108..33c42730375d 100644
--- a/ip/xfrm.h
+++ b/ip/xfrm.h
@@ -1,22 +1,7 @@
-/* $USAGI: $ */
-
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2004 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/xfrm_monitor.c b/ip/xfrm_monitor.c
index b0056d9de432..1f67fe9d14ff 100644
--- a/ip/xfrm_monitor.c
+++ b/ip/xfrm_monitor.c
@@ -1,25 +1,9 @@
-/* $USAGI: $ */
-
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2005 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on ipmonitor.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index be5fcfed2027..be2235ca949d 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -1,25 +1,9 @@
-/* $USAGI: $ */
-
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2004 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on iproute.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index 16c65e23a7e7..aa0dce072dff 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -1,25 +1,9 @@
-/* $USAGI: $ */
-
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * Copyright (C)2004 USAGI/WIDE Project
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses>.
- */
-/*
  * based on iproute.c
- */
-/*
+ *
  * Authors:
  *	Masahide NAKAMURA @USAGI
  */
-- 
2.39.0

