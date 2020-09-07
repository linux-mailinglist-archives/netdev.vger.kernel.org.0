Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282F02601FB
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbgIGRPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729755AbgIGOF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:05:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7433C061575
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 07:05:23 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1599487319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5lmwZ+UmDmXW6q4mpPvjAmh+0skTtrOGymKCZhnIYJ8=;
        b=W8S0eT6tKopAU6ELl+WkbfEE7UIYmuQfiFexZL8AR19WILxURui57K3zTf12x9F2DfUfli
        pZj8tJtjSCmSyAAIn0okwK1MCLRgwGQzD26CECSZEDJ9NnrrPjFGJuFS/7bJmtCGSJtk5O
        X1y4E1DQI3dd+lyK546mO91Ne4SOALZis5R814A5fdY/h8SC6D3X1OnMuAqjVo0USSEmlD
        GigSuwqd56N1hfiNGpSYhCJumzFCgHlZ7K+IxKEH7m8kEvBdWiluOzI0BVe8tE58bYQinZ
        hKcBDnSqXWhm8UhcDHglF1E7gIR21xZne0yK+rQg02CRAXAGI6UW/XDUOShELw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1599487319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5lmwZ+UmDmXW6q4mpPvjAmh+0skTtrOGymKCZhnIYJ8=;
        b=q/1Hguw4CZZluVRp11XgEidyL4dXWpnKFxuIiGPvhrRXoSWk/Z7o0x4me1QsuRjMePdOA7
        We5tGcjCkvb/zBCQ==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v5 2/7] net: dsa: Add DSA driver for Hirschmann Hellcreek switches
In-Reply-To: <20200907132109.234ha7xst37dtqcj@skbuf>
References: <20200904062739.3540-1-kurt@linutronix.de> <20200904062739.3540-3-kurt@linutronix.de> <20200905204235.f6b5til4sc3hoglr@skbuf> <875z8qazq2.fsf@kurt> <20200907104821.kvu7bxvzwazzg7cv@skbuf> <87eendah1c.fsf@kurt> <20200907132109.234ha7xst37dtqcj@skbuf>
Date:   Mon, 07 Sep 2020 16:01:57 +0200
Message-ID: <87a6y1adnu.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon Sep 07 2020, Vladimir Oltean wrote:
> On Mon, Sep 07, 2020 at 02:49:03PM +0200, Kurt Kanzenbach wrote:
>> On Mon Sep 07 2020, Vladimir Oltean wrote:
>> > On Mon, Sep 07, 2020 at 08:05:25AM +0200, Kurt Kanzenbach wrote:
>> >> Well, that depends on whether hellcreek_vlan_add() is called for
>> >> creating that vlan interfaces. In general: As soon as both ports are
>> >> members of the same vlan that traffic is switched.
>> >
>> > That's indeed what I would expect.
>> > Not only that, but with your pvid-based setup, you only ensure port
>> > separation for untagged traffic anyway.
>>
>> Why? Tagged traffic is dropped unless the vlan is configured somehow. By
>> default, I've configured vlan 2 and 3 to reflect the port separation for
>> DSA. At reset the ports aren't members of any vlan.
>>
>
> Wait, so what is the out-of-reset state of "ptcfg & HR_PTCFG_INGRESSFLT"?

No, ingress filtering is not set by default. But, still the ports are by
default not members of any vlan. So, I thought the traffic will be
dropped as well. I'll check that.=20

> If it is filtering by default (and even if it isn't, but you can make
> it), then I suppose you can keep it like that, and try to model your
> ports something like this:
>
> - force "ethtool -k swpN | grep rx-vlan-filter" to return "on (fixed)".
> - enforce a check that in standalone mode, you can't have an 8021q upper
>   interface with the same VLAN ID on more than 1 port at the same time.
>   This will be the only way in which you can terminate VLAN traffic on
>   standalone ports.
>
> If you do this, I think you should be compliant with the stack.

OK, great. I'll look into it.

>> OK. when a new driver should set the flag, then I'll set it. So, all
>> vlan requests programming requests should be "buffered" and executed
>> when vlan filtering is enabled? What is it good for?
>
> It is good for correct functionality of the hardware, I don't get the
> question? If your driver makes private use of VLAN tags beyond what the
> upper layers ask for, then it should keep track of them.

OK.

> DSA has, in the past, ignored VLAN switchdev operations from the
> bridge when not in vlan_filtering mode, for unknown reasons. This is
> known to break some command sequences (see below), so the consensus at
> the time was to stop doing that, and introduce this temporary
> compatibility flag.
>
> Some tests to make sure you're passing are:
>
> 1. Statically creating an 802.1Q bridge:
>
> ip link add br0 type bridge vlan_filtering 1
> ip link set swp1 master br0
> ip link set swp2 master br0
>
> 2. Dynamically turning an 802.1D bridge into an 802.1Q bridge:
>
> ip link add br0 type bridge
> ip link set swp1 master br0
> ip link set swp2 master br0
> ip link set br0 type bridge vlan_filtering 1
> # at this moment in time, if you don't have
> # configure_vlan_while_not_filtering =3D true, then the VLAN tables of
> # swp1 and swp2 will be missing the default_pvid (by default 1) of br0.

Yes, OK. I've observed this behavior myself and was confused about it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl9WPVUACgkQeSpbgcuY
8KZ6bw/+IQmb02UbQGGTBSPWRHx7aY33LrPV+SdvLni5E5FHY/DEtvRjaauE3Ckl
rEovJs4dRYKR5CaaAhwOlBueqjeJm5AsP6wMZYoux1sO/zOqJr6cejYscI5zQgPG
3DBnOxOvHuO2Ya7++jPE5ZRgQvAL4B4K5hvq8rSLgNRPUWRnmKkWMCVagdLkXsgh
sTIbkYMPRMOGuPAUKICxQwVXQv5kZKooFzQeQ6DsQu2xCalpV6KXFcsMo3E91v5d
MXf4mJ5JBc4xJbPysmw30PH1gBfhtebz9lWzK+PS+EihnEJ8LeVuNMq1tEWkQbdV
LTzRdb115koqRfD2Vhw4BPq562rTjHbodi0gJZhwGo5FzXdnQI6CqrFnyScjN96q
1NjSYpvBsR2YwyQp5vq+nMx0wvgIx+E6jsh+dI9vYQo5rLigGDJF5ECFZSvL5nN6
lSuwyq2fLd01QR3sEfbXoMENqC1bnUAdNjTMR47CJGEhI1YxblKXKBdeBV49pUsE
HKYHxVp8hDnKSbV5sQ1geifKeVSBEinUc1K7PR7U+afQTkfLzC7PmPDX91m6IWru
j730MnN6x2kDB5AsuEJsypPimYSc/XKGE0zVEuDuKH3QpocCRMjX6IEd98Y1PSBo
TBtXkF9u0W54wI3qqj8oIm0Qy3N9F0C7HogM8xsUUtfePI1JUL8=
=ZiYz
-----END PGP SIGNATURE-----
--=-=-=--
