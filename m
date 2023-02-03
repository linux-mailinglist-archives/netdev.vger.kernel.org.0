Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091D2688D0A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 03:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbjBCC0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 21:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBCC0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 21:26:35 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACC24741C;
        Thu,  2 Feb 2023 18:26:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P7KKM2fklz4xwt;
        Fri,  3 Feb 2023 13:26:31 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675391192;
        bh=icFT2EItQus7Dylw4jsLrPA9aj+5ZNs9mfl7Cxb1gFw=;
        h=Date:From:To:Cc:Subject:From;
        b=UB9II4ceqUYoMjxRxAyBdZvOepHvUcWQz9tgkdH8dP2A2xjo60G9VUODCOpLcUNUW
         r8RKy6cR2pAqgzAaCRWebeZLStJqPm3yVxPnx7u40wYH4puuGsBjaWOZHe++dQp3Vx
         4XOTcoQABVQVP2KETRFhwawH7XM62H7vzCVT86yCcRbyUQ2fIhDEjs9KCjf+cgGUnM
         dKv0UC4hpgGm0efDhkKsMR1uqdl137tpJU4tBFlkds1ol3In9ah0ERqV1RLzvy6ipC
         pmE5VJD56+bDPuoZc6cxTmlmoEZYk0rYJeof1Kxzm8kuivFNk8bo2cqRUsEDwFrG+c
         q45yvPD01bcJg==
Date:   Fri, 3 Feb 2023 13:26:29 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Networking <netdev@vger.kernel.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: duplicate patches in the vhost tree
Message-ID: <20230203132629.30cf161c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/783BGTTSd4b33Fmu8PmSwz2";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/783BGTTSd4b33Fmu8PmSwz2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

The following commits are also in Linus Torvalds' tree as different
commits (but the same patches):

  022659ee3363 ("virtio_net: notify MAC address change on device initializa=
tion")
  d0aa1f8e8d63 ("virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F_M=
AC is not set")

These are commits

  9f62d221a4b0 ("virtio_net: notify MAC address change on device initializa=
tion")
  7c06458c102e ("virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F_M=
AC is not set")

in the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/783BGTTSd4b33Fmu8PmSwz2
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPccNUACgkQAVBC80lX
0Gz/Hgf/WXdBDXn1v7M9nnVxsbZJQplfFlitevFal2El09K8fIw5MAMJHaSieDgS
R0TDuPIurmjQMMpBur3M/OqI6kxbxM3LNlvGNEPbMlbPvu2EWpU4HIO7zF3lRqVZ
oxc++Br0NAbZD0/9DvJNVDrRmQAfTBO+GRVskRuuBfe5Q9CAgQH0JzF/Sg5dPawZ
WaHi3AQq3slTwPXkvEQbqWUFthvkjBBQ894xR2Z8kd6FVHzkOymeG2dDhW5S1Dvi
Jsb492jxAcJKnhoUHkyCK0U7vYOMqkQ8xrbKYB9ILSH1K6FVKp1PUm4N2wrD3XRO
txwtd9E41W/av2jp3FVwTfIm/hXH0w==
=FKvM
-----END PGP SIGNATURE-----

--Sig_/783BGTTSd4b33Fmu8PmSwz2--
