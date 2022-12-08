Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887FD647232
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLHOwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLHOwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:52:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108BA17438;
        Thu,  8 Dec 2022 06:52:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB2CB82432;
        Thu,  8 Dec 2022 14:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC95C433D7;
        Thu,  8 Dec 2022 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670511165;
        bh=Mq2R6tTzaLZHrS/2fNvvpXKjwej8WUo7ipuT20ESI7s=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=aGIkVTiJaQHVDQAGZDUqhXdZsqfl01Mczv+LhqOGvz0gLrfwSANLc2F/J8V1wn9DM
         YKCmOMzgooyUzNnRRsgWVZBv1dyi8JxMDhMdBAJkVYaCxJ3oUsRO01aApytezYucd1
         WZolOc8WHN0LpOJ/IczO9A2Tz4z9qznC/NUf1lvMXWgr6hh5rV6T814OXxxCKV8+AU
         9AZjtd85WXQ2ykYoyBZzbA8aHM0g8lfBE+xjwcuXJRQBX+ODhbwjoTfRypFMIeMIUs
         8n4irQZfEPwz6CBFEwZe900K+OczBfsAnxGbRU8WwdH8Lo1w2G3eCoAgvmx+j/BsR5
         k8aJ9P2VhRw1Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: rtlwifi: rtl8192se: remove redundant rtl_get_bbreg() call
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221205085342.677329-1-pkosyh@yandex.ru>
References: <20221205085342.677329-1-pkosyh@yandex.ru>
To:     Peter Kosyh <pkosyh@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Peter Kosyh <pkosyh@yandex.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051116096.9839.6828382275039467511.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:52:42 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Peter Kosyh <pkosyh@yandex.ru> wrote:

> Extra rtl_get_bbreg() call looks like redundant reading. The read has
> already been done in the "else" branch. Compile test only.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Signed-off-by: Peter Kosyh <pkosyh@yandex.ru>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

49ebca0d9018 wifi: rtlwifi: rtl8192se: remove redundant rtl_get_bbreg() call

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221205085342.677329-1-pkosyh@yandex.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

