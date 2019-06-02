Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E956322D2
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFBJje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 05:39:34 -0400
Received: from mail.z3ntu.xyz ([128.199.32.197]:50182 "EHLO mail.z3ntu.xyz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfFBJje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Jun 2019 05:39:34 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Jun 2019 05:39:32 EDT
Received: from g550jk.localnet (188-23-224-77.adsl.highway.telekom.at [188.23.224.77])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id CB64EC62FD;
        Sun,  2 Jun 2019 09:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1559468008; bh=pQdvPMLIBmdIcqXAkWH+WvQdnCpnkFRtt4HIJgSnwC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=mvP5P3mXB/dB/BvooP+TNehmDN6t1qMkvdl5CKdYRgltnKJO9kpa7fU37fFxFDiy4
         0UXkiSOpD3TQfZGcOQZdzeS6m8IU7DMfmUKH9kfPRpppTaxnQhtnGTx3v+SfBowUxH
         uTH0vnS1/M55LTnxWhCcMDZFJK5uo7VMp+SuBl1E=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, Vasily Khoruzhick <anarsoul@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        devicetree <devicetree@vger.kernel.org>,
        arm-linux <linux-arm-kernel@lists.infradead.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>
Subject: Re: [PATCH 3/8] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Sun, 02 Jun 2019 11:33:19 +0200
Message-ID: <3444508.DTbMFtmaYk@g550jk>
In-Reply-To: <CAL_Jsq+kqFrY3DoHG_TJCCSxVHRkin4OwM+F9qm6W0w5YfjPQQ@mail.gmail.com>
References: <20190118170232.16142-1-anarsoul@gmail.com> <CA+E=qVdq5GORg-t-vVXM3zBxy3Aq93iCE+zmcGgLFBMcnTDgfw@mail.gmail.com> <CAL_Jsq+kqFrY3DoHG_TJCCSxVHRkin4OwM+F9qm6W0w5YfjPQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8714085.0COXUpWfup"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart8714085.0COXUpWfup
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 19. Februar 2019 15:14:01 CEST Rob Herring wrote:
> > > How is this used?
> > 
> > rtl8723bs-bt needs 2 firmware binaries -- one is actual firmware,
> > another is firmware config which is specific to the board. If
> > firmware-postfix is specified, driver appends it to the name of config
> > and requests board-specific config while loading firmware. I.e. if
> > 'pine64' is specified as firmware-postfix driver will load
> > rtl8723bs_config-pine64.bin.
> 
> We already have 'firmware-name' defined and I'd prefer not to have
> another way to do things. The difference is just you have to give the
> full filename.
> 

Hi Rob,

I'm working on a v2 for this patchset and I've looked on how using "firmware-
name" with the full filename would be possible but as David Summers has already 
written [1], the existing code [2] takes this "postfix" as parameter and 
basically fills it into a filename template ("${CFG_NAME}-${POSTFIX}.bin"). So 
either we stay with the "firmware-postfix" property or the existing code would 
have to be modified to accomodate the full filename; but if using firmware-postfix 
is unacceptable, I can rework the existing code.

Luca

[1] https://lore.kernel.org/netdev/d06e3c30-a34a-bd84-9cdf-535f253843e3@davidjohnsummers.uk/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/
drivers/bluetooth/btrtl.c#n566
--nextPart8714085.0COXUpWfup
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE66ocILd+OiPORlvAOY2pEqPLBhkFAlzzl98ACgkQOY2pEqPL
BhnnFA//VC5cSighumkwqn1tDlKT2am98yezWEof4TyDc9ep57nBLBfxfVi/J9o7
S3uuBW876kpDuh5jCZ9jc7ajY/HOVk2kP63WklFmCPrFSatDw8JGaNV03cnbgV4z
NFZh3Vgnouz+9ELHRG6o2gQiQgu4FLHrQZWzHoccDS5RmerDEFN+1/LYEQuPuFay
WzXUcwNW4STqqQrw0AqfR61Gws1JarHMqShEmvI/5OEdfCFBlVu7uEkyMhQgurNO
dz6Nc6KQQKPV6xBHDAHnTtXKauBENpAe8GSZyIcqpDdIIMzLm/xP1uSG7E9W2yQ8
8YI62hXxCuKcLqNhMmmlxtnR4zQPpqV8b0bMlTHqZ/xdMsiksx/dgagafvPorvRs
U76IRzgrye43KpLQQEmYZxCVjrvtI6RAPY764AfdwoUpo17VEUrmT40W1NkmsPyQ
zo8m3Sl8DIvbxPTOSivZeMpN5GdgkCBT9mEQbYEkdMlDf+mUVOJBqZSNyfimwqL5
mvtTWXneuQmpRrrIhugsO0T0fLEUqTzddawDOgA3r3f6KjQQ6JnGA7FOfF8eJNeO
8uwK36whihKCYqUaUJaWSayF6VZVV4uurjyOMccHD+h1dYiNRBOLxcEns2XiWftw
fcKG10h3MfKscapGVYL6HegnxTnmTSDdeb3CD+v7aP57RIqLb0g=
=np+i
-----END PGP SIGNATURE-----

--nextPart8714085.0COXUpWfup--



