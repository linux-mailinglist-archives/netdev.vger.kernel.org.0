Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79937176E5D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgCCFFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:37806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbgCCFFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:47 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1DB12465A;
        Tue,  3 Mar 2020 05:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211947;
        bh=P/sub7rpG5Bsm4iuXdnDdL07W9NG30VlmxKoBHIFjfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFMCEPPTSOfklKhjbBdC9fH8+lhtbEZfEdE4E0Eqcuh9dgkiJU2c1XCfCiOiVJLsE
         Ejxxn5HrHQp665ffLDCXIoVkT7sXyUhFpI4jwPthe2aXpdsw54PSV4k7I91UqNDTUR
         R+JoNHn3zEEhg/gTbl/5Gd1gDbH1A71YLoGiw9FI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH net 15/16] nfc: add missing attribute validation for deactivate target
Date:   Mon,  2 Mar 2020 21:05:25 -0800
Message-Id: <20200303050526.4088735-16-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for NFC_ATTR_TARGET_INDEX
to the netlink policy.

Fixes: 4d63adfe12dd ("NFC: Add NFC_CMD_DEACTIVATE_TARGET support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Johannes Berg <johannes.berg@intel.com>
CC: Jiri Pirko <jiri@mellanox.com>
CC: Michal Kubecek <mkubecek@suse.cz>
CC: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Greer <mgreer@animalcreek.com>
---
 net/nfc/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 842407a48f96..e988ca486d66 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -32,6 +32,7 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 	[NFC_ATTR_DEVICE_NAME] = { .type = NLA_STRING,
 				.len = NFC_DEVICE_NAME_MAXSIZE },
 	[NFC_ATTR_PROTOCOLS] = { .type = NLA_U32 },
+	[NFC_ATTR_TARGET_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_COMM_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_RF_MODE] = { .type = NLA_U8 },
 	[NFC_ATTR_DEVICE_POWERED] = { .type = NLA_U8 },
-- 
2.24.1

