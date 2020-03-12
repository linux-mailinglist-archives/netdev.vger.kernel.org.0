Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9680183BEF
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 23:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgCLWHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 18:07:51 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38118 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbgCLWHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 18:07:51 -0400
Received: by mail-ed1-f65.google.com with SMTP id h5so9459018edn.5;
        Thu, 12 Mar 2020 15:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=09HoQ5yKKTzC52h8DcFum9TdRrDdU+q3hWjuJoEs67M=;
        b=NeCAbPd46VNfEXE/GihhtpSTXB6ri3ZXEQPFz1pFr7zwBKof5kilpHWiLqxuzUQ+rR
         PzsxPDGD2VTa6vvrkYDUmDlUBg5Q6KJRbr2NnpoF1xxqOvhNM0WdwAQqc/n5gNurbg/A
         GMOq/LGBtgK0AYf15pZflLJtbe4zvq48tugK1M3DiFGzMr6ehYwEdkr94iEkbehJfMKf
         VXe43ZlvCvmI+wGAlgpIwUVj1wq5lPV8K1LJ8wU41ffVhkV1qHQSZmcp7IBpzHprvJ4o
         Ki/GgtCTlu/8e+55iXIK+T1Rn3/hhHXisRtChqa5N30/eBVNZeSnYeUmgg8gdVKwG80k
         tzRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=09HoQ5yKKTzC52h8DcFum9TdRrDdU+q3hWjuJoEs67M=;
        b=epQshqUJvrgjP6AorcT5lx3WVe7DR++Pr8o+TY4y++ekX2L3Qf1Gmwly0FbU0j86me
         rA5IjaGXwsfWXbk41J2BdT41FXUwdub13JxxMzTxiM2ZRaEi6vF5ypYiZJEpnuWfuIL1
         kuUr0CsyxkIPjAwZ8/IoI7lzq1i1jAJcKvxYo4XqyU3mEg5KhStXgVTjviiHPzFUZnSj
         82rinJH4Z3lLcLmKEWjTg9nwpwYrNG0kukKOIUv/KPR/12hrFA4XlRCfwuxZ3orp4a5t
         +bnit4Nta5rgM58FWebVaEHlf+X/jCitytcBaIQlmrhNlw5BSIORPjPZUYOydGJOkf/I
         6UDg==
X-Gm-Message-State: ANhLgQ3huUcgJ5y9jl6d8XuCR83PqPlHTWEcVaU3sW1mNL0pXpEwwqbN
        d+06iiY2SVR+VRFVcoVqfRZJgnIvOSj0f76hLCw=
X-Google-Smtp-Source: ADFU+vv29LV+LrHrAX74+0u8zlCtfmsF/tpTKCLUjivUWOJdldY59uyR0/VG72OTulhoqTqPuaKSJTEcVeLL/ygAGT0=
X-Received: by 2002:a17:906:76c6:: with SMTP id q6mr8622638ejn.176.1584050868783;
 Thu, 12 Mar 2020 15:07:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200312164320.22349-1-michael@walle.cc> <CA+h21hoHMxtxUjHthx2ta9CzQbkF_08Svi7wLU99NqJmoEr36Q@mail.gmail.com>
 <55374edd-2698-6841-569c-cccf1151cfb1@gmail.com>
In-Reply-To: <55374edd-2698-6841-569c-cccf1151cfb1@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 13 Mar 2020 00:07:37 +0200
Message-ID: <CA+h21hrHGJxV8zbG4NSsHEAUucA8s+P6eyFAtWn-C6yk=52ehA@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: felix: allow the device to be disabled
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Michael Walle <michael@walle.cc>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Mar 2020 at 23:45, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 3/12/20 2:35 PM, Vladimir Oltean wrote:
> > On Thu, 12 Mar 2020 at 18:44, Michael Walle <michael@walle.cc> wrote:
> >>
> >> If there is no specific configuration of the felix switch in the device
> >> tree, but only the default configuration (ie. given by the SoCs dtsi
> >> file), the probe fails because no CPU port has been set. On the other
> >> hand you cannot set a default CPU port because that depends on the
> >> actual board using the switch.
> >>
> >> [    2.701300] DSA: tree 0 has no CPU port
> >> [    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> >> [    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22
> >>
> >> Thus let the device tree disable this device entirely, like it is also
> >> done with the enetc driver of the same SoC.
> >>
> >> Signed-off-by: Michael Walle <michael@walle.cc>
> >> ---
> >>  drivers/net/dsa/ocelot/felix.c | 5 +++++
> >>  1 file changed, 5 insertions(+)
> >>
> >> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> >> index 69546383a382..531c7710063f 100644
> >> --- a/drivers/net/dsa/ocelot/felix.c
> >> +++ b/drivers/net/dsa/ocelot/felix.c
> >> @@ -699,6 +699,11 @@ static int felix_pci_probe(struct pci_dev *pdev,
> >>         struct felix *felix;
> >>         int err;
> >>
> >> +       if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
> >> +               dev_info(&pdev->dev, "device is disabled, skipping\n");
> >> +               return -ENODEV;
> >> +       }
> >> +
> >
> > IMHO since DSA is already dependent on device tree for PHY bindings,
> > it would make more sense to move this there:
>
> Michael's solution makes more sense, as this is a driver specific
> problem whereby you have a pci_dev instance that is created and does not
> honor the status property provided in Device Tree. If you were to look
> for a proper solution it would likely be within the PCI core actually.
>
> No other DSA switch has that problem because they use the
> I2C/SPI/platform_device/GPIO/whatever entry points into the driver model.

True, my problem with doing it in the PCI core is that "the book" [0]
doesn't actually say anything about the "status" property, so this
patch might get some pushback from the PCI maintainers (but I don't
actually know):

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 512cb4312ddd..50c2b3da134a 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2281,6 +2281,12 @@ static struct pci_dev *pci_scan_device(struct
pci_bus *bus, int devfn)

        pci_set_of_node(dev);

+       if (dev->dev.of_node && !of_device_is_available(dev->dev.of_node)) {
+               pci_bus_put(dev->bus);
+               kfree(dev);
+               return NULL;
+       }
+
        if (pci_setup_device(dev)) {
                pci_bus_put(dev->bus);
                kfree(dev);

OF bindings are completely optional with PCI, as you probably already
know. But there's nothing "driver" specific in disabling (i.e. not
probing) a device.

> --
>

[0] https://www.openfirmware.info/data/docs/bus.pci.pdf

Thanks,
-Vladimir
