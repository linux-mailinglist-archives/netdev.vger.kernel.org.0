Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD33620497C
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730406AbgFWGFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbgFWGFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:05:16 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A41C061573;
        Mon, 22 Jun 2020 23:05:15 -0700 (PDT)
Received: from p5b06d650.dip0.t-ipconnect.de ([91.6.214.80] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1jnc3T-0001rS-Sh; Tue, 23 Jun 2020 08:05:12 +0200
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "open list\:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [RFC PATCH 6/9] net: dsa: hellcreek: Add debugging mechanisms
In-Reply-To: <CA+h21hokLntfn7sDW-6boJ+=_q2CGUM6aXLg68O7moMyLH=41w@mail.gmail.com>
References: <20200618064029.32168-1-kurt@linutronix.de> <20200618064029.32168-7-kurt@linutronix.de> <20200618173458.GH240559@lunn.ch> <875zbnqwo2.fsf@kurt> <20200619134218.GD304147@lunn.ch> <87d05rth5v.fsf@kurt> <CA+h21hokLntfn7sDW-6boJ+=_q2CGUM6aXLg68O7moMyLH=41w@mail.gmail.com>
Date:   Tue, 23 Jun 2020 08:04:52 +0200
Message-ID: <87k0zynwqj.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Vladimir,

On Mon Jun 22 2020, Vladimir Oltean wrote:
> Hi Kurt,
>
> On Mon, 22 Jun 2020 at 15:34, Kurt Kanzenbach <kurt@linutronix.de> wrote:
>>
>>  * Re-prioritization of packets based on the ether type (not mac address)
>
> This can be done by offloading a tc skbedit priority action, and a
> "protocol" key (even though I don't understand why you need to mention
> "not mac address".

Thanks. That seems like it can be used. I did mention the mac address,
because the switch has two ways of doing a re-prioritization either by
fdb entries via mac addresses or by the high level inspection (HLI)
based on the ether type.

>
>>  * Packet logging (-> retrieval of packet time stamps) based on port, traffic class and direction
>
> What does this mean? tcpdump can give you this, for traffic destined
> to the CPU. Do you want to mirror/sample traffic to the CPU for debug?
>

The switch can capture timestamps (nanoseconds) when packets have been
transmitted or received on all ports. The timestamps are stored in a
FIFO and can be retrieved later. As you said tcpdump only works for
packets at the CPU port. This feature is useful for debugging latency
issues for specific traffic flows.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl7xm4QACgkQeSpbgcuY
8KYtqg//YMqDjYW5NqDvv07mkc2Z4riBVwSakOje7N6ELkYUvtOP2BxXaehF6+Wp
Qa29hYs/uD7+rhDPY88lFuX/jP3baF5r3axEOzQNBq95saMNRAZqjhgrufCU7EIK
HUakdPLLbvlBAM6hGJ8mMkGYhpWOoJkejN0VBHmTwbE58b5YiLVAmpD+zTzvPhs2
R0v9BlF1lQRW2HHsx4YWakk8/k9e0CNYscR8zHuR1htQQiiJwmta4zzHPNRH/TXi
ECSCP4vh6iCZVsg7fA2tBc07iBKJHNLx5WIlrFrmwsBOKUuKkNsSgybpkIUXFn0T
QKjbIN1Kk71WHYN+fRgCGVKOSeQGsvMAVydU+JPC4q/nrlBFktsAXuv6f0shwQOE
5Cf+qY6o+cZ0So489711Qna1+wPyCV8bwXT6JLs+YB4P+FNJe6FH0YaQAa4IMbvk
Gz1olAx9hUhK6+WaIejXbnknKIUd6qA0Qz+4XwxQmebU55etg4yGWlMk4IeFI2m1
ejlcNHZHf6Kqf0l/6W9BwQHjR7TAqDgL6gqNyGdKDPbbpcxUfHrVDEvcUlnxkIvW
KOoOykcsSmNX5V8VWHqgyA/oeMSBn7kINXOryZkirXfH4doAIVpisQSAP8AdDDVc
KYwVC6iqM7XPnchNTvLBGjOTkIpoF0M529Feuxlp/R1YDFIDJYs=
=GYlY
-----END PGP SIGNATURE-----
--=-=-=--
