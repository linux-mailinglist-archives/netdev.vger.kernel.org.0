Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF54431EAC
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhJROFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhJROBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12FEE61A7E;
        Mon, 18 Oct 2021 13:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634564571;
        bh=zfHUTqiEZNcwoTUEA15pyh36vmYEdz3Eki/UQj7YGCI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gicUw8LVEDCj9LJBhuB3HeBeyCGAZy5KwtvZM4oxTFEBeAvRPRrxbcLh1/AXi6hoG
         l/HhOTaHtQFVX+oGrCq4/XMSFdmpFrLveJRawy1qeiMWyzBgdj6RmBNkZqdE42jTnW
         kLv5oO+8/c3lDDGaqMvE2y73xeuZV4FCLcGmC3Kl+0n4VPqt/Xz0df5FSaXJXk0eXX
         R6gNc4Lc6LkFMr6vqcL+7KsWvr8SJkYdwymFFc0p9XGlGx7WK4Q9Wy7XD8hDPqyIuP
         kM9Ev3+rGT9lQYtQipEpDa0ieEr15tnvk12AUdQCmpdH0UG880E1j6PTmwCyzdWpq6
         k38ta733bQ/HQ==
Received: by mail-ed1-f42.google.com with SMTP id r18so71544804edv.12;
        Mon, 18 Oct 2021 06:42:50 -0700 (PDT)
X-Gm-Message-State: AOAM531Oi3J/Gxwmnu51qQ8fXZ1PqBAbwc/QkwE2jni+aldXWfbixDT5
        AAJMdUzAB2MvMn5WIcfx/RYY4ZCZKWw0no8wdQ==
X-Google-Smtp-Source: ABdhPJzWbI+B+lLuu8xwQGu826Gmqq4SJu2VbMU/6JQw9AwjJfTBE5Yy6QBqgtkm0PDiqQ4EsR6qrnYUH5+3acvq6BM=
X-Received: by 2002:a05:6402:1778:: with SMTP id da24mr43699821edb.318.1634564462043;
 Mon, 18 Oct 2021 06:41:02 -0700 (PDT)
MIME-Version: 1.0
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-6-vladimir.oltean@nxp.com> <1634221864.138006.3295871.nullmailer@robh.at.kernel.org>
 <20211015125527.28445238@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20211015224825.wyjg63uzyuaguewx@skbuf>
In-Reply-To: <20211015224825.wyjg63uzyuaguewx@skbuf>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 18 Oct 2021 08:40:50 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+rMtRKD11ZTqqCE+6iM3rmbDTaTBR5K0u+Adz837WKvg@mail.gmail.com>
Message-ID: <CAL_Jsq+rMtRKD11ZTqqCE+6iM3rmbDTaTBR5K0u+Adz837WKvg@mail.gmail.com>
Subject: Re: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 5:48 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, Oct 15, 2021 at 12:55:27PM -0700, Jakub Kicinski wrote:
> > On Thu, 14 Oct 2021 09:31:04 -0500 Rob Herring wrote:
> > > On Thu, 14 Oct 2021 01:23:12 +0300, Vladimir Oltean wrote:
> > > > Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
> > > > MAC-level RGMII delays. These properties must be per port and must be
> > > > present only for a phy-mode that represents RGMII.
> > > >
> > > > We tell dsa.yaml that these port properties might be present, we also
> > > > define their valid values for SJA1105. We create a common definition for
> > > > the RX and TX valid range, since it's quite a mouthful.
> > > >
> > > > We also modify the example to include the explicit RGMII delay properties.
> > > > On the fixed-link ports (in the example, port 4), having these explicit
> > > > delays is actually mandatory, since with the new behavior, the driver
> > > > shouts that it is interpreting what delays to apply based on phy-mode.
> > > >
> > > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >
> > > My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> > > on your patch (DT_CHECKER_FLAGS is new in v5.13):
> >
> > FWIW I dropped the set from pw based on Rob's report, I see a mention
> > of possible issues with fsl-lx2160a-bluebox3.dts, but it's not clear
> > to me which DT is disagreeing with the schema.. or is the schema itself
> > not 100?
>
> I am only saying that I am introducing a new DT binding scheme and
> warning all users of the old one. That's also why I am updating the
> device trees, to silence the newly introduced warnings. I would like
> this series to go through net-next, but fsl-lx2160a-bluebox3.dts isn't
> in net-next.

.dts changes should go in via the sub-arch's tree, not a subsystem tree.

Rob
