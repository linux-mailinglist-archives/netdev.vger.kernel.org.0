Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C9C49D250
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244368AbiAZTLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244351AbiAZTLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944C8C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 11:11:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322F36165F
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6CFC340EA;
        Wed, 26 Jan 2022 19:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224276;
        bh=ZC5pmUsRVY26Mr/DL0ZeYMCqUbpYxe1aGPf98OpVrKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVPFDGJFsoGQho7/UWbxg0lA4r0sG3tC0O751SxeP/bdR1vw1saZAue+5VtHZdOx6
         F8A8oXwOwQ5QVOo5cfBFXb7G3bY24vwOPUJTZq+xSpFposhh7IMQnxnIqu2Rkk8YXW
         w+1tetuDhCXkG2PU2kXx5aJpfO9fvyC4xOGDdTY6XU28TM615YNjROZyVvBHm2YR7q
         f/gn+Zdg2uV58MUgrxQ4oASF8Pjq/pjUYp1nF7PPUqghcHhOwykng5wpWuo+FAE4Cj
         LDVr8SrZuvB0Y+vzgiGhSP/hoOmdxEytfVp3x92F1kiyiAZ/n3Q2tjzY2EjXLW+ZTN
         ULHnmh92BmvzQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        george.mccollister@gmail.com, ennoerlangen@gmail.com
Subject: [PATCH net-next 07/15] hsr: remove get_prp_lan_id()
Date:   Wed, 26 Jan 2022 11:11:01 -0800
Message-Id: <20220126191109.2822706-8-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

get_prp_lan_id() has never been used.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: george.mccollister@gmail.com
CC: ennoerlangen@gmail.com
---
 net/hsr/hsr_main.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 043e4e9a1694..ff9ec7634218 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -259,11 +259,6 @@ static inline u16 prp_get_skb_sequence_nr(struct prp_rct *rct)
 	return ntohs(rct->sequence_nr);
 }
 
-static inline u16 get_prp_lan_id(struct prp_rct *rct)
-{
-	return ntohs(rct->lan_id_and_LSDU_size) >> 12;
-}
-
 /* assume there is a valid rct */
 static inline bool prp_check_lsdu_size(struct sk_buff *skb,
 				       struct prp_rct *rct,
-- 
2.34.1

