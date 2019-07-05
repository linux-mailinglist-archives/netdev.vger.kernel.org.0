Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8AC602E5
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 11:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfGEJI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 05:08:59 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35713 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGEJI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 05:08:58 -0400
Received: by mail-ed1-f65.google.com with SMTP id w20so7624342edd.2;
        Fri, 05 Jul 2019 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kSiMC23ISGGQqVJSQMfXoclzcfCXE9jKziQow8Aqu58=;
        b=bV5DgE/awiZCo70PJlZnyqIWgNigM3VnXItEoGqIjp2VwZAjg1Xtuv4hQpPEB0Jt6F
         Fq5BSo7B/rY4PMP/4Nwu27G69SQWZt+J6PAH2WXApCEy7ZPAb3tfWAIIP1vcjgWxUGlW
         eNQwjSrBPEfkUsBUD50OmCAvjzjhzwnTWIysIdTelYTQHmRPPTMScD6/trE7whDBf6HV
         G2WCWOFKxTlOoQwaIFS2Tr5i7U7WxlJCtJalVwHV9bXmlsNH/BVDB9FOg1yy7PB5xxRR
         H9Q5HcXpRB4X31oxQyBpicdAK4o0cRVRE8CevPbt2rFH5oT+MCW3xSEYts34UIcnBtz0
         GbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kSiMC23ISGGQqVJSQMfXoclzcfCXE9jKziQow8Aqu58=;
        b=JHHPGUKSpXxpFwYBds1FPWCCwK+2aq3Ggph5/1/HQAvPFPzB3qBnwRMoM0EAjPhQf6
         oTyN3fEuUuXJul5RhFfohiIQRj/NwVxuHCfIcnzciwuKbo1CnWm/+jhZPnp3qqnL/70b
         fj+Mhg2ghHlEsAuAc+dsz+kYrCym7wDtIxdH/3Z/ti9nVHlWhvAWMlOBCu/DhgXzZd1r
         +vD+PM/C7Ram3ZUs6jAvbHbIQUDmLZlwEucmQcBGzwDzJzujDeSqVWq9QILdMFNGmFPB
         bxIMtXlvHyloBh5491/pmM+NGCe1g3YjTaQLhk9j4Dph6Ph0oIp3JNRIFDa5fJxOzcWI
         4mHw==
X-Gm-Message-State: APjAAAVHZoJdrNDHXvy62olkreQfsn95/LJ53GiDfeQMxl/DUFHAnQF9
        XXgxWr5kG43loH2EDzlkdK7GNLRnPklTFHCK2Bg=
X-Google-Smtp-Source: APXvYqx22fS+pUeLNsjnHvqrFs6EQGY5EsmKNI1CNKh15QT+gqZBMDoV2f19y7PER6ojlIisVn9BH1EpPtvyAEyWL8k=
X-Received: by 2002:a17:906:b7d8:: with SMTP id fy24mr2518380ejb.230.1562317736258;
 Fri, 05 Jul 2019 02:08:56 -0700 (PDT)
MIME-Version: 1.0
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch> <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net> <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch> <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com> <20190705044945.GA30115@lunn.ch>
In-Reply-To: <20190705044945.GA30115@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 5 Jul 2019 12:08:45 +0300
Message-ID: <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Fri, 5 Jul 2019 at 07:49, Andrew Lunn <andrew@lunn.ch> wrote:
>
> Hi Vladimir
>
> > - DSA is typically used for discrete switches, switchdev is typically
> > used for embedded ones.
>
> Typically DSA is for discrete switches, but not exclusively. The
> b53/SF2 is embedded in a number of Broadcom SoCs. So this is no
> different to Ocelot, except ARM vs MIPS. Also, i would disagree that
> switchdev is used for embedded ones. Mellonex devices are discrete, on
> a PCIe bus. I believe Netronome devices are also discrete PCIe
> devices. In fact, i think ocelot is the only embedded switchdev
> switch.
>
> So embedded vs discrete plays no role here at all.
>

drivers/staging/fsl-dpaa2/ethsw/ is another example of switchdev
driver for an embedded switch.
I would give it to you that the sample size is probably too small to
say 'typically', but my point was that in order to support cascaded
switches it makes more sense for those to be discrete.

> > - The D in DSA is for cascaded switches. Apart from the absence of
> > such a "Ocelot SoC" driver (which maybe can be written, I don't know),
> > I think the switching core itself has some fundamental limitations
> > that make a DSA implementation questionable:
>
> There is no requirement to implement D in DSA. In fact, only Marvell
> does. None of the other switches do. And you will also find that most
> boards with a Marvell switch use a single device. D in DSA is totally
> optional. In fact, DSA is built from the ground up that nearly
> everything is optional. Take a look at mv88e6060, as an example. It
> implements nearly nothing. It cannot even offload a bridge to the
> switch.
>

Let me see if I get your point.
The D is optional, and the S is optional. So what's left? :)
Also, there's a big difference between "the hardware can't do it" and
"the driver doesn't implement it". If I follow your argument, would
you write a DSA driver for a device that doesn't do L2 switching?
Along that same line, what benefit does the DSA model bring to a
switch that can't do cascading, compared to switchdev? I'm asking this
as a user, not as a developer.

> > So my conclusion is that DSA for Felix/Ocelot doesn't make a lot of
> > sense if the whole purpose is to hide the CPU-facing netdev.
>
> You actually convinced me the exact opposite. You described the
> headers which are needed to implement DSA. The switch sounds like it
> can do what DSA requires. So DSA is the correct model.
>
>      Andrew

Somebody actually asked, with the intention of building a board, if
it's possible to cascade the LS1028A embedded switch (Felix) with
discrete SJA1105 devices - Felix being at the top of the switch tree.
Does the DSA model support heterogeneous setups (parsing stacked
headers)? I can't tell if that's how EDSA tags work. With switchdev
for Felix there wouldn't be any problem - it just wouldn't be part of
the DSA tree and its own driver would remove its tags before DSA would
look at the rest.

Regards,
-Vladimir
