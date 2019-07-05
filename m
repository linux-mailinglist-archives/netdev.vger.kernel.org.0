Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD177609E4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 18:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbfGEQDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 12:03:20 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43071 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbfGEQDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 12:03:20 -0400
Received: by mail-pl1-f194.google.com with SMTP id cl9so4779986plb.10;
        Fri, 05 Jul 2019 09:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tpm/49CMge9GGSgW5OlmplqW6PGiorTO4o8V9fLZ7hE=;
        b=ZVbjMfv4tekvvXfIui1y1EotpSdh0IvEFyS/dHxd0l1Qx63+wLnBabygQzc0U1Fz/G
         ETJ0SI8RS/UaEKKH5+pk9PguG9pYwxhppYGHvKcEg7oGOa+CpxN1+IqYrmp22Xuu5l5T
         a4bcsWAW5Rf835AsHzlgv1qsWDBzKqRtKCSq9I9qOfL2dAVXpI13p0woJOdtjQkil6EA
         iske6VhLtgmOl6P2vDZHsWdbi23HmdoDu4y3h9JPIEu366d81joZFconmiLUUogsjrmN
         7PxDecJyrECO88iNV4/rPMFqHuK3++7udWJmlC7dTTQWPF6tiVCvKVcICeucbcD+cYjy
         vn6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tpm/49CMge9GGSgW5OlmplqW6PGiorTO4o8V9fLZ7hE=;
        b=KQqDnFnhAFKlXau5aQRqIqjQuCRefaXOZp7n6NP7P0tuaGVMlkDAv+Qh66JwZSEFdY
         HuwKlkWqn2t4Y+x6KT8DwXE60ucdxhilVdGduDtfTjHqbB/5HAFks7zoEV5i8K+Hu2jW
         kZAuqzCP0yYEM1oV/xFH8F7dLbsl9UvMl7NDRObN5CUqupJ1cbXyKPa6LZkSf4BKLo/Y
         2ox9+6X8yAJcj4EIWPYvi+eA5MtugifPRQgmb3oMVHbR6+FrOiY1UB50SrTErapuk7iU
         1K3hZw5tYOwm6xdPoKNmGOc638SxSxla7/14OSMuMiHXxGT/ZHgcsJeIhUKOnWsZmSw9
         neew==
X-Gm-Message-State: APjAAAV9LfQKPYQcVb6XJ6eUFtwkwVD8lr53bv4s98N4LydeEB18L3kP
        +zRAloyjj500ThYrXwYHhwE=
X-Google-Smtp-Source: APXvYqxGzCdLXelAJUEGE3ud5sNVpGihTJoNCAeK33dQhBfTKH/g3SgJIePXQFNOshDssjw1qneJBw==
X-Received: by 2002:a17:902:a714:: with SMTP id w20mr6485494plq.127.1562342599378;
        Fri, 05 Jul 2019 09:03:19 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id b36sm22013156pjc.16.2019.07.05.09.03.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 09:03:18 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] arm64: dts: fsl: ls1028a: Add Felix switch
 port DT node
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>
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
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
 <1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com>
 <20190621164940.GL31306@lunn.ch>
 <VI1PR04MB4880D8F90BBCD30BF8A69C9696E00@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <20190624115558.GA5690@piout.net> <20190624142625.GR31306@lunn.ch>
 <20190624152344.3bv46jjhhygo6zwl@lx-anielsen.microsemi.net>
 <20190624162431.GX31306@lunn.ch> <20190624182614.GC5690@piout.net>
 <CA+h21hqGtA5ou7a3wjSuHxa_4fXk4GZohTAxnUdfLZjV3nq5Eg@mail.gmail.com>
 <20190705044945.GA30115@lunn.ch>
 <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <c60df66a-b3c9-1445-36c6-cad7c6b75550@gmail.com>
