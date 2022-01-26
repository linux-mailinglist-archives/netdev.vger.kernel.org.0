Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB49549D253
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 20:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbiAZTLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 14:11:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55070 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244357AbiAZTLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 14:11:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65EB4615C1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 19:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06038C340E3;
        Wed, 26 Jan 2022 19:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643224277;
        bh=BnF7jakSQX4z4RoEUeII1OrL4n52DWWGQ9UzbgMR/vQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1/Gf/khprquuogXXAY6VkTsBPCPajGhviH6XCodTOmOWqmMJ6afEiEQ9hYMCI1tW
         xE4plcEll9ZiWv9ifmD8m/9DFYnfMD4EjaVREUN3f+PlfRUp0hepuMVqzHgqPb5sQ9
         TnrPOohbWgeLyaeRHxt7yLWJ9Dcnn2PALX65jBkFuDjHTuDUOhiaXxjZ2A7QmyrAob
         uU4XNiKk/1qbaM5ii9NXad9EUq/Oh47GjsDuGSDFb0F3yz9CG+3FBwrOk3y3z5/sci
         Wrka9t7Ph5rsx1zeQh3N1nte8ztzbtvY4ThZLyw0vv+H2DavOQQXaaXwAxtyrV0G+Z
         L+PsSIDM/g2zg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, willemb@google.com
Subject: [PATCH net-next 10/15] udp: remove inner_udp_hdr()
Date:   Wed, 26 Jan 2022 11:11:04 -0800
Message-Id: <20220126191109.2822706-11-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126191109.2822706-1-kuba@kernel.org>
References: <20220126191109.2822706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not used since added in v3.8.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: pabeni@redhat.com
CC: willemb@google.com
---
 include/linux/udp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index ae66dadd8543..254a2654400f 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -23,11 +23,6 @@ static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
 	return (struct udphdr *)skb_transport_header(skb);
 }
 
-static inline struct udphdr *inner_udp_hdr(const struct sk_buff *skb)
-{
-	return (struct udphdr *)skb_inner_transport_header(skb);
-}
-
 #define UDP_HTABLE_SIZE_MIN		(CONFIG_BASE_SMALL ? 128 : 256)
 
 static inline u32 udp_hashfn(const struct net *net, u32 num, u32 mask)
-- 
2.34.1

