Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708D5478627
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233805AbhLQIZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:25:28 -0500
Received: from mail-ua1-f50.google.com ([209.85.222.50]:46797 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbhLQIZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:25:26 -0500
Received: by mail-ua1-f50.google.com with SMTP id 30so2856967uag.13
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 00:25:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FeNeSpzoC2WZTK2BKJPT9JpC4dqYF9I+seUoRuusiec=;
        b=cJ8WRJzCrR7tbmWjQ+r90OUGTHenmAoUw+7pJgHl2u4baWOfu9CN0ViCz24TjJHsER
         Ounnp1vGhH0hO9SfIMZznqhvt1OcRTfx6vU4RMnmeDDG5FL8pIlGpGoyzTwT+eHHZaAE
         dEuHUSOiheQ90CJdErzsm3jaALu9EVlwxGy2b/MDw2qyqNpV0idYxmH1SnIJbwAAGUg7
         A0RCeyenzTqiaQJXIRpMPMbLmK6LQuCXH0PLZuMaM3BdQHTw3jc4oHRvdPvHZ3peEBle
         lGTmD0noE1TUU8dQwgKS6a27OY2CcHjrt4b0WupK3ovUEDkimJxmnKaq2g/0BWgLuheG
         l5dg==
X-Gm-Message-State: AOAM5321nCECL6M2H3tD3+MVADUJbXng+Vt038CkI4Qz5Rqzd9y3NvG0
        GG05s5qtGg2hadN5YM7gpd4NXRpU36XlpINie2s=
X-Google-Smtp-Source: ABdhPJyaLati4Th/6Ty2otALOB5QtrgHn3tE4MGy4JavFFVkj8G8oRqXPNLQHgGPqoRFqd3p8QOZqaPrxBKgI5ewjSI=
X-Received: by 2002:a67:1985:: with SMTP id 127mr577594vsz.34.1639729525857;
 Fri, 17 Dec 2021 00:25:25 -0800 (PST)
MIME-Version: 1.0
References: <Ybs1cdM3KUTsq4Vx@shell.armlinux.org.uk> <E1mxqBh-00GWxo-51@rmk-PC.armlinux.org.uk>
 <20211216071513.6d1e0f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
In-Reply-To: <YbtxGLrXoR9oHRmM@shell.armlinux.org.uk>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Fri, 17 Dec 2021 13:55:14 +0530
Message-ID: <CAFcVECJeRwgjGsxtcGpMuA23nnmywsNkA2Yngk6aDK_JuVE3NQ@mail.gmail.com>
Subject: Re: [PATCH CFT net-next 1/2] net: axienet: convert to phylink_pcs
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Fri, Dec 17, 2021 at 5:26 AM Russell King (Oracle)
<linux@armlinux.org.uk> wrote:
>
> On Thu, Dec 16, 2021 at 07:15:13AM -0800, Jakub Kicinski wrote:
> > On Thu, 16 Dec 2021 12:48:45 +0000 Russell King (Oracle) wrote:
> > > Convert axienet to use the phylink_pcs layer, resulting in it no longer
> > > being a legacy driver.
> > >
> > > One oddity in this driver is that lp->switch_x_sgmii controls whether
> > > we support switching between SGMII and 1000baseX. However, when clear,
> > > this also blocks updating the 1000baseX advertisement, which it
> > > probably should not be doing. Nevertheless, this behaviour is preserved
> > > but a comment is added.
> > >
> > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> >
> > drivers/net/ethernet/xilinx/xilinx_axienet.h:479: warning: Function parameter or member 'pcs' not described in 'axienet_local'
>
> Fixed that and the sha1 issue you raised in patch 2. Since both are
> "documentation" issues, I won't send out replacement patches until
> I've heard they've been tested on hardware though.

Thanks for the patches.
Series looks good and we're testing at our end; will get back to you
early next week.

Regards,
Harini
