Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8988F6F230A
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 07:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbjD2FQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 01:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjD2FQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 01:16:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E83C2706;
        Fri, 28 Apr 2023 22:16:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA22260F4D;
        Sat, 29 Apr 2023 05:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46D2C433EF;
        Sat, 29 Apr 2023 05:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682745413;
        bh=9EbmiYIZMWGtF3gGoIlyTxa/ZhoxOpHzUctWNuN4Wq0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bKXr/GO+957j6cwoXpiipvLxaX+0+y0C73LfkEWr4QzsCP0k0g7KlzPfo4NcAbf5j
         hlg3OC+Q/Ux88P8lUo7nXBfreaumzjU0RmI2r/hfq6HfeMK9RFKGAyZlie+xxCbO8G
         XtoI2u4wxO68yhASQhmRGvXl2y1FmVfngLv7IaTJkRvWk6aIKTvn1X2L3DxXK7C81W
         aEorDGCcfOIFy1sxfUjFFys1JjJZ37wAXQR4zDohpDqTB7rynCeHnsqy30Yrl7WH3r
         Ifu0njSyVdKHQVmn6xX3xjCvfTXuasAxOLwDx0WUf5yixs33SQbsu1h/EjMzaYKGFI
         GhPMke87AWCBw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     wo <luyun_611@163.com>, Jes.Sorensen@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH] wifi: rtl8xxxu: fix authentication timeout due to incorrect RCR value
References: <20230427020512.1221062-1-luyun_611@163.com>
        <866570c9-38d8-1006-4721-77e2945170b9@lwfinger.net>
        <53e5cb36.2d9d.187c61b8405.Coremail.luyun_611@163.com>
        <87ttx0s9a3.fsf@kernel.org>
        <79edb0c1-170a-8a09-5247-951d833647cd@lwfinger.net>
Date:   Sat, 29 Apr 2023 08:16:48 +0300
In-Reply-To: <79edb0c1-170a-8a09-5247-951d833647cd@lwfinger.net> (Larry
        Finger's message of "Fri, 28 Apr 2023 13:30:47 -0500")
Message-ID: <87v8hfqncv.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 4/28/23 03:25, Kalle Valo wrote:
>> wo  <luyun_611@163.com> writes:
>>
>>> In fact, there is another driver rtl8192cu.ko
>>> (drivers/net/wireless/realtek/rtlwifi/), that can also match this
>>> device.
>>
>> It's not good if there are two drivers supporting same hardware. Should
>> the support be removed from rtlwifi?
>
> Kalle,
>
> I have just sent a patch removing rtl8192cu.

Awesome, thanks Larry.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
