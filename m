Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E710B46B
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 18:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfK0R2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 12:28:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:49878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726292AbfK0R2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Nov 2019 12:28:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 25895AF22;
        Wed, 27 Nov 2019 17:28:39 +0000 (UTC)
Message-ID: <eccd6a23d8dbc577058c538fa4ef79ba376cd04a.camel@suse.de>
Subject: Re: [PATCH v3 0/7] Raspberry Pi 4 PCIe support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     andrew.murray@arm.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, james.quinlan@broadcom.com,
        mbrugger@suse.com, f.fainelli@gmail.com, phil@raspberrypi.org,
        wahrenst@gmx.net, jeremy.linton@arm.com, linux-pci@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-rockchip@lists.infradead.org,
        iommu@lists.linux-foundation.org
Date:   Wed, 27 Nov 2019 18:28:35 +0100
In-Reply-To: <20191126215020.GA191414@google.com>
References: <20191126215020.GA191414@google.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-LD8Ga7xd6xkOxp2WErAx"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-LD8Ga7xd6xkOxp2WErAx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

On Tue, 2019-11-26 at 15:50 -0600, Bjorn Helgaas wrote:
> On Tue, Nov 26, 2019 at 10:19:38AM +0100, Nicolas Saenz Julienne wrote:
> > This series aims at providing support for Raspberry Pi 4's PCIe
> > controller, which is also shared with the Broadcom STB family of
> > devices.
> > Jim Quinlan (3):
> >   dt-bindings: PCI: Add bindings for brcmstb's PCIe device
> >   PCI: brcmstb: add Broadcom STB PCIe host controller driver
> >   PCI: brcmstb: add MSI capability
>=20
> Please update these subjects to match the others, i.e., capitalize
> "Add".  Also, I think "Add MSI capability" really means "Add support
> for MSI ..."; in PCIe terms the "MSI Capability" is a structure in
> config space and it's there whether the OS supports it or not.
>=20
> No need to repost just for this.

Noted, I'll update them.

Regards,
Nicolas


--=-LD8Ga7xd6xkOxp2WErAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3eskMACgkQlfZmHno8
x/60Swf/Rwz7o3DibuLSdZZBrCQ9sK0AToOIKPKSSquZNgW7MKr1ByJjnNAS9/4r
9N3namc6tZJcCE7C+QKKVcikyMR0ENUSovq0hrCA6WCiUipefFyD22H/WEtsWvHf
1QcGifBBN6mjLDS1DSnBTPiDAVqWm5w1celUlauXFZAZc5YQftSwRQRVkZui2q9H
aljeQuVsPZ+CfdOFgqo1xlwJvk+BbfDIxgQ+cg4du/tS3enlrrMspevtkEw/awv9
aZl62mLNRTUPlsHW07akov+GIKROrknLnBTqiCKLg0Ei7J3dTo3Su/wzSyZQw7H4
hOq7QZ/9Qezc3LUiCtuauS3v8a6ang==
=dKU6
-----END PGP SIGNATURE-----

--=-LD8Ga7xd6xkOxp2WErAx--

