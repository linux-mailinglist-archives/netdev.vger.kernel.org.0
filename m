Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8832CF4B1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730508AbgLDTXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:23:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgLDTXm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:23:42 -0500
Date:   Fri, 4 Dec 2020 11:22:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607109781;
        bh=NBvueAlFsmQHzL0lTxjCKAaV+65o5qYn02pI6Wbz6SI=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=upayJwBaQGoo3NxPo/MIVgAn8JYwWqG22c9tTgDGBCigX25cpiuYapo4BsHbflb+s
         sw2nNGlSsmYPA1EulvoASDW7jW5RDcs0X33ck3OfbQlL0fVIogq8pXVf/+L4epUvqA
         KJJlz0jXc42/w5mAdPZ/IH1VH/2fKE6nyvgp4/uLsSm3beE4ryY6BG4ggTCmmjfXay
         sxd2+m8dWDZQh4yaBORtrKeTqHgrsZ44mK3WBhuNDJRmzXwDVbGypN16mb6qWsk/iw
         wQXPYESwlAFKEP88L6bbJE9LLaryDbRaBXVNAzzi2p7/Xs4rOjqRuV8QfKNgb41ntV
         Q1d+1pQj/uUhA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 0/5] New netdev feature flags for XDP
Message-ID: <20201204112259.7f769952@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <87k0tx7aa5.fsf@toke.dk>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
        <20201204092012.720b53bf@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <87k0tx7aa5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 04 Dec 2020 18:26:10 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > On Fri,  4 Dec 2020 11:28:56 +0100 alardam@gmail.com wrote: =20
> >>  * Extend ethtool netlink interface in order to get access to the XDP
> >>    bitmap (XDP_PROPERTIES_GET). [Toke] =20
> >
> > That's a good direction, but I don't see why XDP caps belong in ethtool
> > at all? We use rtnetlink to manage the progs... =20
>=20
> You normally use ethtool to get all the other features a device support,
> don't you?

Not really, please take a look at all the IFLA attributes. There's=20
a bunch of capabilities there.

> And for XDP you even use it to configure the number of TXQs.
>=20
> I mean, it could be an rtnetlink interface as well, of course, but I
> don't think it's completely weird if this goes into ethtool...

