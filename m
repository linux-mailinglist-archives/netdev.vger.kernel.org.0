Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941681DEED0
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgEVSDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730674AbgEVSDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:03:02 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B881C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 11:03:01 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id o14so13767190ljp.4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 11:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ml7THgxorDYQib7DNZk9FOL557ltFBJZwgBDu/FX7ek=;
        b=utZG2z7QWctXEl2uBsqebsPA3zfffsfGw4WhJkgCfkJRUu4WysBlQsd6TntjTNBHx3
         RK+Zo29s0/c/ZnqtVGJmqNrHdhn5QXlsUYSOgATtrw3P2A66BjaIC+EweLSi7Qf5OCdJ
         GX8CThuo8VGKZoQ/S8llIsLBcbjEKIsCgS6FyXI6J0vWlGQhppYjrZB43nktZeDTbVz+
         /cBkJZMpRhQqvN/MMVYP0tUSHik5oh/twKJuMwFF3g8/XgBtVJmm53yVGqLhMUari5La
         ai3jkm32UuKZl7k2x6PS7wxJVctBUAZtXtFQuKDBlBvU7NRBH3dGFG9H7s0NtFQlqBzI
         J3gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ml7THgxorDYQib7DNZk9FOL557ltFBJZwgBDu/FX7ek=;
        b=Y2hjWWJR+NgTtuanLCLgck2XF/AqfzKqZtJEXJ1FYl527hDAopE3H1/ug+iOQTrTBy
         el5lhyAr+8qJYjHpoU4Qd3W39HqMv99ceKagUuQ+EbvEpS251DnWQ2vHysWyYX2qboF6
         i2f6Nb6W1gdvDOHimFC0oW/Ad3fLE65fIsUXVjzZlAT6DJ0RlLqfS0w0S9I/6nywggTR
         hwJCP6HJXSmABrOWdnaAEqawr6TCyUWbM+m2leCyBvgX07/IjgNpe6/Cen8eMafRxg25
         uOZ6EJhavd0k3rbCQQ8l1Cmx8kWMDZ2fJXb5r5BmvIA9eyUun2N8O3iy4Aw58mWN+u8H
         VcwQ==
X-Gm-Message-State: AOAM533QafRKz2YMxdJF8wpc9Ly/xFHAfhH+ebGppXOW+jV95BQyNr/4
        lQQg1Y1/T9zaJHcPxXupfmkbwuTxzECoPJynbCHb1Eumlfc=
X-Google-Smtp-Source: ABdhPJzs5UnC3g+qyhn2Pqztia3rsTY7EBXN83mCWsVde6vm6uyh7VAkm66rYkFtvsi6TWc5cLnEDYqxX/6C5QKjPdg=
X-Received: by 2002:a2e:1f02:: with SMTP id f2mr7760495ljf.156.1590170579919;
 Fri, 22 May 2020 11:02:59 -0700 (PDT)
MIME-Version: 1.0
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com> <20200520170322.GJ652285@lunn.ch>
 <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <20200521130700.GC657910@lunn.ch> <AM6PR0402MB360728F404F966B9EF404697FFB40@AM6PR0402MB3607.eurprd04.prod.outlook.com>
In-Reply-To: <AM6PR0402MB360728F404F966B9EF404697FFB40@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Fri, 22 May 2020 20:02:49 +0200
Message-ID: <CANh8QzwxfnQ1cACz=6dhYujEVtQoTCw8kTgkHi9BnxESptL=xQ@mail.gmail.com>
Subject: Re: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property
 to match new format
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy,

On Fri, 22 May 2020, 03:01 Andy Duan, <fugang.duan@nxp.com> wrote:
>
> Andrew, many customers require the wol feature, NXP NPI release always support
> the wol feature to match customers requirement.
>
> And some customers' board only design one ethernet instance based on imx6sx/imx7d/
> Imx8 serial, but which instance we never know, maybe enet1, maybe enet2. So we should
> supply different values for gpr.
>
> So, it is very necessary to support wol feature for multiple instances.
>

Yes, I don't think anyone is saying otherwise.

The problem is just that there are already .dtsi files for i.MX chips
having multiple ethernet interfaces
in the mainline kernel (at least imx6ui.dtsi, imx6sx.dts, imx7d.dtsi)
but that this patch series does not
modify those files to use the new DT format.

It currently only modifies the dts files that are already supported by
hardcoded values in the driver.

As to not knowing which instance it shouldn't matter.
The base dtsi can declare both/all ethernet interfaces with the
appropriate GPR bits.
Both set to status = "disabled".

Then the board specific dts file sets status="okay" and activates wol
by adding "
"fsl,magic-packet" if the hardaware supports it
(because that depends on things beyond the SoC, like how the ethernet
PHY is clocked and powered.)

Martin
