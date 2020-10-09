Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EAF2881CF
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 07:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731318AbgJIFtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 01:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgJIFtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 01:49:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6B2C0613D2
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 22:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=rJ48TiZDgO6RimptHrDL+fTBq3f56cOD+wTL8hP3fM0=; b=tKjLUcEzQQTjmBwNliamsHp8Q3
        vu5Z1kjN1pjihoAuS9UCyinpKAEiBXgBTMuNiXqcvDxtB3/H5psQM227dDKbEOyivTWeGyQqGnDTh
        IjhtU1uHI/LEirUeRwPOcVWfM5Onztd9mnnDWwP5vtzupyMt4Nh7QPPUi905OyLqjHdh+LlNRqd6B
        Y6bWmpps4nkQYjG8tuHU8xb0lvGbaBfndVTblZkPo9NhjLcFK37pa/cK3ZT2PiDW/w4Z/UyFBoOIU
        9EFw6q4vRLrIX7t5cZTyNGzW9JerYbqaCbtEBxnF+MxrC/exz96icyK2W4L3mZzJT9TgA1HE+ZVx7
        5QG+bT3w==;
Received: from [2601:1c0:6280:3f0::8280] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQlH6-00071J-3i; Fri, 09 Oct 2020 05:49:04 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net/tls: remove a duplicate function prototype
Date:   Thu,  8 Oct 2020 22:49:00 -0700
Message-Id: <20201009054900.20145-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove one of the two instances of the function prototype for
tls_validate_xmit_skb().

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Boris Pismenny <borisp@nvidia.com>
Cc: Aviad Yehezkel <aviadye@nvidia.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Kicinski <kuba@kernel.org>
To: netdev@vger.kernel.org
---
Sorry, resending to netdev@ also.

 include/net/tls.h |    4 ----
 1 file changed, 4 deletions(-)

--- lnx-59-rc8.orig/include/net/tls.h
+++ lnx-59-rc8/include/net/tls.h
@@ -679,10 +679,6 @@ int decrypt_skb(struct sock *sk, struct
 		struct scatterlist *sgout);
 struct sk_buff *tls_encrypt_skb(struct sk_buff *skb);
 
-struct sk_buff *tls_validate_xmit_skb(struct sock *sk,
-				      struct net_device *dev,
-				      struct sk_buff *skb);
-
 int tls_sw_fallback_init(struct sock *sk,
 			 struct tls_offload_context_tx *offload_ctx,
 			 struct tls_crypto_info *crypto_info);
