Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00BDE72358
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbfGXAQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:16:10 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37727 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbfGXAQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:16:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id y26so43758750qto.4
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=DlN9QRCV3ElFQ7B7e0ZjlaYwOT8vcTapNg7jJk2jCok=;
        b=BQ5jtww4150q+ZhrghI3hTl6vrPLVlLZTuVHoEgLMuMZLAmNixfF9IUtQs9X4HrCJW
         sPrp6fFbnGW906vj92XkvtoAFkk9wCM62C/8hxRpiiDKra8ZI9J4tX3zOim6XjWuUiNw
         k75i8VtnuXViUhocFvbX8Hkl3ACJx9eUKcF8eIiqTr+u2B+UTBIvdS51i1OFbUAbNvKo
         hzbVSXDZe8nBhGhxfzXqChLzheHw2NBmzHkb8zn/FQKUool5kyzT9L5TrqvZ0dRCyZyH
         AxGJirzm3oKvlUm11932QI11NtpKMeqN0ryxVIll5anLgve01+kYSlOiUnSiiNY6ctGW
         f7Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DlN9QRCV3ElFQ7B7e0ZjlaYwOT8vcTapNg7jJk2jCok=;
        b=dAkXXW8XWFM952auZfc8yXnN1gM03dgPKNE1H8FJAwteNaxffG3s8aFEreBZNr8EEx
         Sz3pes6EYi+31NIqCKINxFib/T4Z4KHGIGU0cvHj05vyDEKh6BRNd92WG8rXLDyMzhMJ
         fj+2mm9Y+OvCXfez8F/pQlvBhsPxYF5mbyl3FAnb4dTOmgyRMFJdwfpMjMdZN6tbiSSD
         s4slrL5Tlvqtlfbu+2rlGr2XrUlddiXYnZvgd9RKMLSIxp4Q/rmvNESX1RbM2parjrni
         TNyFl/s6yxyHHrrPfn7cDgdZshdpHJPNmIet8gjaJwL37endSsJa94vc39F5vNMTeLIh
         oNKg==
X-Gm-Message-State: APjAAAV/aqSOBQeCp59k+9w1/hmYqR11Jrf74SGJXjDndS8vclN7rUDM
        IFREclbPiLB4VmDIb1BYLrgN3W0CLz5NtYltDDzDg7uC
X-Google-Smtp-Source: APXvYqxXUrLhbjaVUyp3x6qUcQKcLde73DUotek3MzAk9h2EyV7UIPYozg7b97yo99TnMpk0idlCLrL48Xshh7WanOM=
X-Received: by 2002:ac8:7549:: with SMTP id b9mr13406706qtr.198.1563927368322;
 Tue, 23 Jul 2019 17:16:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190723002042.105927-1-ppenkov.kernel@gmail.com>
 <20190723002042.105927-4-ppenkov.kernel@gmail.com> <8736ix3p8h.fsf@toke.dk>
