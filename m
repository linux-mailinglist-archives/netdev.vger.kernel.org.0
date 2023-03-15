Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1BB6BB4CA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjCONf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjCONf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:35:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB92929E00
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:35:43 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1pcRI0-0000e2-Fy; Wed, 15 Mar 2023 14:35:36 +0100
Message-ID: <4ad22818-6304-f00d-fa58-ad8b5de10495@pengutronix.de>
Date:   Wed, 15 Mar 2023 14:35:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net 1/2] net: dsa: realtek: fix out-of-bounds access
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315130917.3633491-1-a.fatoum@pengutronix.de>
 <2f0cb0a4-5611-4c61-9165-30cf1b1ef543@lunn.ch>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <2f0cb0a4-5611-4c61-9165-30cf1b1ef543@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,

On 15.03.23 14:30, Andrew Lunn wrote:
> On Wed, Mar 15, 2023 at 02:09:15PM +0100, Ahmad Fatoum wrote:
>> The probe function sets priv->chip_data to (void *)priv + sizeof(*priv)
>> with the expectation that priv has enough trailing space.
>>
>> However, only realtek-smi actually allocated this chip_data space.
>> Do likewise in realtek-mdio to fix out-of-bounds accesses.
> 
> Hi Ahmad
> 
> It is normal to include a patch 0/X which gives the big picture, what
> does this patch set do as a whole.
> 
> Please try to remember this for the next set you post.

Ok, will do next time. I didn't include one this time, because there's
no big picture here; Just two fixes for the same driver.

Cheers,
Ahmad

> 
>        Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

