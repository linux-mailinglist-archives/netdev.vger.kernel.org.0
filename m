Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0F1A831
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 17:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbfEKPGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 11:06:08 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39201 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728572AbfEKPGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 11:06:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id n25so9890247wmk.4;
        Sat, 11 May 2019 08:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:mime-version:message-id:in-reply-to
         :references:user-agent:content-transfer-encoding;
        bh=6UiqJ4m3sPzyqJomJHE7ExCLyXzjMLS98K0ef/RXLqM=;
        b=A32EvO3vT97nPsb17JblWScq/XGUUQbxZ80CDHR3TB+hUY4N8JC5DCb3ni8k98y6HJ
         3e/h6gFm+YEMLzNJb2x3OcWJihyEqa3Atjs5sNv3ctiyVh1Lhq+KmRu6v6wFusYqfk3k
         96sZg2ytrT3rQmHOCTzRO49OH8A3TykpzKmz71MEBoQQjAlfT9VJu+aoRnqiijR9bUrY
         nk19GkM6KTvCBZ7+rcuRNOgadCxTWY4RF7CR+UH+8H770Y06Yofd43F5ZLonQPC/YaeX
         0PUId5H8j1712WzcLicZskpCNccZ9egdwu6N+4tVuMeCtx35Bt8yEzq2MwfjiByJfbXu
         eB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:mime-version:message-id
         :in-reply-to:references:user-agent:content-transfer-encoding;
        bh=6UiqJ4m3sPzyqJomJHE7ExCLyXzjMLS98K0ef/RXLqM=;
        b=j7CUrEgy+LYUhnngOE4whNWx65xBlUTvGaTgTBtVKUq1ExtiTKSs8pYi92FpThjM0j
         ypADsRI5clhJ0udGVCxx+hrQ4BlzgaL8QppXapb2wMy/IzeMXysakgStvlag6tRqTMY3
         rE/oYd4xfZkdUy/gtkWJdz7lGZ2B1EUZFbLD6UvezRQcTyT6ARbTyJnuG754TZf5igKt
         XvSZTHsfCCdYcBcb6EW3LFF+biNHPkr8UeJ0X9k7GUtHfh7sjo6LOms0QHdUxncgLd6e
         tPqQk/0GeSxmaNcT1Y9LU5WJQjiscyseo/TfRX1PZnBFLFWIg3n7FAMJZdJjXnGHTJw/
         b0RA==
X-Gm-Message-State: APjAAAVUbxee5Uj9uimzYt26P53Cn7u4gGAj1qUf7Ny2+0xWa/f1HtZv
        obIik519cadXvckCvoV8uIE=
X-Google-Smtp-Source: APXvYqzf+zs+O6W1AWuhFETXIp95aae5PeCygtmrCNOYqQrkdcyEqkflvUOX5JUrjHx0T/0QDtOG6A==
X-Received: by 2002:a1c:9eca:: with SMTP id h193mr1650053wme.125.1557587166149;
        Sat, 11 May 2019 08:06:06 -0700 (PDT)
Received: from localhost ([92.59.185.54])
        by smtp.gmail.com with ESMTPSA id v5sm18209728wra.83.2019.05.11.08.06.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 11 May 2019 08:06:05 -0700 (PDT)
From:   Vicente Bergas <vicencb@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Date:   Sat, 11 May 2019 17:06:04 +0200
MIME-Version: 1.0
Message-ID: <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
In-Reply-To: <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
User-Agent: Trojita
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, May 11, 2019 4:56:56 PM CEST, Heiner Kallweit wrote:
> On 11.05.2019 16:46, Vicente Bergas wrote:
>> On Friday, May 10, 2019 10:28:06 PM CEST, Heiner Kallweit wrote:
>>> On 10.05.2019 17:05, Vicente Bergas wrote: ...
>>=20
>> Hello Heiner,
>> just tried your patch and indeed the NPE is gone. But still no network...
>> The MAC <-> PHY link was working before, so, maybe the rgmii=20
>> delays are not
>> correctly configured.
>
> That's a question to the author of the original patch. My patch was just
> meant to fix the NPE. In which configuration are you using the RTL8211E?
> As a standalone PHY (with which MAC/driver?) or is it the integrated PHY
> in a member of the RTL8168 family?

It is the one on the Sapphire board, so is connected to the MAC on the
RK3399 SoC. It is on page 8 of the schematics:
http://dl.vamrs.com/products/sapphire_excavator/RK_SAPPHIRE_SOCBOARD_RK3399_L=
PDDR3D178P232SD8_V12_20161109HXS.pdf

> Serge: The issue with the NPE gave a hint already that you didn't test your=

> patch. Was your patch based on an actual issue on some board and did you
> test it? We may have to consider reverting the patch.
>
>> With this change it is back to working:
>> --- a/drivers/net/phy/realtek.c
>> +++ b/drivers/net/phy/realtek.c
>> @@ -300,7 +300,6 @@
>>     }, {
>>         PHY_ID_MATCH_EXACT(0x001cc915),
>>         .name        =3D "RTL8211E Gigabit Ethernet",
>> -        .config_init    =3D &rtl8211e_config_init,
>>         .ack_interrupt    =3D &rtl821x_ack_interrupt,
>>         .config_intr    =3D &rtl8211e_config_intr,
>>         .suspend    =3D genphy_suspend,
>> That is basically reverting the patch.
>>=20
>> Regards,
>>  Vicen=C3=A7.
>>=20
>>> Nevertheless your proposed patch looks good to me, just one small change
>>> would be needed and it should be splitted.
>>>=20
>>> The change to phy-core I would consider a fix and it should be fine to
>>> submit it to net (net-next is closed currently).
>>>=20
>>> Adding the warning to the Realtek driver is fine, but this would be ...

