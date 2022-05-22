Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89041530676
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiEVWQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241216AbiEVWQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:16:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24707DF47
        for <netdev@vger.kernel.org>; Sun, 22 May 2022 15:16:40 -0700 (PDT)
Received: from ptz.office.stw.pengutronix.de ([2a0a:edc0:0:900:1d::77] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1nsts8-0006nK-OP; Mon, 23 May 2022 00:16:24 +0200
Message-ID: <80306a31-462c-4ce3-5c54-c0f74ad828f8@pengutronix.de>
Date:   Mon, 23 May 2022 00:16:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/2] dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT
 binding
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
References: <20220521200734.421223-1-a.fatoum@pengutronix.de>
 <CACRpkdbKUHu-T2whY4wgk5xnR7X-hptEg+Jm5Hudq8ieQi3VwA@mail.gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
In-Reply-To: <CACRpkdbKUHu-T2whY4wgk5xnR7X-hptEg+Jm5Hudq8ieQi3VwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:900:1d::77
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.05.22 23:03, Linus Walleij wrote:
> On Sat, May 21, 2022 at 10:07 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrote:
> 
>> The BCM4349B1 chip is a single-chip Bluetooth 5.0 controller and
>> Transceiver. It is contained in the CYW/BCM89359 WiFi+BT package.
> 
> So the BT and the package have two different names.

The package also goes by the name BCM4349B1 apparently.
Cypress support had later confirmed BCM4349B1 and BCM89359 to
be the same chipset. I should probably rephrase the commit message.


>> +      - brcm,bcm4349-bt
> 
> Then why do you have to tag on "-bt" on this compatible?
> 
> That is typically used when the wifi and bt has the *same* name, so
> the only way to distinguish between them is a suffix.
I think that's the case here too.

Cheers,
Ahmad

> 
> Yours,
> Linus Walleij
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