Date:   Fri, 5 Jul 2019 09:03:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+h21hqU1H1PefBWKjnsmkMsLhx0p0HJTsp-UYrSgmVnsfqULA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2019 2:08 AM, Vladimir Oltean wrote:
> Hi Andrew,
> 
> On Fri, 5 Jul 2019 at 07:49, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> Hi Vladimir
>>
>>> - DSA is typically used for discrete switches, switchdev is typically
>>> used for embedded ones.
>>
>> Typically DSA is for discrete switches, but not exclusively. The
>> b53/SF2 is embedded in a number of Broadcom SoCs. So this is no
>> different to Ocelot, except ARM vs MIPS. Also, i would disagree that
>> switchdev is used for embedded ones. Mellonex devices are discrete, on
>> a PCIe bus. I believe Netronome devices are also discrete PCIe
>> devices. In fact, i think ocelot is the only embedded switchdev
>> switch.
>>
>> So embedded vs discrete plays no role here at all.
>>
> 
> drivers/staging/fsl-dpaa2/ethsw/ is another example of switchdev
> driver for an embedded switch.
> I would give it to you that the sample size is probably too small to
> say 'typically', but my point was that in order to support cascaded
> switches it makes more sense for those to be discrete.
> 
>>> - The D in DSA is for cascaded switches. Apart from the absence of
>>> such a "Ocelot SoC" driver (which maybe can be written, I don't know),
>>> I think the switching core itself has some fundamental limitations
>>> that make a DSA implementation questionable:
>>
>> There is no requirement to implement D in DSA. In fact, only Marvell
>> does. None of the other switches do. And you will also find that most
>> boards with a Marvell switch use a single device. D in DSA is totally
>> optional. In fact, DSA is built from the ground up that nearly
>> everything is optional. Take a look at mv88e6060, as an example. It
>> implements nearly nothing. It cannot even offload a bridge to the
>> switch.
>>
> 
> Let me see if I get your point.
> The D is optional, and the S is optional. So what's left? :)
> Also, there's a big difference between "the hardware can't do it" and
> "the driver doesn't implement it". If I follow your argument, would
> you write a DSA driver for a device that doesn't do L2 switching?
> Along that same line, what benefit does the DSA model bring to a
> switch that can't do cascading, compared to switchdev? I'm asking this
> as a user, not as a developer.

As an user, I don't think there are compelling arguments to either
switchdev or DSA because the end result is the same: network devices
that can offload "stuff". As a developer though, there is much less code
to write with DSA than with switchdev to get your HW live.

> 
>>> So my conclusion is that DSA for Felix/Ocelot doesn't make a lot of
>>> sense if the whole purpose is to hide the CPU-facing netdev.
>>
>> You actually convinced me the exact opposite. You described the
>> headers which are needed to implement DSA. The switch sounds like it
>> can do what DSA requires. So DSA is the correct model.
>>
>>      Andrew
> 
> Somebody actually asked, with the intention of building a board, if
> it's possible to cascade the LS1028A embedded switch (Felix) with
> discrete SJA1105 devices - Felix being at the top of the switch tree.
> Does the DSA model support heterogeneous setups (parsing stacked
> headers)? I can't tell if that's how EDSA tags work. With switchdev
> for Felix there wouldn't be any problem - it just wouldn't be part of
> the DSA tree and its own driver would remove its tags before DSA would
> look at the rest.

DSA not does not make any particular assumptions about how the stacking
is done actually because each slave network device is expected to
provided standard Ethernet frames to the network stack. How you get to
that point is entirely specific to what the hardware can do.

You do what Andrew described about one of my setup (bcm_sf2 w/ tagging
enabled and b53 w/o tagging, see more below why [1]]) and both being
discrete switch trees, with the master netdev of the b53 being a slave
netdev provided by bcm_sf2. If your tagging protocol supports it you can
make them part of the same DSA switch tree and just have them have
different switch identifiers, that is what Marvell switches do and it
works just great. In your case, I suppose you could even use double VLAN
tagging to get such cascading to work, that would limit you to a two
level of cascading, unless you invent something custom.

[1]: The original Broadcom tag format introduced with BCM5325/5365 did
support cascading in the same way that Marvell did where a switch
identifier can be added in addition to a port number within the tag. The
newest Broadcom tag that was introduced with 5395 and newer dropped
support for the switch identifier and the switch will "terminate" the
first (from start of Ethernet frame) tag that it receives. This is the
reason why we need to disable tagging on the outermost B53 device that
we are connected to. This means those network devices are mainly
configuration endpoints and not passing data (DSA_TAG_PROTO_NONE),
though we could use DSA_TAG_PROTO_8021Q and resolve that now.
-- 
Florian
