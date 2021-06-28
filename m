Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8C53B5A72
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 10:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbhF1I2p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 04:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbhF1I2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 04:28:44 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C1BC061574;
        Mon, 28 Jun 2021 01:26:19 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w13so18624733edc.0;
        Mon, 28 Jun 2021 01:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g4PI97rHtLeYK11OULP1ovkKwmxtW8szp+2tw0+tBZk=;
        b=B2xvAaoC92DlGfbVskv4mOCDwGR9dLnm3uCFjLxEUHeU/yXNbJsfB+WngqZF/1H/h+
         kNixc9QJT9lPzMpbmlaYvxYghOr7UspMjuweKa14UZZjVrwQg9LzA24qCFOKKf86TyMR
         dYUWoeM+NRtx92YJ4sVuBXo5oZv0RzQTktspfxmlkTH39dEE/o5AdTxQqU3Uz5mYsxYi
         7R4wjaFCleTDbEiLOFJdR8khrLfrRk6Hf2aCaBtCByVPttZyZqpIpC1CnJjReT9q2ban
         4iN3WiXqtUm2R9c0oosKzczwNs8xw/I+jQX2h0pgQ96schFdw5AREQAOtjDDZeD3xrdQ
         I0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g4PI97rHtLeYK11OULP1ovkKwmxtW8szp+2tw0+tBZk=;
        b=pmM78R39K+4iaUX1BJu/rgDHM+01knYw9nO9lGLtBwCk0w7RxICHovGzci10BkDQdZ
         XE5viTILNAKF9cxsPQuiAUrTiWkmNRCIyZBLAY8QXN8PpQdsQHG5yUtFebphlhe8SIPy
         ohQcvKy8UK64kA6Oi2LgeaHmTmyuZOoE6cEZd1S8GId7hDBysEpmXnygc2y4a9yH5ts0
         sr3hQOs3CPWS5BhVKDUA/hZYayEMPHz7owy6621yOfTfeq4sxDXa0Rju4xUB1HXrHK4I
         I3CyDXDXKq9etWdq4DGjju2x2LG68i1yITWgUYLezMs3NnIR7w1r4v/+j7qJMSPFidD6
         Rp5A==
X-Gm-Message-State: AOAM531+Av99AfdX5XGHBVYeeUhJN/QwLRZqpSW+0UOJ0bjOx29vxUm4
        qPlY7vtDQns1gPxPNi1cnql/4Zk2v2lfcqKyoW0=
X-Google-Smtp-Source: ABdhPJxMEm5q3bs9V/gHqSa0A49eOh8fZ2OX2anTdiNFmvPt/+Bb8MYxEEca9MVTSifC7/W/PPn+3xORMMLZGdGO8bY=
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr31073516edd.71.1624868777683;
 Mon, 28 Jun 2021 01:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
 <ab25bd143589d3c1894cdb3189670efa62ed1440.1616368101.git.cristian.ciocaltea@gmail.com>
 <17876c6e-4688-59e6-216f-445f91a8b884@gmail.com> <20210322084420.GA1503756@BV030612LT>
In-Reply-To: <20210322084420.GA1503756@BV030612LT>
From:   Amit Tomer <amittomer25@gmail.com>
Date:   Mon, 28 Jun 2021 13:55:40 +0530
Message-ID: <CABHD4K_r_ixtBXH_v82S62onYr-=fbh8cHJsdz0oo6MN-i5tVg@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] net: ethernet: actions: Add Actions Semi Owl
 Ethernet MAC driver
To:     Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > Do you know the story behind this Ethernet controller?
>
> I just happened to get a board based on the S500 SoC, so I took this
> opportunity to help improving the mainline kernel support, but other
> than that I do not really know much about the hardware history.
>
> > The various
> > receive/transmit descriptor definitions are 99% those defined in
> > drivers/net/ethernet/stmmicro/stmmac/descs.h for the normal descriptor.
>
> That's an interesting observation. I could only assume the vendor did
> not want to reinvent the wheel here, but I cannot say if this is a
> common design scheme or is something specific to STMicroelectronics
> only.

I am not entirely sure about it but it looks like it *may* only need
to have a glue driver to
connect to DWMAC.
For instance, on the U-boot[1] side (S700 is one of 64bit OWL SoC from
actions), we kind of re-uses already
existing DWMAC and provide a glue code, and on the Linux side as well
have some similar implementation (locally).

Thanks
-Amit.

[1]: https://source.denx.de/u-boot/u-boot/-/blob/master/drivers/net/dwmac_s700.c
