Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE6AEA7D0A
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfIDHvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:51:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36569 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDHvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:51:05 -0400
Received: from [5.158.153.52] (helo=linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt.kanzenbach@linutronix.de>)
        id 1i5Q48-0007nx-3b; Wed, 04 Sep 2019 09:50:56 +0200
Date:   Wed, 4 Sep 2019 09:50:55 +0200
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com,
        weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH v1 net-next 10/15] net: dsa: Pass ndo_setup_tc slave
 callback to drivers
Message-ID: <20190904075055.GC8133@linutronix.de>
References: <20190902162544.24613-1-olteanv@gmail.com>
 <20190902162544.24613-11-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <20190902162544.24613-11-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 02, 2019 at 07:25:39PM +0300, Vladimir Oltean wrote:
> DSA currently handles shared block filters (for the classifier-action
> qdisc) in the core due to what I believe are simply pragmatic reasons -
> hiding the complexity from drivers and offerring a simple API for port
> mirroring.
>
> Extend the dsa_slave_setup_tc function by passing all other qdisc
> offloads to the driver layer, where the driver may choose what it
> implements and how. DSA is simply a pass-through in this case.
>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl1vbN4ACgkQeSpbgcuY
8KYllRAAx2pf4FS4kcV36xoKHGBkpQImyHJ1FPs+XL58kSm3nQBfsHhn6ole5lav
DqojGS/BC1jDC5ixretvQ14UVksidoskhoCsxZmJwQuDRQTBwrQ+SZnCHxvg+Rfb
tlXdHcQafcjcNTC0M0gXiwNDJ1gwhWdidbfNh/jQuoyWa8v7+PFVAaupOKqaObP1
P/BXNj8pVGQ0sruUqNlwzuidddCFpSqrgBFFLb6jTfN/TTuLa7T4oKoFMTQW2voh
nMRSKPqkcNVcYS1Y5nIqx3KVj7U++J69jVHY18DBSXldvDGJBLVxwzF9EXzu/d/4
KOA6bDAYAnEjwugK/HH5fbJ+5sWzB2jI07m52p4NUj+pQSzD42e6XpgUrFuifLxX
VGuLtuji+zvRR2ad3foq266URd60kaKJ81YYy3KpbtIXG6KG2MAzr5m+nfbgd8mV
8y+qKf1Ad051C+AF5JuGBTbHYMY+q/sEyP0OcVbE7hi9GXGDdNGt4PsgbVLw2q0s
yObtEgT1WHEM3N6JnvXl0v5OlGnO9mlEeInrMGq5u8wFlaksYyH2ZN2szckkaNAb
+G2sYLV158dYm12ZFCaUogSfo1zFj6SSXAio24VsGq8b/VuG/KKryERaYr3oXsbN
1L4rwuTW9rMtO66n1vLd+PRQmfDG/l7WnKOb0y7SCbGFRGTNuYc=
=IzCQ
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
