Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BCF32CACC
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 04:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhCDDYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 22:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhCDDXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 22:23:43 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E00C061574;
        Wed,  3 Mar 2021 19:23:03 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id u12so5889177pjr.2;
        Wed, 03 Mar 2021 19:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xdKiGIdwVXdTmOhV3INy054O4Zx9EPbcN+nl/sOK6d8=;
        b=DjALegeUk07ZVMgGsF2BzyV8Z/ZHTVxfahnRdM3qrJvRVJsuMdHGC2lcnQlbkFOC0c
         Z2g4XyDQ+kIcrPongySSTs1q/Sj0rpY+ZYDYceRTthp53mIJ76KvzBst5Wv2Sc6ASrEd
         1xdzHEam2gQ+YB30HBBtWFdnu6da2/qQMt/c7DfF8scYjJvprSuV8cHcv3AvOD7eChdn
         ZyMg4FiMkCmz4MNwaKB4julZP9jRmFh9e7JyMR5zeQ1guKJdB2AHfrBDQY2y357X9/ta
         emf6HZ6ku0+rnuvT98evhAZXKYtachOd/KHe1krGxBfz7GqgDMQn5Wrk1D9SHwwQhmuO
         AXLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=xdKiGIdwVXdTmOhV3INy054O4Zx9EPbcN+nl/sOK6d8=;
        b=XYyrD2AMbp9VN+nr0t+wrvPI/H7PtnfTQ0EfeADqVVGZmli6iEs7gKAW9BJFSh6kRZ
         6vQMFsavftxwpaDpuy8Rza5UAlsXuWfLzv2Oz2OwTbNjr+s+FB29AdvUvKYIntOX4fdy
         E9JeLuReCjs92TBZQqlcQ21+jsUMYF5waBUi6fG4ZaTCoiaaknSc+JH9fIpbid7WZ7dK
         w6JB3H9Ja2r8wkghbEIlj110iXqtb95LFeby6YWrT8Dwqi8f75enYi6CuvXH3QtChq6U
         BrjHNQMW7zZwv3pI8EP9dZbCulO2elGI4/3aoa28TgrRpXTjuzrKmqWq/pHB7ouEUE8l
         gRVg==
X-Gm-Message-State: AOAM532ZUgvkKuFI4iM5E36euy+ebwzotuVm8lKB9y7txK/fALVffQ/d
        GkjylsAitGULPKndfzNokxI=
X-Google-Smtp-Source: ABdhPJzxC3hgQXpl9HDkSGZFAMu9aumkgns3FG+CIrcInCkKzKAwlvJSXR9qzkljxfjUySQ+StxfXQ==
X-Received: by 2002:a17:902:e8cb:b029:e2:9906:45a6 with SMTP id v11-20020a170902e8cbb02900e2990645a6mr2085523plg.41.1614828183194;
        Wed, 03 Mar 2021 19:23:03 -0800 (PST)
Received: from [172.17.32.59] ([122.10.101.142])
        by smtp.gmail.com with ESMTPSA id mp19sm8950493pjb.2.2021.03.03.19.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 19:23:02 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH/v4] bpf: add bpf_skb_adjust_room flag
 BPF_F_ADJ_ROOM_ENCAP_L2_ETH
From:   Xuesen Huang <hxseverything@gmail.com>
In-Reply-To: <CA+FuTSfY0y7Y2XSKO-rqPY5mX83NWgAWbQeVukFA94eJVu2B2g@mail.gmail.com>
Date:   Thu, 4 Mar 2021 11:22:56 +0800
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D5B444A-FE98-46CF-80D2-DEEBE9C1D74A@gmail.com>
References: <20210303123338.99089-1-hxseverything@gmail.com>
 <CA+FuTSfY0y7Y2XSKO-rqPY5mX83NWgAWbQeVukFA94eJVu2B2g@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2021=E5=B9=B43=E6=9C=884=E6=97=A5 =E4=B8=8A=E5=8D=882:53=EF=BC=8CWillem =
de Bruijn <willemdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, Mar 3, 2021 at 7:33 AM Xuesen Huang <hxseverything@gmail.com> =
wrote:
>>=20
>> From: Xuesen Huang <huangxuesen@kuaishou.com>
>>=20
>> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for =
packets
>> encapsulation. But that is not appropriate when pushing Ethernet =
header.
>>=20
>> Add an option to further specify encap L2 type and set the =
inner_protocol
>> as ETH_P_TEB.
>>=20
>> Update test_tc_tunnel to verify adding vxlan encapsulation works with
>> this flag.
>>=20
>> Suggested-by: Willem de Bruijn <willemb@google.com>
>> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
>> Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
>> Signed-off-by: Li Wang <wangli09@kuaishou.com>
>=20
> Thanks for adding the test. Perhaps that is better in a separate =
patch?
>=20
> Overall looks great to me.
>=20
> The patch has not (yet?) arrived on patchwork.
>=20
Thanks Willem, I will separate it into two patch.

I will send patch/v5 with only that new flag addition, lol.

