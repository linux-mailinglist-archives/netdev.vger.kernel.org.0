Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B685BDEAD
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 09:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiITHrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 03:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiITHqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 03:46:36 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F3F267E;
        Tue, 20 Sep 2022 00:45:45 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oaXwq-00084B-2t; Tue, 20 Sep 2022 09:45:40 +0200
Message-ID: <9165d763-ec2c-3014-cebf-121934ad93f3@leemhuis.info>
Date:   Tue, 20 Sep 2022 09:45:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
Content-Language: en-US, de-DE
To:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?B?Q3PDs2vDoXMgQmVuY2U=?= <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
 <20220912122857.b6g7r23esks43b3t@pengutronix.de>
 <20220912123833.GA4303@francesco-nb.int.toradex.com>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220912123833.GA4303@francesco-nb.int.toradex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1663659946;fbec6853;
X-HE-SMSGID: 1oaXwq-00084B-2t
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.09.22 14:38, Francesco Dolcini wrote:
> On Mon, Sep 12, 2022 at 02:28:57PM +0200, Marc Kleine-Budde wrote:
>> On 12.09.2022 09:01:41, Francesco Dolcini wrote:
>>> Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
>>> issues and we are at 6.0-rc5.
>>>
>>> Francesco Dolcini (2):
>>>   Revert "fec: Restart PPS after link state change"
>>>   Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
>>
>> Nitpick: I would revert "net: fec: Use a spinlock to guard
>> `fep->ptp_clk_on`" first, as it's the newer patch.
> 
> Shame on me, I do 100% agree, I inverted the 2 patches last second.

What's the status of this patchset? It seems it didn't make any progress
in the past few days, or am I missing something?

Just asking, because the thing is: I'm pretty sure that Linus will be
somewhat unhappy if there isn't any attempt to get this fixed before
rc7, as the the problems caused by these patches are known for a while now.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
