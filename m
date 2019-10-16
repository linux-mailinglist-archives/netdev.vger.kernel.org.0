Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF91D9792
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406362AbfJPQiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:38:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404133AbfJPQiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 12:38:50 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A93DA2168B;
        Wed, 16 Oct 2019 16:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571243929;
        bh=2EbE5nCvBEahpTJRgdzbU+ZqH1XFFPH0hQubllFojTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oDkqPdDvSSDhHSvsl5C23d7W91uPZeZBaVZReevBDWbOtujC1uix3thzYza0xijWz
         1tsGgY9xtWIMSDkx7gZx3+XmQ5nkQ9A4MJy9jgBY4rpjeA/Culjl+yoKiI06S8l56F
         iLbFPusGl+0jbxjImLSBDPwuaQh1cmAubSPvgAoc=
Date:   Wed, 16 Oct 2019 18:38:42 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-mediatek@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt76x2e hardware restart
Message-ID: <20191016163842.GA18799@localhost.localdomain>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
 <9d581001e2e6cece418329842b2b0959@natalenko.name>
 <20191012165028.GA8739@lore-desk-wlan.lan>
 <f7695bc79d40bbc96744a639b1243027@natalenko.name>
 <96f43a2103a9f2be152c53f867f5805c@natalenko.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <96f43a2103a9f2be152c53f867f5805c@natalenko.name>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hello.
>=20
> On 15.10.2019 18:52, Oleksandr Natalenko wrote:
> > Thanks for the answer and the IRC discussion. As agreed I've applied
> > [1] and [2], and have just swapped the card to try it again. So far,
> > it works fine in 5 GHz band in 802.11ac mode as an AP.
> >=20
> > I'll give it more load with my phone over evening, and we can discuss
> > what to do next (if needed) tomorrow again. Or feel free to drop me an
> > email today.
> >=20
> > Thanks for your efforts.
> >=20
> > [1]
> > https://github.com/LorenzoBianconi/wireless-drivers-next/commit/cf3436c=
42a297967235a9c9778620c585100529e.patch
> > [2]
> > https://github.com/LorenzoBianconi/wireless-drivers-next/commit/aad256e=
b62620f9646d39c1aa69234f50c89eed8.patch
>=20
> As agreed, here are iperf3 results, AP to STA distance is 2 meters.
>=20
> Client sends, TCP:
>=20
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.00  sec  70.4 MBytes  59.0 Mbits/sec  3800
> sender
> [  5]   0.00-10.03  sec  70.0 MBytes  58.6 Mbits/sec
> receiver
>=20
> Client receives, TCP:
>=20
> [ ID] Interval           Transfer     Bitrate         Retr
> [  5]   0.00-10.06  sec   196 MBytes   163 Mbits/sec  3081
> sender
> [  5]   0.00-10.01  sec   191 MBytes   160 Mbits/sec
> receiver
>=20
> Client sends, UDP, 128 streams:
>=20
> [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total
> Datagrams
> [SUM]   0.00-10.00  sec   160 MBytes   134 Mbits/sec  0.000 ms  0/115894
> (0%)  sender
> [SUM]   0.00-10.01  sec   160 MBytes   134 Mbits/sec  0.347 ms  0/115892
> (0%)  receiver
>=20
> Client receives, UDP, 128 streams:
>=20
> [ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total
> Datagrams
> [SUM]   0.00-10.01  sec   119 MBytes  99.4 Mbits/sec  0.000 ms  0/85888 (=
0%)
> sender
> [SUM]   0.00-10.00  sec   119 MBytes  99.5 Mbits/sec  0.877 ms  0/85888 (=
0%)
> receiver
>=20
> Given the HW is not the most powerful, the key point here is that nothing
> crashed after doing these tests.

Hi Oleksandr,

thx a lot for testing these 2 patches. Now we need to understand why the ch=
ip
hangs if we enable scatter gather dma transfer on x86 while it is working f=
ine
on multiple mips/arm devices (patch 2/2 just disable it for debugging).

Regards,
Lorenzo

>=20
> --=20
>   Oleksandr Natalenko (post-factum)

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXadHkAAKCRA6cBh0uS2t
rJ1WAP9tpX4oSA7UhRs0gQT0nQOQJ1ONxMOdUZiEXY1VQ8+BngD+KS/CMITu8+px
nJSFzOS5A5KbCSWMJoLBxp4D4TebrgQ=
=JdPS
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
