Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E29D447858C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 08:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbhLQHY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 02:24:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhLQHY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 02:24:58 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17DC061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 23:24:55 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w24so1104355ply.12
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 23:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=D6HtjCvzR0S/a12IaShvqVx/3AWqSpL+5RJ/x96KYs0=;
        b=JaBtxUGEfkxgFPMFAUYQsz4QnkjOJ/IN3RZcT6d99snl5c3RpFLuYwjFlJ+Ah+JRuw
         fDhlMGgrlLkWImVzeKZHRg9zMljR/HKXiRj/oDFZ+7id7vDlk7tpMJ69M9w8GY9lnAPs
         mx+mP+9VZCZ2eDnN4bAiEIP9JM9xB+RK0OZbgNNiBzk1j42H3s6C1HjXhTP4nHcTKAv1
         cts/SubVFO9N/UiGvtgDVrRrLXtRSXz6ajQiVcXJYid1XSpoJoJgBAjjyl73H9qDFJEk
         TYFcG6Q5wyV0SL1FkVbrQVNPegPg7zM1NpveW8eV28ceCNOW90wh4GhuoBmatx2Qfi+b
         Jofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=D6HtjCvzR0S/a12IaShvqVx/3AWqSpL+5RJ/x96KYs0=;
        b=JvKP+rvOeNVlmAJGe6wjdbRa6UWfGpvkwjaN7pEKrCEZfuIpSfOE6tIGcsbgmsSF3a
         ue1iFHaJ8wP8hUSF49a4WFqQ9wIpVmsTAKXS8lUJYNMuxvAcY6iVnWG9bMvZWQ2pA8PE
         SqRmpO5iytyLnyqKktXllh8ky/yhup4Oy89s7x6/bMUTJDovrcDDY8I7jZnvoUBtC1Y5
         sMzMr7o5xjqHyocJEKawEBf9W3NZVRkz1fMJEY/2i067kVBT49+FoQCB3xOZ0/ngI+ZY
         Y4nl2lUvZue2j9SI4dYoq0L4RF45gY3o2vkDfdd+Rpl0ojgEDOTPoCh1Fu7cQ8mQR6jd
         00HA==
X-Gm-Message-State: AOAM533tlgTBNVzKKolvxuNv0Eao5PDpxNuUBqOoIWdlvqD51IUDB8kL
        HTjDrpaFgQmGB8kpbut34X6lakOf58IP2GNExOwOaR5rvPCE4ydw
X-Google-Smtp-Source: ABdhPJxVhx6meQ4WPlS/rbHfLJqSXdj32t+KRoVt4o7iyDFd9YjYVrfIJ2p2alM51RvUJO15TjRC1MSi13u5M6UhA40=
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr2322077pjb.183.1639725895007;
 Thu, 16 Dec 2021 23:24:55 -0800 (PST)
MIME-Version: 1.0
References: <20211216201342.25587-1-luizluca@gmail.com> <20211216201342.25587-8-luizluca@gmail.com>
 <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
In-Reply-To: <1fbf5793-8635-557b-79f2-39b70b141ba3@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 17 Dec 2021 04:24:43 -0300
Message-ID: <CAJq09z79xThgsagBLAcLJqDKzC6yx=_jjP+Bg0G4OXXbNj30EQ@mail.gmail.com>
Subject: Re: [PATCH net-next 07/13] net: dsa: rtl8365mb: rename rtl8365mb to rtl8367c
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Luiz,
Hi Alvin,

> On 12/16/21 21:13, luizluca@gmail.com wrote:
> > From: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> >
> > rtl8365mb refers to a single device supported by the driver.
> > The rtl8367c does not refer to any real device, but it is the
> > driver version name used by Realtek.
> >
> > Tested-by: Ar=C4=B1n=C3=A7 =C3=9CNAL <arinc.unal@arinc9.com>
> > Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> > ---
> >   drivers/net/dsa/realtek/Kconfig       |    9 +-
> >   drivers/net/dsa/realtek/Makefile      |    2 +-
> >   drivers/net/dsa/realtek/realtek-smi.c |    4 +-
> >   drivers/net/dsa/realtek/realtek.h     |    2 +-
> >   drivers/net/dsa/realtek/rtl8367c.c    | 1321 ++++++++++++------------=
-
> >   drivers/net/phy/realtek.c             |    2 +-
> >   6 files changed, 666 insertions(+), 674 deletions(-)
> >
>
> Is the rename really necessary? My logic in naming it rtl8365mb was
> simply that it was the first hardware to be supported by the driver,
> which was more meaningful than Realtek's fictitious rtl8367c. This seems
> to be common practice in the kernel, and bulk renames don't normally
> bring much value.
>
> I think the vendor's naming scheme is confusing at best, so it's better
> to stick to real things in the kernel.

Yes, it is quite confusing. I just know that the last digit is the
number of ports and NB
seems to indicate a switch that does not "switch" (user ports does not
share a broadcast
domain). RTL8365MB-VC does seem to be the first one "switch" in the
rtl8367c supported list.

I don't have any strong preference which name it will have. I'm really
not an expert in
the Realtek product line. My guess is that Realtek has some kind of
"driver/device generation",
because I also see rtl8367b, and rtl8367d. I used rtl8367c as it is
the name used by Realtek
API and Programming Guide. I saw it referenced in, arduino and uboot
and out-of-tree linux
drivers. I really don't know the best name but, if we use a real
product name, I suggest using
the full name, including suffixes because Realtek could launch a new
RTL8365MB (with a
different suffix or even without one) for a different incompatible
chip. And that will be even more
confusing. We could also create our own fake sequence (rtl83xx-1,
rtl83xx-2,...) but it is normally
better to adopt an in-use standard than to create a new one.

I do care about names but I simply don't have the knowledge to have a
say. I think there are
plenty of experts on this list. I would also love to hear from someone
from Realtek to suggest
 a good name. Does anyone have a contact?

Regards
