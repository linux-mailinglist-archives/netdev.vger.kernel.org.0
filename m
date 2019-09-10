Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7622BAED49
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 16:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbfIJOkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 10:40:45 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43001 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfIJOkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 10:40:45 -0400
Received: by mail-ot1-f67.google.com with SMTP id c10so19043828otd.9;
        Tue, 10 Sep 2019 07:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/ieZnycxFN+JerYiY3rxoFtjLzkHguz7iRH/hDZcmIw=;
        b=d9agNx71wVkpHR2XTIIiwTL0XH2EGudfPc7dYtC1KajHCIqFTXUVoYq1bMB3s4rntp
         i0LCeyM+gEtprb+7CQJEMcJs2U5EGJPotnQ5fxb12skLyXd7NWJYX/HNOwZy1/TohFeK
         vBmJRtCgB9dmMLVVavsIZBAr7DoB7hn6uH+eR++EtyctbPQZ3A2EHeRu71gfbszWswDC
         JtRNdoAzFAJgHM79H7pyblqejEHy3V3bP5JuQt9IE66iP2xABt5GaML+442VeF9mg6FQ
         P4YwPxQuDiFloO0+UJG1g7kzYcRsg6fx65SJ2BsppR7/580JiCYIVmI2uTS3yRFapIZV
         AdQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/ieZnycxFN+JerYiY3rxoFtjLzkHguz7iRH/hDZcmIw=;
        b=ds+xfTl3Va3jhfnt+yFDiEDrkSt6sduVIuX71pw2772zA+MRGQhGTpIno1cvC3nFA+
         TsITuFxiI5UHQprhw60CvzZD+5xSZxyPDjmLmswl/Vy91SUJlTMUCluXfn+YDkoDDqKL
         C6EAB7t1i1YQ2zqmeGLylgl+Rk8rTjEZDy9BseLGypqWs4WtqfQQulDPAeoOhMa9Spdb
         22BuAJDtAxs8aG8qHI1kymHOfkG+3XtuuKBbwPPMGiLupv52jLuRAzK/KZM9//vYwh8M
         1d5H/OE2G1XClMZS5PkjOv4Q8o3XA1oV8uzA5UNZkbP0RhEN7b4C9mN0tdV7CitjK/Bv
         mKpw==
X-Gm-Message-State: APjAAAVuLWgS7zvbk5msLfWIfW5Uzgq6M+lN8Bi8Slwm5SK6HISzVV6X
        8AzAHxNl6D6zz2MDiSSQ9jRZTPtRo6lguooO+w==
X-Google-Smtp-Source: APXvYqzkLM0vlrL0Fi3NtmzLQzUZlEbzuQcjjOXQEGD286xMohRCfpSOgOJKC3SNtRcwSNPzq/3jeBi8bsajctzPCns=
X-Received: by 2002:a05:6830:10c5:: with SMTP id z5mr7849959oto.366.1568126444139;
 Tue, 10 Sep 2019 07:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190910131836.114058-1-george.mccollister@gmail.com>
 <20190910131836.114058-2-george.mccollister@gmail.com> <20190910140304.GA4683@lunn.ch>
In-Reply-To: <20190910140304.GA4683@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 10 Sep 2019 09:40:32 -0500
Message-ID: <CAFSKS=O9nDMk-ytxkFhTuZNT-QDmJ_twDdk2o2u0R4Y_YZ0z8A@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] net: dsa: microchip: add KSZ9477 I2C driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew,

On Tue, Sep 10, 2019 at 9:03 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi George
>
> > +KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
> > +
> > @@ -294,6 +294,8 @@ static inline void ksz_pwrite32(struct ksz_device *dev, int port, int offset,
> >  #define KSZ_SPI_OP_RD                3
> >  #define KSZ_SPI_OP_WR                2
> >
> > +#define swabnot_used(x)              0
>
> > +
> >  #define KSZ_SPI_OP_FLAG_MASK(opcode, swp, regbits, regpad)           \
> >       swab##swp((opcode) << ((regbits) + (regpad)))
>
> There seems to be quite a lot of macro magic here which is not
> obvious. Can this be simplified or made more obvious?

I thought about this for quite some time. To reduce the "macro magic"
the SPI specific parts will need to be removed from the common macro
and arguments for read_flag_mask and write_flag_mask would need to be
added to both KSZ_REGMAP_TABLE and KSZ_REGMAP_TABLE. That would leave
us with two macros that have 7 arguments. Not really an improvement
IMHO. Alternatively we could have different macros for SPI and I2C (or
not use the macros at all and define the i2c regmaps in ksz9477_i2c.c)
at the cost of ~20 lines of duplication. I prefer the "macro magic"
approach, however if you won't let the patch through the way it is
I'll respect your decision, just let me know which of the three
proposed approaches you want to go with.

>
>          Andrew

Cheers,
George
