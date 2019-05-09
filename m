Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433C71959C
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 01:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfEIXTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 19:19:42 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37100 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbfEIXTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 19:19:42 -0400
Received: by mail-qk1-f195.google.com with SMTP id c1so1257639qkk.4
        for <netdev@vger.kernel.org>; Thu, 09 May 2019 16:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ByrTm2yjTFW4PwCt0qvTOf74j9JiqRJMy3tZZryRxs0=;
        b=Gys7XtL8Rky9PbhCcfoKt1Xlb9tYcKVbqNq2ib+5slNcTJzvjSkV1qSb8osNHiHnGV
         DInUQQns+TEwmefyL6WaU2ENQKADpp7jar/7SZyESFl07LsCdkl720MEqUKTkXmKWhQ4
         /2n45KkxwM5T7VuxK28Z7R3Fgl6j3cZ/A7ncWFAvXzJkNEvp1NyERJF2rNrin82YDmT/
         YLIm5NDtLlkTYw5Gw2kuDAJWfa90PRHli5wVN48Xn1KpJH5GQDEGt/Sgnpei3Pg9r+WR
         HgQ6VMTQ57KKyojxbbqB2rKAroimAHrmxYpCkQy8B59JUSnzJfSHRLGgmeAxcIVNBNay
         QHkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ByrTm2yjTFW4PwCt0qvTOf74j9JiqRJMy3tZZryRxs0=;
        b=IOwNU6hhfnVhrCON/xnz/IFG7ZVLHNrCFqY2EtpF0sOJIP7vL0XFV9Q+lC8mk3JROy
         Io7FxpPInBJ5IxoQFGTTep5l1ejwqf7pCskex+vP6bnpH4tCH3y4Kbjk+2tx/vnwQ/i8
         mr/cvsktksVS4Vr4avRd9QbGJDaI1TvWjm74OkA6jjRvdyoBg5kYDVN0FEQ5UvQoJxIl
         OEBIMdcB7rqawLsKiz3bidwjwkGovFcKkmF+Ygswkzt2/9ExHmFBhTxhxjRvq7TsLvrt
         GpCfiNCR+g45hh84c2XrBHQLr93v2uATVWECye6CvzguLsJCFSFNft/FMazr+cj++Dzl
         et1A==
X-Gm-Message-State: APjAAAX/MiMHWJgkjPsiOJGGWr48ZD1MBjJ1hQWjzKGFn7Wa+LxGhm+X
        QPo3I73tRaZPHsHQQj+1CfqgjKH1z5Q=
X-Google-Smtp-Source: APXvYqwwsnTgsmBWvCDfe5GUAfbXQIE5Jj4jmVxdUCCkqS/33hIP5iaxZq32RlAZ1P7uYCySSVM7QQ==
X-Received: by 2002:a37:bb07:: with SMTP id l7mr5592481qkf.51.1557443981309;
        Thu, 09 May 2019 16:19:41 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o64sm1890429qke.61.2019.05.09.16.19.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 16:19:40 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net] nfp: add missing kdoc
Date:   Thu,  9 May 2019 16:19:34 -0700
Message-Id: <20190509231934.13103-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing kdoc for app member.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/ccm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/ccm.h b/drivers/net/ethernet/netronome/nfp/ccm.h
index e2fe4b867958..ac963b128203 100644
--- a/drivers/net/ethernet/netronome/nfp/ccm.h
+++ b/drivers/net/ethernet/netronome/nfp/ccm.h
@@ -54,6 +54,8 @@ static inline unsigned int nfp_ccm_get_tag(struct sk_buff *skb)
 
 /**
  * struct nfp_ccm - common control message handling
+ * @app:		APP handle
+ *
  * @tag_allocator:	bitmap of control message tags in use
  * @tag_alloc_next:	next tag bit to allocate
  * @tag_alloc_last:	next tag bit to be freed
-- 
2.21.0

