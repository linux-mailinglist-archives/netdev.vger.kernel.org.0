Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379EA2D2B84
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLHM6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:58:35 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:33921 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgLHM5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 07:57:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607432083;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:From:
        Subject:Sender;
        bh=JPe60FiXFw4FjZQPyeBwYTkfdrTdRhNRFGDzKOOVX4o=;
        b=Ow5YBRvNjKkovBTTW1/gdHF8RFFJnqTCzD04UN67fLznTzOFWyksGUFa+SRsUDIo/I
        qZM9zZugvdTlhpH02DkDW/5SsfzjWJElXulwHnaTeqUUxMY1BFyu7VJqx3iz7pOdefOV
        SUTfin1T7kpqAiN9jt9ZGZPONykkITGb2cEZdMgUTtLWM7Ph656ZSaeUM9eBLJNfY1yK
        f6CxfjblYJ4nknjwDdwS+iF/Jsx84Mps/U9+u0PxS26oARcQuBGeNY6DgAH2ikGohyNl
        mT9/HHtUf4Ulwj43+IWdn7riu8nRG63LDZxPgBual4RSRfxm4QfkW7VX0xIimgpPg0q2
        oEdg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3TMaFqTGVJiOMtqpw=="
X-RZG-CLASS-ID: mo00
Received: from [192.168.10.137]
        by smtp.strato.de (RZmta 47.6.2 DYNA|AUTH)
        with ESMTPSA id 302891wB8Csc1Ph
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 8 Dec 2020 13:54:38 +0100 (CET)
Subject: Re: [net 3/3] can: isotp: add SF_BROADCAST support for functional
 addressing
To:     Jakub Kicinski <kuba@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Thomas Wagner <thwa1@web.de>, linux-can@vger.kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org, davem@davemloft.net
References: <20201204133508.742120-1-mkl@pengutronix.de>
 <20201204133508.742120-4-mkl@pengutronix.de>
 <20201204194435.0d4ab3fd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <b4acc4eb-aff6-9d20-b8a9-d1c47213cefd@hartkopp.net>
 <eefc4f80-da1c-fed5-7934-11615f1db0fc@pengutronix.de>
 <20201205123300.34f99141@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <ce547683-925d-6971-6566-a0b54146090a@pengutronix.de>
 <20201205130904.3d81b0dc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <752c8838-b478-43da-620b-e15bcc690518@hartkopp.net>
Date:   Tue, 8 Dec 2020 13:54:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201205130904.3d81b0dc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05.12.20 22:09, Jakub Kicinski wrote:
> On Sat, 5 Dec 2020 21:56:33 +0100 Marc Kleine-Budde wrote:
>> On 12/5/20 9:33 PM, Jakub Kicinski wrote:
>>>> What about the (incremental?) change that Thomas Wagner posted?
>>>>
>>>> https://lore.kernel.org/r/20201204135557.55599-1-thwa1@web.de
>>>
>>> That settles it :) This change needs to got into -next and 5.11.
>>
>> Ok. Can you take patch 1, which is a real fix:
>>
>> https://lore.kernel.org/linux-can/20201204133508.742120-2-mkl@pengutronix.de/
> 
> Sure! Applied that one from the ML (I assumed that's what you meant).
> 

I just double-checked this mail and in fact the second patch from Marc's 
pull request was a real fix too:

https://lore.kernel.org/linux-can/20201204133508.742120-3-mkl@pengutronix.de/

Btw. the missing feature which was added for completeness of the ISOTP 
implementation has now also integrated the improvement suggested by 
Thomas Wagner:

https://lore.kernel.org/linux-can/20201206144731.4609-1-socketcan@hartkopp.net/T/#u

Would be cool if it could go into the initial iso-tp contribution as 
5.10 becomes a long-term kernel.

But I don't want to be pushy - treat it as your like.

Many thanks,
Oliver
