Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34472C733F
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389577AbgK1VuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:50:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:42986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387773AbgK1VJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Nov 2020 16:09:29 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9217022240;
        Sat, 28 Nov 2020 21:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606597728;
        bh=IxBm3yJb5O+bX21JPdDuHm/EmyUrXE0dJRLgAPBi7zk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVFGS3Bhno46qEjzleGCbFK930F2Q1pwzZT/UWQnehWyM415oa2Ra1xHwoKr1eGPi
         KkRs/I0GqRUkjEGlenRBZWgIpYm1iSqDe+27GIyYQ7uoluTIWFN3CIg/nc2thC4YC+
         6Thb0AnlOwzKyZCA1MmYwOlQNUpCaerbPyq4fORg=
Date:   Sat, 28 Nov 2020 13:08:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2020-11-28
Message-ID: <20201128130847.01b1a600@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201128005104.1205-1-daniel@iogearbox.net>
References: <20201128005104.1205-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Nov 2020 01:51:04 +0100 Daniel Borkmann wrote:
> 1) Do not reference the skb for xsk's generic TX side since when looped
>    back into RX it might crash in generic XDP, from Bj=C3=B6rn T=C3=B6pel.
>=20
> 2) Fix umem cleanup on a partially set up xsk socket when being destroyed,
>    from Magnus Karlsson.
>=20
> 3) Fix an incorrect netdev reference count when failing xsk_bind() operat=
ion,
>    from Marek Majtyka.
>=20
> 4) Fix bpftool to set an error code on failed calloc() in build_btf_type_=
table(),
>    from Zhen Lei.

Pulled thanks!
