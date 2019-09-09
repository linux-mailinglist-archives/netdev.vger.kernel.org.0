Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5050DAD96A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 14:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfIIMyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 08:54:43 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41923 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfIIMyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 08:54:43 -0400
Received: by mail-ot1-f67.google.com with SMTP id o101so12278513ota.8;
        Mon, 09 Sep 2019 05:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jjrn6A2RxaPHcdUZ2VFg5+GyJ8uTQrYjwa78yJcAKgM=;
        b=BqJ4tJMmhx+JRBdaAHyD0xwOXpFQSJ/rfHC3v1Ph2GubkCM2TqjEEvn4+iVNZ0BVmO
         oiUtA9MHWJcATU5F7/WHP0PRrOvyqhTuQC4w42M54L+pR7S0mO1X0M9dHI5hDeuuJPIq
         AMX7fG+XrTFxgN5/sDS3y6w32gRqg1cbQYQa4uVi80rWCnUKJ6OUvzezkQ7E9mmqCurU
         z8soPaiCSsxiLo16Bk5VUXGtJe0GhbRoxWFgajfXBD/58Nz1JajZLcIETdhK0auznyG0
         rslOj4ACKUtS2qbO4jalyBGSfW1WQ9MvMfFRzjgjv7zqwKFwGCy6oCYpWAOmNSTqro++
         bsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jjrn6A2RxaPHcdUZ2VFg5+GyJ8uTQrYjwa78yJcAKgM=;
        b=iH2xhOMVdA66IlJpQt5/mVbTX0Y1/snQ9t14hUkhhTQoW1z0MKS3JF4FFDQLaDXMwd
         3ksTJwEEg7xoUQd3CQGyNH1vAR5HQdTtiGDgRlDOJpxIbPFbD5fujLBnl8M+aIcs7q89
         NwX2wcAcSbpys1TlHAbr1OL6E021sJWvhyKgDBp32rWqslRetkM5U9TOERIDznRcYvJx
         mIziCFcm+OQhvGfiAle9GPjify/jNDfuCHQUsFJ22PNx2/vE8Rfeqs1l8sSnet/MKc4T
         /gCSVXrtc8fyyi3ZdV7GR90qqOA8yPNw65IwmsazzIdOVMuJKaWM9mMbNL1I4ANONElQ
         ACRg==
X-Gm-Message-State: APjAAAXLJLMJu6+KwV105cjgNVLSUEoEpn74eLnRJ1/UIZHC1VC8rjgP
        mdFftWVDdXoqVOV+wITVrHZ/BA0qrI9pFyMbkg==
X-Google-Smtp-Source: APXvYqww86Is8zR/qH0sjPSklEeCqNF/sD9xfIt5EcrvsRNEdbP2jR3g6/J6mteGvB8UgORtKyR2a992VOroDAGMH54=
X-Received: by 2002:a9d:21a6:: with SMTP id s35mr20276702otb.77.1568033682605;
 Mon, 09 Sep 2019 05:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190906213054.48908-1-george.mccollister@gmail.com>
 <20190906213054.48908-2-george.mccollister@gmail.com> <b1e98d5e-50b7-1f2f-6874-9515fcf2b540@denx.de>
In-Reply-To: <b1e98d5e-50b7-1f2f-6874-9515fcf2b540@denx.de>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 9 Sep 2019 07:54:31 -0500
Message-ID: <CAFSKS=PL2+M481jnm_Xi-6Z+nTBtAorCReP45D8H7mkQ97BuSQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: dsa: microchip: add KSZ9477 I2C driver
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 4:42 PM Marek Vasut <marex@denx.de> wrote:
>
> On 9/6/19 11:30 PM, George McCollister wrote:
>
> [...]
>
> > --- /dev/null
> > +++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
> > @@ -0,0 +1,100 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Microchip KSZ9477 series register access through I2C
> > + *
> > + * Copyright (C) 2018-2019 Microchip Technology Inc.
>
> Doesn't the copyright need update ?

I figured it wasn't necessary since you didn't update the copyright in
ksz9477_spi.c when you converted it to use regmap and made other
changes.
You're suggesting I add my copyright below this one, correct?

>
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/regmap.h>
> > +#include <linux/i2c.h>
>
> Please keep the headers sorted.

Ack. Moving linux/i2c.h before linux/kernel.h in v2.

>
> > +#include "ksz_common.h"
> > +
> > +KSZ_REGMAP_TABLE(ksz9477, not_used, 16, 0, 0);
> > +
>
> The rest looks good.
>
> [...]
>
> --
> Best regards,
> Marek Vasut
