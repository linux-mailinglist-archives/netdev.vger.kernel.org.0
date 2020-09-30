Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9505327F450
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgI3VkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:40:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730842AbgI3VkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:40:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 902DF2076B;
        Wed, 30 Sep 2020 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601502004;
        bh=XMXD+M92oCewfW0upYUkfc2XA2D5Am6tiXwzm86e/4Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=acrxvPL/ZFFefrbzTP0YK+Jv6BZ3kzf2vWwS3gbelbScCXFWGW9T/ga+rVQlXZ9gj
         r9+aC/KNfMHgoWd050UOhqhik1tVb3fROllNQ4UVDG4Xoutonlvpv2KYCLyjr2QiJH
         HugffI080kUxd9DDcZRVt5Y+aJDYCAcUU3UZnI3w=
Date:   Wed, 30 Sep 2020 14:40:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 00/12] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200930144002.6bb60d67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930163907.GF17959@lore-desk>
References: <cover.1601478613.git.lorenzo@kernel.org>
        <20200930093130.3c589423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200930163907.GF17959@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 18:39:07 +0200 Lorenzo Bianconi wrote:
> > On Wed, 30 Sep 2020 17:41:51 +0200 Lorenzo Bianconi wrote: =20
> > > This series introduce XDP multi-buffer support. The mvneta driver is
> > > the first to support these new "non-linear" xdp_{buff,frame}. Reviewe=
rs
> > > please focus on how these new types of xdp_{buff,frame} packets
> > > traverse the different layers and the layout design. It is on purpose
> > > that BPF-helpers are kept simple, as we don't want to expose the
> > > internal layout to allow later changes. =20
> >=20
> > This does not apply cleanly to net-next =F0=9F=A4=94 =20
>=20
> Hi Jakub,
>=20
> patch 12/12 ("bpf: cpumap: introduce xdp multi-buff support") is based on=
 commit
> efa90b50934c ("cpumap: Remove rcpu pointer from cpu_map_build_skb signatu=
re")
> already in bpf-next. I though it was important to add patch 12/12 to the
> series. Do you have other conflicts?

Sorry for the delay, my thing (https://patchwork.hopto.org/) does not
collect what failed exactly, sadly :(
