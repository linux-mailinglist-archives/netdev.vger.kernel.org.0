Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4EB26EC309
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 01:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbjDWXDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 19:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjDWXDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 19:03:51 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD0B10C1;
        Sun, 23 Apr 2023 16:03:48 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1003)
        id 4Q4P2R2Yf4z4xFk; Mon, 24 Apr 2023 09:03:43 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ozlabs.org;
        s=201707; t=1682291023;
        bh=vjUFs6M92ee7Cz7N/rxQRO0Y97PnGZo4UIaiEBMAsPs=;
        h=Date:From:To:Cc:Subject:From;
        b=yi8kAVDFRRISojIg9JDv+p/ZqWbz/5OjmvjA6zytvB1YOw3ehhWypaxzejdGFzH/c
         fHvPGyvC3sWYzVY2EwXgm0M8mLnoTWVgJnFIzeO/6d+im8/f4xG6SqyUhBNU5YrIpR
         FNMAMeMBDWzxx5OUCQHftXF2YVqyJ81Sv+MoaCbEzy8eBw1W3WVxh8j1KhiSmc0GSZ
         YWQPl6jGDIdO2mz/tNPKmBmoak/oWGWhRW7TV8iloDlVASrLMjIQ/BHnJg+k2k40MH
         SSV1nxdZbL3b5C/WTuhY8HaLtxYOf/QNT7dmHOcAUn9de3+ECZNiQiOqn/ldBXtI9I
         grdJfDDVz1mJg==
Date:   Mon, 24 Apr 2023 09:02:32 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH] MAINTAINERS: Remove PPP maintainer
Message-ID: <ZEW5CLw7MW4tPxml@cleo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am not currently maintaining the kernel PPP code, so remove my
address from the MAINTAINERS entry for it.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
I am still maintaining the user-space PPP daemon, though.
Also, the paulus@samba.org address will probably stop working soon.

 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d79bae5590f8..bc0a4f17607c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16771,9 +16771,8 @@ F:	include/uapi/linux/if_pppol2tp.h
 F:	net/l2tp/l2tp_ppp.c
 
 PPP PROTOCOL DRIVERS AND COMPRESSORS
-M:	Paul Mackerras <paulus@samba.org>
 L:	linux-ppp@vger.kernel.org
-S:	Maintained
+S:	Orphan
 F:	drivers/net/ppp/ppp_*
 
 PPS SUPPORT
-- 
2.39.2

