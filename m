Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04050176E5E
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727453AbgCCFF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbgCCFFq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:05:46 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 358DF2064A;
        Tue,  3 Mar 2020 05:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583211946;
        bh=pNDeNcSL4kYFSnO7rXRKKDlFVhxMiUyFx6Gk0qRZPSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4Lao380dp3G7A35bZVy+nomfSl0V39UWZT/fRzqV3vNCy41wK+/+SnVSdfQful9j
         tvMvjSqucO228EbOCEwsYniZKy11RIBI2S+C6OYqlhz4ymjh08pdPnJ2hu9eFwSEva
         VMD+6FICWm14Db/iYirYp9lqEN7kW368Uykm0868=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH net 14/16] nfc: add missing attribute validation for SE API
Date:   Mon,  2 Mar 2020 21:05:24 -0800
Message-Id: <20200303050526.4088735-15-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303050526.4088735-1-kuba@kernel.org>
References: <20200303050526.4088735-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing attribute validation for NFC_ATTR_SE_INDEX
to the netlink policy.

Fixes: 5ce3f32b5264 ("NFC: netlink: SE API implementation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: Johannes Berg <johannes.berg@intel.com>
CC: Jiri Pirko <jiri@mellanox.com>
CC: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index eee0dddb7749..842407a48f96 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -43,6 +43,7 @@ static const struct nla_policy nfc_genl_policy[NFC_ATTR_MAX + 1] = {
 	[NFC_ATTR_LLC_SDP] = { .type = NLA_NESTED },
 	[NFC_ATTR_FIRMWARE_NAME] = { .type = NLA_STRING,
 				     .len = NFC_FIRMWARE_NAME_MAXSIZE },
+	[NFC_ATTR_SE_INDEX] = { .type = NLA_U32 },
 	[NFC_ATTR_SE_APDU] = { .type = NLA_BINARY },
 	[NFC_ATTR_VENDOR_DATA] = { .type = NLA_BINARY },
 
-- 
2.24.1

