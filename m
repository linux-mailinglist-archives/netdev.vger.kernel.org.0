Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1064C466B77
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376986AbhLBVUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358627AbhLBVUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:20:22 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B27C06174A;
        Thu,  2 Dec 2021 13:16:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0Yc7uTuUXobwOFuqMYK6lgrbotOqoK6CKloGgp2Ox0g=; b=hNOK11THoFabuV+1wx3/5rGI3L
        hzbNn0gYLNby8pF+IFzpFx9edsXocHy+qE2O8IbgqiIlJ0/+B107biqU652cWnm2mk+9y66xB06fg
        RrrYa0dMuvTN1d0BXB6coNIhRXjtKq8OhTDl8dF7d//3Ss4fwaILLNs8cSLY6cmNFdK8SvC49dvty
        UL4DszLRZAaUFwJA/vgUfJu9ZVUBdKxysQ4ifSSzAxCeDg66Yc4NYhr64doHIR1PeWWHSLlsIByB8
        nu7dnJVfxr7SKld7J+v6DKQqlCmFSQ4rGqLXFxLjumIEk4V53WczIGlsqFIHcpzMT3tEmT3dobGO0
        2kXBNUVw==;
Received: from [192.168.96.13] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mstRV-00DC4R-5u; Thu, 02 Dec 2021 21:16:37 +0000
Date:   Thu, 2 Dec 2021 21:16:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Bixuan Cui <cuibixuan@linux.alibaba.com>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Leon Romanovsky <leon@kernel.org>, Willy Tarreau <w@1wt.eu>,
        Kees Cook <keescook@chromium.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH -next] mm: delete oversized WARN_ON() in kvmalloc() calls
Message-ID: <Yak3sIYC7RxLrXBC@azazel.net>
References: <1638410784-48646-1-git-send-email-cuibixuan@linux.alibaba.com>
 <20211201192643.ecb0586e0d53bf8454c93669@linux-foundation.org>
 <10cb0382-012b-5012-b664-c29461ce4de8@linux.alibaba.com>
 <20211201202905.b9892171e3f5b9a60f9da251@linux-foundation.org>
 <YaiiFxD7jfFT9cSR@azazel.net>
 <CAADnVQLV4Tf3LemvZoZHw7jcywZ4qqckv_EMQx3JF9kXtHhY-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nUPL30MqoHnEoqa0"
Content-Disposition: inline
In-Reply-To: <CAADnVQLV4Tf3LemvZoZHw7jcywZ4qqckv_EMQx3JF9kXtHhY-Q@mail.gmail.com>
X-SA-Exim-Connect-IP: 192.168.96.13
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nUPL30MqoHnEoqa0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2021-12-02, at 07:34:36 -0800, Alexei Starovoitov wrote:
> On Thu, Dec 2, 2021 at 2:38 AM Jeremy Sowden wrote:
> > On 2021-12-01, at 20:29:05 -0800, Andrew Morton wrote:
> > > On Thu, 2 Dec 2021 12:05:15 +0800 Bixuan Cui wrote:
> > > > =E5=9C=A8 2021/12/2 =E4=B8=8A=E5=8D=8811:26, Andrew Morton =E5=86=
=99=E9=81=93:
> > > > >> Delete the WARN_ON() and return NULL directly for oversized
> > > > >> parameter in kvmalloc() calls.
> > > > >> Also add unlikely().
> > > > >>
> > > > >> Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls=
")
> > > > >> Signed-off-by: Bixuan Cui<cuibixuan@linux.alibaba.com>
> > > > >> ---
> > > > >> There are a lot of oversize warnings and patches about kvmalloc()
> > > > >> calls recently. Maybe these warnings are not very necessary.
> > > > >
> > > > > Or maybe they are.  Please let's take a look at these warnings,
> > > > > one at a time.  If a large number of them are bogus then sure,
> > > > > let's disable the runtime test.  But perhaps it's the case that
> > > > > calling code has genuine issues and should be repaired.
> > > >
> > > > Such as=EF=BC=9A
> > >
> > > Thanks, that's helpful.
> > >
> > > Let's bring all these to the attention of the relevant developers.
> > >
> > > If the consensus is "the code's fine, the warning is bogus" then let's
> > > consider retiring the warning.
> > >
> > > If the consensus is otherwise then hopefully they will fix their stuf=
f!
> > >
> > > > https://syzkaller.appspot.com/bug?id=3D24452f89446639c901ac07379ccc=
702808471e8e
> > >
> > > (cc bpf@vger.kernel.org)
> > >
> > > > https://syzkaller.appspot.com/bug?id=3Df7c5a86e747f9b7ce333e7295875=
cd4ede2c7a0d
> > >
> > > (cc netdev@vger.kernel.org, maintainers)
> > >
> > > > https://syzkaller.appspot.com/bug?id=3D8f306f3db150657a1f6bbe192746=
7084531602c7
> > >
> > > (cc kvm@vger.kernel.org)
> > >
> > > > https://syzkaller.appspot.com/bug?id=3D6f30adb592d476978777a1125d1f=
680edfc23e00
> > >
> > > (cc netfilter-devel@vger.kernel.org)
> >
> > The netfilter bug has since been fixed:
> >
> >   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/lo=
g/?id=3D7bbc3d385bd813077acaf0e6fdb2a86a901f5382
>
> How is this a "fix" ?
> u32 was the limit and because of the new warn the limit
> got reduced to s32.
> Every subsystem is supposed to do this "fix" now?

My intention was only to provide information about what had been done in
the ipset case.  In that case, there was already a check in place to
ensure that the requested hash-table size would not result in integer
overflow, and it was adjusted to reflect the limit imposed by the new
warning (one imagines that there is not much demand for hash-tables that
big).

I'm not familiar with the other cases, and so I would not presume to
make suggestions about whether those warnings were useful.

J.

--nUPL30MqoHnEoqa0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGpN6kACgkQKYasCr3x
BA1DFg/+Op3yh9EB8aITIjFewcU/5ehJujJveseMI0Dhey60wdWRpo9pcOsCqTvO
xhJJNW0s8X+31cvl26pxtelcfsiu12t4iEwFztiJSswYajjtvQx2wSP/CB7cE8CD
TLjYhZcVoWsJWVONOn9lVwKuA4AOR2lV7r2rybFf6+9YKGzQUaM9ZH6pNDUKqkQd
1ASff5plUkPCvwZBF0SkkJFdPjFLWT3xe3MLfL+IT2vXtDee619DNKUvZu+K8GJ6
fRGqWMpCi40yubOKx/zF7iJ9wMr3zOhoZyIcj7UQYvpIQEqsMp7Lthv3rjnDV8vh
WHTxwujs6Gmq/eZt5TCANLaJrATs3veigldNrqYFjjPSDZd1WiqIRD2D/IEZvYyD
reVasR8VROsRMmy/ojtj1nWp9SAzi0zQZK9defAZyTp1zSjGTVVrdxMvGtrttfSG
BAn/iGm3tEFMu53H0skJAM3TfvG8SCjeTXq4nPQRBsuV+ZiPvkBik38jrDRnNGoH
nf4ZYp+iu4Yef6x00qrJPycljZH+m1hWPYvP22L+PHbLt6WZh9i4JroyNqLFbl4y
W4eGYyM3kK1GLM1uLCZDrsajdCkN7cpcySHsXdrpND32OeuWgJJpug++GZUblDc8
Md5Yw2c0j3mI8rWwjjibawk40BtgyX1696vfZ5QiJ7o3CtUzAw4=
=Gsdm
-----END PGP SIGNATURE-----

--nUPL30MqoHnEoqa0--
