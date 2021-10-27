Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4326243D649
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhJ0WLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhJ0WLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:11:32 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE49C061570;
        Wed, 27 Oct 2021 15:09:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HfjWw4rzpz4xbP;
        Thu, 28 Oct 2021 09:09:00 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1635372541;
        bh=E9vVZjugBxglNf6mi6b6L+lVqqoYk5z7JFagTw04whQ=;
        h=Date:From:To:Cc:Subject:From;
        b=scASQ9Ug6DFtYELD9ZZ2S49iOPriP9YMcrQAt3L2xBRaCOo5Mt+8V535+hXdHZYd0
         /Qut292kAVwJd5BHAtIfYs8RT7RoTp5wvxmjm2XgZx9zoTCE4m0X+rT/7rXydgmiC1
         CLPu0zYuK5xAHYq6kRl7Pq4HUNQ2+EKAEqzE8vsn6yhBo+HW6n2D4iIYgQUrAjo/A2
         iaPzjcZ4kAGUZnewakyhkCo32imuys97NBnj8aCKN5/OyWhK5bklQEr1L8hjCwl6I0
         Cfz6wGDmEdP3zeOoEniD37zxpywAoeNhhte26AzX5thUWL2ouW9Tig0cWIb7WfG4m3
         Ww+PDf+KCNmGw==
Date:   Thu, 28 Oct 2021 09:08:58 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: Signed-off-by missing for commit in the net-next tree
Message-ID: <20211028090858.138ece92@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hG=c7RxsV1BQlc5BrNzc+qA";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/hG=c7RxsV1BQlc5BrNzc+qA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Commit

  8ca9caee851c ("net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inli=
ne")

is missing a Signed-off-by from its committer.

--=20
Cheers,
Stephen Rothwell

--Sig_/hG=c7RxsV1BQlc5BrNzc+qA
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmF5zfoACgkQAVBC80lX
0Gz0dggAh0vYgmI8g3kbbr6S1C39+SeVfTpwP2iuvEh9wzLSYtXVce3ukR59kqPf
hMQ0YNAaaVTfDKHj0pEjS4Ie39XBrasZquwsrhjzX3ZW51cziU84Eq2XCLb+Lcw8
YfAX6Cx6DzF74sllppO9BtHstppzvfyTVaLt6AaHJo3+dek17B6g7eud/O4mFVZO
J23Vl3NydBa9/8Ybwn93KxPAqKr4wuMu96ef9Gi/5bofYMJkm4ePBHz6Tf8b/9QE
29gjkAXpTFMLRKC5w0wyeRxQRAaXy3Ha83zc956XIe8mgrPAPpuPwp8qkOI07XLw
fXPnYB6WonmcOM0neh7kJmxL/DoQtw==
=HDX9
-----END PGP SIGNATURE-----

--Sig_/hG=c7RxsV1BQlc5BrNzc+qA--
