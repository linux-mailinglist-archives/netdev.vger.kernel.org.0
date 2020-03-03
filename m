Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98749176E63
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgCCFGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:37626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgCCFFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:42 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4267424681;
        Tue,  3 Mar 2020 05:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211942;
        bh=hDSCkRxG7b9Lfu61biZDPI4vIJM1EwBG1IB1vqm147A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhUhYGsxfBKsP8XyQHdsinbd19dEgSz7yNsX/uulwCH5OES2t6Ly0vi1JEYoY+KrA
         wFclgiKDqWbnNxs4MWQTl0qLiLsjuLS7kOR0pCBgfi9xxZT1fQnn3ldZwzgv8OtBfm
         fd+qp6hTILuSc9uhe7b4gJOAPuEavCdjySh3SZSs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        alex.bluesman.smirnov@gmail.com, linux-wpan@vger.kernel.org
Subject: [PATCH net 05/16] nl802154: add missing attribute validation for dev_type
Date:   Mon,  2 Mar 2020 21:05:15 -0800
Message-Id: <20200303050526.4088735-6-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute type validation for IEEE802154_ATTR_DEV_TYPE
to the netlink policy.

Fixes: 90c049b2c6ae ("ieee802154: interface type to be added")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Alexander Aring <alex.aring@gmail.com>
CC: Stefan Schmidt <stefan@datenfreihafen.org>
CC: alex.bluesman.smirnov@gmail.com
CC: linux-wpan@vger.kernel.org
---
 net/ieee802154/nl_policy.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
index 824e7e84014c..0672b2f01586 100644
--- a/net/ieee802154/nl_policy.c
+++ b/net/ieee802154/nl_policy.c
@@ -27,6 +27,7 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
 	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_DEV_TYPE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
 	[IEEE802154_ATTR_COORD_PAN_ID] = { .type = NLA_U16, },
-- 
2.24.1

