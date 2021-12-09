Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BF546E192
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 05:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbhLIElv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 23:41:51 -0500
Received: from mail-vk1-f171.google.com ([209.85.221.171]:46957 "EHLO
        mail-vk1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLIElu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 23:41:50 -0500
Received: by mail-vk1-f171.google.com with SMTP id m16so2911082vkl.13;
        Wed, 08 Dec 2021 20:38:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1BrJIivy5ULsFEw3z8mK7xap0WSge261MqOp/JZDTo8=;
        b=A0wt1CMda7yMU5cxAC2VIA+LpjGjvpbvhbmVxlkg6F9kG6axwQP7ZFXUGihefp2wOt
         s5L/QfOK2uCpMqrGW/nKLaaDmNl8+iUf7n6DxH04H3Ftm1rTGpYgsmVeUxA4WJt+NPdU
         2y0QKNBvHLItg0b+uwMxcAIVhg4LAm2vbOCTjU6lVrP7u/BLU8rERqqaOMnKyUc381f4
         VwAJcGUME4rqQ5rnIOFPMWrctpNzw6RTgL/wa2mNLE+AMCHZ7YITn1ozucbWBnA32pDq
         Md9iN9necMmWa218DgwjBUz8Qo9GynJQMuhVPdEkYzdKwSdBYpAfohWYt6pXvrLqgSZn
         YCpg==
X-Gm-Message-State: AOAM533tb5VBW4+VAh3Nz22Rr6gAxYMGMbuM4iTRus7/tYyY4cypetFz
        9+pp4jqTUAMGzg9z0roXkkWTwxTWQEKfg1XgkZY=
X-Google-Smtp-Source: ABdhPJzSEdRFkQlrsU6LaBJXJV+aoGM05IKnp1wULRAtWmhxiPu+RBIET8ui3f40bJ3D15iquJlaXgHFN/RJYjnJ5Vw=
X-Received: by 2002:a1f:c193:: with SMTP id r141mr5251257vkf.27.1639024696997;
 Wed, 08 Dec 2021 20:38:16 -0800 (PST)
MIME-Version: 1.0
References: <104dcbfd22f95fc77de9fe15e8abd83869603ea5.1637927673.git.geert@linux-m68k.org>
 <YagEai+VPAnjAq4X@robh.at.kernel.org> <CAMuHMdW5Ng9225a6XK0VKd0kj=m8a1xr_oKeazQYxdpvn4Db=g@mail.gmail.com>
 <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
In-Reply-To: <CAL_JsqJHkL_Asqd5WPc7rfqXkbz1dpYfR0zxp5erVCyLiHaJNQ@mail.gmail.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Thu, 9 Dec 2021 10:08:06 +0530
Message-ID: <CAFcVEC++u1DxG+DNa+rpAQZ-LXtyFApiK3wgjZPDdU27Xp0ccg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: net: cdns,macb: Convert to json-schema
To:     Rob Herring <robh@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
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

Hi Rob, Geert,

On Mon, Dec 6, 2021 at 6:32 PM Rob Herring <robh@kernel.org> wrote:
>
> On Thu, Dec 2, 2021 at 4:10 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > Hi Rob,
> >
> > CC Michal
> >
<snip>
> >
> > It wasn't clear to me if this is still needed, or legacy. Michal?
>
> They should update to the iommu binding instead of the legacy smmu
> one. It's been around for years now.

Yes, this is a legacy entry and not used anymore. We'll plan to update our
devicetree.

Regards,
Harini
