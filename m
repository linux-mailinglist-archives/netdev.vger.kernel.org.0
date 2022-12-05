Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588D0642908
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 14:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiLENPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 08:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiLENPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 08:15:23 -0500
Received: from hfcrelay.icp-osb-irony-out2.external.iinet.net.au (hfcrelay.icp-osb-irony-out2.external.iinet.net.au [203.59.1.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 93D0AD132;
        Mon,  5 Dec 2022 05:15:20 -0800 (PST)
IronPort-SDR: f5lXJsM+d4s7BG69CwWPUh0rT/Jh7Ze5ivVI/PvE1GhOCS421Ytx9vsCzb/m1kTQk6xgJCHju9
 9SQTCln+D9gmSqxYeYLiV6f53O9mi7LGHh00vh52Yef5ibcbjUvs/SrhDKYxoR84hyOe1FGxFq
 xLpOdsb7W8vBmYp9nAsZMEqV8cLI4mRR8h9bptTu2P7vbS2OttQxrOd5DKXt4WZzmdEFUGH2dT
 UwvtCGiBeLPaau5ey72QGvr5VdAjsnMLGhU0KuXTL25VnhRIwhlPXT9WPdupkFLc02h+9Y0d4k
 pbA=
X-SMTP-MATCH: 1
IronPort-Data: A9a23:nIvNN6Nw2CZor9/vrR2plsFynXyQoLVcMsEvi/4bfWQNrUoSY0+zN
 tZk7ZAyRo+IZ1JB9ql3aI2GQSqzYKdhr6ZjeLYO3SgFo0li9IyUW7x1Em+qZ3nId5ebERo+h
 ykjQoKowP4cHye0SiiFb+CJQUlUjclkkZKlVYYokggoLeNVYH9JZSBLwobVsaYx6TSNOD5hj
 PupyyHp1P5J7BYvWo4cw/rrRBpH4K+o4GtA1rA0TagjUFT2zxH5ALpDfvvpdyOQroR8RoaHq
 +j/IL6RpXHZ7yozIOGerOigSBYXY6TpPiaRoy8DM0SiqkAqSi0a4f9qbrxFNxcR03PTxeUZJ
 Ndl7M3rD15wYOuSxqJEA0Yw/yJWZMWq/JfIO3WwrMqcwlfLaVPzzu5yCkwqe4Yf/6B+HAmi8
 NREc2lQME7f1rneLLSTQ/FRgskYA9jQPpoOuGN40RD0KO8KaMWWK0nNzZoCtNsqvehKHPDDd
 +IDYCFqcQ/eYhlLN1IQBYl4kOTArmD+ejtXsVOTquwl42HVwyR3wKCrO93QEvSGTNtYm26Ur
 3zL+mD+DA1cMtGDoRKI/m+pj/3CgQv0X4UdELD+/flv6HWQ22YaIB4bT122pb++kEHWc8pWI
 UES+wI0oKQy/VDtRd74NzW+rWKIswA0RdVdCas55RuLx66S5ByWbkAATzhceJkludUwSDgCy
 FCEhZXqCCZpvbnTTmiSnop4thvraHNQdDZcIHFaCFJVvJ//uI4yyBnIS5BqDcZZk+HIJN05+
 BjSxABWulnZpZVjO3mTlbwfvw+Rmw==
IronPort-HdrOrdr: A9a23:6aUE16t+egZFSkVJFe1Emkqh7skDqtV00zEX/kB9WHVpm62j5r
 uTdZEgviMc5wx+ZJhNo7290eq7MBfhHOdOgLX5ZI3DYOCEghrLEGgB1/qb/9SIIUSXnNK1s5
 0QFpSWY+eeMbEVt6rHCUaDYrEdKXS8gcaVrPab5U1ECSttb7hk7w9/AAreKEtrXwNLbKBJd6
 Z0ovA33gadRQ==
X-IronPort-AV: E=Sophos;i="5.96,219,1665417600"; 
   d="scan'208";a="431566493"
Received: from 193-116-66-187.tpgi.com.au (HELO [192.168.0.22]) ([193.116.66.187])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 05 Dec 2022 21:15:15 +0800
Message-ID: <86d17574-926a-e449-47ce-409701e80656@westnet.com.au>
Date:   Mon, 5 Dec 2022 23:15:15 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: fec: don't reset irq coalesce settings to defaults
 on "ip link up"
Content-Language: en-US
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <c69c1ff1-4da9-89f8-df2e-824cb7183fe9@westnet.com.au>
 <72eb4e63-10a8-702b-1113-7588fcade9fc@rasmusvillemoes.dk>
From:   Greg Ungerer <gregungerer@westnet.com.au>
In-Reply-To: <72eb4e63-10a8-702b-1113-7588fcade9fc@rasmusvillemoes.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/12/22 18:44, Rasmus Villemoes wrote:
> On 05/12/2022 08.15, Greg Ungerer wrote:
>> Hi Rasmus,
>>
>> On 23 Nov 2022, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
>>> Currently, when a FEC device is brought up, the irq coalesce settings
>>> are reset to their default values (1000us, 200 frames). That's
>>> unexpected, and breaks for example use of an appropriate .link file to
>>> make systemd-udev apply the desired
>>> settings
>>> (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
>>> or any other method that would do a one-time setup during early boot.
>>>
>>> Refactor the code so that fec_restart() instead uses
>>> fec_enet_itr_coal_set(), which simply applies the settings that are
>>> stored in the private data, and initialize that private data with the
>>> default values.
>>>
>>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>>
>> This breaks The ColdFire parts that use the FEC hardware module at the
>> very least. It results in an access to a register (FEC_TXIC0) that does
>> not exist in the ColdFire FEC. Reverting this change fixes it.
>>
>> So for me this is now broken in 6.1-rc8.
> 
> Sorry about that.
> 
> Since we no longer go through the same path that ethtool would, we need
> to add a check of the FEC_QUIRK_HAS_COALESCE bit before calling
> fec_enet_itr_coal_set() during initialization. So something like
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index 93a116788ccc..3df1b9be033f 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1186,7 +1186,8 @@ fec_restart(struct net_device *ndev)
>                  writel(0, fep->hwp + FEC_IMASK);
> 
>          /* Init the interrupt coalescing */
> -       fec_enet_itr_coal_set(ndev);
> +       if (fep->quirks & FEC_QUIRK_HAS_COALESCE)
> +               fec_enet_itr_coal_set(ndev);
>   }

That certainly fixes it.


> Or perhaps it's even better to do the check inside
> fec_enet_itr_coal_set() and just return silently?

That may well be better, yes.


> Either way, I don't know if it's too late to apply this fix, or if
> df727d4547 should just be reverted for 6.1 and then redone properly?
> Greg, can you check if the above fixes it for you?

Yep, that is good. I have no strong opinion on which way to handle
right now, so up to you.

Regards
Greg


