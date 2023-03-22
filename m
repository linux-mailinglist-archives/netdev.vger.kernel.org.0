Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD4B6C4FAC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjCVPro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjCVPrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:47:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8BB6485D
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:47:42 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pf0gY-00072h-Tg; Wed, 22 Mar 2023 16:47:34 +0100
Message-ID: <ba3121a5-7d97-ab51-6aba-d7a8fcdc363f@pengutronix.de>
Date:   Wed, 22 Mar 2023 16:47:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net 2/2] net: dsa: realtek: fix missing new lines in error
 messages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        kernel@pengutronix.de, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <20230315130917.3633491-2-a.fatoum@pengutronix.de>
 <20230316210520.5b939600@kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <20230316210520.5b939600@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.03.23 05:05, Jakub Kicinski wrote:
> On Wed, 15 Mar 2023 14:09:16 +0100 Ahmad Fatoum wrote:
>> Some error messages lack a new line, add them.
> 
> I thought printk() and friends automatically add a new line these days,
> unless continuation is specifically requested. Is that not the case?
> Have you seen these prints actually getting mangled?

I did not. I had noticed the asymmetry with other error prints in the
same file and assumed this to be unintended. Good to know this no
longer causes an issue nowadays.

Sorry for the noise and please disregard this patch.

Thanks,
Ahmad

> 
>> Fixes: d40f607c181f ("net: dsa: realtek: rtl8365mb: add RTL8367S support")
>> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

