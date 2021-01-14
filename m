Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5F2F56A1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbhANBuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbhANBuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FFE923442;
        Thu, 14 Jan 2021 01:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610588965;
        bh=mc5svK7kNbk2ItAXXTBb/+K43sl6Ln8jhje+t0jeH5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bg8eBNgi1pyVLgybb37HNI8zBJ0swZE0szJ7aVa2ebrsshdtsjr26m/jndGDoz2SB
         hqAmkS1yx5wNprkrvC6HiywbflxBtNQWhn6yQr/AE+LP9eaw7CE9F2niiowP9tiAri
         YeV+ldbE87ne3cNDDf8l/XvxZVdaWJOYYTGCqqxOwwskIyxFOqFscOda1RFfku0pM3
         G9SMlrxPTrqJeoR4Wsf+6AO/N/3/+5lZw4SPQhZuQ7WsLXdlTQIdKot536kKhdCSje
         87tAgYgFaxenQCx7aP4Q6TXwGTjn8emLmTW5CFadx6EzUDTeN8ZWaaW0Rf6l1bOO4x
         HNCb0s5piZz+g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, corbet@lwn.net,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH net v2 2/7] MAINTAINERS: net: move Alexey Kuznetsov to CREDITS
Date:   Wed, 13 Jan 2021 17:49:07 -0800
Message-Id: <20210114014912.2519931-3-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114014912.2519931-1-kuba@kernel.org>
References: <20210114014912.2519931-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move Alexey to CREDITS.

I am probably not giving him enough justice with
the description line..

Subsystem NETWORKING [IPv4/IPv6]
  Changes 1535 / 5111 (30%)
  Last activity: 2020-12-10
  "David S. Miller" <davem@davemloft.net>:
    Author b7e4ba9a91df 2020-12-09 00:00:00 407
    Committer e0fecb289ad3 2020-12-10 00:00:00 3992
    Tags e0fecb289ad3 2020-12-10 00:00:00 3978
  Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>:
  Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>:
    Tags d5d8760b78d0 2016-06-16 00:00:00 8
  Top reviewers:
    [225]: edumazet@google.com
    [222]: dsahern@gmail.com
    [176]: ncardwell@google.com
  INACTIVE MAINTAINER Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
---
 CREDITS     | 4 ++++
 MAINTAINERS | 1 -
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/CREDITS b/CREDITS
index 59a704a45170..3dceea737694 100644
--- a/CREDITS
+++ b/CREDITS
@@ -2142,6 +2142,10 @@ E: seasons@falcon.sch.bme.hu
 E: seasons@makosteszta.sote.hu
 D: Original author of software suspend
 
+N: Alexey Kuznetsov
+E: kuznet@ms2.inr.ac.ru
+D: Author and maintainer of large parts of the networking stack
+
 N: Jaroslav Kysela
 E: perex@perex.cz
 W: https://www.perex.cz
diff --git a/MAINTAINERS b/MAINTAINERS
index 57e17762d411..c6e7f6bf7f6d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12417,7 +12417,6 @@ F:	tools/testing/selftests/net/ipsec.c
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
-M:	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
 M:	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
-- 
2.26.2

