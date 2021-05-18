Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7D387442
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 10:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347567AbhERIou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 04:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242128AbhERIom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 04:44:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B07C061573;
        Tue, 18 May 2021 01:42:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g24so5125720pji.4;
        Tue, 18 May 2021 01:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=zPAWZP38EyewYo25KzL/nEXTJR7YqH77lAlzwI/ZVY4=;
        b=EY6ssFDewzkGa3XU9kRDLv77BOy56Xu6cUQfvPZU8HDcu/5oaTQLimkvR0kpMCE4Om
         sYYGijwwpccvd6LRyzTjWNS0alMhA/B5LtDO2kxWK1mdG/rUF0oa1UToWm4D8NDOSdo3
         kI9/Efgl+H76747tzlAS0a+F9bvz2jWGxf9437nPphGUxCoJKARwdzc8fnj8+suaeJqT
         GvUKUaIWTwjwe8sTS7kDH8tm1GIxMo8PKpn/BmpBjyXAwPbxbFOL5/8AH3IlPHtbvIeb
         qvjOSjSAwJePEX97NwVHlksqESBhGd9neHk3ItRj6iX4gMuahEa2jZRHdeOasIc7th1W
         +WCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=zPAWZP38EyewYo25KzL/nEXTJR7YqH77lAlzwI/ZVY4=;
        b=gRPvFC+wbMLTn+jKIthQRWtdwhwm5qiaFekqfrfm8MYF5c4nrtrqh7p8oX9hCpIEEc
         GPOQShriAoApyXsWImaYklhNMf10CbNC7nvatILuBsbNwiLxO/Ha2ILk3f5Fnv3n9Yab
         fbE0342RvFmUazv0IETg/qpdFzhgCgoKNmd12QxSIQj0fz9LCSuIozr5jde9fVGS/TqV
         x5qF+2GCqtVhlMbr7R1ljF6JQ6AFkmmpM8PIs5tDhXzWK7SpfgMvhv+/z3t3QieqRTdo
         izY+Ynn63NQoQVeoF9iCMaUlMKC1jiveLzsQQIyZD8Y+bY8pddp+iEcNpCM/WW7hsMIm
         Y/sQ==
X-Gm-Message-State: AOAM5333ZUrJoXHWTtbZSkhtuW/X18afrcH7qO2e2kCa1cuJEIJt3DbX
        YnBml5K1f0U12qfr6StnHztBev8PQs8=
X-Google-Smtp-Source: ABdhPJy/9B2pYUkqZ/C+iYZOlxNHXz+PNo78bGChv3WrbwdeNdBkRR8C3ImkYKM0zr5OHbJccn9xMw==
X-Received: by 2002:a17:902:8d83:b029:e6:508a:7b8d with SMTP id v3-20020a1709028d83b02900e6508a7b8dmr3428154plo.18.1621327357883;
        Tue, 18 May 2021 01:42:37 -0700 (PDT)
Received: from [10.1.1.24] (122-58-21-90-fibre.sparkbb.co.nz. [122.58.21.90])
        by smtp.gmail.com with ESMTPSA id bo10sm1504727pjb.36.2021.05.18.01.42.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 May 2021 01:42:37 -0700 (PDT)
Subject: Re: [PATCH 2/2] net-next: xsurf100: drop include of lib8390.c
To:     Arnd Bergmann <arnd@kernel.org>
References: <CAMuHMdVfjE=+YiqCrPfGObeYYkQwKGiQEWyprQr-n9z7J9-X-A@mail.gmail.com>
 <1528604559-972-3-git-send-email-schmitzmic@gmail.com>
 <CAK8P3a0pH0V_y-Ayt0rTNgZGR+Rm6tVRSzjCbo_vuA97c4shkA@mail.gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        kernel@mkarcher.dialup.fu-berlin.de
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <83400daa-d5a4-b39d-bd05-544a29065717@gmail.com>
Date:   Tue, 18 May 2021 20:42:30 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0pH0V_y-Ayt0rTNgZGR+Rm6tVRSzjCbo_vuA97c4shkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

Am 16.05.2021 um 21:52 schrieb Arnd Bergmann:
> On Sun, Jun 10, 2018 at 6:23 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>
>> Now that ax88796.c exports the ax_NS8390_reinit() symbol, we can
>> include 8390.h instead of lib8390.c, avoiding duplication of that
>> function and killing a few compile warnings in the bargain.
>>
>> Fixes: 861928f4e60e826c ("net-next: New ax88796 platform
>> driver for Amiga X-Surf 100 Zorro board (m68k)")
>>
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>> ---
>>  drivers/net/ethernet/8390/xsurf100.c |   11 +++++------
>>  1 files changed, 5 insertions(+), 6 deletions(-)
>
> Geert noticed that a patch I just sent is similar to this one. Since I assume
> you have verified this version works, it would be nice if you could resend
> both patches.

Oh dear - I had all but forgotten about this one. The patch announcement 
states it was tested on elgar so yes, this version works.

These patches originated in a review comment by Geert for the original 
xsurf100 driver that came after Dave had accepted the driver. Might even 
have been misrouted by me (I wasn't very clear whether net or net-next 
was appropriate). I evidently never followed up.

Which reminds me to check how far we ever got with testing the XSurf500 
driver that's still stuck in my tree.

> Alternatively, I can include them in my series if you like.

Please do that - I haven't followed net-next for over a year and don't 
have a current enough tree to rebase this on.

> Reviewed-by: Arnd Bergmann <arnd@arndb.de
>
>> diff --git a/drivers/net/ethernet/8390/xsurf100.c b/drivers/net/ethernet/8390/xsurf100.c
>> index e2c9638..1c3e8d1 100644
>> --- a/drivers/net/ethernet/8390/xsurf100.c
>> +++ b/drivers/net/ethernet/8390/xsurf100.c
>> @@ -22,8 +22,6 @@
>>  #define XS100_8390_DATA_WRITE32_BASE 0x0C80
>>  #define XS100_8390_DATA_AREA_SIZE 0x80
>>
>> -#define __NS8390_init ax_NS8390_init
>> -
>>  /* force unsigned long back to 'void __iomem *' */
>>  #define ax_convert_addr(_a) ((void __force __iomem *)(_a))
>>
>> @@ -42,10 +40,11 @@
>>  /* Ensure we have our RCR base value */
>>  #define AX88796_PLATFORM
>>
>> -static unsigned char version[] =
>> -               "ax88796.c: Copyright 2005,2007 Simtec Electronics\n";
>> +#define NS8390_CORE
>> +#include "8390.h"
>
> I don't see that #define being referenced anywhere, can that be dropped?

Can't find it used anywhere either, so I'm confident it can be dropped. 
While you're at it, I believe it can be dropped from lib8390.c as well 
now (that's where I copied it from). Dave would know for sure.

Cheers,

	Michael


>
>         Arnd
>
