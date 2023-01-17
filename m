Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6826966DC3F
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbjAQLWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbjAQLWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:22:06 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F3281ABE5;
        Tue, 17 Jan 2023 03:21:45 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id 9AF362F2022C; Tue, 17 Jan 2023 11:21:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 1303E2F2022A;
        Tue, 17 Jan 2023 11:21:42 +0000 (UTC)
Date:   Tue, 17 Jan 2023 14:21:41 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Chi-hsien Lin <chi-hsien.lin@cypress.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix allocation size
Message-ID: <20230117112141.GB15213@altlinux.org>
References: <20230117104508.GB12547@altlinux.org>
 <87o7qxxvyj.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <87o7qxxvyj.fsf@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-01-17 13:05:24 +0200, Kalle Valo wrote:

 >> - buf_size +=3D (max_idx + 1) * sizeof(pkt);
 >> + buf_size +=3D (max_idx + 1) * sizeof(struct sk_buff);
 > Wouldn't sizeof(*pkt) be better?

Usually sizeof(type) produces less errors than sizeof(var)...

 > Just like with sizeof(*rfi) few lines above.

=2E.. but to keep consistency sizeof(*pkt) would also be ok.


--=20
Alexey V. Vissarionov
gremlin =F0=F2=E9 altlinux =F4=FE=EB org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJjxoTFAAoJEFv2F9znRj5KegUQAKzzGOsvMlqH7llqYiZ04Nir
OYBXVb7BsV1LS1JIIQGAa/mYL9c204/7+y+aDTJ0JQbupNAzXSGPngTUTi7qXchM
HvLke4lsI+c/PX+DrS+n5QGI3J4fOlvVDHN2v32S+TQPgd/azzJ19Gvh7Vp/Kjpo
G2zEKkvr9iedtwG81TDC+9XI2fNuywcaOE8Lfwu/ihyqF6vR4P+BoT/yX2sZCsqm
rhcbQ/BfJgYYxeFLHSCmNgjMVDx7N+faneKKL15dYWttBa6ihvvV0fP3z2zIlHN/
w7w5A6CD3kMmHYSNfNWTXg7QSWi44jZE1C1cFELVx1EGkUBzBN1vdIYC5EV9nDEm
66+2SBSi8IAmW7sTrRD/VuE1IAhzkCM4Hw9HCpY26SXXhzm/Z9gNeeE+jo4zKEwd
ZIlZ3MfOZEpZxziXnRJpiG/P4SUiWft1o+GkoJIT0L+5N9FR6x0CBCMP+C4wcMoR
eJR0OR/zhvimxAI8ms4ol6ofi44ShRYJT2G6X4lFcV2jOa8EYtVut0YT2BckTUVA
AqGoR5sZ3Tj1kXApmNE1D1jCOCjLRmDoo4Edvy/BagG7Qlov6TegQ6DR9jfsboBX
sP0N+/v1txi8HL+Mz+ZxFT5nPUY7C3HRLRKiwBBjU1SJbSjdR2rLxdgcusWwvrVt
ds7cOX1SHN0OOzt67rZ6
=vt5V
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
