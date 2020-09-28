Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 794B527AABC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgI1J24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:28:56 -0400
Received: from ozlabs.org ([203.11.71.1]:53639 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbgI1J24 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 05:28:56 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4C0HJj0bF2z9sPB;
        Mon, 28 Sep 2020 19:28:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1601285333;
        bh=o+I87mc/zNx7eVLu2XLL9SdJNQ6tAxA1/UTxrP/Ei9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XLtH0ib/Ax5GZmOhhGzOCCSmiuenSurvYfoAHMKxcIe/oNy1MiRieV4egM0rn6zRv
         NA3bUjEyp/AVuee84FhaHuneHCb04YCtfeZg9w0nFujERa22CsAdwlF1163qq3ppq9
         nZivm+GcADjwL6SE+BpbUQeoe1wDUoNpwh/Zk3jKn/cNh6mX25DrkRquiMz4mbsB1E
         qhDxRfJlSuzM1QgVaXj4MUIINTwlrrvpwfaPtL5Am9YFb2qdFtlzmtyrsXIgX2rJVw
         u5/0OFXP026U/EJXftMKf9ow7n9auw57Rtn16nAanr5vV6b0hXebXhWtBSMkRbBoW0
         lusF61xnI/hIQ==
Date:   Mon, 28 Sep 2020 19:28:52 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Govind Singh <govinds@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mhi tree
Message-ID: <20200928192852.76e7eddf@canb.auug.org.au>
In-Reply-To: <20200928091035.GA11515@linux>
References: <20200928184230.2d973291@canb.auug.org.au>
        <20200928091035.GA11515@linux>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/J8at0BZwR2F._ceo0sLyJg3";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/J8at0BZwR2F._ceo0sLyJg3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Manivannan,

On Mon, 28 Sep 2020 14:40:35 +0530 Manivannan Sadhasivam <manivannan.sadhas=
ivam@linaro.org> wrote:
>
> But your change looks good and I can just modify the subject/description =
and
> resubmit. Or if Dave prefers to fix the original commit itself in net-nex=
t,
> I'm fine!

Dave never rebase the net-next tree, so a new fix patch is required.
Thanks for taking case of it.

--=20
Cheers,
Stephen Rothwell

--Sig_/J8at0BZwR2F._ceo0sLyJg3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9xrNQACgkQAVBC80lX
0GxuyQgAi3C5SwnC4bGwPtKOzxEZnffNNdFR5EYCpKmPH/01qj72kuSwSHGRsZFy
Fe5vlFCQkBuPlZyLp9G9vWRdl7zSedbrlEQalPjKT0w1DoJ09xJyOluJQ0a+BiWh
dftAeRQFIYVD4QTKk9gY89LlG41yOwDuzZuivM4NaQTsyhPc9KDek6h5JlJ3pUrr
SPgGNr2TdTo88kXkWljiJjvjSud4PTg6p+vm66hdwCjSJi4gomkZ8J2E1RsERAgp
xfnsh/ZJOFtafjqX9zkG73cGyQBUQCxiH1mamd3x+/bfMQG6xfcXPhr4gm8l2cGL
rxilCFHk3GPGWWHRDDSZ01dC25ATvg==
=ZRxJ
-----END PGP SIGNATURE-----

--Sig_/J8at0BZwR2F._ceo0sLyJg3--
