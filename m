Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB320044D
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731419AbgFSIrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgFSIrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:47:47 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC24C06174E;
        Fri, 19 Jun 2020 01:47:46 -0700 (PDT)
Received: from [5.158.153.52] (helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jmCga-0004c7-Mg; Fri, 19 Jun 2020 10:47:44 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for Hellcreek switches
In-Reply-To: <20200618134704.GQ249144@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-10-kurt@linutronix.de> <20200618134704.GQ249144@lunn.ch>
Date:   Fri, 19 Jun 2020 10:47:43 +0200
Message-ID: <87zh8zphlc.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Andrew,

On Thu Jun 18 2020, Andrew Lunn wrote:
>> +Ethernet switch connected memory mapped to the host, CPU port wired to gmac0:
>> +
>> +soc {
>> +        switch0: switch@0xff240000 {
>> +                compatible = "hirschmann,hellcreek";
>> +                status = "okay";
>> +                reg = <0xff240000 0x1000   /* TSN base */
>> +                       0xff250000 0x1000>; /* PTP base */
>> +                dsa,member = <0 0>;
>> +
>> +                ports {
>> +                        #address-cells = <1>;
>> +                        #size-cells = <0>;
>> +
>> +                        port@0 {
>> +                                reg = <0>;
>> +                                label = "cpu";
>> +                                ethernet = <&gmac0>;
>> +                        };
>> +
>> +                        port@2 {
>> +                                reg = <2>;
>> +                                label = "lan0";
>> +                                phy-handle = <&phy1>;
>> +                        };
>> +
>> +                        port@3 {
>> +                                reg = <3>;
>> +                                label = "lan1";
>> +                                phy-handle = <&phy2>;
>> +                        };
>> +                };
>> +        };
>> +};
>> +
>> +&gmac0 {
>> +        status = "okay";
>> +        phy-mode = "mii";
>> +
>> +        fixed-link {
>> +                speed = <100>;
>> +                full-duplex;
>
> Hi Kurt
>
> The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do you
> need some properties in the port@0 node to tell the switch to only use
> 100Mbps? I would expect it to default to 1G. Not looked at the code
> yet...

No, that is not needed. That is a hardware configuration and AFAIK
cannot be changed at run time.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7se68ACgkQeSpbgcuY
8Ka0Nw//R69dCJB8c6OO+8xewEAX+LjZceywkiETCKDnq+fqXzkZc7OPhYBQViBR
ARXcIAPlqG0+BBrmS5ttaIR3vfzLRxUJmeUHW521a55tCnD0d1A7LJo8HNap/5rO
zVpidl5OcDELabjB7KRatOKnItYS21kkotwOX9BKAXHixcC+V3+0w7NSu13nLLmi
pT/jR+bU29ttPTA6Q70xKYDrz3h+i3zAgFEF4h57H4PfJIeSJtNOTseEmNHP8l23
S38wuDGSU1ZeJ7QJY/lQoyX3qvXmCR6MXuQbfi78kMRSzIGZJwfp3xR5eNAyf44i
D2vClwcV591PqjkTwljjjufnu3l8CCHyL1jFHWyJiEDXYwtStnmiCyM6TRw6vGwH
UncgkiEDhyymBwfahdbAV9SS+H28ng0kBG7r6NwFa1s1g4SJIof+IvqdBfV281nt
t6NAtA/cU7yM3eUG0urX9q1Bmxwp7HOSyfEOIJb9WwTcrR5NvEHvW2Wqu6Z/V/MZ
sa9/R3RyJFuNLRmwBI6mXx78nsvbC2sB/b2GIP55QZvgFXlQeBsoZgzp0mk9baLw
jIz4IyU9jHAP1AZYwmHr4uNoekPj3en6n6yvO5PZgqFX+oCkCGdOYfm+jRzTXjyu
GelCRIQODeI3j48laE6jajwYqt57k2xyBkWZYOVPc8qUGQ8qAz4=
=DTYQ
-----END PGP SIGNATURE-----
--=-=-=--
