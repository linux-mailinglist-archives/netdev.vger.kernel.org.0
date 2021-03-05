Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E47332E7CC
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhCEMU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 07:20:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhCEMUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:20:47 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16F3C061574;
        Fri,  5 Mar 2021 04:20:46 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t25so1253369pga.2;
        Fri, 05 Mar 2021 04:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Uh9p0RSc8dHyDNEag591AlYjV9Zp1DnOW10nwM2LhJ0=;
        b=hxape13oVsVoduHAonjoZ/cRTP7CQZFtT51ZBnzwH+vLcq2Mv9wnGjrT8hHN0tpQZx
         EmiqW9KHjSyfu3pkZPNCnMXqugdzQKfmb/8vL3RTL64GTFhJQFYHogEPnol2CGrroobC
         oqvMehLlls6U84btOyr8AYkGBLTkG3fZW+sZ2rpxY8/lE0eHkMOvgxsWvV4m7/oqzIEi
         qX0np24yMVOUOdiawmF/3nOvRGbGTPzty2Kp5hZs7zfQQbCF49WlG1UPoRnRPDP+OPPe
         rEOT8PVWSrpdWPXay1Yy6hjccah2cs/76psNdycG6ffbJ3tANzmmWtLLfef88HWse13U
         qAGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Uh9p0RSc8dHyDNEag591AlYjV9Zp1DnOW10nwM2LhJ0=;
        b=ltFCb1hffg3EbpsIt/m7qXgxvF2HrzCw+HjNqebXptHe5MBjhSju2j3BzzY+3blnSS
         wXFsCtZoaU5ssUmRWMIEtlgVQw07dRZ1Q0sGu99gMPJ6lmVebSPpiUY3kJNhJpFYpblZ
         /4ZfDIk1sJIQnlwknk2N9sRNGhcQFn2HjHBZu/SVEnSG69idgkSUEnbKZXXjHnCnglb2
         yyYSG5Obgx+pvMDHu5cA1x6Pdv5fEhjPUF8esqcp1LpbcQLVVLyzyX2+TYqsGNPBfttn
         +/uhniFEbZoTbHnH1FXR1mW+CNP8hTWHGDVCOgR4QDg4dHelFtFF9ZTQOyhRrLeV5jy7
         gT6Q==
X-Gm-Message-State: AOAM531rcrgx+QSfqHmK/ArD2Rj5TxVwzNrMiaXUwPhXnUmxESIgwLN/
        JsCFufyNmeAzuz5WMMirENc=
X-Google-Smtp-Source: ABdhPJx1eYs1tycuYxQCZmEXP6GtGAr1Gxvb8cn9wcCOGHHMkoQ4EQFDzIP9e0+fR9fZ3ddr5cKISw==
X-Received: by 2002:a65:64ce:: with SMTP id t14mr8234255pgv.36.1614946846538;
        Fri, 05 Mar 2021 04:20:46 -0800 (PST)
Received: from [172.17.32.59] ([154.48.252.65])
        by smtp.gmail.com with ESMTPSA id w4sm2233307pjk.55.2021.03.05.04.20.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Mar 2021 04:20:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH] selftests_bpf: extend test_tc_tunnel test with vxlan
From:   Xuesen Huang <hxseverything@gmail.com>
In-Reply-To: <CA+FuTSfj2u5pEbKJR_m0qCiPfdhCVS_BZVPPO=dNjAyL7HG7FQ@mail.gmail.com>
Date:   Fri, 5 Mar 2021 20:20:41 +0800
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9789D5AA-5B93-4045-9818-B1E84C01A16C@gmail.com>
References: <20210304064212.6513-1-hxseverything@gmail.com>
 <CA+FuTSfj2u5pEbKJR_m0qCiPfdhCVS_BZVPPO=dNjAyL7HG7FQ@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> 2021=E5=B9=B43=E6=9C=884=E6=97=A5 =E4=B8=8B=E5=8D=8810:02=EF=BC=8CWillem=
 de Bruijn <willemdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Mar 4, 2021 at 1:42 AM Xuesen Huang <hxseverything@gmail.com> =
wrote:
>>=20
>> From: Xuesen Huang <huangxuesen@kuaishou.com>
>>=20
>> Add BPF_F_ADJ_ROOM_ENCAP_L2_ETH flag to the existing tests which
>> encapsulates the ethernet as the inner l2 header.
>>=20
>> Update a vxlan encapsulation test case.
>>=20
>> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
>> Signed-off-by: Li Wang <wangli09@kuaishou.com>
>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>=20
> Please mark patch target: [PATCH bpf-next]
>=20
Thanks.

>> ---
>> tools/testing/selftests/bpf/progs/test_tc_tunnel.c | 113 =
++++++++++++++++++---
>> tools/testing/selftests/bpf/test_tc_tunnel.sh      |  15 ++-
>> 2 files changed, 111 insertions(+), 17 deletions(-)
>=20
>=20
>> -static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 =
encap_proto,
>> -                                     __u16 l2_proto)
>> +static __always_inline int __encap_ipv4(struct __sk_buff *skb, __u8 =
encap_proto,
>> +                                       __u16 l2_proto, __u16 =
ext_proto)
>> {
>>        __u16 udp_dst =3D UDP_PORT;
>>        struct iphdr iph_inner;
>>        struct v4hdr h_outer;
>>        struct tcphdr tcph;
>>        int olen, l2_len;
>> +       __u8 *l2_hdr =3D NULL;
>>        int tcp_off;
>>        __u64 flags;
>>=20
>> @@ -141,7 +157,11 @@ static __always_inline int encap_ipv4(struct =
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
>> @@ -171,14 +191,26 @@ static __always_inline int encap_ipv4(struct =
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
>> +
>> +               if (ext_proto & EXTPROTO_VXLAN) {
>> +                       struct vxlanhdr *vxlan_hdr =3D (struct =
vxlanhdr *)l2_hdr;
>> +
>> +                       vxlan_hdr->vx_flags =3D VXLAN_FLAGS;
>> +                       vxlan_hdr->vx_vni =3D bpf_htonl((VXLAN_VNI & =
VXLAN_VNI_MASK) << 8);
>> +
>> +                       l2_hdr +=3D sizeof(struct vxlanhdr);
>=20
> should this be l2_len? (here and ipv6 below)
>=20
Should be l2_hdr.=20

It=E2=80=99s a little tricky. l2_len has already been modified above. We =
use l2_hdr here=20
to help us to find the address in h_outer to load original Ethernet =
header which=20
is different in (eth) and (vxlan + eth).

>> +SEC("encap_vxlan_eth")
>> +int __encap_vxlan_eth(struct __sk_buff *skb)
>> +{
>> +       if (skb->protocol =3D=3D __bpf_constant_htons(ETH_P_IP))
>> +               return __encap_ipv4(skb, IPPROTO_UDP,
>> +                               ETH_P_TEB,
>> +                               EXTPROTO_VXLAN);
>=20
> non-standard indentation: align with the opening parenthesis. (here
> and ipv6 below)
Thanks.

