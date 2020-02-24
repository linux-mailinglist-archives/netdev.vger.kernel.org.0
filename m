Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36A316A586
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 12:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgBXLxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 06:53:09 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40554 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgBXLxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 06:53:08 -0500
Received: by mail-ed1-f67.google.com with SMTP id p3so11556957edx.7;
        Mon, 24 Feb 2020 03:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nyV3Tq0pbVzV0gOMvCwpDS2Frt9VsoTq/4jG3RQtfPQ=;
        b=Yf0kUD+Jf23zw3msaO/I5H1ErHEq9z9/So6oCcVT+LyB2NCVoDn5jQxCu2h1HPgEqu
         uxDqZN4ifX12CEFAYEPonXwHrzi+7Pys9cplcPUl7rUWaqMFgddugEcX1miUpnhE1Epu
         UcpmnwYE0s58jMQoi8QblEyO1ECx6LScGvKTj15SVBc9dJnNMJGeCfbNQ002fwUHIMa3
         C0YOE+x2yPdA7ATwJ29mRh5rfCVd4K8rEALFaCM6UgaSleHf8PFDKJ+g+o+8oaWq2ISg
         OkuYMfWOcDmFP6JCjlJz8F10upx6WmkUwDD3og5mY7bv+qrr7hrMyIfO0KFEF70kq00q
         ElFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nyV3Tq0pbVzV0gOMvCwpDS2Frt9VsoTq/4jG3RQtfPQ=;
        b=fWbOrUmcfkMiol2WbJEZXLWn1nhJMOOk+PAmCCGU8KqbXGDN+tRG0qbCFRPcZmC09H
         A04d+WgMKisHvDWECP/WQV0AObT3l4fqDzjMRiDAZLxeh2yf3DN2Wntjf0+9coBfJNMp
         Bqmsoytjiu5p7//9VdqotaCJHiX8kkcAAAnqB7gGxap3VCshdRSWmmsFQpywZp/miECm
         ypxmpn3DNGvOKLujjz5S8UkTqfq6GcuwPtRmg9lNmB88MM3PzdWsZRz7EPiVzP5h4Nk6
         Od/l3fXZKmzxoeoa1ofqT6UQCq1l3lJP7VQkCYNFFN9T0xnihWKOX4tV0FeK2wXcavud
         19ng==
X-Gm-Message-State: APjAAAUYmIomvHUZ+eQ7IvCpBCBOjOkQX/Fw9aEj0y2osJ2bpWO+2VtM
        S5AWF83Ud/AdD/cBMQoaA9bEZP+/DdMgn99udwo=
X-Google-Smtp-Source: APXvYqwfEc6CcVi5zjK3yPIzHvFMK/TsN3Eb5YXaRVfL+xDHIBwYeS7232DrblT4/eUf1bN238+W+21rz4w1S8ZUctw=
X-Received: by 2002:a05:6402:3046:: with SMTP id bu6mr46559357edb.139.1582545187071;
 Mon, 24 Feb 2020 03:53:07 -0800 (PST)
MIME-Version: 1.0
References: <20200223204716.26170-1-olteanv@gmail.com> <20200224112026.GF27688@dragon>
 <f92f01d60589d94bb25a38dd828200b0@walle.cc>
In-Reply-To: <f92f01d60589d94bb25a38dd828200b0@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 24 Feb 2020 13:52:56 +0200
Message-ID: <CA+h21hqjXedxha9_qncGQK-mzMxLZa6Jqs3q1P8rqy29wZmBkA@mail.gmail.com>
Subject: Re: [PATCH v3 devicetree 0/6] DT bindings for Felix DSA switch on LS1028A
To:     Michael Walle <michael@walle.cc>
Cc:     Shawn Guo <shawnguo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Mon, 24 Feb 2020 at 13:38, Michael Walle <michael@walle.cc> wrote:
>
> Hi Shawn,
>
> Am 2020-02-24 12:20, schrieb Shawn Guo:
> > On Sun, Feb 23, 2020 at 10:47:10PM +0200, Vladimir Oltean wrote:
> >> This series officializes the device tree bindings for the embedded
> >> Ethernet switch on NXP LS1028A (and for the reference design board).
> >> The driver has been in the tree since v5.4-rc6.
> >>
> >> It also performs some DT binding changes and minor cleanup, as per
> >> feedback received in v1 and v2:
> >>
> >> - I've changed the DT bindings for the internal ports from "gmii" to
> >>   "internal". This means changing the ENETC phy-mode as well, for
> >>   uniformity. So I would like the entire series to be merged through a
> >>   single tree, probably the devicetree one - something which David
> >>   Miller has aggreed to, here [0].
> >> - Disabled all Ethernet ports in the LS1028A DTSI by default, which
> >>   means not only the newly introduced switch ports, but also RGMII
> >>   standalone port 1.
> >>
> >> [0]: https://lkml.org/lkml/2020/2/19/973
> >>
> >> Claudiu Manoil (2):
> >>   arm64: dts: fsl: ls1028a: add node for Felix switch
> >>   arm64: dts: fsl: ls1028a: enable switch PHYs on RDB
> >>
> >> Vladimir Oltean (4):
> >>   arm64: dts: fsl: ls1028a: delete extraneous #interrupt-cells for
> >> ENETC
> >>     RCIE
> >>   arm64: dts: fsl: ls1028a: disable all enetc ports by default
> >
> > I applied these 4 DTS patches with changing prefix to 'arm64: dts:
> > ls1028a: '.
>
> Oh, then the kontron-sl28 boards won't have ethernet because the nodes
> are
> disabled now. I'll send a patch shortly which explicitly sets the status
> to
> "okay", hopefully you can pick it up so it'll end up in the same pull
> request
> as this one:
>
>    arm64: dts: fsl: ls1028a: disable all enetc ports by default
>

Sorry, I didn't notice your board.

> -michael
>
> >
> > Shawn
> >
> >>   net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
> >>   dt-bindings: net: dsa: ocelot: document the vsc9959 core
> >>
> >>  .../devicetree/bindings/net/dsa/ocelot.txt    | 116
> >> ++++++++++++++++++
> >>  .../boot/dts/freescale/fsl-ls1028a-qds.dts    |   1 +
> >>  .../boot/dts/freescale/fsl-ls1028a-rdb.dts    |  61 ++++++++-
> >>  .../arm64/boot/dts/freescale/fsl-ls1028a.dtsi |  89 +++++++++++++-
> >>  drivers/net/dsa/ocelot/felix.c                |   3 +-
> >>  drivers/net/dsa/ocelot/felix_vsc9959.c        |   3 +-
> >>  6 files changed, 265 insertions(+), 8 deletions(-)
> >>  create mode 100644
> >> Documentation/devicetree/bindings/net/dsa/ocelot.txt
> >>
> >> --
> >> 2.17.1
> >>

Regards,
-Vladimir
