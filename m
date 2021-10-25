Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA5A439708
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJYNHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 09:07:05 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:58934 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233340AbhJYNHE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 09:07:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UtcfbEE_1635167079;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UtcfbEE_1635167079)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 21:04:40 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH] net/tls: tls_crypto_context add supported algorithms context
Date:   Mon, 25 Oct 2021 21:04:39 +0800
Message-Id: <20211025130439.92746-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tls already supports the SM4 GCM/CCM algorithms. It is also necessary
to add support for these two algorithms in tls_crypto_context to avoid
potential issues caused by forced type conversion.

Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 include/net/tls.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/tls.h b/include/net/tls.h
index b6d40642afdd..adab19a8aed7 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -221,6 +221,8 @@ union tls_crypto_context {
 		struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
 		struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
 		struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
+		struct tls12_crypto_info_sm4_gcm sm4_gcm;
+		struct tls12_crypto_info_sm4_ccm sm4_ccm;
 	};
 };
 
-- 
2.19.1.3.ge56e4f7

