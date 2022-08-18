Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5506B598DDD
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 22:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345844AbiHRUVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345852AbiHRUU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 16:20:59 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1433C12DF;
        Thu, 18 Aug 2022 13:20:53 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 27IKKQjF2765878;
        Thu, 18 Aug 2022 22:20:26 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 27IKKQjF2765878
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1660854026;
        bh=lW65DDWl1Jdxk9iycgYWgAWipBLdfd5gVplN3DTCx44=;
        h=Date:From:To:Cc:Subject:From;
        b=Z9l8OCA9SpxhUVVJBPCgVbBT4mBaWapxTTsjn7C9wi2ygM+suopNJVDngesS+W2UC
         I74rGN5FOcXwAZ1bpnOOBFlMdYmO6PGtQfXUbwjmogUN0xhHF+dTMNrzz9w/9C6jn3
         UFJ0yf/pI6mx89jBljSBinmrseuXyK4ieD2W12ww=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 27IKKOMV2765877;
        Thu, 18 Aug 2022 22:20:24 +0200
Date:   Thu, 18 Aug 2022 22:20:24 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     netdev@vger.kernel.org
Cc:     Ralf Baechle <ralf@linux-mips.org>, linux-hams@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Thomas Osterried <thomas@osterried.de>
Subject: [PATCH net-next 1/1] MAINTAINERS: update amateur radio status.
Message-ID: <Yv6fCCB3vW++EGaP@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is still useful work in the linux kernel amateur radio area but
it should not hurt to align advertised expectations in MAINTAINERS file
with Ralf Baechle's stance from 2021/07/17.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Link: https://marc.info/?l=linux-hams&m=162651322506623
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f2d64020399b..691aa4e84537 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3436,7 +3436,7 @@ F:	drivers/iio/adc/hx711.c
 AX.25 NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 W:	http://www.linux-ax25.org/
 F:	include/net/ax25.h
 F:	include/uapi/linux/ax25.h
@@ -14074,7 +14074,7 @@ F:	net/netfilter/
 NETROM NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 W:	http://www.linux-ax25.org/
 F:	include/net/netrom.h
 F:	include/uapi/linux/netrom.h
@@ -17640,7 +17640,7 @@ F:	include/linux/mfd/rohm-shared.h
 ROSE NETWORK LAYER
 M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
-S:	Maintained
+S:	Odd Fixes
 W:	http://www.linux-ax25.org/
 F:	include/net/rose.h
 F:	include/uapi/linux/rose.h
-- 
2.37.1

