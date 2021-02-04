Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D7330F90F
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 18:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238369AbhBDREc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 12:04:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:55432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238214AbhBDREF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 12:04:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E824764F65;
        Thu,  4 Feb 2021 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612458204;
        bh=IcR+Cua+B8lZ++45Daif1Ue567t+v/+w8V3xe6kLNq8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=topSnfCNi0SGUl8/ZT9sN/s4GW2Wl5ib8cBgG193QxHg9n6cMHfOhmCNCw+o8KhB+
         WAa9FGnR7cKt6BeAhRf0JxYaeOajiINeA7i+sIpjR3C1xAtz3tgB2fWWd+alQFwbAa
         xDcGU6rdCNmoZCLa8siRMgmNzfxxNMinFlUshQ2jiA7LJLDWZR1rr995vAvdXSNheC
         XsuYOIDMWm7ROLa6Kd9TuLRonNDWhIG05NcGLQD0vZVBUlHZCx4/d18Nn/4xWH8ZRS
         mZv8zTNUVNvvJgWjGq2MAMZY1t61BdwNuY2cRBdXITIBFwtHN7EbNgyYVZGv2oXRJ/
         8KEMYkXT9C24g==
Date:   Thu, 4 Feb 2021 09:03:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Message-ID: <20210204090323.14bcbaba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87zh0k85de.fsf@toke.dk>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
        <20210125124516.3098129-1-liuhangbin@gmail.com>
        <20210204001458.GB2900@Leo-laptop-t470s>
        <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
        <20210204031236.GC2900@Leo-laptop-t470s>
        <87zh0k85de.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 04 Feb 2021 12:00:29 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Patchwork is usually the first place to check: =20
> >
> > Thanks John for the link. =20
> >>=20
> >>  https://patchwork.kernel.org/project/netdevbpf/list/?series=3D421095&=
state=3D* =20
> >
> > Before I sent the email I only checked link
> > https://patchwork.kernel.org/project/netdevbpf/list/ but can't find my =
patch.
> >
> > How do you get the series number? =20
>=20
> If you click the "show patches with" link at the top you can twiddle the
> filtering; state =3D any + your own name as submitter usually finds
> things, I've found.

New patchwork can actually find messages by Message-ID header.

Just slap message ID of one of the patches at the end of:

https://patchwork.kernel.org/project/netdevbpf/patch/

And there is a link to entire series there.


Since I'm speaking, Hangbin I'd discourage posting new version=20
as a reply to previous posting. It brings out this massive 100+
message thread and breaks natural ordering of patches to review.
