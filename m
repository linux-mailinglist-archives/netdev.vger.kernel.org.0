Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1840511292
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358829AbiD0HfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiD0HfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:35:24 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918F884ED3;
        Wed, 27 Apr 2022 00:32:13 -0700 (PDT)
Received: from [2a02:8108:963f:de38:6624:6d8d:f790:d5c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1njc9f-0005I9-AK; Wed, 27 Apr 2022 09:32:07 +0200
Message-ID: <60d2a5b8-7e25-3020-6092-64afe7abc186@leemhuis.info>
Date:   Wed, 27 Apr 2022 09:32:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
Content-Language: en-US
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Philippe Schenker <dev@pschenker.ch>,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
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
 <7aa0bbd0-5498-ba74-ad6d-6dacbade8a3d@leemhuis.info>
 <87o816oaez.fsf@kernel.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87o816oaez.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1651044733;3de9c336;
X-HE-SMSGID: 1njc9f-0005I9-AK
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.04.22 12:36, Kalle Valo wrote:
>> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
>> [...]
>> P.S.: As the Linux kernel's regression tracker I'm getting a lot of
>> reports on my table. I can only look briefly into most of them and lack
>> knowledge about most of the areas they concern. I thus unfortunately
>> will sometimes get things wrong or miss something important. I hope
>> that's not the case here; if you think it is, don't hesitate to tell me
>> in a public reply, it's in everyone's interest to set the public record
>> straight.
> BTW, maybe you could add that boilerplace text after P.S. into the
> signature (ie. under "-- " line)? That way your mails would more
> readable and make it more clear that you didn't write the boilerplate
> text specifically for this mail.

Late reply:

FYI, I thought back and forth about the boilerplace text and how to
handle that when I started using it. I deliberately decided against
putting it under a "-- " line, as that wouldn't work well for some of
the mails I write -- for example those where I deliberately use
top-posting (which I hate and kinda feels wrong, but nevertheless right
at the same time) to make this as easy to grasp as possible.

After your comment I have thought about it again for a while but in the
end for now decided to mostly stick to the approach I used, but your
comment made me shorten the text a bit.

Ciao, Thorsten

