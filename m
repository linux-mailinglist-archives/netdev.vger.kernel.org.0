Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FAF49D24B
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244344AbiAZTLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54966 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiAZTLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 14D1C616CC
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D11CC340E8;
        Wed, 26 Jan 2022 19:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224274;
        bh=RjQ6b1tdQJ9J1FqoxSiMgMdn79veWH+d3vajivU4n1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIs6JP5FusYkyPHeFjXQRBl+/ID+UIiwxOUVKi1brQAcehp+CpN09kVX17s9DUU7h
         o8q9KMEFTxxPJZZ2RtbB3hg2kTvh4kDdwBmObhxLeMi6FjOYEwF5s8/4Zeny7Nq76U
         AhUEiDHz5BbSjEBRgrWxk3Ujl85fzvc0nW8fAcJe5E1rIr1+mNOJ2rF7q2blkCx/5t
         pqZXw/F8S/Us3OiGytlLFc2b9yePVSfqXeRcNKVu8qoi6JDIGvPUID+VuzptS4DMYK
         el0Qty5W5RnkGI/cvFVmhm076oijdZRLjUAB8MSfbXo/bK8+jaoK93CwxUJqxWJOlu
         u0w6mSOp0j7Hw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/15] net: remove net_invalid_timestamp()
Date:   Wed, 26 Jan 2022 11:10:57 -0800
Message-Id: <20220126191109.2822706-4-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No callers since v3.15.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/skbuff.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 8131d0de7559..60bd2347708c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3899,11 +3899,6 @@ static inline ktime_t net_timedelta(ktime_t t)
 	return ktime_sub(ktime_get_real(), t);
 }
 
-static inline ktime_t net_invalid_timestamp(void)
-{
-	return 0;
-}
-
 static inline u8 skb_metadata_len(const struct sk_buff *skb)
 {
 	return skb_shinfo(skb)->meta_len;
-- 
2.34.1

