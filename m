Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A12601A6C
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbiJQUhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiJQUhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:37:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADDF80BD3;
        Mon, 17 Oct 2022 13:35:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 855B2B81AD3;
        Mon, 17 Oct 2022 20:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7ABC433C1;
        Mon, 17 Oct 2022 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666038898;
        bh=pr4++4yUHbZlDDwyrw3c+RvKoKW1WA0ngYLG9iMMutk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MrHVh88PjdMGfdAOf5Bim7C4ijNzrtPm7Ai19A9NZ+q3r08LrdzKnGZIHGSWUZ230
         JsgVFUnWvvdkLZ2hgnlSu4x4Vajj1lL9ePVl4HW5uXncvlIWwrXZRsSUUn1uLoA5qo
         /4wfQsL6kFxU1uTRKUxiHVuYgJsH4w+6r5EQ9poI7hqrnEyIPVjjKRXt+jwH1IxgKu
         vYKtsG3xBrG1jbUGqEynnfgCQVzS9hCVB6PuaK5Q6u4ngJJTagu93SGDSPs++s2TQp
         TA99IJzxIqAStR8Wd+x+3kUb+vgRShV/+7BvZ5v5OMKIzUJDR5iFg2Ouajlhqzhx1W
         Bivv/zPi927Pg==
Date:   Mon, 17 Oct 2022 15:34:48 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH 3/6][next] ipw2x00: Remove unnecessary cast to iw_handler in
 ipw_wx_handlers
Message-ID: <421a4b4673da8fb610850f674d0994ad46bc1ed6.1666038048.git.gustavoars@kernel.org>
References: <cover.1666038048.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1666038048.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous patches have removed the rest of the casts to iw_handler in
ipw_wx_handlers array definition, and with that multiple
-Wcast-function-type-strict warnings have been fixed.

Remove the one cast to iw_handler remaining, which was not removed in
previous patches because there was no -Wcast-function-type-strict warning
associated with it.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 5b483de18c81..3158f91b18d5 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -9870,7 +9870,7 @@ static int ipw_wx_sw_reset(struct net_device *dev,
 
 /* Rebase the WE IOCTLs to zero for the handler array */
 static iw_handler ipw_wx_handlers[] = {
-	IW_HANDLER(SIOCGIWNAME, (iw_handler)cfg80211_wext_giwname),
+	IW_HANDLER(SIOCGIWNAME, cfg80211_wext_giwname),
 	IW_HANDLER(SIOCSIWFREQ, ipw_wx_set_freq),
 	IW_HANDLER(SIOCGIWFREQ, ipw_wx_get_freq),
 	IW_HANDLER(SIOCSIWMODE, ipw_wx_set_mode),
-- 
2.34.1

