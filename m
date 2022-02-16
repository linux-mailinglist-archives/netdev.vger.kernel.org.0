Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2744B8CF3
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiBPPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:55:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235747AbiBPPzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:55:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D9295FE6;
        Wed, 16 Feb 2022 07:55:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB97B61A5A;
        Wed, 16 Feb 2022 15:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3390C004E1;
        Wed, 16 Feb 2022 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645026901;
        bh=eE1+ZOG+o56GVBrCD53cuQ0ru/sUiq3uQkgLPoUhz1w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vPR17qhqgiXT9d/mA/vVROVXEvcaOdNU2jYiED4+XYWO4YWvqlDpBs3ektG2BKQ22
         W0jitEPCFWpGcxdGObCRU3IJyzxSE1qoE9AIIN6qmej72SEVsVke9nj7U39vxg3VjR
         AYKbhIOOGT9YCTd5Wpu+sUjeV8S+5iJaO67pKfia6RpeBqS7GwGStPzypOYYdYjW20
         307hpDvq/Bh1PvQM/bnJ6vQILwNnaSN6WGR71fk4SndK58an360cyUYnvCp+fhdrik
         Qc8GeS9IB8CGEoxTlSVJPdxleADPNzpJGr1PNrxwq/pEKsYR+JbgOzFLdboXsV7y+y
         A5YhejyNAovww==
Date:   Wed, 16 Feb 2022 16:54:54 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH net-next v5 1/2] dt-bindings: net: New binding
 mctp-i2c-controller
Message-ID: <Yg0eTtiChnmfJeqX@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Rob Herring <robh@kernel.org>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
 <20220210063651.798007-2-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u2d3AB3C5u+1/++1"
Content-Disposition: inline
In-Reply-To: <20220210063651.798007-2-matt@codeconstruct.com.au>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--u2d3AB3C5u+1/++1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 10, 2022 at 02:36:50PM +0800, Matt Johnston wrote:
> Used to define a local endpoint to communicate with MCTP peripherals
> attached to an I2C bus. This I2C endpoint can communicate with remote
> MCTP devices on the I2C bus.
>=20
> In the example I2C topology below (matching the second yaml example) we
> have MCTP devices on busses i2c1 and i2c6. MCTP-supporting busses are
> indicated by the 'mctp-controller' DT property on an I2C bus node.
>=20
> A mctp-i2c-controller I2C client DT node is placed at the top of the
> mux topology, since only the root I2C adapter will support I2C slave
> functionality.
>                                                .-------.
>                                                |eeprom |
>     .------------.     .------.               /'-------'
>     | adapter    |     | mux  --@0,i2c5------'
>     | i2c1       ----.*|      --@1,i2c6--.--.
>     |............|    \'------'           \  \  .........
>     | mctp-i2c-  |     \                   \  \ .mctpB  .
>     | controller |      \                   \  '.0x30   .
>     |            |       \  .........        \  '.......'
>     | 0x50       |        \ .mctpA  .         \ .........
>     '------------'         '.0x1d   .          '.mctpC  .
>                             '.......'          '.0x31   .
>                                                 '.......'
> (mctpX boxes above are remote MCTP devices not included in the DT at
> present, they can be hotplugged/probed at runtime. A DT binding for
> specific fixed MCTP devices could be added later if required)
>=20
> Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
> Reviewed-by: Rob Herring <robh@kernel.org>

Acked-by: Wolfram Sang <wsa@kernel.org>


--u2d3AB3C5u+1/++1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmINHkkACgkQFA3kzBSg
KbYWQQ//T0o6sAFYpqHYgqQJC9nytNVfRU3yp4Q8LKKpkVW7gZJetq7TtiGYTb4g
iSydYQGckhPUVt2f7xsdvkEhm3fXtlD5T/T83pgB8nNIkCxlpzIOouv+jE+WG42x
zFVUutvUV536WsXdYQ7COEasoa+k3W3kBZemOfvh0QcDbubswuSdf3yMezI9BE4y
mpovo/lBXQEG5NTzQDBUJ5jg0UzHl0P/jc2OU0gQ/tLP1H8nC6JG4KlPbF/E0A2r
I+iy9NgaI1nRka/3e7ylB8ejmNsrv1LWNtP5TFmEB/L3pV/IJ+/Sd639oyUN2+OY
WvdItszZHOWa1X6rlft9/IJudrev3XA9QzHm+2lksjJAozhXkUXHQTD1etPZLFZM
J1bcVHhqwiy2zzgRcOfJ6113FDlMWR7DkG9ocoQ0n/ic6xyS1YNktJBFEdmNKeBD
SinABwdhIbsPDfAHx/X0n0K9yAZemoJu2ZeLMsivuoTIDpSKuVH7js1SzQuBhqgR
hvfJjg9AW4YUW/uatwBRX1TP5vBuxCJEzVjsCophVLlIPAkASrFoAeXf47xa/N3S
StC1EJlF52wI+iSJ9441Xds7kpk45nza+vXJ1h1nA8P76dn6zbwssp+S8oWhbVZd
coC8Tc2m02xdzRHjieuqSiPT5pv68f0rdE6Xg5Qg4VfcfGRDkU4=
=8P1o
-----END PGP SIGNATURE-----

--u2d3AB3C5u+1/++1--
