Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960E535D305
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242505AbhDLWZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240565AbhDLWZV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 18:25:21 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4034C061574;
        Mon, 12 Apr 2021 15:25:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u21so22777052ejo.13;
        Mon, 12 Apr 2021 15:25:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1RenzXTJSBo+AimK/YzFpXcFAd3BU20qANVd3I3tddM=;
        b=NYEl8j8Ip4WVvi7Swjni1mrV2X0L2aqTmAHFigsQ7d646H+PzH9QMRFNx9AcgEE0iF
         +zrn5aIyZODs9KKxeO6PQS2YupTtekrWMetA80T3wB8d+gL+rqMf2wpggJXVuK5yiYyp
         6LQLRK2EO1F5sxU0PLe/Tk5VyEbT10AE2i+SshdD84hPU41uIaRgKyuMj6IcKo/+coWX
         4DwoqHH39DPj/d4NpUT6i9cnOtRYWVi7XixVTELTMwQbkk9EqZfLkb7PepeE8G3/FkIA
         a7pdNhQVmUFQ17XAdp3mJn5qaQE+ONWmLQu+P9DzAQcixkM6te048HA1Ubdy4GeUMtN9
         E2dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RenzXTJSBo+AimK/YzFpXcFAd3BU20qANVd3I3tddM=;
        b=CDR5XlVzEnAL+7WkSMlqBgcqIoQJ6eXdfKhY2u7os4Mg5pas29313RLec1IXExwfgF
         CrfABfhhIazVBA2jLYw1P9Kp/DSb4lXY9OiUJdGbXnG9b4VdaRGcm+R7FJLHC4QvrWxS
         MqypjW7ZbYmaeS4Q75RKoGPO7EtIs0iMk83v+61GMdGWzKTcUDg+eBBEiwXCrz8P68sA
         7Zqr9ylZNiyUBJ2k8gtzfmuKxRjHYgcEM+SxZftF+Q4k9KBERvwFXWlWGaMa97QYUmlU
         hJcW39C1MlSRK8+LqJnAohqv7V/04F9pWFd6/0W1japln71qpgwYUh1pJG+MZ4oAgM7t
         9HTQ==
X-Gm-Message-State: AOAM531AsCeSqghMQ9N77TQaCVM3DU/0Al7TD3Ty1oKObobuCdRSJNaC
        I6n7lfOAzGTjhLR3ljzQhZIfkf0vJbnyE+HVI4FBDgs4
X-Google-Smtp-Source: ABdhPJyDctgHJVW5ux47rGgKptehgsp1ixGGvq2ZTnuMjImKTK5yQmMgy4sLCHjZmYm5JfiAoo2/xKRiOMj7ibIPjig=
X-Received: by 2002:a17:907:e87:: with SMTP id ho7mr28555572ejc.2.1618266300608;
 Mon, 12 Apr 2021 15:25:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210411205511.417085-1-martin.blumenstingl@googlemail.com> <YHODYWgHQOuwoTf4@lunn.ch>
In-Reply-To: <YHODYWgHQOuwoTf4@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Tue, 13 Apr 2021 00:24:49 +0200
Message-ID: <CAFBinCD9TV3F_AEMwH8WvqH=g2vw+1YAwGBr4M9_mnNwVuhwBw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: lantiq_gswip: Add support for dumping
 the registers
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, olteanv@gmail.com,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Apr 12, 2021 at 1:16 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Apr 11, 2021 at 10:55:11PM +0200, Martin Blumenstingl wrote:
> > Add support for .get_regs_len and .get_regs so it is easier to find out
> > about the state of the ports on the GSWIP hardware. For this we
> > specifically add the GSWIP_MAC_PSTATp(port) and GSWIP_MDIO_STATp(port)
> > register #defines as these contain the current port status (as well as
> > the result of the auto polling mechanism). Other global and per-port
> > registers which are also considered useful are included as well.
>
> Although this is O.K, there has been a trend towards using devlink
> regions for this, and other register sets in the switch. Take a look
> at drivers/net/dsa/mv88e6xxx/devlink.c.
>
> There is a userspace tool for the mv88e6xxx devlink regions here:
>
> https://github.com/lunn/mv88e6xxx_dump
>
> and a few people have forked it and modified it for other DSA
> switches. At some point we might want to try to merge the forks back
> together so we have one tool to dump any switch.
actually I was wondering if there is some way to make the registers
"easier to read" in userspace.
It turns out there is :-)

Hauke, which approach do you recommend?:
- update this patch with your suggestion and ask Andrew to still merge
it soon-ish
- put this topic somewhere on my or your TODO-list and come up with a
devlink solution at some point in the future


Best regards,
Martin
