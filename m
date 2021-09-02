Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795C83FF775
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347894AbhIBW5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:57:24 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34106
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232684AbhIBW5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:57:23 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 7F08A3F355;
        Thu,  2 Sep 2021 22:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630623383;
        bh=LSEKeaSDQ1GT7tY9vov/U+ekVIymsacQFSJsNSyYZuU=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=UszIlSz4z3N74cHzsTz7PQ9Rnu2TwTQy1kW3+8I/a78Br5T1Yubv52jneNfePS99e
         xtmbTejSoiT+DJHfYC3D7SQZIW5c8G0wQaG2fM3e/DAJhnGWF67JThm20kIU7OfDpN
         plXDU6RP2xRT7JoDofmcQn1USDK3OdL1PZIl/eoL0TdOG92As2HbFEleOd8RY+Ug/8
         ay/SxGNi81hQEe35NR7+QYnTh0nlNxClLq2zCEiidwiFWxGmCb5zqD9r7POJYBTvLk
         rxmIZ0+nXWq5JxkulOnSh3k/mOxxZECs+QKPKbsNX6PbGP22Wbiqc2N2tDiRKfhGt/
         miFoV0s3QOFtg==
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] skbuff: clean up inconsistent indenting
Date:   Thu,  2 Sep 2021 23:56:23 +0100
Message-Id: <20210902225623.58209-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented one character too deeply,
clean this up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f9311762cc47..2170bea2c7de 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3884,7 +3884,7 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
 		skb_release_head_state(nskb);
-		 __copy_skb_header(nskb, skb);
+		__copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
 		skb_copy_from_linear_data_offset(skb, -tnl_hlen,
-- 
2.32.0

