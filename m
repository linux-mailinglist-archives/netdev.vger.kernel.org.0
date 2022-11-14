Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDCF627417
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 02:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235674AbiKNBQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 20:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiKNBQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 20:16:13 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3FACE3D;
        Sun, 13 Nov 2022 17:16:11 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4N9WbX4WzXz4x1D;
        Mon, 14 Nov 2022 12:16:08 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1668388569;
        bh=ObhabSbuS93L7p7A3l4XhhwBOwjsly4Sl16aRTUaFSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SgApv1+PYiL1RCaXctEMRetjr+h0Y+QV1pyGwFKo4dXQo2sDg4152T5uLAloJqXto
         PJzGjZz3zPp+lMJNmk7hy9e7xMSUM28wCUOJ5ZPZPfhWOhooMyD0KE0qu485oGalH6
         rY7XoaSBjx7NO5WN0apYfOx0I8HdODJXYogKjFnNg2VlTDd1aQYSfsgB2ZE9r3dKzw
         2SDkQR3fcVuZohH7ZTeFLWQN7JC5j8o9Vt29WK6bm9w13bdBvAlbBOfWHxMjKvX+5W
         vqPebmIPNQdjsd40a5p/TFCHQujPBo3Y5yiBA0tW8jtMg8grhWph0IFjqsefoWqNlb
         5KSuetaNBRz3w==
Date:   Mon, 14 Nov 2022 12:16:06 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eduard Zingerman <eddyz87@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: linux-next: manual merge of the bpf-next tree with the perf
 tree
Message-ID: <20221114121606.14436235@canb.auug.org.au>
In-Reply-To: <20221111104009.0edfa8a6@canb.auug.org.au>
References: <20221111104009.0edfa8a6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/QCE2iO7U4vgc6tCpQS32AXk";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/QCE2iO7U4vgc6tCpQS32AXk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Fri, 11 Nov 2022 10:40:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>=20
> Today's linux-next merge of the bpf-next tree got a conflict in:
>=20
>   tools/perf/util/stat.c
>=20
> between commit:
>=20
>   8b76a3188b85 ("perf stat: Remove unused perf_counts.aggr field")
>=20
> from the perf tree and commit:
>=20
>   c302378bc157 ("libbpf: Hashmap interface update to allow both long and =
void* keys/values")
>=20
> from the bpf-next tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>=20
> --=20
> Cheers,
> Stephen Rothwell
>=20
> diff --cc tools/perf/util/stat.c
> index 3a432a949d46,c0656f85bfa5..000000000000
> --- a/tools/perf/util/stat.c
> +++ b/tools/perf/util/stat.c
> @@@ -318,7 -258,27 +318,7 @@@ void evlist__copy_prev_raw_counts(struc
>   		evsel__copy_prev_raw_counts(evsel);
>   }
>  =20
> - static size_t pkg_id_hash(const void *__key, void *ctx __maybe_unused)
>  -void evlist__save_aggr_prev_raw_counts(struct evlist *evlist)
>  -{
>  -	struct evsel *evsel;
>  -
>  -	/*
>  -	 * To collect the overall statistics for interval mode,
>  -	 * we copy the counts from evsel->prev_raw_counts to
>  -	 * evsel->counts. The perf_stat_process_counter creates
>  -	 * aggr values from per cpu values, but the per cpu values
>  -	 * are 0 for AGGR_GLOBAL. So we use a trick that saves the
>  -	 * previous aggr value to the first member of perf_counts,
>  -	 * then aggr calculation in process_counter_values can work
>  -	 * correctly.
>  -	 */
>  -	evlist__for_each_entry(evlist, evsel) {
>  -		*perf_counts(evsel->prev_raw_counts, 0, 0) =3D
>  -			evsel->prev_raw_counts->aggr;
>  -	}
>  -}
>  -
> + static size_t pkg_id_hash(long __key, void *ctx __maybe_unused)
>   {
>   	uint64_t *key =3D (uint64_t *) __key;
>  =20

This is now a conflict between perf tree and the net-next tree.

--=20
Cheers,
Stephen Rothwell

--Sig_/QCE2iO7U4vgc6tCpQS32AXk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmNxltYACgkQAVBC80lX
0GwHewgAoweu3rA0MGKL2cpYnqa5Uu6YuE9dwsNBJmevt0T0CX0SxgI0fAdNN2sx
EpAbip0NzkbfbOY4x7KiN5OXY/kRKJum4WazUza9LjGXJgv9T/rr2R89KI8Its7w
NdVLW+F3ngSFya0ZYzRM8Fclw31UC7q2yylXnkIw6E5JhXNiUHaKFFGOmUccqXvy
lB5PSvPug8T0UxJZz1gCrZHKTG0l/3lUXzUs89jlISwx3/xR1clVQmhOD5asA3wi
eXsst9trZTLJPkRDWCYccAf9M7hXGaDhsXJPhV47h63PPkNBtHLynMxvfsK45Qww
U7T8LVXaUUqdGqDRAVleeNd8tvTdNw==
=baLb
-----END PGP SIGNATURE-----

--Sig_/QCE2iO7U4vgc6tCpQS32AXk--
