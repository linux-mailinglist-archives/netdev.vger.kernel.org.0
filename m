Return-Path: <netdev+bounces-10184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C04472CB55
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:20:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0968A28112B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D64AD21CD1;
	Mon, 12 Jun 2023 16:20:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252831F18A;
	Mon, 12 Jun 2023 16:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09927C4339B;
	Mon, 12 Jun 2023 16:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686586802;
	bh=66ygMs0CwE4WNODEjHy6ZTSb3j/x/VhPTsfuj7GGvZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qX8K8vA1kYBzb9oDy5Fg/EbH+9pxFT9jRaDkTl4yIjrSxnyXnGf8/v4fSo5ULuzPo
	 ZvqBwVt+wWd0MKusRnD1zwvSiTLityRJH/Gm9w1vPrNb2kfsB9+EUkaH5RdQ8YNUTs
	 aE4tFCGtp/xPfaz5Pjnu2XeAZTX0hLD2YIFS6ITXosZkTnIv3SVtkvj7HR+kUK44QW
	 Na8EitDoGXOqz14pKq1sIbxbAnkR6dbLiHFwINksSHQ9kFGpIdfE82Q5xonMMSGMOZ
	 v5NVovwS5VCI/0KfAtp+Q239j+AloDGAy+C2kN7Y1zoVi2O5cyfYZaxIC7Q/TvvyRb
	 T6VlOblVODixA==
Date: Mon, 12 Jun 2023 18:19:58 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>,
	Andrey Rakhmatullin <wrar@wrar.name>,
	Linux regressions mailing list <regressions@lists.linux.dev>,
	linux-wireless@vger.kernel.org, Neil Chen <yn.chen@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>, Felix Fietkau <nbd@nbd.name>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev <netdev@vger.kernel.org>
Subject: Re: MT7922 problem with "fix rx filter incorrect by drv/fw
 inconsistent"
Message-ID: <ZIdFrtrvYPJEmEEE@lore-desk>
References: <ZGY4peApQnPAmDkY@durkon.wrar.name>
 <ad948b42-74d3-b4f1-bbd6-449f71703083@leemhuis.info>
 <ZGtsNO0VZQDWJG+A@durkon.wrar.name>
 <cd7d298b-2b46-770e-ed54-7ae3f33b97ee@leemhuis.info>
 <c647de2d-fbb5-4793-99b3-b800c95c04c2@leemhuis.info>
 <87jzw8g8hk.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BsS24y+nLkfMXEat"
Content-Disposition: inline
In-Reply-To: <87jzw8g8hk.fsf@kernel.org>


--BsS24y+nLkfMXEat
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Thorsten Leemhuis <regressions@leemhuis.info> writes:
>=20
> > [CCing the wifi-driver and the net developers, as a "JFYI" to ensure
> > they are aware of this "newer kernel requires newer firmware"
> > regression, so they can jump in if they want]
> >
> > On 22.05.23 16:12, Thorsten Leemhuis wrote:
> >> On 22.05.23 15:20, Andrey Rakhmatullin wrote:
> >>> On Mon, May 22, 2023 at 03:00:30PM +0200, Linux regression tracking
> >>> #adding (Thorsten Leemhuis) wrote:
> >>>> On 18.05.23 16:39, Andrey Rakhmatullin wrote:
> >>>>> Hello. I have a "MEDIATEK Corp. MT7922 802.11ax PCI Express Wireless
> >>>>> Network Adapter" (14c3:0616) and when the commit c222f77fd4 ("wifi:=
 mt76:
