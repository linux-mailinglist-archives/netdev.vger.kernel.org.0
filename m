Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EED32D67DF
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404480AbgLJT7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404416AbgLJT7n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 14:59:43 -0500
Date:   Thu, 10 Dec 2020 20:58:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607630342;
        bh=s2+iLf6qBKVf58ffYZN9l2zof1I9JLW9V6wDx6uBGB8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=eklBHcybGU7NaHOQQv++7WWXgTVIXfU4CnRYhDTvdmMh828hU1HhwGuy262A7mXl3
         UVfMlgSR9hjmxiHEEmyAKdwE8N24GronEa9YX/3xByG12lhH5sLlYjOzWtARATmbU+
         gbjs//eYTsEVpjwIHW5m8/FwAch5WCZ79eUruF3gO37OfRXISugUzkUxi/tczLL5H1
         C81E6xkV7hUWEVha0XOmiWm7bl+CmN06kwTj6Wpcq+BBF8+02d6kP4fL05muxPEfXb
         pZ3KGXhlBNtOeEDWP9EZLwn/4dPMZS2smZLYs42jw9BUNf2bClh/cggGRtfKBSWABt
         n3IVdl/kI4rwg==
From:   Wolfram Sang <wsa@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Elie Morisse <syniurge@gmail.com>,
        Nehal Shah <nehal-bakulchandra.shah@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Andreas Larsson <andreas@gaisler.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Michael Chan <michael.chan@broadcom.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Jon Mason <jdmason@kudzu.us>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Daniele Venzano <venza@brownhat.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kevin Brace <kevinbrace@bracecomputerlab.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] dma-mapping: move hint unlikely for dma_mapping_error
 from drivers to core
Message-ID: <20201210195855.GA11120@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        George Cherian <gcherian@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Elie Morisse <syniurge@gmail.com>,
        Nehal Shah <nehal-bakulchandra.shah@amd.com>,
        Shyam Sundar S K <shyam-sundar.s-k@amd.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Andreas Larsson <andreas@gaisler.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Guy Tzalik <gtzalik@amazon.com>, Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com,
        Michael Chan <michael.chan@broadcom.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>, Jon Olson <jonolson@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, Jon Mason <jdmason@kudzu.us>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Jiri Pirko <jiri@resnulli.us>, Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Daniele Venzano <venza@brownhat.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Kevin Brace <kevinbrace@bracecomputerlab.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Nick Kossifidis <mickflemm@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Luca Coelho <luciano.coelho@intel.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, qat-linux@intel.com,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, wil6210@qti.qualcomm.com,
        b43-dev@lists.infradead.org, iommu@lists.linux-foundation.org
References: <5d08af46-5897-b827-dcfb-181d869c8f71@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <5d08af46-5897-b827-dcfb-181d869c8f71@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 10, 2020 at 03:47:50PM +0100, Heiner Kallweit wrote:
> Zillions of drivers use the unlikely() hint when checking the result of
> dma_mapping_error(). This is an inline function anyway, so we can move
> the hint into the function and remove it from drivers.
> From time to time discussions pop up how effective unlikely() is,
> and that it should be used only if something is really very unlikely.
> I think that's the case here.
>=20
> Patch was created with some help from coccinelle.
>=20
> @@
> expression dev, dma_addr;
> @@
>=20
> - unlikely(dma_mapping_error(dev, dma_addr))
> + dma_mapping_error(dev, dma_addr)
>=20
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Acked-by: Wolfram Sang <wsa@kernel.org> # for I2C


--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl/SffoACgkQFA3kzBSg
KbYcjxAAgOE4gHcgEP8+Oex1fposdP2Z4KiWFjIYYWG4fo/Ry9PjDbSGh9Nptht2
fnsCRcFXFj4oaSXaflBTq6ky4usgo2Gyp9puXbnpyj7P2uEjrqZs1zUFpAWdzMor
UgiJkW/P2IZjCDfwxE8nn9L0fm8ZfcHWqVohAgDh/9SKsrQCdzlzwvd7vSQ94fXr
qnYrmc6BF68dxVZx4TV18GddP5qFXYKytQ8pXL51XZEJTI05IGmc2l6hs/B4tKj6
muxiEFw5Ac0eseMimi4J5YDJJZxWe28onn69mMJYQDzVPqSZRyhSAqCv0EhMg6Vp
sABbG/eShtxir8A5ZrVRgqCaVyBjPu6pHAxdccHkj4d/6hfvD6F2FDXXaWirAf3i
A4gsMJAmxtBYV0Lyx0D+fzCFnvUSDDSOEayRJdzotQXVCbLvuWHTp6EXVJFD5mMU
/o3LApTC1uYQTXfGh1HHanpSEXLXfVgzjuDHRUsVIwemk5JwUAl6fw4oXbMrHYdZ
v9Inx4U81LGxayz1vGmzbE39AeE7YH/5lH4metjot96RpKa+Gg++mMxUHBPW6Jam
AOz6I3cKYsn7mPkzAZfDNvhvfgz2vxXcGGULSCdaWnVCJY7FMqe8i98w1z/Ymo7U
JSXmDUhFS43r0JqUfbR0sRGgLL+kHTEa6I4ZT8UNd9DmTtS0Jmo=
=4X1P
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
