Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26ABE4337B6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235966AbhJSNub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:50:31 -0400
Received: from mail-ua1-f46.google.com ([209.85.222.46]:37403 "EHLO
        mail-ua1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235929AbhJSNua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:50:30 -0400
Received: by mail-ua1-f46.google.com with SMTP id f4so3514598uad.4;
        Tue, 19 Oct 2021 06:48:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcDzEu/olBUewc2zfLP9L5lSacn9aVLegk1TrgMXQas=;
        b=Jzmhf3cw/KshIRz8/xBpAv46b3d7uYEbmVLuJ+p/+8pDnEMzCntEHDTxFynCSvjMbL
         fCSw9YyizoQQQ+4O/3Lfwl/KEh+pwmQU2M2ffoSPtt7MiGP1fMJqa6ms18wGKYFS+3Br
         aT6MrLpoPQSyOPU8Nn59tQkMYk3FFJC+3DtD8MiRdqqxgf19jE1vS9DEW/6yWXlMiqgv
         Qgv2qr2DUDKY3/AyJZhrtlvjGX2XbYHFVgcfZ9W6V3NFEiUKF3pbSRI95ymPBw0DjbS8
         AfXDyPda85ZFNlpeEsPPNn+F/kdNFVCX0IvseSkOWxXLsO6YcZqusmHsvF/fxCa37J6+
         RjUw==
X-Gm-Message-State: AOAM530iZg/yAw6QsSbAoFwBjtPXsrev9IrxSZcmjI51FbyyHFo+EVs5
        +gKUrH6oB9df1i5MI7VztqtyJZjU6OhcJw==
X-Google-Smtp-Source: ABdhPJwep983ZzJlXgVZ2iEEdJAq2O28V2X8VNam5AcKFVqSYD+Nd8ojG3/RZJuDE2SSsGdKHTwEqQ==
X-Received: by 2002:a67:ac42:: with SMTP id n2mr35580262vsh.21.1634651296314;
        Tue, 19 Oct 2021 06:48:16 -0700 (PDT)
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com. [209.85.221.175])
        by smtp.gmail.com with ESMTPSA id b24sm10798780uaq.16.2021.10.19.06.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 06:48:15 -0700 (PDT)
Received: by mail-vk1-f175.google.com with SMTP id bc10so3428305vkb.1;
        Tue, 19 Oct 2021 06:48:15 -0700 (PDT)
X-Received: by 2002:a1f:1604:: with SMTP id 4mr32111362vkw.11.1634651295119;
 Tue, 19 Oct 2021 06:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1634646975.git.geert+renesas@glider.be> <87a6j5gmvg.fsf@codeaurora.org>
In-Reply-To: <87a6j5gmvg.fsf@codeaurora.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 19 Oct 2021 15:48:03 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWEwsK=jUt=T8irpAdjocLtAjajBCacGHnu4fKKio6ZbA@mail.gmail.com>
Message-ID: <CAMuHMdWEwsK=jUt=T8irpAdjocLtAjajBCacGHnu4fKKio6ZbA@mail.gmail.com>
Subject: Re: [PATCH 0/3] dt-bindings: net: TI wlcore json schema conversion
 and fix
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        Sebastian Reichel <sre@kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kalle,

On Tue, Oct 19, 2021 at 3:33 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> Geert Uytterhoeven <geert+renesas@glider.be> writes:
> > This patch series converts the Device Tree bindings for the Texas
> > Instruments Wilink Wireless LAN and Bluetooth Controllers to
> > json-schema, after fixing an issue in a Device Tree source file.
> >
> > Thanks for your comments!
> >
> > Geert Uytterhoeven (3):
> >   ARM: dts: motorola-mapphone: Drop second ti,wlcore compatible value
> >   dt-bindings: net: wireless: ti,wlcore: Convert to json-schema
> >   dt-bindings: net: ti,bluetooth: Convert to json-schema
> >
> >  .../devicetree/bindings/net/ti,bluetooth.yaml |  91 ++++++++++++
> >  .../devicetree/bindings/net/ti-bluetooth.txt  |  60 --------
> >  .../bindings/net/wireless/ti,wlcore,spi.txt   |  57 --------
> >  .../bindings/net/wireless/ti,wlcore.txt       |  45 ------
> >  .../bindings/net/wireless/ti,wlcore.yaml      | 134 ++++++++++++++++++
> >  .../boot/dts/motorola-mapphone-common.dtsi    |   2 +-
> >  arch/arm/boot/dts/omap3-gta04a5.dts           |   2 +-
> >  7 files changed, 227 insertions(+), 164 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/net/ti,bluetooth.yaml
> >  delete mode 100644 Documentation/devicetree/bindings/net/ti-bluetooth.txt
> >  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
> >  delete mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.txt
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore.yaml
>
> Via which tree should these go?

The DTS change should go through the OMAP tree.
The binding changes through the net or DT trees.

I kept everything together for an improved overview.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
