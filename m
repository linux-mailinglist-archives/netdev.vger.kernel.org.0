Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC7B39C3D6
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 01:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbhFDXXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 19:23:31 -0400
Received: from mailrelay3-2.pub.mailoutpod1-cph3.one.com ([46.30.212.2]:36571
        "EHLO mailrelay3-2.pub.mailoutpod1-cph3.one.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229873AbhFDXX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 19:23:28 -0400
X-Greylist: delayed 963 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jun 2021 19:23:28 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bordum.dk; s=20191106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
         from;
        bh=SlgsVQRojbtbhqhWPWoR0U722emhmutf5u88htHKubI=;
        b=IsTImQzgObPaJJ03Tja6yycxqfaA0bqO2GDQKbRnY0z4sa8BdVfTKJbVU0KoiTjwJDu3iq/iA1zuk
         tN7GqrzQhX92rMTjhIWftBEvPCl3iqQl0Bh/zAo65g82WgrHa1p0uQm0f45vHUb+f2iOJ7c4197Vw8
         9BCyGbpjc45dvlUMCd+n8VpyftSN6dYXn+L41zLwPZrfIO8Qq0B3XRXDBD9pz5I0z5flsNW48vgEON
         pie2kYpjuIEakyd7cR4Iw1357fVO1jAiisgB1GmgnD/CThjnaqEr71xVVwyx4dUcHiGgXpbXiiuml6
         cUgZmC7BXgz6XxN+z/HFXXmmjmhIpJw==
X-HalOne-Cookie: cef3b369ddadb490c164b8a60e295f16499df4d3
X-HalOne-ID: 5f5b1d6f-c589-11eb-8cd9-d0431ea8bb03
Received: from localhost.localdomain (2-111-64-240-cable.dk.customer.tdc.net [2.111.64.240])
        by mailrelay3.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id 5f5b1d6f-c589-11eb-8cd9-d0431ea8bb03;
        Fri, 04 Jun 2021 23:05:36 +0000 (UTC)
From:   Carl Bordum Hansen <carl@bordum.dk>
To:     netdev@vger.kernel.org
Cc:     Carl Bordum Hansen <carl@bordum.dk>
Subject: [PATCH] ip link docs: mention wireguard interface type
Date:   Sat,  5 Jun 2021 01:05:34 +0200
Message-Id: <20210604230534.104899-1-carl@bordum.dk>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Carl Bordum Hansen <carl@bordum.dk>
---
 ip/iplink.c           | 2 +-
 man/man8/ip-link.8.in | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index 27c9be44..d676a8de 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -123,7 +123,7 @@ void iplink_usage(void)
 			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
 			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
 			"	   ipvlan | ipvtap | geneve | bareudp | vrf | macsec | netdevsim | rmnet |\n"
-			"	   xfrm }\n");
+			"	   xfrm | wireguard }\n");
 	}
 	exit(-1);
 }
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index fd67e611..6fbd5bf4 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -231,7 +231,8 @@ ip-link \- network device configuration
 .BR macsec " |"
 .BR netdevsim " |"
 .BR rmnet " |"
-.BR xfrm " ]"
+.BR xfrm " |"
+.BR wireguard " ]"
 
 .ti -8
 .IR ETYPE " := [ " TYPE " |"
@@ -377,6 +378,9 @@ Link types:
 .sp
 .BR xfrm
 - Virtual xfrm interface
+.sp
+.BR wireguard
+- Wireguard interface
 .in -8
 
 .TP
-- 
2.27.0

