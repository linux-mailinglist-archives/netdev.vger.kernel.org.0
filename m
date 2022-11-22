Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C66C633B46
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 12:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiKVL0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 06:26:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbiKVL0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 06:26:13 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D03663BA9;
        Tue, 22 Nov 2022 03:20:05 -0800 (PST)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 0A603FF80E;
        Tue, 22 Nov 2022 11:19:59 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     "Bonaccorso, Salvatore" <carnil@debian.org>,
        "Kumar, M Chetan" <m.chetan.kumar@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>
Subject: Re: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type [-Werror=incompatible-pointer-types]
Date:   Tue, 22 Nov 2022 12:19:48 +0100
Message-ID: <2659493.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <3150689.e9J7NaK4W3@bagend>
References: <Y3aKqZ5E8VVIZ6jh@eldamar.lan> <SJ0PR11MB500875E67568132D3D4EBCB1D70A9@SJ0PR11MB5008.namprd11.prod.outlook.com> <3150689.e9J7NaK4W3@bagend>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart12100934.O9o76ZdvQC"; micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart12100934.O9o76ZdvQC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Diederik de Haas <didi.debian@cknow.org>
Date: Tue, 22 Nov 2022 12:19:48 +0100
Message-ID: <2659493.mvXUDI8C0e@bagend>
Organization: Connecting Knowledge
In-Reply-To: <3150689.e9J7NaK4W3@bagend>
MIME-Version: 1.0

The procedure missed an important step, added below:

On Monday, 21 November 2022 15:16:52 CET Diederik de Haas wrote:
> # Clean things up and do the actual build
> $ dpkg-architecture -c fakeroot debian/rules maintainerclean
> $ dpkg-architecture -c debian/rules orig

$ dpkg-architecture -c debian/rules debian/control

> $ time dpkg-architecture -c fakeroot debian/rules binary-indep
> $ time dpkg-architecture -c fakeroot debian/rules binary-arch


--nextPart12100934.O9o76ZdvQC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQT1sUPBYsyGmi4usy/XblvOeH7bbgUCY3ywVAAKCRDXblvOeH7b
bmm1AQDHpcQos/9jAv5ham2VJ1VA2g72u6LuRkGpogEP9DdVJQEAo3cKijBtBEt/
KMBzlwKplJ42AayWF0Qp5JsH0AOcigU=
=mR+/
-----END PGP SIGNATURE-----

--nextPart12100934.O9o76ZdvQC--



