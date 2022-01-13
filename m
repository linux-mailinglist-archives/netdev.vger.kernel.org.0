Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D5148DD11
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbiAMRoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:44:05 -0500
Received: from mail-ua1-f41.google.com ([209.85.222.41]:33442 "EHLO
        mail-ua1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiAMRoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:44:04 -0500
Received: by mail-ua1-f41.google.com with SMTP id u6so12709057uaq.0;
        Thu, 13 Jan 2022 09:44:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ORKMunvRFTinL6Ez6yQ6x47XYXMKW+GNe6tXXjsqkmw=;
        b=Z8PtEeRj1O5hGJb0T/L/u+NVH/L8FjWot30F2db64Xag6sz8STwiYh4dNdraVY1L7g
         pnB+whzJAJVZ9bznMPZj9eoY+HJ46vdnCbledx7r/mz5u22PxaLc2/Cb0aZw3VKDoxvg
         ab6lO5RO4e5VSfOpW/XomGmhLZGk1pmvsbCOqkOhLRHVEjLKl9gbjkvTmt5fMtj6d6Hf
         AddIfwRIL2A1hHC1b1PmHU3XTZQQkfJVI1b2IEx3WtBrWsZKzqnF6yO+hZqarHrddrXu
         V8rrhwRHrjM/q9CnUW5S1/DwYWSQzvJmdgiJQ3/XQHTRFcBEygTEynf3TFHdJQgYcXle
         vffg==
X-Gm-Message-State: AOAM5324OejFvpWMvXan95qK24GNqyUF7fBuAM1fk3Pfl636hJAMSaft
        HPrLnI9po6yWTxf00aqDQsfG89OriEwhdg==
X-Google-Smtp-Source: ABdhPJwl7YafDoNFkUqoNsE9U58xOfEiHc/UfwMaWiobf9wjNQuV4X3jPcyMChlN8ouf1PQ1gkaabg==
X-Received: by 2002:ab0:447:: with SMTP id 65mr2801185uav.129.1642095843773;
        Thu, 13 Jan 2022 09:44:03 -0800 (PST)
Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com. [209.85.221.177])
        by smtp.gmail.com with ESMTPSA id y8sm2098353vsj.12.2022.01.13.09.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 09:44:03 -0800 (PST)
Received: by mail-vk1-f177.google.com with SMTP id v192so1321019vkv.4;
        Thu, 13 Jan 2022 09:44:02 -0800 (PST)
X-Received: by 2002:a1f:2344:: with SMTP id j65mr2729354vkj.7.1642095842588;
 Thu, 13 Jan 2022 09:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20220112181113.875567-1-robert.hancock@calian.com>
 <20220112181113.875567-2-robert.hancock@calian.com> <d5952271-a90f-4794-0087-9781d2258e17@xilinx.com>
 <b8612073ebd24e4bf9f4e729bd5ea7c4678494e2.camel@calian.com>
In-Reply-To: <b8612073ebd24e4bf9f4e729bd5ea7c4678494e2.camel@calian.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 13 Jan 2022 18:43:51 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUyBF5XkoVVK9zrWf6f7cP+jEBC-dW_APfw_a=upqpDhQ@mail.gmail.com>
Message-ID: <CAMuHMdUyBF5XkoVVK9zrWf6f7cP+jEBC-dW_APfw_a=upqpDhQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] macb: bindings doc: added generic PHY and
 reset mappings for ZynqMP
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert,

On Thu, Jan 13, 2022 at 5:34 PM Robert Hancock
<robert.hancock@calian.com> wrote:
> On Thu, 2022-01-13 at 08:25 +0100, Michal Simek wrote:
> > On 1/12/22 19:11, Robert Hancock wrote:
> > > Updated macb DT binding documentation to reflect the phy-names, phys,
> > > resets, reset-names properties which are now used with ZynqMP GEM
> > > devices, and added a ZynqMP-specific DT example.
> > >
> > > Signed-off-by: Robert Hancock <robert.hancock@calian.com>

> > > --- a/Documentation/devicetree/bindings/net/macb.txt
> > > +++ b/Documentation/devicetree/bindings/net/macb.txt

> > Geert already converted this file to yaml that's why you should target this
> > version.
>
> Is that version in a tree somewhere that can be patched against?

It has just entered upstream, and will be part of v5.17-rc1:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4e5b6de1f46d0ea0

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
