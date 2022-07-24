Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3A357F75C
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 00:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiGXWeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 18:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiGXWeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 18:34:18 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC7F10FD9;
        Sun, 24 Jul 2022 15:34:17 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4LrdJR0tgZz4xCy;
        Mon, 25 Jul 2022 08:34:14 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1658702056;
        bh=qnf0MrBahT2hsNdMKM4srx4DyvMmAByL2qQBSDmtfl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K8keaT2MUsEw82vfiQzGYtLhZEtJMBGDrHt9myQtwDJXeo/VlU2D0NqyImuDdRIb9
         qIFhKfzJIkDMic19LoViM7DkQpknY0Brei2dmJCyS4ZohlY9wsqLWb6zrIK3L0TkF/
         Ge90fW+or1/jQ8vj6G6iBmQwVB8woKaaw4tpRCVx98B+GS0pTnKl3BjS+etyDJdt9+
         ty8BdQ1+oRceuPUS893pPJduTTO18DaMf7wH2A5OpustwKKAU1o1VYC4Y8vG3U35ad
         ywwU4xdUg1pxYJJUA28ciKht1DVmysCZbdqVOPUfcoOGRL82vRWWImJAeE57ihrSuX
         S3025TaYyWp3w==
Date:   Mon, 25 Jul 2022 07:59:35 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Zhengping Jiang <jiangzp@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the bluetooth tree
Message-ID: <20220725075935.68ef1c10@canb.auug.org.au>
In-Reply-To: <20220725075350.64662d13@canb.auug.org.au>
References: <20220725075350.64662d13@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/qfZ4R+jqDqgV3=13KOuU0ys";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/qfZ4R+jqDqgV3=13KOuU0ys
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 25 Jul 2022 07:53:50 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> In commit
>=20
>   68253f3cd715 ("Bluetooth: hci_sync: Fix resuming scan after suspend res=
ume")
>=20
> Fixes tag
>=20
>   Fixes: 3b42055388c30 (Bluetooth: hci_sync: Fix attempting to suspend wi=
th
>=20
> has these problem(s):
>=20
>   - Subject has leading but no trailing parentheses
>=20
> Please do not split Fixes tags over more than one line, just use:
>=20
>   git log -1 --format=3D'Fixes: %h ("%s")' <commit>
>=20
> Also, please keep all the commit message tags together at the end of
> the commit message.

This is now on the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/qfZ4R+jqDqgV3=13KOuU0ys
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmLdwMcACgkQAVBC80lX
0Gw+tAf7BWb9D3zYHxNd+Jd9yC1LAGv2gj5awCaSTzHlGtZu5JDGp1+G2ELgxRVa
BBRf0gt9x0VCXLZCr0hWklss4nyKXhT3fbwdif1zuOG/sygDAxdP7u56ID1q0eI7
sRneNc7HdgSQR5CUrEK099shA9u1B40atwTop1ldEFsvzTs+GOM1IpucnkYNgdz1
udB0tXR/CsTo+WBwBOiPpdHtyaWe92fNehArduSt4sa4gtzPSsODBf1KFbua27FB
A9NEn9V9AfIAFtIMd4YPF7cdX1VjsJB79tKBBaMvTF3bE//BtONyd/sw6tMdGxkI
PoNpo+BQj2MK1YcEahMu/Yg9bz6GWg==
=mABc
-----END PGP SIGNATURE-----

--Sig_/qfZ4R+jqDqgV3=13KOuU0ys--
