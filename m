Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D079A4FDD65
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245124AbiDLLJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 07:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353482AbiDLLEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 07:04:55 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39CE5FF2A;
        Tue, 12 Apr 2022 02:55:21 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1neDEx-0005Ez-CY; Tue, 12 Apr 2022 11:55:15 +0200
Message-ID: <7aa0bbd0-5498-ba74-ad6d-6dacbade8a3d@leemhuis.info>
Date:   Tue, 12 Apr 2022 11:55:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>, Philippe Schenker <dev@pschenker.ch>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        "David S. Miller" <davem@davemloft.net>,
        Deren Wu <deren.wu@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20220412090415.17541-1-dev@pschenker.ch>
 <87y20aod5d.fsf@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
In-Reply-To: <87y20aod5d.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1649757321;4339350e;
X-HE-SMSGID: 1neDEx-0005Ez-CY
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.22 11:37, Kalle Valo wrote:
> Philippe Schenker <dev@pschenker.ch> writes:
> 
>> This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
>>
>> This commit introduces a regression on some systems where the kernel is
>> crashing in different locations after a reboot was issued.
>>
>> This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest firmware.
>>
>> Link: https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/
>> Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> 
> Can I take this to wireless tree? Felix, ack?
> 
> I'll also add:
> 
> Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")

Sorry, stupid questions from the regression tracker: wouldn't this cause
a regression for users of kernel versions post-bf3747ae2e25, as the
power consumption is likely to increase for them? Without having dug
into the backstory much: would disabling ASPM for this particular
machine using a quirk be the better approach? Or are we assuming a lot
of machines are affected?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