>> enum {
>> diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c =
b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> index 37bce7a..6e144db 100644
>> --- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> +++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
>> @@ -20,6 +20,14 @@
>> #include <bpf/bpf_endian.h>
>> #include <bpf/bpf_helpers.h>
>>=20
>> +#define encap_ipv4(...) __encap_ipv4(__VA_ARGS__, 0)
>> +
>> +#define encap_ipv4_with_ext_proto(...) __encap_ipv4(__VA_ARGS__)
>> +
>> +#define encap_ipv6(...) __encap_ipv6(__VA_ARGS__, 0)
>> +
>> +#define encap_ipv6_with_ext_proto(...) __encap_ipv6(__VA_ARGS__)
>> +
>=20
> Instead of untyped macros, I'd define encap_ipv4 as a function that
> calls __encap_ipv4.
>=20
> And no need for encap_ipv4_with_ext_proto equivalent to __encap_ipv4.
>=20
I defined these macros to try to keep the existing  invocation for =
encap_ipv4/6
as the same, if we define this as a function all invocation should be =
modified?

>> static const int cfg_port =3D 8000;
>>=20
>> static const int cfg_udp_src =3D 20000;
>> @@ -27,11 +35,24 @@
>> #define        UDP_PORT                5555
>> #define        MPLS_OVER_UDP_PORT      6635
>> #define        ETH_OVER_UDP_PORT       7777
>> +#define        VXLAN_UDP_PORT          8472
>> +
>> +#define        EXTPROTO_VXLAN  0x1
>> +
>> +#define        VXLAN_N_VID     (1u << 24)
>> +#define        VXLAN_VNI_MASK  bpf_htonl((VXLAN_N_VID - 1) << 8)
>> +#define        VXLAN_FLAGS     0x8
>> +#define        VXLAN_VNI       1
>>=20
>> /* MPLS label 1000 with S bit (last label) set and ttl of 255. */
>> static const __u32 mpls_label =3D __bpf_constant_htonl(1000 << 12 |
>>                                                     MPLS_LS_S_MASK | =
0xff);
>>=20
>> +struct vxlanhdr {
>> +       __be32 vx_flags;
>> +       __be32 vx_vni;
>> +} __attribute__((packed));
>> +
>> struct gre_hdr {
>>        __be16 flags;
>>        __be16 protocol;
>> @@ -45,13 +66,13 @@ struct gre_hdr {
>> struct v4hdr {
>>        struct iphdr ip;
>>        union l4hdr l4hdr;
>> -       __u8 pad[16];                   /* enough space for L2 header =
*/
>> +       __u8 pad[24];                   /* space for L2 header / =
vxlan header ... */
>=20
> could we use something like sizeof(..) instead of a constant?
>=20
Thanks, I will try to fix this.

>> @@ -171,14 +197,26 @@ static __always_inline int encap_ipv4(struct =
__sk_buff *skb, __u8 encap_proto,
>>        }
>>=20
>>        /* add L2 encap (if specified) */
>> +       l2_hdr =3D (__u8 *)&h_outer + olen;
>>        switch (l2_proto) {
>>        case ETH_P_MPLS_UC:
>> -               *((__u32 *)((__u8 *)&h_outer + olen)) =3D mpls_label;
>> +               *(__u32 *)l2_hdr =3D mpls_label;
>>                break;
>>        case ETH_P_TEB:
>> -               if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + =
olen,
>> -                                      ETH_HLEN))
>=20
> This is non-standard indentation? Here and elsewhere.
I thinks it=E2=80=99s a previous issue.

>=20
>> @@ -249,7 +288,11 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
>>                break;
>>        case ETH_P_TEB:
>>                l2_len =3D ETH_HLEN;
>> -               udp_dst =3D ETH_OVER_UDP_PORT;
>> +               if (ext_proto & EXTPROTO_VXLAN) {
>> +                       udp_dst =3D VXLAN_UDP_PORT;
>> +                       l2_len +=3D sizeof(struct vxlanhdr);
>> +               } else
>> +                       udp_dst =3D ETH_OVER_UDP_PORT;
>>                break;
>>        }
>>        flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
>> @@ -267,7 +310,7 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
>>                h_outer.l4hdr.udp.source =3D =
__bpf_constant_htons(cfg_udp_src);
>>                h_outer.l4hdr.udp.dest =3D bpf_htons(udp_dst);
>>                tot_len =3D bpf_ntohs(iph_inner.payload_len) + =
sizeof(iph_inner) +
>> -                         sizeof(h_outer.l4hdr.udp);
>> +                         sizeof(h_outer.l4hdr.udp) + l2_len;
>=20
> Was this a bug previously?
>=20
Yes, a tiny bug.

>>                h_outer.l4hdr.udp.check =3D 0;
>>                h_outer.l4hdr.udp.len =3D bpf_htons(tot_len);
>>                break;
>> @@ -278,13 +321,24 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
>>        }
>>=20
>>        /* add L2 encap (if specified) */
>> +       l2_hdr =3D (__u8 *)&h_outer + olen;
>>        switch (l2_proto) {
>>        case ETH_P_MPLS_UC:
>> -               *((__u32 *)((__u8 *)&h_outer + olen)) =3D mpls_label;
>> +               *(__u32 *)l2_hdr =3D mpls_label;
>>                break;
>>        case ETH_P_TEB:
>> -               if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + =
olen,
>> -                                      ETH_HLEN))
>> +               flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2_ETH;
>=20
> This is a change also for the existing case. Correctly so, I imagine.
> But the test used to pass with the wrong protocol?
Yes all tests pass. I=E2=80=99m not sure should we add this flag for the =
existing tests
which encap eth as the l2 header or only for the Vxlan test? =20

Waiting for your suggestion.
Thanks.


