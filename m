Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C223396A6
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 19:33:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhCLSd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 13:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbhCLSdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 13:33:14 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0D2C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 10:33:13 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y13so2457407pfr.0
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 10:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KxrC8jEciIVVc+WkSIWy2wwQwDlmYHmK6w9Bx/UUmFE=;
        b=k/3JYhBPvtH4RXOQmMLo+CEZgPVGbd2WKdupwB8vzFth6FKNkvQXs+VW3IM08n3m9q
         LVF0KCrYkxWY5pB6STQl1OKJScFgZ1KvQZxyQrETW95y6J1Sbpkh0MUGgtf8cvriYFoW
         tSS8p80oqhb4YfF99bL4/jRH8MKzirR2COGO9m+VNlxBYhYzg8SmP/MbnxfR30N2JhXG
         PBnIhII2zCLA1Rx5bOFdXcJqrj3yplVqbKXIcio+vE2n8f3Msb3Ba0qFN2U0O0gqvifl
         g+dcei1remfgI9PeaHHwo7l2orFSIZ8VE+iYRC0qF4+7qBcnFvQGYp5AHDqmxsQF6a6x
         GNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KxrC8jEciIVVc+WkSIWy2wwQwDlmYHmK6w9Bx/UUmFE=;
        b=EkQBnn6vHqAOR+ve00ohwDQr95KifuYSQ4AYflQWtXZRWxroa6LUNXG5k2+jGubqkQ
         Lp58dqY2alb2tnFJ0eMBsr8a8ComRACKTMynBJd00JYUD/pJ6vpyuS2zRgZG70+SLznn
         nR1SkK30NPmTbWljExnpUuJsEk5ZtmcPMwgiAH6fakaSi7UXZ1LIhGe/9uuCWBAusTEL
         XUQ5GXh5NujjYfSu6RcdEGPOalRMBhEFZ6dFCittnB+wUrlTKbwE99ZdxTefuQtX+sQi
         sv70NZYi7qt2JrZXSPpCPb0p7b9MlNiUFAi9+qhFgfzDZwWQGU3zdTd0hIte5cGSdftU
         Nj+Q==
X-Gm-Message-State: AOAM5329vTrpqHzJImn4JDK5CvdpqYEGS0EiaC2s6WFHNlnZI0PvDFRs
        jx1yKIvIbONzkcPaW0rBJoK2P18iVKI=
X-Google-Smtp-Source: ABdhPJwxBuqx6d95G86jpW5MaXZLglMdMI3DUvGTPOHM6LhYx+FuMlQV3syMZ9Aq94ValZQq9qmhpA==
X-Received: by 2002:a65:4887:: with SMTP id n7mr12966609pgs.14.1615573992951;
        Fri, 12 Mar 2021 10:33:12 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g5sm7014882pfb.77.2021.03.12.10.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 10:33:12 -0800 (PST)
Subject: Re: stmmac driver timeout issue
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <DB8PR04MB679570F30CC2E4FEAFE942C5E6979@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <8a996459-fc77-2e98-cc0c-91defffc7f29@gmail.com>
 <DB8PR04MB6795BB20842D377DF285BB5FE6939@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <49fedeb2-b25b-10d0-575f-f9808a537124@gmail.com>
 <DB8PR04MB6795BCB93919DF684CA8DA79E6909@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5d636daa-b25a-d0f1-dc95-b021cb0f53eb@gmail.com>
Date:   Fri, 12 Mar 2021 10:33:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795BCB93919DF684CA8DA79E6909@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/21 4:04 AM, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: 2021年3月9日 1:57
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Jakub Kicinski
>> <kuba@kernel.org>; Andrew Lunn <andrew@lunn.ch>
>> Cc: netdev@vger.kernel.org
>> Subject: Re: stmmac driver timeout issue
>>
>> On 3/8/21 4:45 AM, Joakim Zhang wrote:
>>>
>>> Hi Florian, Andrew,
>>>
>>> Thanks for your help, after debug, It seems related to PHY(RTL8211FDI). It
>> stop output RXC clock for dozens to hundreds milliseconds during
>> auto-negotiation, and there is no such issue with AR8031.
>>> When do ifup/ifdown test or system suspend/resume test, it will
>>> suspend then resume phy which do power down and then change to normal
>>> operation.(switch from power to normal operation)
>>>
>>> There is a note in RTL8211FDI datasheet:
>>> Note 2: When the RTL8211F(I)/RTL8211FD(I) is switched from power to
>> normal operation, a software reset and restart auto-negotiation is performed,
>> even if bits Reset(0.15) and Restart_AN(0.9) are not set by the users.
>>>
>>> Form above note, it will trigger auto-negotiation when do ifup/ifdown test or
>> system suspend/resume, so we will meet RXC clock is stop issue on
>> RTL8211FDI. My question is that, Is this a normal behavior, all PHYs will
>> perform this behavior? And Linux PHY frame work can handle this case, there is
>> no config_init after resume, will the config be reset?
>>
>> I do not have experience with Realtek PHYs however what you describe does
>> not sound completely far off from what Broadcom PHYs would do when
>> auto-power down is enabled and when the link is dropped either because the
>> PHY was powered down or auto-negotiation was restarted which then leads to
>> the RXC/TXC clocks being disabled.
>>
>> For RGMII that connects to an actual PHY you can probably use the same
>> technique that Doug had implemented for GENET whereby you put it in isolate
>> mode and it maintains its RXC while you do the reset. The problem is that this
>> really only work for an RGMII connection and a PHY, if you connect to a MAC
>> you could create contention on the pins. I am afraid there is no fool proof
>> situation but maybe you can find a way to configure the STMMAC so as to route
>> another internal clock that it generates as a valid RXC just for the time you
>> need it?
>>
>> With respect to your original problem, looks like it may be fixed with:
>>
>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kern
>> el.org%2Fnetdev%2Fnet%2Fc%2F9a7b3950c7e1&amp;data=04%7C01%7Cqian
>> gqing.zhang%40nxp.com%7Cb7e83671b0184471020708d8e25b8ca6%7C686ea
>> 1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C637508230113442096%7CUnk
>> nown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1
>> haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=LPY4fazuJFAOanncuGll1jGK8W
>> bxiR2iZ5KfuuaAk98%3D&amp;reserved=0
>>
>> or maybe this only works on the specific Intel platform?
> 
> Thanks Florian, I also noticed that patch, but that should work for driver remove. The key is RXC not stable when auto-nego at my side.
> 
> I have a question about PHY framework, please point me if something I misunderstanding.
> There are many scenarios from PHY framework would trigger auto-nego, such as switch from power down to normal operation, but it never polling the ack of auto-nego (phy_poll_aneg_done), is there any special reasons? Is it possible and reasonable for MAC controller driver to poll this ack, if yes, at least we have a stable RXC at that time.

Adding Heiner and Russell as well. Usually you do not want, or rather
cannot know whether auto-negotiation will ever succeed, so waiting for
it could essentially hog your system for some fairly indefinite amount
of time.

With respect to your Realtek PHY is there no way you can force it to
output the 125MHz RX clock towards the MAC while you perform the MAC
initialization?
-- 
Florian
