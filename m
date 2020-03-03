Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E647176E55
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727368AbgCCFFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgCCFFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:43 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BBF24673;
        Tue,  3 Mar 2020 05:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211943;
        bh=WsZ2Ns87leljy1aJFD03c5TrozG2zzz492aWzLgls+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pQDY1K+kA4yVsYiO+FFcbshqSc8YWlOQ5/VD2BmBXTnU/B8/x7CdpjbZskCqEWanF
         Tu9LkzywtJhjlhX9Bs3ysB8yWMEi20kNex89556mX1NvtEdMxa0YCVEXdlSPAnCb3s
         AJdLGBTYmWlpP4Qo4CIpGxwxn+fqodOFcQHAjf0c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 07/16] macsec: add missing attribute validation for port
Date:   Mon,  2 Mar 2020 21:05:17 -0800
Message-Id: <20200303050526.4088735-8-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for IFLA_MACSEC_PORT
to the netlink policy.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Antoine Tenart <antoine.tenart@bootlin.com>
CC: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 45bfd99f17fa..5af424eeea86 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3342,6 +3342,7 @@ static const struct device_type macsec_type = {
 
 static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCI] = { .type = NLA_U64 },
+	[IFLA_MACSEC_PORT] = { .type = NLA_U16 },
 	[IFLA_MACSEC_ICV_LEN] = { .type = NLA_U8 },
 	[IFLA_MACSEC_CIPHER_SUITE] = { .type = NLA_U64 },
 	[IFLA_MACSEC_WINDOW] = { .type = NLA_U32 },
-- 
2.24.1