In-Reply-To: <8736ix3p8h.fsf@toke.dk>
From:   Petar Penkov <ppenkov@google.com>
Date:   Tue, 23 Jul 2019 17:15:57 -0700
Message-ID: <CAG4SDVUnPxtRVJ3XisuEuOBWFfYJrFj-5srDvDBVKdq3-dGPnw@mail.gmail.com>
Subject: Re: [bpf-next 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Petar Penkov <ppenkov.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, lmb@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 5:33 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Petar Penkov <ppenkov.kernel@gmail.com> writes:
>
> > From: Petar Penkov <ppenkov@google.com>
> >
> > This helper function allows BPF programs to try to generate SYN
> > cookies, given a reference to a listener socket. The function works
> > from XDP and with an skb context since bpf_skc_lookup_tcp can lookup a
> > socket in both cases.
> >
> > Signed-off-by: Petar Penkov <ppenkov@google.com>
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > ---
> >  include/uapi/linux/bpf.h | 30 ++++++++++++++++-
> >  net/core/filter.c        | 73 ++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 102 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 6f68438aa4ed..20baee7b2219 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2713,6 +2713,33 @@ union bpf_attr {
> >   *           **-EPERM** if no permission to send the *sig*.
> >   *
> >   *           **-EAGAIN** if bpf program can try again.
> > + *
> > + * s64 bpf_tcp_gen_syncookie(struct bpf_sock *sk, void *iph, u32 iph_l=
en, struct tcphdr *th, u32 th_len)
> > + *   Description
> > + *           Try to issue a SYN cookie for the packet with correspondi=
ng
> > + *           IP/TCP headers, *iph* and *th*, on the listening socket i=
n *sk*.
> > + *
> > + *           *iph* points to the start of the IPv4 or IPv6 header, whi=
le
> > + *           *iph_len* contains **sizeof**\ (**struct iphdr**) or
> > + *           **sizeof**\ (**struct ip6hdr**).
> > + *
> > + *           *th* points to the start of the TCP header, while *th_len=
*
> > + *           contains the length of the TCP header.
> > + *
> > + *   Return
> > + *           On success, lower 32 bits hold the generated SYN cookie i=
n
> > + *           followed by 16 bits which hold the MSS value for that coo=
kie,
> > + *           and the top 16 bits are unused.
> > + *
> > + *           On failure, the returned value is one of the following:
> > + *
> > + *           **-EINVAL** SYN cookie cannot be issued due to error
> > + *
> > + *           **-ENOENT** SYN cookie should not be issued (no SYN flood=
)
> > + *
> > + *           **-ENOTSUPP** kernel configuration does not enable SYN
> > cookies
>
> nit: This should be EOPNOTSUPP - the other one is for NFS...
Will correct this in a v2, thanks for catching that!

>
> > + *
> > + *           **-EPROTONOSUPPORT** IP packet version is not 4 or 6
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)                \
> >       FN(unspec),                     \
> > @@ -2824,7 +2851,8 @@ union bpf_attr {
> >       FN(strtoul),                    \
> >       FN(sk_storage_get),             \
> >       FN(sk_storage_delete),          \
> > -     FN(send_signal),
> > +     FN(send_signal),                \
> > +     FN(tcp_gen_syncookie),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which =
helper
> >   * function eBPF program intends to call
> > diff --git a/net/core/filter.c b/net/core/filter.c
> > index 47f6386fb17a..92114271eff6 100644
> > --- a/net/core/filter.c
> > +++ b/net/core/filter.c
> > @@ -5850,6 +5850,75 @@ static const struct bpf_func_proto bpf_tcp_check=
_syncookie_proto =3D {
> >       .arg5_type      =3D ARG_CONST_SIZE,
> >  };
> >
> > +BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32,=
 iph_len,
> > +        struct tcphdr *, th, u32, th_len)
> > +{
> > +#ifdef CONFIG_SYN_COOKIES
> > +     u32 cookie;
> > +     u16 mss;
> > +
> > +     if (unlikely(th_len < sizeof(*th) || th_len !=3D th->doff * 4))
> > +             return -EINVAL;
> > +
> > +     if (sk->sk_protocol !=3D IPPROTO_TCP || sk->sk_state !=3D TCP_LIS=
TEN)
> > +             return -EINVAL;
> > +
> > +     if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> > +             return -ENOENT;
> > +
> > +     if (!th->syn || th->ack || th->fin || th->rst)
> > +             return -EINVAL;
> > +
> > +     if (unlikely(iph_len < sizeof(struct iphdr)))
> > +             return -EINVAL;
> > +
> > +     /* Both struct iphdr and struct ipv6hdr have the version field at=
 the
> > +      * same offset so we can cast to the shorter header (struct iphdr=
).
> > +      */
> > +     switch (((struct iphdr *)iph)->version) {
> > +     case 4:
> > +             if (sk->sk_family =3D=3D AF_INET6 && sk->sk_ipv6only)
> > +                     return -EINVAL;
> > +
> > +             mss =3D tcp_v4_get_syncookie(sk, iph, th, &cookie);
> > +             break;
> > +
> > +#if IS_BUILTIN(CONFIG_IPV6)
> > +     case 6:
> > +             if (unlikely(iph_len < sizeof(struct ipv6hdr)))
> > +                     return -EINVAL;
> > +
> > +             if (sk->sk_family !=3D AF_INET6)
> > +                     return -EINVAL;
> > +
> > +             mss =3D tcp_v6_get_syncookie(sk, iph, th, &cookie);
> > +             break;
> > +#endif /* CONFIG_IPV6 */
> > +
> > +     default:
> > +             return -EPROTONOSUPPORT;
> > +     }
> > +     if (mss <=3D 0)
> > +             return -ENOENT;
> > +
> > +     return cookie | ((u64)mss << 32);
> > +#else
> > +     return -ENOTSUPP;
>
> See above
>
> > +#endif /* CONFIG_SYN_COOKIES */
> > +}
> > +
> > +static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto =3D {
> > +     .func           =3D bpf_tcp_gen_syncookie,
> > +     .gpl_only       =3D true, /* __cookie_v*_init_sequence() is GPL *=
/
> > +     .pkt_access     =3D true,
> > +     .ret_type       =3D RET_INTEGER,
> > +     .arg1_type      =3D ARG_PTR_TO_SOCK_COMMON,
> > +     .arg2_type      =3D ARG_PTR_TO_MEM,
> > +     .arg3_type      =3D ARG_CONST_SIZE,
> > +     .arg4_type      =3D ARG_PTR_TO_MEM,
> > +     .arg5_type      =3D ARG_CONST_SIZE,
> > +};
> > +
> >  #endif /* CONFIG_INET */
> >
> >  bool bpf_helper_changes_pkt_data(void *func)
> > @@ -6135,6 +6204,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, c=
onst struct bpf_prog *prog)
> >               return &bpf_tcp_check_syncookie_proto;
> >       case BPF_FUNC_skb_ecn_set_ce:
> >               return &bpf_skb_ecn_set_ce_proto;
> > +     case BPF_FUNC_tcp_gen_syncookie:
> > +             return &bpf_tcp_gen_syncookie_proto;
> >  #endif
> >       default:
> >               return bpf_base_func_proto(func_id);
> > @@ -6174,6 +6245,8 @@ xdp_func_proto(enum bpf_func_id func_id, const st=
ruct bpf_prog *prog)
> >               return &bpf_xdp_skc_lookup_tcp_proto;
> >       case BPF_FUNC_tcp_check_syncookie:
> >               return &bpf_tcp_check_syncookie_proto;
> > +     case BPF_FUNC_tcp_gen_syncookie:
> > +             return &bpf_tcp_gen_syncookie_proto;
> >  #endif
> >       default:
> >               return bpf_base_func_proto(func_id);
> > --
> > 2.22.0.657.g960e92d24f-goog
