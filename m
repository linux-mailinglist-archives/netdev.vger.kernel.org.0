Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B53C35F5628
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiJEOMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJEOMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:12:30 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A17786CA;
        Wed,  5 Oct 2022 07:12:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:73::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 8A6D2385;
        Wed,  5 Oct 2022 14:12:27 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 8A6D2385
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1664979147; bh=cPWxFc/53chuPrEn8nKpMvLwM1xRLSdinHoPALwDFnc=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=sfapab40Pry1D7GkGr4/ohSk+Nx/lMXmSiSyR4FMuq9NlWhP2GhrWWzWfSWMBTco6
         SNZwyqvZ4mbXaOtj2iXkk0vsBXxcZ3Lh7AZI+ix7iN775tXpbbhE1FesdlJOGaLmYM
         DlEExFgBZAIlZfWXf+lWR7/pPJYtpwt2uE7ft3CnNjcwy5DfGjfxIi7ugCIoukyADE
         in0GxpO+crDcE/0+PuOe2HE99BMa8PboS9YvIXidT0nr8zln7+dlrIzkptH9Wf3QNn
         vLql9Lxyu2PyqtvHQ9dEdMKhDsqv8Vg5tgQzN0ahgCTIW9zKnK1hIH9YSIkBDASvQb
         N7mFxemRmHGHg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Casper Andersson <casper.casan@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] docs: networking: phy: add missing space
In-Reply-To: <30e3cee2-420b-b2bc-9af0-9f7e9c696c57@gmail.com>
References: <20221004073242.304425-1-casper.casan@gmail.com>
 <6645ba3ba389dc6da8d16f063210441337db9249.camel@redhat.com>
 <a495dd76-060a-210a-1a11-55333d67180c@gmail.com>
 <30e3cee2-420b-b2bc-9af0-9f7e9c696c57@gmail.com>
Date:   Wed, 05 Oct 2022 08:12:26 -0600
Message-ID: <8735c2bbqt.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bagas Sanjaya <bagasdotme@gmail.com> writes:

> On 10/5/22 01:35, Florian Fainelli wrote:
>> On 10/4/22 03:30, Paolo Abeni wrote:
>>> On Tue, 2022-10-04 at 09:32 +0200, Casper Andersson wrote:
>>>> Missing space between "pins'" and "strength"
>>>>
>>>> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
>>>> ---
>>>
>>> The merge window has now started (after Linus tagged 6.0)
>>> and will last until he tags 6.1-rc1 (two weeks from now). During this
>>> time we'll not be taking any patches for net-next so
>>> please repost in around 2 weeks.
>> 
>> It is a documentation patch, therefore not functionally touching code, maybe that could count as an exception?
>
> I think jon will pick up this patch, maybe as -rc-worthy fixes.

The networking folks prefer to carry their own documentation patches, so
I don't normally do that.  I'd be happy to this time with a suitable
ack.

But honestly, there is nothing urgent about this change, I'd say just
wait until net-next is open.

jon
