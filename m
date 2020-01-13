Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C851393FA
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgAMOub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:50:31 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40901 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgAMOub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:50:31 -0500
Received: by mail-ed1-f66.google.com with SMTP id b8so8692480edx.7;
        Mon, 13 Jan 2020 06:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qoLqzXdrbilZqhirWy6N7+fMr1NtgjKpfzyuJ+M+kac=;
        b=MuOx5yHcNcFfR0jxVW3pvnvW9BxnEiI+157fOGVTCOB9120OWpV9Lp2S/fQvcx0Rv1
         FEfOLnlXKLLOknh6FpGGgsKjCBHsGzOoMI88rnVtEILnOPvE5hO2IJwCKPxje/xFozk+
         mypj5YTgRIaH9hpc21VEybYynQlng9Rj69pHpeponaQmpF4owLLcFK1F6sx58NlGSIkI
         MqGOGCZz3gXYaCdSbc/JJ9WrYlEcmIo7LWA5Cnzssqg2Ijv3WRFLwggs/ywG53lxONKC
         +VDwR1l9UhYvntLb4G86nkIc4hxEhfpnRS3I9A1hbENAq2IPvw1k5bdsAlnkuoXuV28O
         vVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qoLqzXdrbilZqhirWy6N7+fMr1NtgjKpfzyuJ+M+kac=;
        b=fX8ORh0ZkVJGgTJagha4axtdziY8mV3hP1L/mL810p2O2pVWvMa8DU4jwjjytSz446
         GDPm0qbbgtkGKrZtCAZhkqvGVYfjjNSjXGHBEG9YNmlbRiOZrPcy4PcKkoQd34DvlbMS
         VcMveHOiVJvivvdNBvIAWDT7+VrE32gh2Dout58hs2xAQQWjHoksRJMd2DJNA893sxJI
         lT1CbBjmbYVbU3WDxwXbLHDoanq1nvHUcb55fZDC7fC+8oEnxbWnU3C0cPPlk0o21oQJ
         LJrobxa4d+MkZCr/ksBMo/+plRGZBQpGJdVmdetGmqfk1jtjpqzKjCZdizF0VLU5mhql
         JcaQ==
X-Gm-Message-State: APjAAAVLnWM0tgUT6rjotoD74Infx2PF2fxWNoyFcV5pKNPDN72s61Cx
        EJAHrDKkLE/8RVmXAWMINZrah6BaLKC22N0+yj0=
X-Google-Smtp-Source: APXvYqxfimYZBDjuQ+nHG9oT+BPrb+35m6utZ8lzc2T2SD4MReedVpJma3L1GSez6D1lUcqyUMeZnAXqzWc8XZkRX98=
X-Received: by 2002:aa7:c402:: with SMTP id j2mr17276124edq.51.1578927029298;
 Mon, 13 Jan 2020 06:50:29 -0800 (PST)
MIME-Version: 1.0
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch> <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
In-Reply-To: <20200113141817.GN25745@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 13 Jan 2020 16:50:18 +0200
Message-ID: <CA+h21hqYeq_D5hLi8yssNko6ucNSVCFMQxqkvGcGxL86niu7pA@mail.gmail.com>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Mon, 13 Jan 2020 at 16:19, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> I've recently suggested a patch to phylink to add a generic helper to
> read the state from a generic 802.3 clause 37 PCS, but I guess that
> won't be sufficient for an XPCS.  However, it should give some clues
> if you're intending to use phylink.
>

I don't think the PCS implementations out there are sufficiently
similar to be driven by a unified driver, and at least nothing
mandates that for now. Although the configuration interface is MDIO
with registers quasi-compliant to C22 or C45, many times bits in
BMCR/BMSR are not implemented, you can't typically achieve full
functionality [ sometimes not at all ] without writing to some
vendor-specific registers, there might be errata workarounds that need
to be implemented through PCS writes, often the PCS driver needs to be
correlated with a MMIO region corresponding to that SerDes lane for
stuff such as eye parameters.
The code duplication isn't even all that bad.

_But_ I am not sure how PHYLINK comes into play here. A PHY driver
should work with the plain PHY library too. Dealing with clause 73
autoneg indicates to me that this is more than just a MAC PCS,
therefore it shouldn't be tied in with PHYLINK.

Thanks,
-Vladimir
