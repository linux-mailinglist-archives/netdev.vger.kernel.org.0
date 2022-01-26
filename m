Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3076349D259
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbiAZTLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53348 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244369AbiAZTLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05E9BB81FC7;
        Wed, 26 Jan 2022 19:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914C4C36AE3;
        Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224276;
        bh=mPA0v+iLUaBVg1CAzBV2P5fk3XilC/0DEg10ZKQb4MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tns1XTBHkn5j35tmIfuqg4ZpPquWJezHWaGJSgHkeU6bObH7jFZNloXcCHlWn88fe
         oxpm1V6TOcd1XLjcEKnmczuYiz7EnjOm3/AytPBoxAKMceABJvb8ARz0gV8QK/QKZZ
         VAnj8zt6FKslr5afKNCSWcnWR1BwgrFqf7TTSr7TRics/lqSQFXCNtayEo6rpQLRpF
         AldUsQTfFc5bexaPszEhO7+g9PSwKjlMOY7Mh6OmJmH6c9l66UVclGxZvo07K/59ou
         NHnm5Xx6oabNO1efdE1G7cgIo3lgyIL6akFiKM+PV9E3N5c4Br4F9SvSps+AL4jjbh
         sFGTGV46tyBLw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        rdunlap@infradead.org, ncardwell@google.com, edumazet@google.com,
        dccp@vger.kernel.org
Subject: [PATCH net-next 09/15] dccp: remove max48()
Date:   Wed, 26 Jan 2022 11:11:03 -0800
Message-Id: <20220126191109.2822706-10-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not used since v2.6.37.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: rdunlap@infradead.org
CC: ncardwell@google.com
CC: edumazet@google.com
CC: dccp@vger.kernel.org
---
 net/dccp/dccp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dccp/dccp.h b/net/dccp/dccp.h
index 5183e627468d..671c377f0889 100644
--- a/net/dccp/dccp.h
+++ b/net/dccp/dccp.h
@@ -136,11 +136,6 @@ static inline int between48(const u64 seq1, const u64 seq2, const u64 seq3)
 	return (seq3 << 16) - (seq2 << 16) >= (seq1 << 16) - (seq2 << 16);
 }
 
-static inline u64 max48(const u64 seq1, const u64 seq2)
-{
-	return after48(seq1, seq2) ? seq1 : seq2;
-}
-
 /**
  * dccp_loss_count - Approximate the number of lost data packets in a burst loss
  * @s1:  last known sequence number before the loss ('hole')
-- 
2.34.1

