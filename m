Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B4F6987FE
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 23:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjBOWiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 17:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjBOWiC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 17:38:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 496955B83;
        Wed, 15 Feb 2023 14:38:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04464B823D8;
        Wed, 15 Feb 2023 22:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39DFDC433EF;
        Wed, 15 Feb 2023 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676500678;
        bh=NvXLo4zERJELs3A0OEbINEn9B1MOqPEhBbBoM1rX5Sc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cg1aZIRXEngBsn1Qg0rZaUeexAmJiiImPjpo2Ks+7c0VvaIrFt6Abyu9m+0Mvk70d
         RKB7m11YqKvzWlqEjRIV/X3QfTm/vGyCctgxWP0XlFvcebgjjqwBwfB8qVA5vFKokK
         nwohXTC168+65/ECwiM6zxf61BoS0n1keoteZkRhAkpoA22BXd3AVM89KvZ1bA3uqh
         e29Ajs4P22ZsPV7nHO6qgz5ejXyn6PDND7HURaQeeaDHMNl1I9TpiPGg+I4xGvXIy9
         GuIRiyxCe7NA4M8vH4mEFVlF62VlIUs4y267CBDD9W4F4F1XmzBV3xNW8wF6LfjKQj
         WV0MAuX2lPtEQ==
Date:   Wed, 15 Feb 2023 22:37:51 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Pu Lehui <pulehui@huaweicloud.com>
Cc:     bpf@vger.kernel.org, linux-riscv@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Pu Lehui <pulehui@huawei.com>
Subject: Re: [PATCH bpf-next v1 1/4] riscv: Extend patch_text for multiple
 instructions
Message-ID: <Y+1evzv1PkuETdVm@spud>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
 <20230215135205.1411105-2-pulehui@huaweicloud.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zfz/HF4ZANB5RmXZ"
Content-Disposition: inline
In-Reply-To: <20230215135205.1411105-2-pulehui@huaweicloud.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--zfz/HF4ZANB5RmXZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2023 at 09:52:02PM +0800, Pu Lehui wrote:
> From: Pu Lehui <pulehui@huawei.com>
>=20
> Extend patch_text for multiple instructions. This
> is the preparaiton for multiple instructions text
> patching in riscv bpf trampoline, and may be useful
> for other scenario.

In the future, please use the full width for your commit message (or
fix your editor if it thinks fifty-something chars is the full width).

Otherwise, looks grand...
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.


--zfz/HF4ZANB5RmXZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCY+1evwAKCRB4tDGHoIJi
0otNAQD6dzDRBTtWgsltvV157r3eLCncHyAAlAEHTxf6GkoQwgEA1I7d2AKYYUF1
7I9rFNKoujbABR5RcyUYKdUBGnSVjAc=
=mAMb
-----END PGP SIGNATURE-----

--zfz/HF4ZANB5RmXZ--
