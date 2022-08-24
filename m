Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B93E59F14A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiHXCLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiHXCLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:11:00 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558024BD28
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 19:10:59 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MC8hc2kJKz4x1G;
        Wed, 24 Aug 2022 12:10:56 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1661307057;
        bh=MmrVRuyhvTynP8BUSrVVrwOFah8kPs+i8JVbxqvDgAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OHtehsw4PMDmbcLHRJhug9ogT799/1sRsqIjXKEIVjg+T7vbL2MenIz99KW/Mp1Is
         9v3StTYk8D9uN4dhj/ldQhQW27bLHKHnqEwvTNTxaait8ynUPOK1FkHtqCwKMGmY8J
         Gdwhip3zMabvPQpVWazt+saNHyGuzLw/CIQOruKsI/p2Wt6KGf5iZxWgoIbt8ogAcm
         C/wXR+rRgOUzKsC6kYlKkdwkgro97amsuo5gLpEokAfPQ9GTEh/ocijkKqtOcxRHNf
         3NKTsSUoLDuP0+HsOVcH9kMRLVNlxhw1QZTLuVXvQKdK67uFicuPmMnA/a4rovRfsV
         OL21LmEctkpjQ==
Date:   Wed, 24 Aug 2022 12:10:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next] docs: fix the table in
 admin-guide/sysctl/net.rst
Message-ID: <20220824121054.4198d3c7@canb.auug.org.au>
In-Reply-To: <20220823180454.463f8a8b@kernel.org>
References: <20220823230906.663137-1-kuba@kernel.org>
        <20220824104144.466e50b1@canb.auug.org.au>
        <20220823180454.463f8a8b@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EnzV7E37kw7PbT9kYqMW0zW";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/EnzV7E37kw7PbT9kYqMW0zW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Tue, 23 Aug 2022 18:04:54 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
>
> Should I trim the first 'Content' column to the min required length as
> well? Commit 1202cdd66531 (which is in -next only) reshuffled the
> entire table anyway so we won't be preserving any history by not
> trimming.

I don't think that is necessary, but also don't really care either way
:-)

--=20
Cheers,
Stephen Rothwell

--Sig_/EnzV7E37kw7PbT9kYqMW0zW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmMFiK4ACgkQAVBC80lX
0GzXKAf/QSjb7RA0cJNhyS6nD63qnrSSklVTtiBjjVScXyOlmxyYKuhrn/lz/+t9
fBbs31TUiZIXwYZJUhqYxwYks9d++CMnvGRZKtxxg+Ex/Oky8KZ5hHlpwiI+Mi0M
6JG+x5p2hmsEdBdKF5Fbo9vh+zdt2EKJWkMk5u4zNUEtrwRUoyV9FEt5gkZbJmUi
Kta7Ej1JV8c791WIFe7aC0iaqcCX3lPsj3MD2kT81eDTzGmLG8797Hmzu4WAguwi
E5B78aTyRCPdL/oF719XoxX9LPIhNRvwnzSiG78czs01I1XB30EoeCfaeq5kSjju
pH4G5FVksWQ2ZmpRsH+8gcoSk8x2uQ==
=EcDe
-----END PGP SIGNATURE-----

--Sig_/EnzV7E37kw7PbT9kYqMW0zW--
