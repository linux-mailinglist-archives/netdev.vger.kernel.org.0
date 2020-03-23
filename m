Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED6818F6B1
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 15:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgCWOVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 10:21:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgCWOVD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 10:21:03 -0400
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F83720735;
        Mon, 23 Mar 2020 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584973263;
        bh=e8hZ/g1bNvklC5cvNY4Apt+hoToW8hqn4IgzX984TW0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=BB4Ru6T1NkxKNSViSeB7Ky4cBEWTioqOpo64eC5YmhBY7D0rFuTE22ak1rvOPpLJq
         oxsJMFPMMGnxNVy/KLt6HoyHymfZqTTC9/S63wCeBl98V/CCQJN2N7UjJPbw2cdWXv
         iIN0Qah4ohu4uMZxPk1Sp1h9jSIEZ/6man5hzuPM=
Received: by mail-qv1-f45.google.com with SMTP id z13so7243012qvw.3;
        Mon, 23 Mar 2020 07:21:03 -0700 (PDT)
X-Gm-Message-State: ANhLgQ2S/tSxpY+/PbAhgz0CedCcg54Z0IYGx6EItPgZjgVNnqWML9QH
        0/ExMFwiaH4n4UT4dbyS4QKL4IItQB8IXy3Z7Q==
X-Google-Smtp-Source: ADFU+vuEfOdadZVySdc7iq8l12uQIlz1tLgqs39PWkTAjyHZZ5yGYfX2C/lrU7LWzLsHdW/r1B4I6TObLucuUl7YGEw=
X-Received: by 2002:a05:6214:a6f:: with SMTP id ef15mr20183351qvb.79.1584973262182;
 Mon, 23 Mar 2020 07:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200313052252.25389-1-o.rempel@pengutronix.de>
 <20200313052252.25389-2-o.rempel@pengutronix.de> <545d5e46-644a-51fb-0d67-881dfe23e9d8@gmail.com>
 <20200313181056.GA29732@lunn.ch> <20200313181601.sbxdrqdjqfj3xn3e@pengutronix.de>
 <15dafdcd-1979-bf35-3968-c80ffc113001@gmail.com> <20200313185327.nawcp2imfldyhpqa@pengutronix.de>
 <20200317115626.4ncavxdcw4wu5zgc@pengutronix.de> <137a6dd3-c5ba-25b1-67ff-f0112afd7f34@gmail.com>
 <20200320230504.GA30209@bogus> <a1968447-5dd9-e309-6a3e-48ed05c2ab93@gmail.com>
In-Reply-To: <a1968447-5dd9-e309-6a3e-48ed05c2ab93@gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Mon, 23 Mar 2020 08:20:50 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+KHfW0LtzJQFjB7HTWFBGf_9fe79nKBSe-g5npRYfZ6A@mail.gmail.com>
Message-ID: <CAL_Jsq+KHfW0LtzJQFjB7HTWFBGf_9fe79nKBSe-g5npRYfZ6A@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 3:09 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 3/20/2020 4:05 PM, Rob Herring wrote:
> >>>> Because the primary PHY0 can be autodetected by the bus scan.
> >>>> But I have nothing against your suggestions. Please, some one should say the
> >>>> last word here, how exactly it should be implemented?
> >>
> >> It's not for me to decide, I was hoping the Device Tree maintainers
> >> could chime in, your current approach would certainly work although it
> >> feels visually awkward.
> >
> > Something like this is what I'd do:
> >
> > ethernet-phy@4 {
> >   compatible = "nxp,tja1102";
> >   reg = <4 5>;
> > };
>
> But the parent (MDIO bus controller) has #address-cells = 1 and
> #size-cells = 0, so how can this be made to work without creating two
> nodes or a first node encapsulating another one?

That is the size of the address, not how many addresses there are. If
the device has 2 addresses, then 2 address entries seems entirely
appropriate.

Rob