> >>>>> mt7921: fix rx filter incorrect by drv/fw inconsistent") is applied=
 (found
> >>>>> by bisecting, checked by reverting it on v6.3) I have the following
> >>>>> problem on my machine: when I connect to my router no DHCPv4 exchan=
ge
> >>>>> happens, I don't see responses in tcpdump. My network setup is non-=
trivial
> >>>>> though, and it looks like the problem is specific to it, but I still
> >>>>> wonder if it's some bug in the aforementioned patch as my setup wor=
ks with
> >>>>> all other devices and I would expect it to work as long as the netw=
ork
> >>>>> packets sent by the device are the same.
> >>>>>
> >>>>> My setup is as follows: I have an ISP router which provides a 2.4GHz
> >>>>> network and another router (Xiaomi R4AC with OpenWRT) connected by
> >>>>> Ethernet to it that provides a 5GHz network and is configured as a =
"Relay
> >>>>> bridge" (using relayd) to forward packets to the ISP router and bac=
k. This
> >>>>> includes DHCPv4 packets, which are handled by the ISP router. tcpdu=
mp on
> >>>>> the machine with MT7922 shows that the DHCP requests are sent while=
 the
> >>>>> responses are not received, while tcpdump on the bridge router show=
s both
> >>>>> requests and responses.
> >>>>>
> >>>>> I've tried connecting the machine to the ISP router network directl=
y and
> >>>>> also to another AP (one on my phone) and those work correctly on all
> >>>>> kernels.

@Andrey: IIUC the issue, you do not receive any DHCP offer/reply when
you try to connect to the OpenWrt 5GHz AP, right? If so, are you able to
provide a traffic sniff obtained from a monitor interface running on a node
connected to the same SSID when the MT7922 client is trying to connect?
It would be very helpful if you can run this test with encryption enabled
and disabled. Thanks in advance.

Regards,
Lorenzo

> >>>
> >>> Deren Wu asked me privately
> >>> if I'm using the latest firmware, and I
> >>> wasn't. I updated the firmware and now the problem doesn't happen.
> >>> The firmware where the problem happens is
> >>> mediatek/WIFI_RAM_CODE_MT7922_1.bin from the linux-firmware commit
> >>> e2d11744ef (file size 826740, md5sum 8ff1bdc0f54f255bb2a1d6825781506b=
),
> >>> the one where the problem doesn't happen is from the commit 6569484e6b
> >>> (file size 827124, md5sum 14c08c8298b639ee52409b5e9711a083).
> >>=20
> >> FWIW, just checked: that commit is from 2023-05-15, so quite recent.
> >>=20
> >>> I haven't
> >>> tried the version committed between these ones.
> >>> Not sure if this should be reported to regzbot and if there are any
> >>> further actions needed by the kernel maintainers.
> >>=20
> >> Well, to quote the first sentence from
> >> Documentation/driver-api/firmware/firmware-usage-guidelines.rst
> >>=20
> >> ```Users switching to a newer kernel should *not* have to install newer
> >> firmware files to keep their hardware working.```
> >>=20
> >> IOW: the problem you ran into should not happen. This afaics makes it a
> >> regression that needs to be addressed -- at least if it's something th=
at
> >> is likely to hit others users as well. But I'd guess that's the case.
> >
> > Well, until now I didn't see any other report about a problem like this.
> > Maybe things work better for others with that hardware =E2=80=93 in tha=
t case it
> > might be something not worth making a fuzz about. But I'll wait another
> > week or two before I remove this from the tracking.
>=20
> Yeah, this is bad. mt76 (or any other wireless driver) must not require
> a new firmware whenever upgrading the kernel. Instead the old and new
> firmware should coexist (for example have firmware-2.bin for the new
> version and firmware.bin for the old version). Then mt76 should first
> try loading the new firmware (eg. firmware-2.bin) and then try the old
> one (eg. firmware.bin).
>=20
> Should we revert commit c222f77fd4 or how to solve this?
>=20
> --=20
> https://patchwork.kernel.org/project/linux-wireless/list/
>=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

--BsS24y+nLkfMXEat
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZIdFrgAKCRA6cBh0uS2t
rFvHAQC/HF7WPXzq1TBtkFKpaFgI2U6lugnpL4ETiiqU7cXFzAEAmamMFlMiavIm
3tlI46PynTs8xJMHScp5uI+SIBMEOg4=
=KLdj
-----END PGP SIGNATURE-----

--BsS24y+nLkfMXEat--

