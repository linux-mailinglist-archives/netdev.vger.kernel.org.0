Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C58D5F4C1B
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 00:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiJDWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 18:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiJDWpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 18:45:43 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68864F192;
        Tue,  4 Oct 2022 15:45:41 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Mht8L0QSjz4xDn;
        Wed,  5 Oct 2022 09:45:38 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1664923539;
        bh=VLbDgrb7jeNhNRMHmVfeAUsikRAntGBmoxvtb8owLaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K/1fMqEbLkZW5q380KFNwEknWdDMRWLySfEakFNwRjDbCcypGYRI3jMNmBJDeSx1d
         HcxdVAsI0F7a/7EeqI/v0jGU+nDA8Rob2EBbkOqk+84Q6VfdyCTBdG4OQvla38N1Yt
         cXS/2X2THhglbFhyc77hBFF3ipNa8rFA96TO1+aaPSJf1sFcNYfjvB6KjvJ55OG2zW
         qQjVTfC0vh+b8ocs2QS4RYgvi0eZnlSs1qo0w0aZefbBbvOglkFN/bV3mKmnuHIzhu
         BTq/Akl5HSv/E5Bwr/P+rV4qglKrpPSpXuqImg6w6W+LAg9eDBErE+CDsmrkx5jlqW
         w3x/DcoDBHBrA==
Date:   Wed, 5 Oct 2022 09:45:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        David Vernet <void@manifault.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: linux-next: manual merge of the net-next tree with the bpf tree
Message-ID: <20221005094536.679c55e1@canb.auug.org.au>
In-Reply-To: <20221003190727.0921e479@kernel.org>
References: <20221004122428.653bd5cd@canb.auug.org.au>
        <20221003190727.0921e479@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/.YE0yhnbwf.UMCRzoDHIheM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/.YE0yhnbwf.UMCRzoDHIheM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

On Mon, 3 Oct 2022 19:07:27 -0700 Jakub Kicinski <kuba@kernel.org> wrote:
>
> Unrelated to the conflict but do you see this when building the latest
> by any chance? Is it just me and my poor old gcc 8.5?
>=20
> vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data=
 relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
> vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to =
!ENDBR: bpf_dispatcher_xdp_func+0x0

I don't get those messages.

--=20
Cheers,
Stephen Rothwell

--Sig_/.YE0yhnbwf.UMCRzoDHIheM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmM8t5AACgkQAVBC80lX
0Gz91Qf9E1ojiA6qxk7bNCljWKPy/DaHWjiZGTBqtH5+miY6l+/dqwGKX5VmiEYo
ZcZIqJjyAfmnVwA2rKkfJx0JnWbKn5NV7C0p0F5viRNkRS+C566pxJkiAorWZSvE
ocyDhu0xjW0b9K24j/hcudXm4yC2zgcFIaMWVFeOA/m2XpGGIiEAIkUEhQwafk5R
LiPA6sKcd88yo2AppmSlZAi0A1C6WGstJ3EyaPNEqGtEFOD9ITgIJtRw2AHyFMeO
IyKMx2gHvIxcvspx2EEes/YK9CEhX6gbGi/mGe6aa3vQB5DjUKp4R3llE7Rxb05l
X0PsZrycf4t3e34V2bTCDz4WH3JM6A==
=djYm
-----END PGP SIGNATURE-----

--Sig_/.YE0yhnbwf.UMCRzoDHIheM--
