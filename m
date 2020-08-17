Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0624674B
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgHQNY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728421AbgHQNY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 09:24:59 -0400
X-Greylist: delayed 421 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 Aug 2020 06:24:58 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44E5C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 06:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1597670264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cde8ODjdi/Hj+eFzS40l/kA7hrIqtDcaKJsOWvcx2WQ=;
        b=w7GA85MncI06ABIFdKIExO0r2VkhqT1Erhwj4hogZmei4Rp+VTQnPvI0YH2hw6qMDgxWYx
        oUcs3yOIRvlsvYog/a+SV4BDpMmYF2quODDksBpWspuLyQ7igvgIo715zyYRmrrwKsfOs8
        ZNt+DRDsQCGcfzj9hxkwFu0/wumKVtY=
From:   Sven Eckelmann <sven@narfation.org>
To:     gluon@luebeck.freifunk.net
Cc:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Linus =?ISO-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org, openwrt-devel@lists.openwrt.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [gluon] Re: [RFC PATCH net-next] bridge: Implement MLD Querier wake-up calls / Android bug workaround
Date:   Mon, 17 Aug 2020 15:17:37 +0200
Message-ID: <1830568.o5y0iYavLQ@sven-edge>
In-Reply-To: <87zh6t650b.fsf@miraculix.mork.no>
References: <20200816202424.3526-1-linus.luessing@c0d3.blue> <87zh6t650b.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart6342531.2lmqPWkH4a"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart6342531.2lmqPWkH4a
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Monday, 17 August 2020 10:39:00 CEST Bj=F8rn Mork wrote:
> Linus L=FCssing <linus.luessing@c0d3.blue> writes:
[...]
> This is not a bug.  They are deliberately breaking IPv6 because they
> consider this a feature.  You should not try to work around such issues.
> It is a fight you cannot win.  Any workaround will only encourage them
> to come up with new ways to break IPv6.

Who are "they" and where is this information coming from? And what do they=
=20
gain from breaking IPv6? Wouldn't it be easier for them just to disable IPv=
6=20
than adding random looking bugs?

Kind regards,
	Sven
--nextPart6342531.2lmqPWkH4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAl86g3EACgkQXYcKB8Em
e0bRtRAA2L6EoJO3y15WlvlK1ULYj+TymlV73Y7yZXpT10K8bxN0MDte23AyoUJ8
yXtwtvbEFVOsOTU4nN+IUIYSUNS2+cs/JIWXMIdzSQ5xlGXEVQvcCnCWAQWDnwWY
OrLJ5VsFFewJPbQdImu4bc6M7WofDsZ+jYUDKEscqlKCNzhA2dNumIBwdLirTAIN
bPS52CZaBMLcFjBtdsaP7pLEGwyeiMb8K0/3WtjBfDlaE7X3mXuY2Lrgev8eDJaP
lWCMU+j8Wce2heirmI6FTGTUE7G19+4dJnbqSSiad5DXHI5d95KqJMzkAqqD+D7G
kqtTOLFBu91Q28SvfLs9zLXVrFf4lhgqJ5ZB9Q9F4KS58vMNp/7SIodjFUv6Hree
SjwAyadH8qDcwVAfw7pkX3ndTFceAoWn7pNNi7qgQQ6cyVTOxAqHloL8FoYoxJAo
zUTxF++G542bXFLbd+iwUdh38+x8uvyO3dnLFHvDFJHVz8kAWrtt3t3cdXaOCuUa
tLGlg713XRCJvUtaruwT9VrbB6i85pc5O7/TFZqqd571zf1GJW3BtayN/v1/6mr0
piGJVKLmy1rOG5p8z/zRZl8lAPh+5oytfsVPIEsEnfRU462o91I/3Af/o6sDo+s5
t9jUfcMlL0A8+sjVxegZlE8dwZsrep14u7mJHiR4dUsUqESjGF4=
=PUb1
-----END PGP SIGNATURE-----

--nextPart6342531.2lmqPWkH4a--



