Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC026E5A56
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbjDRHXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjDRHXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:23:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49AA85BA5
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:23:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD68F62D99
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 07:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A1CC433D2;
        Tue, 18 Apr 2023 07:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681802588;
        bh=uYeAFTD1oLBIHx6yx7q/WG0n612K97YyOJA7fGxD9os=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z4dJs84V8hH06dRXzJzlSJhVafsCNISHzm/FGpgltxowZRtzAQ5KroUCSg9vax/I8
         IEoonezlb6fmzhNlZ26Wzxg5p4w9MLNC90tW9k1VmRC5hPr4g0dzVQezTZW7E5M2bZ
         Nde6bXSScj/igonux+kt9Cfd3pn3UiFI2CvwXh3uXn7B4gvrAP569ez2DX+FaydEuS
         mE1pWR3n/fVAxjJD4Yah4zeIMu3N0/jHG4+cBxmcEb5I4vimXrngvgjaxDTTG3c+Sh
         phsi48daRu+8YUeaObtAWSwJ6GMyRUiqjylt1rUxoskEUe6DxM7HdlUjd1d6IFejoz
         4bAUe38fRVXhQ==
Date:   Tue, 18 Apr 2023 09:23:04 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        lorenzo.bianconi@redhat.com, jdamato@fastly.com
Subject: Re: [PATCH net-next] net: page_pool: add pages and released_pages
 counters
Message-ID: <ZD5FWFik410qExT2@lore-desk>
References: <a20f97acccce65d174f704eadbf685d0ce1201af.1681422222.git.lorenzo@kernel.org>
 <20230414184653.21b4303d@kernel.org>
 <ZDqHmCX7D4aXOQzl@lore-desk>
 <20230417111204.08f19827@kernel.org>
 <ZD28nJonfDPiW4F8@lore-desk>
 <20230417163603.30be79bf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SEB0/kDPDdL1Gt5f"
Content-Disposition: inline
In-Reply-To: <20230417163603.30be79bf@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SEB0/kDPDdL1Gt5f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 17 Apr 2023 23:39:40 +0200 Lorenzo Bianconi wrote:
> > > Yup, that sounds better. =20
> >=20
> > ack, fine. I am now wondering if these counters are useful just during
> > debugging or even in the normal use-case.
>=20
> I was wondering about it too, FWIW, I think the most useful info is
> the number of outstanding references. But it may be a little too
> unflexible as a statistic. BPF attached to the trace point may be
> a better choice there, and tracepoints are already in place.

ack, I agree. Let's drop this patch in this case.

Regards,
Lorenzo

--SEB0/kDPDdL1Gt5f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCZD5FWAAKCRA6cBh0uS2t
rLHoAP9ui/QegW+nn1FwcQUP34z67rRvNSKscIAG58+pMBvMZwEAh5nSe20mNYGP
qn9deLAdfbrM8HNLj4RbIK7HhSeLNwU=
=W0Qo
-----END PGP SIGNATURE-----

--SEB0/kDPDdL1Gt5f--
