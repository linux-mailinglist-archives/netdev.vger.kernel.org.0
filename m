Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26262146FB8
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAWRat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:30:49 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42030 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbgAWRas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:30:48 -0500
Received: by mail-ed1-f68.google.com with SMTP id e10so4096815edv.9
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 09:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a4VaNrzbQO1GcIg/YS1YuuopvLPSuKTOR9MEaQWj+og=;
        b=Ek/tij/MT/WEmu0Vpr7gHtP/F15rfzV+VuE3cSsPdK1xlV8WeH7Eso5wPK7DH25cju
         JTeIhMLVsg9Ap0ZodKoWqjjNgu0yjUTDZQifmBE06y9+Io6eBhpFp5jxsBS/nc6ht07L
         2vTwLrqbkrYpcnqb85pqPvHpGsoccnCaN6OveeNHAM5RzYQ2sKbxMCtaAk2CinIP6eQV
         rZ5kIIuAxnmzqv1ii7YB8ARAUPNRqigMyJc68CIl3FM2fHOXlIlW4x4LpLtPwB4WC91S
         MkxOlze5MDoK0N4IPX+Eho5DyaRzjGPo8IgEv6n54eXJWS8bnK2q08T1DxYxpO+4E71R
         RUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a4VaNrzbQO1GcIg/YS1YuuopvLPSuKTOR9MEaQWj+og=;
        b=TOyJ1Rk7Mynw0zfj4IjEjhQl2ACnlk/6hEXIY1tH/NvtudtrGkpO6Lo40IVyzlnu/T
         1I7BAtOC6T2bPX/+5QsD6TyJd7axLlHa/J4D08gBrvGAW3HSYgaVo4OD7rHDw7zNZes5
         YcgVGAI1QfUZghtoWy8JXzsS7AKy5/epPTX+VZ63G5/BvkKu25bYoY+3MthjpeJc9E5T
         YGC9L7UbuLiRSnTP4WMgRzGwaJQOUa6Ll9Ak8/IK7JabXCfXrEkr7rinlYBg/pwIO3CR
         Q5N5/j9d9JMWW9WNnZKbDZSQpUEAh4Q4NJSAvhmr94PfQ86LudmbNfifoPG4Rbkwqy3A
         oy5A==
X-Gm-Message-State: APjAAAUMLpgdKg7z2CCFbtb0b/KsuKD0VOm5sXc2e4xq45DSQw7mtq+2
        CD30loxGbvOzrj6TqJhJuyG2jPZP0JJW4SsaF+L1eg==
X-Google-Smtp-Source: APXvYqyt8J67mbrRRHPjFnEk33di/ILv9Vov0CLSM0UC3AbHnxr5gbun7mRalQpffbT8pLbD7t//K2vJlpOoHsSaj9g=
X-Received: by 2002:a05:6402:6d2:: with SMTP id n18mr8057043edy.100.1579800646680;
 Thu, 23 Jan 2020 09:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk>
 <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk>
In-Reply-To: <87blqui1zu.fsf@toke.dk>
From:   Luigi Rizzo <lrizzo@google.com>
Date:   Thu, 23 Jan 2020 09:30:35 -0800
Message-ID: <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 23, 2020 at 8:14 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Daniel Borkmann <daniel@iogearbox.net> writes:
>
> > On 1/23/20 10:53 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> Luigi Rizzo <lrizzo@google.com> writes:
> >>
> >>> Add a netdevice flag to control skb linearization in generic xdp mode=
.
> >>> Among the various mechanism to control the flag, the sysfs
> >>> interface seems sufficiently simple and self-contained.
> >>> The attribute can be modified through
> >>>     /sys/class/net/<DEVICE>/xdp_linearize
> >>> The default is 1 (on)
> >
> > Needs documentation in Documentation/ABI/testing/sysfs-class-net.
> >
> >> Erm, won't turning off linearization break the XDP program's ability t=
o
> >> do direct packet access?
> >
> > Yes, in the worst case you only have eth header pulled into linear
> > section. :/
>
> In which case an eBPF program could read/write out of bounds since the
> verifier only verifies checks against xdp->data_end. Right?

Why out of bounds? Without linearization we construct xdp_buff as follows:

mac_len =3D skb->data - skb_mac_header(skb);
hlen =3D skb_headlen(skb) + mac_len;
xdp->data =3D skb->data - mac_len;
xdp->data_end =3D xdp->data + hlen;
xdp->data_hard_start =3D skb->data - skb_headroom(skb);

so we shouldn't go out of bounds.

cheers
luigi
