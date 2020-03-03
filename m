Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A7B176E53
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCCFFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:37614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbgCCFFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:42 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8BE624680;
        Tue,  3 Mar 2020 05:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211942;
        bh=9KZge5aeQczG0RlR00AofDMhKBLJRjsv51c8smRCixM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFFqxui+1/PdVMuCxe2UKw3jmeTOUq9xyZSVI8PYJZ4mpjaB2QrZAuUFwVksFVeWE
         VDcIPW1s2LLyb4mVtyx1ON5cPZifB6zn7rGExANM7muXJMt/dk40gWUSYuKbYt+eQf
         Ki6RJwOGK3gYao91EfJa998Or5LHfFNW/lr3mVDM=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Sergey Lapin <slapin@ossfans.org>, linux-wpan@vger.kernel.org
Subject: [PATCH net 04/16] nl802154: add missing attribute validation
Date:   Mon,  2 Mar 2020 21:05:14 -0800
Message-Id: <20200303050526.4088735-5-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for several u8 types.

Fixes: 2c21d11518b6 ("net: add NL802154 interface for configuration of 802.15.4 devices")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Alexander Aring <alex.aring@gmail.com>
CC: Stefan Schmidt <stefan@datenfreihafen.org>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
CC: Sergey Lapin <slapin@ossfans.org>
CC: linux-wpan@vger.kernel.org
---
 net/ieee802154/nl_policy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl_policy.c b/net/ieee802154/nl_policy.c
index 2c7a38d76a3a..824e7e84014c 100644
--- a/net/ieee802154/nl_policy.c
+++ b/net/ieee802154/nl_policy.c
@@ -21,6 +21,11 @@ const struct nla_policy ieee802154_policy[IEEE802154_ATTR_MAX + 1] = {
 	[IEEE802154_ATTR_HW_ADDR] = { .type = NLA_HW_ADDR, },
 	[IEEE802154_ATTR_PAN_ID] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_CHANNEL] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_BCN_ORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_SF_ORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_PAN_COORD] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_BAT_EXT] = { .type = NLA_U8, },
+	[IEEE802154_ATTR_COORD_REALIGN] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_PAGE] = { .type = NLA_U8, },
 	[IEEE802154_ATTR_COORD_SHORT_ADDR] = { .type = NLA_U16, },
 	[IEEE802154_ATTR_COORD_HW_ADDR] = { .type = NLA_HW_ADDR, },
-- 
2.24.1

