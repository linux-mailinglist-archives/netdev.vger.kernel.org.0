Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811AB3D3B44
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhGWMz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhGWMz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 08:55:27 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A012CC061575;
        Fri, 23 Jul 2021 06:35:59 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id hp25so3565730ejc.11;
        Fri, 23 Jul 2021 06:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=syQdpBaTHu3uZXlH1OVRUA7Md0MxaCJtCpKEccQDxYU=;
        b=huxKMkt0pXXNh5W/94n8CXFbDb7BVJT05xDQ3kMIqeqJzgh+ugjnRjyXli0YWyYgDn
         Hdxj+5BexGIoqPGN4yrJ/V6waa4oC7YpEj8zyF+frkDZOszrH5s9tIfW/T8z7azOzCox
         XGy/sf7+Hb1BGFkxf343bYDJPBu2IaE0oG0j9bQJXm9Em/zr5ofm7B/rReBlgeJ7rhEN
         qHHxRDXpq3oT0H0xygbSQfP+ESyqDOM+7YLNFKIu+nLmLVF4PtpHTEcFz5A41iSKR8By
         RTYtFEBVx+Hmaj4DtDcJ7m5ryFnMEW43JPEkjT3JebanLhWEj5coUsMHXQEMzWl/gHw7
         Adrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=syQdpBaTHu3uZXlH1OVRUA7Md0MxaCJtCpKEccQDxYU=;
        b=reblioVDRNOtRjD/3enfiHA7ErJKMv4o4RsFl5zYDgfGKM49Y59B3lFTroUNLiCskj
         g4DoxJJHiz7HwguzRXi5+9pI8O5m6KO8dmK09gahk5V1KwjMCwjh4peV5k4Gdxsb8LNW
         WOXVapmC2p/YoVTMjoapU3uEuF4YUS49ICULE6sH3aBCtReEHJjq5/zRrwTPiOGZPDk3
         4QBrB70LsFWSHWiC1rDh0T8xSJHvoF7MQhHVMDEsNOFaEyHcNprBwSBt8ID2f0l9aA4R
         STawRXJwlLXzUOTxpVVwO8gBIqRaq219Vcpt/tvMe6PkGzB2CHgIw0LZLs8O5ug5ca/3
         qoSw==
X-Gm-Message-State: AOAM530IH0s5wlQNVhZbWNPPltc08ocpfn8vRV/IzsSgzugiqksFKaiu
        TvjuKhAEHpZvx5wR1WsedP0=
X-Google-Smtp-Source: ABdhPJwb3SBZhK1DPpsdXTPaCI0y0ohVwIroXkDpCWGROEDXHXeJgWea5S0x+piJIduQ49VuPoiSGQ==
X-Received: by 2002:a17:906:180a:: with SMTP id v10mr4602237eje.112.1627047358195;
        Fri, 23 Jul 2021 06:35:58 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id v16sm13478381edc.52.2021.07.23.06.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 06:35:57 -0700 (PDT)
Date:   Fri, 23 Jul 2021 16:35:56 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next] ARM: dts: imx6qdl: Remove unnecessary mdio
 #address-cells/#size-cells
Message-ID: <20210723133556.xnhhxdkvassykavn@skbuf>
References: <20210723112835.31743-1-festevam@gmail.com>
 <20210723130851.6tfl4ijl7hkqzchm@skbuf>
 <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BRt6M=4WrZMWQjYeDcOXMSFhcfjZ95tdUkst5Jm=yB6A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 10:15:52AM -0300, Fabio Estevam wrote:
> Hi Vladimr,
> 
> On Fri, Jul 23, 2021 at 10:08 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > Are you actually sure this is the correct fix? If I look at mdio.yaml, I
> > think it is pretty clear that the "ethernet-phy" subnode of the MDIO
> > controller must have an "@[0-9a-f]+$" pattern, and a "reg" property. If
> > it did, then it wouldn't warn about #address-cells.
> 
> Thanks for reviewing it.
> 
> After double-checking I realize that the correct fix would be to pass
> the phy address, like:
> 
> phy: ethernet-phy@1 {
> reg = <1>;
> 
> Since the Ethernet PHY address is design dependant, I can not make the
> fix myself.
> 
> I will try to ping the board maintainers for passing the correct phy address.
> 
> Thanks

Normally you should have been able to make all PHY addresses be 0. That
is the MDIO "broadcast address" and if there's a single PHY on the bus,
it should respond to that.

Citation:

IEEE 802.3-2015:

22.2.4.5.5 PHYAD (PHY Address)

The PHY Address is five bits, allowing 32 unique PHY addresses. The first PHY address bit transmitted and
received is the MSB of the address. A PHY that is connected to the station management entity via the
mechanical interface defined in 22.6 shall always respond to transactions addressed to PHY Address zero
<00000>. A station management entity that is attached to multiple PHYs must have prior knowledge of the
appropriate PHY Address for each PHY.

However, if you google "MDIO broadcast address", you'll find all sorts
of funny reports of buggy PHYs not adhering to that clause, under all
sorts of pretexts...
