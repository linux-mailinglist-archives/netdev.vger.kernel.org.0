Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51D6C4E9EE7
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245184AbiC1SXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiC1SXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:23:42 -0400
Received: from stuerz.xyz (unknown [45.77.206.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E052940934;
        Mon, 28 Mar 2022 11:22:01 -0700 (PDT)
Received: by stuerz.xyz (Postfix, from userid 114)
        id 3D57DFA6FA; Mon, 28 Mar 2022 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648491721; bh=cOHs6Dygnr8f9Xh/PIbQCTcmuBFS602dynHyaovTSvg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=pmDCnjHHrqRa3Dm3V+iufHZipADY0FZ9RgG0h/4MHTFWp/zzthsEF7PYGi7xYr8pR
         lpgnhdE8xLQcEsnK2/UIdvHQfZe4Kz8wO8NvLBLPiATBhCXZ0FN7IoCbtPjTBtonZQ
         W2TmZuliTiB5rdhySL5ilByt0EhFvAs6E1DwGzqyLSNENpNOfJKI4VE5yvuH18wU9Q
         vJDauvD8Qywqsetyzze4sgdI9m2e63kWvY7JzC7DU8q+9ndk5DF9+7tkTUdB95F1yO
         mHvV5hBJnO3XAKcOLTJ8207tCLppwnvHmsHSIU6MDYVY4hAsp1k3Qcy8CbqaBDdPLF
         hR7kxdr07Ljzg==
Received: from [IPV6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8] (unknown [IPv6:2a02:8109:a100:1a48:ff0:ef2f:d4da:17d8])
        by stuerz.xyz (Postfix) with ESMTPSA id 0E643FA6B1;
        Mon, 28 Mar 2022 18:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stuerz.xyz; s=mail;
        t=1648491718; bh=cOHs6Dygnr8f9Xh/PIbQCTcmuBFS602dynHyaovTSvg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=u1/OpXzUZAtaaHVVjI5rz6jWnLRgL12meTQpnmtHWY7pmFYqX9xVn2/VALywSlYId
         HdvAKfF2zgL2YLsfv7ugIAnc/k6GgWbcomXhuPXqgE86BZ1VFJXCv6HDGZAe9dAvUv
         MOzSVa0Txbqpe4lOxnInZB0vxG/czgco27SkmQJbxJCAWUOBbiVB53WuKm1sq5BFQ1
         W9cZTtyUwq+GQAYyJG0spxsGlK9GV6D1bmKGf8ibbMPdngjMBrpRI313Bx/wVEb1UY
         7p1Uihb+xrw1fsI6HqnZQdYy1FiKO0214/OJQSpH+rIPFklALmjefuKSHgbldiALCi
         9zpgM7BcDqvrw==
Message-ID: <1b694c4c-100b-951a-20f7-df1c912bb550@stuerz.xyz>
Date:   Mon, 28 Mar 2022 20:21:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: [PATCH 20/22 v2] ray_cs: Replace comments with C99 initializers
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
References: <20220326165909.506926-20-benni@stuerz.xyz>
 <164846920750.11945.16978682699891961444.kvalo@kernel.org>
From:   =?UTF-8?Q?Benjamin_St=c3=bcrz?= <benni@stuerz.xyz>
In-Reply-To: <164846920750.11945.16978682699891961444.kvalo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RDNS_DYNAMIC,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace comments with C99's designated initializers.

Signed-off-by: Benjamin Stürz <benni@stuerz.xyz>
---
 drivers/net/wireless/ray_cs.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 87e98ab068ed..dd11018b956c 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2529,20 +2529,23 @@ static void clear_interrupt(ray_dev_t *local)
 #define MAXDATA (PAGE_SIZE - 80)

 static const char *card_status[] = {
-	"Card inserted - uninitialized",	/* 0 */
-	"Card not downloaded",			/* 1 */
-	"Waiting for download parameters",	/* 2 */
-	"Card doing acquisition",		/* 3 */
-	"Acquisition complete",			/* 4 */
-	"Authentication complete",		/* 5 */
-	"Association complete",			/* 6 */
-	"???", "???", "???", "???",		/* 7 8 9 10 undefined */
-	"Card init error",			/* 11 */
-	"Download parameters error",		/* 12 */
-	"???",					/* 13 */
-	"Acquisition failed",			/* 14 */
-	"Authentication refused",		/* 15 */
-	"Association failed"			/* 16 */
+	[0]  = "Card inserted - uninitialized",
+	[1]  = "Card not downloaded",
+	[2]  = "Waiting for download parameters",
+	[3]  = "Card doing acquisition",
+	[4]  = "Acquisition complete",
+	[5]  = "Authentication complete",
+	[6]  = "Association complete",
+	[7]  = "???",
+	[8]  = "???",
+	[9]  = "???",
+	[10] = "???",
+	[11] = "Card init error",
+	[12] = "Download parameters error",
+	[13] = "???",
+	[14] = "Acquisition failed",
+	[15] = "Authentication refused",
+	[16] = "Association failed"
 };

 static const char *nettype[] = { "Adhoc", "Infra " };
-- 
2.35.1
