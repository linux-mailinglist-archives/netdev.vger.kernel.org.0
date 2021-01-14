Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185022F69B2
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729034AbhANSgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhANSgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:36:40 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FABC061575;
        Thu, 14 Jan 2021 10:36:00 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id d8so6107532otq.6;
        Thu, 14 Jan 2021 10:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VqjmGEa8mvJviyLORYPrU1czcSwgwoqxH0DM/94PiCQ=;
        b=YNHXNIiPeQOKtDtkNI6NpmxLROYl8EvnUa27wTLBNxYO9VMc4In+uxGNMPmAN+Ix1X
         KSVIfAGz0ue6qGusnIz4fv2uJrlnqzWnbpHLeyC5JfTyoUmNKitwL73IdG0xQlkSOGMU
         mLs3xKb6DBo5ZWKa0huVZ55lpHnFiUXdEG80QstfyZ67nlBZQsrCAtFFTK4+f4FwDLHr
         F/y8WYG1jkJVIR7HGHKNUyoufCVMUKtr9XXDN2IxaG8pbrW//uv91tD8WO8iHoH9XtQb
         ZvIL9DKU6dsaJOwK1l4qOaiPB1jZh2vepiHL1WfquXHqQ/Tp/m77XLntwPvKAk1etSI5
         sE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VqjmGEa8mvJviyLORYPrU1czcSwgwoqxH0DM/94PiCQ=;
        b=j1gR2CodwRI2bQx49mLGSj/5ZqyB+n3eW+V9C8AI4ozYTQ9Hzh7KNtGHFCOofBjCt4
         nH9rbjzlq3C3EeM01hRKpQSg5tRuSM5SiQO67oE06QyB70S4Ny7ugV04IxYV4VCEFJWd
         /53V94KII+/pm5tEDx6mfLZgEaBUs4d3aabpeYsiVRy6M+m6zkwdAk1HInorsKeD0eu6
         aCCNwU2Y9Sqy0GNr8SnDlv9yzzSDmULOqoFXQDwmSe1y0LmhutCXHmiYYhjzFxYvNz5b
         L1PRU/KtfQeiwcLqfbCAeN7Chf1uCyg8nPqGbw75thvP0Dk+IQzFY/8CVRgl89xl8RRU
         sx2w==
X-Gm-Message-State: AOAM531YVvgjTngKNogv9+kQGW8fwti2WJpHu30TeAQZkC74e3XuYntx
        ouI0pXvlY6yfjPTwMkkSPUfLDW0nwxV8gHcXuw==
X-Google-Smtp-Source: ABdhPJynv56whF3/2OlPo/fUu1P6n3zthJqVfCXJJRbwLfbwWNsorpXKCjRoOB1ncr5dZJhwdck8ubKmBo/jxZRdvfA=
X-Received: by 2002:a05:6830:1b7b:: with SMTP id d27mr5723213ote.132.1610649360059;
 Thu, 14 Jan 2021 10:36:00 -0800 (PST)
MIME-Version: 1.0
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com> <13473e91-d017-9d8a-e130-037d46ff225c@gmail.com>
In-Reply-To: <13473e91-d017-9d8a-e130-037d46ff225c@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 14 Jan 2021 12:35:48 -0600
Message-ID: <CAFSKS=Ox9W0baAgC4fzjxW-adosF6ReLGyT5PY5_DvT9GHdQsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x driver
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 11:28 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 1/13/21 6:59 AM, George McCollister wrote:
> > Add a driver with initial support for the Arrow SpeedChips XRS7000
> > series of gigabit Ethernet switch chips which are typically used in
> > critical networking applications.
> >
> > The switches have up to three RGMII ports and one RMII port.
> > Management to the switches can be performed over i2c or mdio.
> >
> > Support for advanced features such as PTP and
> > HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> > may be added at a later date.
> >
> > Signed-off-by: George McCollister <george.mccollister@gmail.com>
> > ---
> [snip]
>
> This looks ready to me, just a few nits and suggestions.
>
>
> > +/* Add an inbound policy filter which matches the BPDU destination MAC
> > + * and forwards to the CPU port. Leave the policy disabled, it will be
> > + * enabled as needed.
> > + */
> > +static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
> > +{
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val = 0;
> > +     int i = 0;
> > +     int ret;
> > +
> > +     /* Compare all 48 bits of the destination MAC address. */
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 48 << 2);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /* match BPDU destination 01:80:c2:00:00:00 */
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 0), 0x8001);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_1(port, 0), 0xc2);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = regmap_write(priv->regmap, XRS_ETH_ADDR_2(port, 0), 0x0);
> > +     if (ret)
> > +             return ret;
>
> Not that this is likely to change, but you could write this as a for
> loop and use eth_stp_addr from include/linux/etherdevice.h.

Okay, changed to a loop using eth_stp_addr. I'll retest STP to make
sure I didn't break it (this would be my luck towards the end of a
patch series).

>
> [snip]
>
> > +static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> > +{
> > +     bool cpu_port = dsa_is_cpu_port(ds, port);
> > +     struct xrs700x *priv = ds->priv;
> > +     unsigned int val = 0;
> > +     int ret, i;
> > +
> > +     xrs700x_port_stp_state_set(ds, port, BR_STATE_DISABLED);
>
> It looks like we should be standardizing at some point on having switch
> drivers do just the global configuration in the ->setup() callback and
> have the core call the ->port_disable() for each port except the CPU/DSA
> ports, and finally let the actual port configuration bet done in
> ->port_enable(). What you have is fine for now and easy to change in the
> future.

Sounds good.

>
> > +int xrs700x_switch_register(struct xrs700x *dev)
> > +{
> > +     int ret;
> > +     int i;
> > +
> > +     ret = xrs700x_detect(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     ret = xrs700x_setup_regmap_range(dev);
> > +     if (ret)
> > +             return ret;
> > +
> > +     dev->ports = devm_kzalloc(dev->dev,
> > +                               sizeof(*dev->ports) * dev->ds->num_ports,
> > +                               GFP_KERNEL);
> > +     if (!dev->ports)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < dev->ds->num_ports; i++) {
> > +             ret = xrs700x_alloc_port_mib(dev, i);
> > +             if (ret)
> > +                     return ret;
>
> Nothing frees up the successfully allocated p->mib_data[] in case of
> errors so you would be leaking here.

In case of an error probe will end up returning an error and the
memory will be free'd since it was allocated with a devm_ function,
won't it?

>
> [snip]
>
> > +
> > +     /* Main DSA driver may not be started yet. */
> > +     if (ret)
> > +             return ret;
> > +
> > +     i2c_set_clientdata(i2c, dev);
>
> I would be tempted to move this before "publishing" the device, probably
> does not harm though, likewise for the MDIO stub.

Okay, I moved it.

>
> [snip]
>
> > +/* Switch Configuration Registers - VLAN */
> > +#define XRS_VLAN(v)                  (XRS_SWITCH_VLAN_BASE + 0x2 * (v))
> > +
> > +#define MAX_VLAN                     4095
>
> Can you use VLAN_N_VID - 1 here from include/linux/if_vlan.h?

Sure.

> --
> Florian
