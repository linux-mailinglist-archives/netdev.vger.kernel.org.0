Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8276176E58
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgCCFFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgCCFFr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:47 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5B524671;
        Tue,  3 Mar 2020 05:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211947;
        bh=ujz8F5bs4zcS+pDthRaZ+JHV9uX8cGp65lZdXcmDRrk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EL4bUutnGehogOOjYQlhh9+idVPClqnZp8xlBLw6dECIAMCiJtlYbrWPe58uig2oH
         OCOeb9O8XHLyRDTyIXslwo4E9mgTuPFMn68HVBFMcA+G7TKs74oD/6VBKsILnJbmpU
         jwhMaT/3YzN0rXPjF0Aku7qTJ03e3L4EQi5fSops=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH net 16/16] nfc: add missing attribute validation for vendor subcommand
Date:   Mon,  2 Mar 2020 21:05:26 -0800
Message-Id: <20200303050526.4088735-17-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for vendor subcommand attributes
to the netlink policy.

Fixes: 9e58095f9660 ("NFC: netlink: Implement vendor command support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Johannes Berg <johannes.berg@intel.com>
CC: Jiri Pirko <jiri@mellanox.com>
CC: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index e988ca486d66..e894254c17d4 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -46,6 +46,8 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
 	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
+	[NFC_ATTR_VENDOR_ID] = { .type = NLA_U32 },
+	[NFC_ATTR_VENDOR_SUBCMD] = { .type = NLA_U32 },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 
 };
-- 
2.24.1

