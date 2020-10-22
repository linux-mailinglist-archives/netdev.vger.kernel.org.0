Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68470296526
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370028AbgJVTQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506728AbgJVTQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:16:25 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD91624656;
        Thu, 22 Oct 2020 19:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603394184;
        bh=iMAY9GeJiuodfJPX9n2FL/h4nsCaNV/OywPcSmPUNW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=okcJ5LJWA8kGXsheoOHjj5tcLjVYRYESutXSt7W27qITfNanlBUkvswe+amoqupDI
         CxJdZKs0fIhUbzZgq1DKxDaqDSL1XQvmfS92MS30aHxoYMUa5cbjacRotVipqGJzQK
         mBlDRHpF+0vJv0xDJZxenqcnp7Hm/qWp2xdCmUd0=
Date:   Thu, 22 Oct 2020 12:16:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-10-22
Message-ID: <20201022121622.692903bf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022141724.11010-1-daniel@iogearbox.net>
References: <20201022141724.11010-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 16:17:24 +0200 Daniel Borkmann wrote:
> Hi David, hi Jakub,
>=20
> The following pull-request contains BPF updates for your *net* tree.
>=20
> We've added 8 non-merge commits during the last 4 day(s) which contain
> a total of 16 files changed, 426 insertions(+), 102 deletions(-).
>=20
> The main changes are:
>=20
> 1) Fix enforcing NULL check in verifier for new helper return types of
>    RET_PTR_TO_{BTF_ID,MEM_OR_BTF_ID}_OR_NULL, from Martin KaFai Lau.
>=20
> 2) Fix bpf_redirect_neigh() helper API before it becomes frozen by adding
>    nexthop information as argument, from Toke H=C3=B8iland-J=C3=B8rgensen.
>=20
> 3) Guard & fix compilation of bpf_tail_call_static() when __bpf__ arch is
>    not defined by compiler or clang too old, from Daniel Borkmann.
>=20
> 4) Remove misplaced break after return in attach_type_to_prog_type(), from
>    Tom Rix.

Pulled, thank you!
