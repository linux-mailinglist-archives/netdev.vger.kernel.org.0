Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F15746613A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356758AbhLBKNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:13:37 -0500
Received: from mail-ua1-f42.google.com ([209.85.222.42]:43823 "EHLO
        mail-ua1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346435AbhLBKNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 05:13:36 -0500
Received: by mail-ua1-f42.google.com with SMTP id j14so54616200uan.10;
        Thu, 02 Dec 2021 02:10:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gtt0K2kxZfiDKpqCoFE7opDwj75/HaGJjpOiQDC84E8=;
        b=Eg3XoukpsYvTDJMR5IAVA3IqsR+nO2o/N55taKBQWQlm5jPameR6krJjl5HlrKXPOm
         Ou6znlDItowY5kz31rIZqfcm/YMkUxNXZAif1VZXU4+4QoBpKfli3mKnwbo3a9IUqiZ6
         HqoEnkk2Mp3bqRRQLhLBnafE/TeFmnlaocWbjrIBFi/tK5rHzkuWRmslJHlcaRLntVoa
         J+iept8hraG+44HGoONZqqv0lqFSFByMWjVkYLAMKC4AYEwUuWlLEd/F7iOMAfW6dKNI
         h7FME+wo8mpgWdI+bUiS2YOe5bmK7nokIntdEDkISbbp8/7AV9JUDG0hNz1RcN0EqdI2
         KD1Q==
X-Gm-Message-State: AOAM532478ZbSgrbfvJvh+MPFf3PhdH8aY7aw+a/4+vxSXtQjPNBjk2D
        5upWh6Nne6NMELT5X2OTGLo3SxEo5dVGgA==
X-Google-Smtp-Source: ABdhPJwEbDYzatVtsi6D33Ax7LpckZF7DWK+xVdHNnB1u6jBh8f9nucDwq/UTeXNnqRyf/92GNpSZQ==
X-Received: by 2002:ab0:14a:: with SMTP id 68mr13784308uak.0.1638439813384;
        Thu, 02 Dec 2021 02:10:13 -0800 (PST)
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com. [209.85.221.173])
        by smtp.gmail.com with ESMTPSA id t11sm695666vkt.34.2021.12.02.02.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:10:13 -0800 (PST)
Received: by mail-vk1-f173.google.com with SMTP id 84so18050704vkc.6;
        Thu, 02 Dec 2021 02:10:13 -0800 (PST)
X-Received: by 2002:a05:6122:104f:: with SMTP id z15mr15150540vkn.39.1638439812926;
 Thu, 02 Dec 2021 02:10:12 -0800 (PST)
MIME-Version: 1.0
References: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
 <YagEai+VPAnjAq4X@robh.at.kernel.org>
In-Reply-To: <YagEai+VPAnjAq4X@robh.at.kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 2 Dec 2021 11:10:01 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
Message-ID: <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

CC Michal

On Thu, Dec 2, 2021 at 12:25 AM Rob Herring <robh@kernel.org> wrote:
> On Fri, Nov 26, 2021 at 12:57:00PM +0100, Geert Uytterhoeven wrote:
> > Convert the Cadence MACB/GEM Ethernet controller Device Tree binding
> > documentation to json-schema.
> >
> > Re-add "cdns,gem" (removed in commit a217d8711da5c87f ("dt-bindings:
> > Remove PicoXcell bindings")) as there are active users on non-PicoXcell
> > platforms.
> > Add missing "ether_clk" clock.
> > Add missing properties.
> >
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml

> > +  '#stream-id-cells':
> > +    const: 1
>
> I can't figure out why you have this here. I'll drop it while applying.

See arch/arm64/boot/dts/xilinx/zynqmp.dtsi and
drivers/iommu/arm/arm-smmu/arm-smmu.c.

It wasn't clear to me if this is still needed, or legacy. Michal?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
