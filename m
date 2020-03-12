Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F55A183B6F
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 22:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgCLVf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 17:35:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42596 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgCLVf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 17:35:29 -0400
Received: by mail-ed1-f65.google.com with SMTP id n18so9344678edw.9;
        Thu, 12 Mar 2020 14:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w1zcQ0pwsk6Sv5HkuPglXPmgpcyE2cmpz+kIS0DS4nw=;
        b=Ns03hq698c5nJGC7j/6c5N9u3dyz/UKqOCtYtrfKIIrjDDTWfxUyd2jEas6KNqlSmI
         Ld+BKVByi4vsTqlmcAENsFHkbaraOdhSfotILQOcUREF4Wr8Gvch7+9HK/pW48ygG9N9
         zP9ub4iFy6Oq+NeRdx1ceKEDkdlpyrLpL5HSY0AnNqDioQDmFwlSC2FFeWVTCSlsGPg9
         hiLLtO0NsC0jVvy2RP1EaRwB9D4U4lGYVFxmN05EKPV76oRZ4r36Ttk73BzYsg7uy3vC
         ph8W4hF6XzQSy8FczqEZ8QyVw3G/uExf9L8sYjfjKS8wzdZz224ncurQFa6PKElVa6D1
         C+hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w1zcQ0pwsk6Sv5HkuPglXPmgpcyE2cmpz+kIS0DS4nw=;
        b=szMqfQiWsShxXw4Gbif1FedP+rhR1a2GfUT81T7DYX1taUkJzGsZqDpoSnj81JApm8
         jZORb92zT7ps3Yd9+xTQj4J/11KHVV+45fqfmWhNEmtqA2QZzBIfP19KcI6IPJpJIdap
         NHlhOMBUdycFj2v5/zHlGBdOx3KI9gMgqMf9FD9YHEdABpTY/O8ttrHh67zwX8+y1Anp
         bBzGVO8ywP7/345dsbWdGSVS9A5SHQW/UNbOSQHU+KhWNQP9j81NGZkVjeo/WGMZ6rJF
         X86VgJnyLZueRjy/NyHuAcb/RQt0tnm3lYh8Kqsz4TnxwO6aufeyma1+ObmV9Fi52/nT
         /5Iw==
X-Gm-Message-State: ANhLgQ15xqXzA/YqGzuGN0S2hfcCs4E9TiAjwLFkBNEtrVhCAbP800X7
        0C81YUuc5x5vhSZ/X6GV2lkwMLvHrS/0+ybFVnE=
X-Google-Smtp-Source: ADFU+vsiyvjYIkOLbK9gTV05LGSSgyCx7Z0cDMbSZLbMQjbrdyinTU8gUMl1VUDmDLUkNlpuLq769IWuinYNYh/M5kg=
X-Received: by 2002:a05:6402:1c0c:: with SMTP id ck12mr10249138edb.145.1584048926737;
 Thu, 12 Mar 2020 14:35:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200312164320.22349-1-michael@walle.cc>
In-Reply-To: <20200312164320.22349-1-michael@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 12 Mar 2020 23:35:15 +0200
Message-ID: <CA+h21hoHMxtxUjHthx2ta9CzQbkF_08Svi7wLU99NqJmoEr36Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: dsa: felix: allow the device to be disabled
To:     Michael Walle <michael@walle.cc>
Cc:     "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
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

On Thu, 12 Mar 2020 at 18:44, Michael Walle <michael@walle.cc> wrote:
>
> If there is no specific configuration of the felix switch in the device
> tree, but only the default configuration (ie. given by the SoCs dtsi
> file), the probe fails because no CPU port has been set. On the other
> hand you cannot set a default CPU port because that depends on the
> actual board using the switch.
>
> [    2.701300] DSA: tree 0 has no CPU port
> [    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> [    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22
>
> Thus let the device tree disable this device entirely, like it is also
> done with the enetc driver of the same SoC.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  drivers/net/dsa/ocelot/felix.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
> index 69546383a382..531c7710063f 100644
> --- a/drivers/net/dsa/ocelot/felix.c
> +++ b/drivers/net/dsa/ocelot/felix.c
> @@ -699,6 +699,11 @@ static int felix_pci_probe(struct pci_dev *pdev,
>         struct felix *felix;
>         int err;
>
> +       if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
> +               dev_info(&pdev->dev, "device is disabled, skipping\n");
> +               return -ENODEV;
> +       }
> +

IMHO since DSA is already dependent on device tree for PHY bindings,
it would make more sense to move this there:

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index e7c30b472034..f7ca01d93928 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -878,7 +878,7 @@ static int dsa_switch_probe(struct dsa_switch *ds)
        if (!ds->num_ports)
                return -EINVAL;

-       if (np) {
+       if (np && of_device_is_available(np)) {
                err = dsa_switch_parse_of(ds, np);
                if (err)
                        dsa_switch_release_ports(ds);

so that we could enforce more uniform behavior across device drivers.
Then you might want to make felix shut up:

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 35124ef7e75b..fbd17fa94bff 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -712,10 +712,8 @@ static int felix_pci_probe(struct pci_dev *pdev,
        felix->ds = ds;

        err = dsa_register_switch(ds);
-       if (err) {
-               dev_err(&pdev->dev, "Failed to register DSA switch: %d\n", err);
+       if (err)
                goto err_register_ds;
-       }

        return 0;

This has the disadvantage of not printing the "nice" "device is
disabled, skipping" message (useless in my opinion), but the advantage
of also shutting up on -EPROBE_DEFER.

>         err = pci_enable_device(pdev);
>         if (err) {
>                 dev_err(&pdev->dev, "device enable failed\n");
> --
> 2.20.1
>

Thanks,
-Vladimir
