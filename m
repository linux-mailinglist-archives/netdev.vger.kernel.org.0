Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E87C66A552
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjAMVtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:49:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbjAMVs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:48:59 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAF1892DD;
        Fri, 13 Jan 2023 13:48:55 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 55C861645;
        Fri, 13 Jan 2023 22:48:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673646533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X7itDCsidDp1tXSi/vZ6Jh/Qu1ORs+1kkBuFUxVYwzY=;
        b=JDV/8c38SkgGz2HItHdY1EvZ7EyfFu8vAYD0oGYDXpG/32fhLRbola8uD9GTFQmMINy7Z3
        j9lqa9JUlwsZA6DBz6PS1c2WgPUaKWCqszZ70FvFdjfwichaovwPprPuI+vi9Q+ks3BNEA
        NWyyFAM5ltTncxUhOVddY5hgfh7EHbKNCwmQuLMY3JmwXPx27WCDw9AoQ3aiBSCRyJa+ra
        lEmck058HmdI0fh3nVSxDfudFylo77pbsDVZAZKPZ19UfaBZTnpUdbVoo7jyAMtnY+TwNg
        FqHVAEWTAcP55sZOs//f/QgqlqElAc5PAyVm4CAPktcF95HKVUduUt0srNfUUw==
MIME-Version: 1.0
Date:   Fri, 13 Jan 2023 22:48:53 +0100
From:   Michael Walle <michael@walle.cc>
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <CAL_JsqKMo6op93WQHpuVdBV6tOPYa9Pyu4geRQmOeQAicEsLWg@mail.gmail.com>
References: <20230109123013.3094144-1-michael@walle.cc>
 <20230109123013.3094144-3-michael@walle.cc>
 <20230111202639.GA1236027-robh@kernel.org>
 <73f8aad30e0d5c3badbd62030e545ef6@walle.cc>
 <CAL_JsqKMo6op93WQHpuVdBV6tOPYa9Pyu4geRQmOeQAicEsLWg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <da96809052c936581b5e6b258e1b2133@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2023-01-13 17:38, schrieb Rob Herring:
> On Wed, Jan 11, 2023 at 4:30 PM Michael Walle <michael@walle.cc> wrote:
>> 
>> Am 2023-01-11 21:26, schrieb Rob Herring:
>> > On Mon, Jan 09, 2023 at 01:30:11PM +0100, Michael Walle wrote:
>> >> Add the device tree bindings for the MaxLinear GPY2xx PHYs, which
>> >> essentially adds just one flag: maxlinear,use-broken-interrupts.
>> >>
>> >> One might argue, that if interrupts are broken, just don't use
>> >> the interrupt property in the first place. But it needs to be more
>> >> nuanced. First, this interrupt line is also used to wake up systems by
>> >> WoL, which has nothing to do with the (broken) PHY interrupt handling.
>> >
>> > I don't understand how this is useful. If the interrupt line is
>> > asserted
>> > after the 1st interrupt, how is it ever deasserted later on to be
>> > useful.
>> 
>> Nobody said, that the interrupt line will stay asserted. The broken
>> behavior is that of the PHY doesn't respond *immediately* with a
>> deassertion of the interrupt line after the its internal status
>> register is cleared. Instead there is a random delay of up to 2ms.
> 
> With only "keep the interrupt line asserted even after the interrupt
> status register is cleared", I assume that means forever, not some
> delay.

Fair enough. I'll send a doc patch.

>> There is already a workaround to avoid an interrupt storm by delaying
>> the ISR until the line is actually cleared. *But* if this line is
>> a shared one. The line is blocked by these 2ms and important
>> interrupts (like PTP timestaming) of other devices on this line
>> will get delayed. Therefore, the only viabale option is to disable
>> the interrupts handling in the broken PHY altogether. I.e. the line
>> will never be asserted by the broken PHY.
> 
> Okay, that makes more sense.
> 
> So really, this is just an 'is shared interrupt' flag. If not shared,
> then there's no reason to not use the interrupt?

Correct.

> Assuming all
> interrupts are described in DT, we already have that information. It's
> just hard and inefficient to get it. You have to parse all interrupts
> with the same parent and check for the same cells. If we're going to
> add something more explicit, we should consider something common. It's
> not the first time shared interrupts have come up, and we probably
> have some properties already. For something common, I'd probably make
> this a flag in interrupt cells rather than a property. That would
> handle cases with multiple interrupts better.

What kind of flag do you have in mind? Could you give an example?

-michael
