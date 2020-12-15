Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1252DA601
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgLOCLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726209AbgLOCLV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:11:21 -0500
Date:   Mon, 14 Dec 2020 18:10:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998240;
        bh=VJ4pVUDqJ186Yb6AbWAOxpO/nft9uAvVGLlN7xLGu4A=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=AGEUkxGxKAsYC8svjBA/XL7+RchddVg8uokxA3jDxFTl4Cp0I6B3fS+Yxb26dktYw
         pKS9JoCcelmF026rKG7xXCDAX8gGw2g90NnFUdxHHbdfrCKVO5QVeT1cywyUflEfGE
         RyTe3DQGygQ2ldZaIMkF4oppxGsneUggRc9MlLUQA6STVHG7Q1k1zBIJpZROunYoQy
         Hoj1zv73lbcKbjK7YHG9xJMvSMm7FTBRBI8S2HS+nTtyF5EOpJY5npCG0NOvWotU/4
         VTDlpBundhtNeCp5pKhTq6ErKEYRgPjeIxzUIq6YFQrkodQXn2r+awixPB7mTwo3Z2
         tRYi/Mwq/mqwg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf-next 2020-12-14
Message-ID: <20201214181039.2b58ef46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214214316.20642-1-daniel@iogearbox.net>
References: <20201214214316.20642-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 22:43:16 +0100 Daniel Borkmann wrote:
> 1) Expose bpf_sk_storage_*() helpers to iterator programs, from Florent R=
evest.
>=20
> 2) Add AF_XDP selftests based on veth devs to BPF selftests, from Weqaar =
Janjua.
>=20
> 3) Support for finding BTF based kernel attach targets through libbpf's
>    bpf_program__set_attach_target() API, from Andrii Nakryiko.
>=20
> 4) Permit pointers on stack for helper calls in the verifier, from Yongho=
ng Song.
>=20
> 5) Fix overflows in hash map elem size after rlimit removal, from Eric Du=
mazet.
>=20
> 6) Get rid of direct invocation of llc in BPF selftests, from Andrew Delg=
adillo.
>=20
> 7) Fix xsk_recvmsg() to reorder socket state check before access, from Bj=
=C3=B6rn T=C3=B6pel.
>=20
> 8) Add new libbpf API helper to retrieve ring buffer epoll fd, from Brend=
an Jackman.
>=20
> 9) Batch of minor BPF selftest improvements all over the place, from Flor=
ian Lehner,
>    KP Singh, Jiri Olsa and various others.

Looks like the reply bot is not keeping it 100.. I'll report=20
to Konstantin after the merge window craziness is over.

Pulled, thanks!
