Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DEE29039
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 06:57:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbfEXE5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 00:57:11 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34299 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfEXE5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 00:57:11 -0400
Received: by mail-lf1-f68.google.com with SMTP id v18so6066387lfi.1
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 21:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+qCr2MdO19dY/8onl90bo6ep9ea9k6Z+aDecmV1lDU=;
        b=NJeg0VK+SWxhX3lS74jS+A9OVcoe/UK1VhVitVIHaQDI/w8aKHpyEeAUqNJtX5YVL+
         N4Bp7sCjMU+Zm2+0EbHO5aOHag9ssQl0W3Wr5VuvaJgnbLEAnKiBjGy222kI85wRHCmQ
         zFOtk7hZFD5U+deEEv6F6RO49WvqPKidKACPt1wuixwcT64OwvFGEP9oiYWEKnRHHdJg
         /z/UDgaWFDz7+bhzzUQlOn7Ar+j/L3ymuoZ8yPTG7yJ0GVRGCKrafrBl0nmYfbjXmQy5
         bLI40Kyo6L92zfxeNiuJEV34T7De+BjuBUwdBpqwzGwlRZxlH0135f3JQCzLOgo3CZf+
         M+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+qCr2MdO19dY/8onl90bo6ep9ea9k6Z+aDecmV1lDU=;
        b=Lry0hdcFn9DdnkfsmdUv58noH8ahD8S1svYRo6UXBPUlP/WidDkjH0eMNJeCuPYHYG
         Qi6uL7xn9g38AxxpmeBI257YL/FkA9vv2FHC3E6MurLf7uklJUnxsK9LdKwMwH9Ah+3p
         KhoC06HSnu+3PuDkeuthnZ6w7f5o/whyJnEVv3uEk4KiS2W04cts0nKwAOVZXhlH+Vvv
         q5OJb9DLLFNtgPHi4KrnSHILiS893jURsMiEbUEdU7noYn7SAPnEqAzvhHMy68Qfq+1e
         RgJ/domATpZNMlXPZvS3M9de5zVvI3YSHQ1H0JtcgWYDGZItTCDZu6FcC1WJClxpQBFD
         ip3w==
X-Gm-Message-State: APjAAAWvbsZyF9gkQmw50cc81hZxTZJKE/CDvXJiyJQ7q9+yk1LM04dv
        1ZAOBlHU+jXqzsd+OlwX0zPIxgX5xxmmjSfep6c0Dw==
X-Google-Smtp-Source: APXvYqwRkhSZNZodU87MNix/BTrEDGt12SfhEiNeQb7LL1hUJoV2OadkJavkiG2qnAzTw1tidLRoSrRs3E9/C+Q5K9Q=
X-Received: by 2002:ac2:4a6e:: with SMTP id q14mr12821755lfp.46.1558673829099;
 Thu, 23 May 2019 21:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <1558611952-13295-2-git-send-email-yash.shah@sifive.com> <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
In-Reply-To: <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
From:   Yash Shah <yash.shah@sifive.com>
Date:   Fri, 24 May 2019 10:26:32 +0530
Message-ID: <CAJ2_jOEErFdK=n7Brk5A_950vfikdFcxcRri4HXgJWqf0-zR=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000 binding
To:     Rob Herring <robh+dt@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        =?UTF-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sachin Ghadi <sachin.ghadi@sifive.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 2:20 AM Rob Herring <robh+dt@kernel.org> wrote:
>
> On Thu, May 23, 2019 at 6:46 AM Yash Shah <yash.shah@sifive.com> wrote:
> >
> > Add the compatibility string documentation for SiFive FU540-C0000
> > interface.
> > On the FU540, this driver also needs to read and write registers in a
> > management IP block that monitors or drives boundary signals for the
> > GEMGXL IP block that are not directly mapped to GEMGXL registers.
> > Therefore, add additional range to "reg" property for SiFive GEMGXL
> > management IP registers.
> >
> > Signed-off-by: Yash Shah <yash.shah@sifive.com>
> > ---
> >  Documentation/devicetree/bindings/net/macb.txt | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> > index 9c5e944..91a2a66 100644
> > --- a/Documentation/devicetree/bindings/net/macb.txt
> > +++ b/Documentation/devicetree/bindings/net/macb.txt
> > @@ -4,6 +4,7 @@ Required properties:
> >  - compatible: Should be "cdns,[<chip>-]{macb|gem}"
> >    Use "cdns,at91rm9200-emac" Atmel at91rm9200 SoC.
> >    Use "cdns,at91sam9260-macb" for Atmel at91sam9 SoCs.
> > +  Use "cdns,fu540-macb" for SiFive FU540-C000 SoC.
>
> This pattern that Atmel started isn't really correct. The vendor
> prefix here should be sifive. 'cdns' would be appropriate for a
> fallback.

Ok sure. WIll change it to "sifive,fu540-macb"

Thanks for your comment.
- Yash
