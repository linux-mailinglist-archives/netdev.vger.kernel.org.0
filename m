Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5063697792
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 08:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233723AbjBOHuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 02:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbjBOHun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 02:50:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9998532CD0;
        Tue, 14 Feb 2023 23:50:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40A2861A71;
        Wed, 15 Feb 2023 07:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6AEC433EF;
        Wed, 15 Feb 2023 07:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676447438;
        bh=XpvbBaK4xbaNhxlwvyVb04WeG3csNvfLcdKEuWJ14Gc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qGLKtYOC1JidZV0q21JkS8oN2oDMbFsSJLLSQ00irZHaYfD+x/CJLL2zI11TWPQao
         n02MH7PytUN8YAgEmgGSclIZrUvWvyXW402uLQz65NATy640wjiqO1OaW5UbBPTk//
         RkEdwANKDVVbNj6pcyxKxWGvuVytPRU2YlF91SyNadoup9t5bUL/2M9Su7W5Fwy6X8
         lTO5Eg/kFUxdxImILs4tnuyo651QpTbRX5ucgc9KbYl004/ZE46v10lvbxA6CPR7gB
         jbbMJCl3EhlWE+7yXoJfP5J7qEC++NKefFuovuO4XcDvkJ6mnb1pGsmD4PuQl2ik9h
         4COw6XBFSjXNQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] wifi: rtw88: usb: Set qsel correctly
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230210111632.1985205-2-s.hauer@pengutronix.de>
References: <20230210111632.1985205-2-s.hauer@pengutronix.de>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167644743063.2758.2777342637457592464.kvalo@kernel.org>
Date:   Wed, 15 Feb 2023 07:50:35 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sascha Hauer <s.hauer@pengutronix.de> wrote:

> We have to extract qsel from the skb before doing skb_push() on it,
> otherwise qsel will always be 0.
> 
> Fixes: a82dfd33d1237 ("wifi: rtw88: Add common USB chip support")
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

3 patches applied to wireless-next.git, thanks.

7869b834fb07 wifi: rtw88: usb: Set qsel correctly
07ce9fa6ab0e wifi: rtw88: usb: send Zero length packets if necessary
462c8db6a011 wifi: rtw88: usb: drop now unnecessary URB size check

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230210111632.1985205-2-s.hauer@pengutronix.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

