Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B468050E0CB
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241944AbiDYMyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 08:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241984AbiDYMyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 08:54:03 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA2C184;
        Mon, 25 Apr 2022 05:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1650891042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RuGwl2hwKjdiBN+xQt2K7PK+6H9hVtI6INGqk1BZ3MQ=;
        b=bzC/NVfpIoMtLD1rLqbV0/KYVQ8RveWKmFoVna65i6PQYMW8wk/hdMPr7uRQJQyu+I7Adc
        vmlc3JHfTnyOeL7KbhGPhOWgQWES7gBPWZKeCjFzNEtfliiyGxir6F8jPCdkWUX8QRC18B
        atZa9HuSx+aSRrtVEEoUldXSoWX5c4k=
From:   Sven Eckelmann <sven@narfation.org>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        Yu Zhe <yuzhe@nfschina.com>
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liqiong@nfschina.com,
        kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Date:   Mon, 25 Apr 2022 14:50:38 +0200
Message-ID: <2133162.nbW41nx31j@ripper>
In-Reply-To: <20220425113635.1609532-1-yuzhe@nfschina.com>
References: <20220421154829.9775-1-yuzhe@nfschina.com> <20220425113635.1609532-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1665509.GfMoWaoWtX"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart1665509.GfMoWaoWtX
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, Yu Zhe <yuzhe@nfschina.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, liqiong@nfschina.com, kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Date: Mon, 25 Apr 2022 14:50:38 +0200
Message-ID: <2133162.nbW41nx31j@ripper>
In-Reply-To: <20220425113635.1609532-1-yuzhe@nfschina.com>
References: <20220421154829.9775-1-yuzhe@nfschina.com> <20220425113635.1609532-1-yuzhe@nfschina.com>

On Monday, 25 April 2022 13:36:35 CEST Yu Zhe wrote:
> remove unnecessary void* type castings.
> 
> Signed-off-by: Yu Zhe <yuzhe@nfschina.com>
> ---
>  net/batman-adv/translation-table.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

If you send a second version then please use `git format-patch -v2 ...` to 
format the patch. Now it looks in patchworks like you've resent the first 
version again. And please also add a little changelog after "---" which 
explains what you've changed. It is trivial in this little patch but still 
might be useful.

Regarding the patch: Now you've removed bridge_loop_avoidance.c + 
batadv_choose_tt instead of fixing your patch. I would really prefer this 
patch version:

https://git.open-mesh.org/linux-merge.git/commitdiff/8864d2fcf04385cabb8c8bb159f1f2ba5790cf71

Kind regards,
	Sven
--nextPart1665509.GfMoWaoWtX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmJmmR4ACgkQXYcKB8Em
e0ZF9w//UFNInA7OC2T9+5zJHFRLWNgj6+C6pX9JeoShV3BYfv11IUXGEoIOjJo8
b3H97XoTedEQ+tfmHQZTeEwKInyaMFeBUI0DDATjtezwmlHmTkUe7cepupPhv2Oy
7eVxA4FN9pjDl2TIfN9qSkKiFNnCbgzLclwFsnLrTWt0R1o2Wtkb2HN5qXEPXg5Z
Cpsh1GUDuYhec+w+xyK3rcqeTrfgUdwTh6SvzckPPweX6QIMBIHFLjmsvmRiYDAc
7KFaXJxA7KvMduW7zQN26VblEZrhbHwlmTozo7VvdZo+k0ekhSdRseFj5dIRfhs9
r2b6weEAM7NBI/+NHGHHXIS9kFs+LqLpiwAkZhpDrLPD0OvtqMPtjR0e8sBtFhx0
llMZOfJJgcQ5QH0WuPyQ4c7YBYBHUXK9UzMlOkMFe12xPERXt8kIR2Vb2dAmdOMk
5JYrxNRvoCEcID5uGrPpXJ1V2G7KJfaiekEmG56nWgk4Q4ys+wMLnDtzs5GuQ67W
zlKSkJeoViMevRRH4EoyDdezeToP3LPQb9NoTLncPEtnyIu91ugfoxPgigBjINq5
qu8JoJqH7UHRkNIdYvWxyuN9DFY/bwsZFToBJjDK4kaobfrL1/ATGfC8mTUSv3pl
kno8dU9pOOTqTLgZTWfSyrubhNwJ6K0k+JCHx4saaNIF0ERrNOw=
=bG0x
-----END PGP SIGNATURE-----

--nextPart1665509.GfMoWaoWtX--



