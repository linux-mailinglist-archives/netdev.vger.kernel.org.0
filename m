Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FABA42A8FE
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbhJLQAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237586AbhJLQAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07E82610D1;
        Tue, 12 Oct 2021 15:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054331;
        bh=6tHcTSYirflEJc5fhpvAOLmYQzhXj44aomInZHnL7TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNNer5vNV+ZFYdlrg8Jv474etPsQcF7BzwXR/aAWa6gLI//MROwF9kRBrQurq8egV
         jtnjdd+ell3cWTOea1MK6Ihf2MpClT3Rx3qGc/7YbdWXp3KfuYaC14rV6b4yI0ZGKB
         GUpEo72BGUorLlPa/2DdlBzX0SH7wzWk1GDUqiZ9bjF35hFIbCZI72sPyiCZQz6NuP
         UE8mkAGR+qpem50b1/CLyUuSNCrkYmWnEJ/1BweHQ+G4jCE3Vncq31KFZiKUQNFiS5
         NCjSQ63nAdYsJkmHX8DCbffdC3me36l5TLDSlJpksELxOVAM0APnjEss6Jjfg7Se3f
         87FUVdZp0Szig==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/6] decnet: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:40 -0700
Message-Id: <20211012155840.4151590-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in decnet constant.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/dn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/dn.h b/include/net/dn.h
index 56ab0726c641..ba9655b0098a 100644
--- a/include/net/dn.h
+++ b/include/net/dn.h
@@ -166,7 +166,7 @@ struct dn_skb_cb {
 	int iif;
 };
 
-static inline __le16 dn_eth2dn(unsigned char *ethaddr)
+static inline __le16 dn_eth2dn(const unsigned char *ethaddr)
 {
 	return get_unaligned((__le16 *)(ethaddr + 4));
 }
-- 
2.31.1

