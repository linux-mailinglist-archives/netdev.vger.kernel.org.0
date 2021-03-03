Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 017A832C44E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391385AbhCDAMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbhCCMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 07:50:16 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9991CC061756;
        Wed,  3 Mar 2021 04:49:06 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o10so16286898pgg.4;
        Wed, 03 Mar 2021 04:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=84vy5V1ggGNqfRw9O+2ONxJssH/UYcdhxJEl0OZ3ONk=;
        b=tgeXZmu0S541Z8eByoAsR2BKjbVDsTKL42XnaBo1RoI/wSOSMp1GjEUqN1e0PF03mz
         GPOyUpmkHUQLjbkIW4EinY/QSUdNwYdOIuWwpvVLRApLo2+iCT+YQISbMftfq8hn/a4O
         iaPNWdcrUzonz+qQHSoZ4MdvBEkU/PjK5LerjduIv+NTsHVgfXWPE9facFmkSXkM1yfm
         1knh1Y1KGDg+FcVRn8+Fsg0yXXx1kimoxw3Y+f83fb2gq3Z2zsuwEjMlo4p2DIM2F0SM
         U4xLIU+ksC9QcO/dqFYf/wPtmkMt2HSjSo52pOn7rNTzNPlHiesm231dhvfTIZEclqhT
         lWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=84vy5V1ggGNqfRw9O+2ONxJssH/UYcdhxJEl0OZ3ONk=;
        b=kKHKkgzEYmhglE6xpL0UG2TRn7hn9uuLHas0c05/tsCcq3TEN1Sbmbc7edhguCVXif
         had6oeg5+VEVwxSeeF9DtjD0XPiyyTcpNvjLsMEBnITmmWkILzMzW9/sqKjLXuMzExHg
         o18ACfoG5DLFCLy1B15KFT0+RU/ZQbgShpwtLJiDJVsFxpmcl8TtG2HQPvZvGvm3tDYI
         5P+9S/JkvSL6j6L/fgvwLHRZ+gfMLGUQov8VvkVIHPspTmbWt9HxlTRoBR+F1P396+u6
         Nu+qr50faqXvfELKQx0qN+xVz0VPItscli3s0D2UOWoXB7ZgmLa3bZ5+aNwJi18M7KLh
         qmmg==
X-Gm-Message-State: AOAM531r65TOkhMomG54YM6Bbc1NOgC0/21y8k3oDDqPPCV9O9Rw4yg7
        K7sMVN+DXKmCMZdVndr1DMU=
X-Google-Smtp-Source: ABdhPJzxv4itoN8uZlStfoIDcpmPB4hy0iIzlPzmBhthb+g+e66WxFAxSyqRV04m0fMhHBa8m5ELSg==
X-Received: by 2002:aa7:9aad:0:b029:1ee:468a:d950 with SMTP id x13-20020aa79aad0000b02901ee468ad950mr21962991pfi.40.1614775745912;
        Wed, 03 Mar 2021 04:49:05 -0800 (PST)
Received: from [172.17.32.59] ([103.112.79.202])
        by smtp.gmail.com with ESMTPSA id a1sm20672822pff.156.2021.03.03.04.49.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Mar 2021 04:49:05 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH/v4] bpf: add bpf_skb_adjust_room flag
 BPF_F_ADJ_ROOM_ENCAP_L2_ETH
From:   Xuesen Huang <hxseverything@gmail.com>
In-Reply-To: <20210303123338.99089-1-hxseverything@gmail.com>
Date:   Wed, 3 Mar 2021 20:48:59 +0800
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, xiyou.wangcong@gmail.com,
        Willem de Bruijn <willemb@google.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <73E63918-DF95-4AC1-B251-4481F2CA762B@gmail.com>
References: <20210303123338.99089-1-hxseverything@gmail.com>
To:     xiyou.wangcong@gmail.com
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Cong!

Thanks to your suggestion, I try to add a simple test case to =
test_tc_tunnel. It works=20
for me :)

Thanks for your review.

> 2021=E5=B9=B43=E6=9C=883=E6=97=A5 =E4=B8=8B=E5=8D=888:33=EF=BC=8CXuesen =
Huang <hxseverything@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Xuesen Huang <huangxuesen@kuaishou.com>
>=20
> bpf_skb_adjust_room sets the inner_protocol as skb->protocol for =
packets
> encapsulation. But that is not appropriate when pushing Ethernet =
header.
>=20
> Add an option to further specify encap L2 type and set the =
inner_protocol
> as ETH_P_TEB.
>=20
> Update test_tc_tunnel to verify adding vxlan encapsulation works with
> this flag.
>=20
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
> Signed-off-by: Li Wang <wangli09@kuaishou.com>
> ---
> include/uapi/linux/bpf.h                           |   5 +
> net/core/filter.c                                  |  11 ++-
> tools/include/uapi/linux/bpf.h                     |   5 +
> tools/testing/selftests/bpf/progs/test_tc_tunnel.c | 107 =
++++++++++++++++++---
> tools/testing/selftests/bpf/test_tc_tunnel.sh      |  15 ++-
> 5 files changed, 124 insertions(+), 19 deletions(-)
>=20
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 77d7c1b..d791596 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
>  *		  Use with ENCAP_L3/L4 flags to further specify the =
tunnel
>  *		  type; *len* is the length of the inner MAC header.
>  *
> + *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
> + *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further =
specify the
> + *		  L2 type as Ethernet.
> + *
>  * 		A call to this helper is susceptible to change the =
underlying
>  * 		packet buffer. Therefore, at load time, all checks on =
pointers
>  * 		previously done by the verifier are invalidated and must =
be
> @@ -4088,6 +4092,7 @@ enum {
> 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	=3D (1ULL << 3),
> 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	=3D (1ULL << 4),
> 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	=3D (1ULL << 5),
> +	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	=3D (1ULL << 6),
> };
>=20
> enum {
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 255aeee..8d1fb61 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3412,6 +3412,7 @@ static u32 bpf_skb_net_base_len(const struct =
sk_buff *skb)
> 					 BPF_F_ADJ_ROOM_ENCAP_L3_MASK | =
\
> 					 BPF_F_ADJ_ROOM_ENCAP_L4_GRE | \
> 					 BPF_F_ADJ_ROOM_ENCAP_L4_UDP | \
> +					 BPF_F_ADJ_ROOM_ENCAP_L2_ETH | \
> 					 BPF_F_ADJ_ROOM_ENCAP_L2( \
> 					  BPF_ADJ_ROOM_ENCAP_L2_MASK))
>=20
> @@ -3448,6 +3449,10 @@ static int bpf_skb_net_grow(struct sk_buff =
*skb, u32 off, u32 len_diff,
> 		    flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP)
> 			return -EINVAL;
>=20
> +		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH &&
> +		    inner_mac_len < ETH_HLEN)
> +			return -EINVAL;
> +
> 		if (skb->encapsulation)
> 			return -EALREADY;
>=20
> @@ -3466,7 +3471,11 @@ static int bpf_skb_net_grow(struct sk_buff =
*skb, u32 off, u32 len_diff,
> 		skb->inner_mac_header =3D inner_net - inner_mac_len;
> 		skb->inner_network_header =3D inner_net;
> 		skb->inner_transport_header =3D inner_trans;
> -		skb_set_inner_protocol(skb, skb->protocol);
> +
> +		if (flags & BPF_F_ADJ_ROOM_ENCAP_L2_ETH)
> +			skb_set_inner_protocol(skb, htons(ETH_P_TEB));
> +		else
> +			skb_set_inner_protocol(skb, skb->protocol);
>=20
> 		skb->encapsulation =3D 1;
> 		skb_set_network_header(skb, mac_len);
> diff --git a/tools/include/uapi/linux/bpf.h =
b/tools/include/uapi/linux/bpf.h
> index 77d7c1b..d791596 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1751,6 +1751,10 @@ struct bpf_stack_build_id {
>  *		  Use with ENCAP_L3/L4 flags to further specify the =
tunnel
>  *		  type; *len* is the length of the inner MAC header.
>  *
> + *		* **BPF_F_ADJ_ROOM_ENCAP_L2_ETH**:
> + *		  Use with BPF_F_ADJ_ROOM_ENCAP_L2 flag to further =
specify the
> + *		  L2 type as Ethernet.
> + *
>  * 		A call to this helper is susceptible to change the =
underlying
>  * 		packet buffer. Therefore, at load time, all checks on =
pointers
>  * 		previously done by the verifier are invalidated and must =
be
> @@ -4088,6 +4092,7 @@ enum {
> 	BPF_F_ADJ_ROOM_ENCAP_L4_GRE	=3D (1ULL << 3),
> 	BPF_F_ADJ_ROOM_ENCAP_L4_UDP	=3D (1ULL << 4),
> 	BPF_F_ADJ_ROOM_NO_CSUM_RESET	=3D (1ULL << 5),
> +	BPF_F_ADJ_ROOM_ENCAP_L2_ETH	=3D (1ULL << 6),
> };
>=20
> enum {
> diff --git a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c =
b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> index 37bce7a..6e144db 100644
> --- a/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> +++ b/tools/testing/selftests/bpf/progs/test_tc_tunnel.c
> @@ -20,6 +20,14 @@
> #include <bpf/bpf_endian.h>
> #include <bpf/bpf_helpers.h>
>=20
> +#define encap_ipv4(...) __encap_ipv4(__VA_ARGS__, 0)
> +
> +#define encap_ipv4_with_ext_proto(...) __encap_ipv4(__VA_ARGS__)
> +
> +#define encap_ipv6(...) __encap_ipv6(__VA_ARGS__, 0)
> +
> +#define encap_ipv6_with_ext_proto(...) __encap_ipv6(__VA_ARGS__)
> +
> static const int cfg_port =3D 8000;
>=20
> static const int cfg_udp_src =3D 20000;
> @@ -27,11 +35,24 @@
> #define	UDP_PORT		5555
> #define	MPLS_OVER_UDP_PORT	6635
> #define	ETH_OVER_UDP_PORT	7777
> +#define	VXLAN_UDP_PORT		8472
> +
> +#define	EXTPROTO_VXLAN	0x1
> +
> +#define	VXLAN_N_VID     (1u << 24)
> +#define	VXLAN_VNI_MASK	bpf_htonl((VXLAN_N_VID - 1) << 8)
> +#define	VXLAN_FLAGS     0x8
> +#define	VXLAN_VNI       1
>=20
> /* MPLS label 1000 with S bit (last label) set and ttl of 255. */
> static const __u32 mpls_label =3D __bpf_constant_htonl(1000 << 12 |
> 						     MPLS_LS_S_MASK | =
0xff);
>=20
> +struct vxlanhdr {
> +	__be32 vx_flags;
> +	__be32 vx_vni;
> +} __attribute__((packed));
> +
> struct gre_hdr {
> 	__be16 flags;
> 	__be16 protocol;
> @@ -45,13 +66,13 @@ struct gre_hdr {
> struct v4hdr {
> 	struct iphdr ip;
> 	union l4hdr l4hdr;
> -	__u8 pad[16];			/* enough space for L2 header */
> +	__u8 pad[24];			/* space for L2 header / vxlan =
header ... */
> } __attribute__((packed));
>=20
> struct v6hdr {
> 	struct ipv6hdr ip;
> 	union l4hdr l4hdr;
> -	__u8 pad[16];			/* enough space for L2 header */
> +	__u8 pad[24];			/* space for L2 header / vxlan =
header ... */
> } __attribute__((packed));
>=20
> static __always_inline void set_ipv4_csum(struct iphdr *iph)
> @@ -69,14 +90,15 @@ static __always_inline void set_ipv4_csum(struct =
iphdr *iph)
> 	iph->check =3D ~((csum & 0xffff) + (csum >> 16));
> }
>=20
> -static __always_inline int encap_ipv4(struct __sk_buff *skb, __u8 =
encap_proto,
> -				      __u16 l2_proto)
> +static __always_inline int __encap_ipv4(struct __sk_buff *skb, __u8 =
encap_proto,
> +				      __u16 l2_proto, __u16 ext_proto)
> {
> 	__u16 udp_dst =3D UDP_PORT;
> 	struct iphdr iph_inner;
> 	struct v4hdr h_outer;
> 	struct tcphdr tcph;
> 	int olen, l2_len;
> +	__u8 *l2_hdr =3D NULL;
> 	int tcp_off;
> 	__u64 flags;
>=20
> @@ -141,7 +163,11 @@ static __always_inline int encap_ipv4(struct =
__sk_buff *skb, __u8 encap_proto,
> 		break;
> 	case ETH_P_TEB:
> 		l2_len =3D ETH_HLEN;
> -		udp_dst =3D ETH_OVER_UDP_PORT;
> +		if (ext_proto & EXTPROTO_VXLAN) {
> +			udp_dst =3D VXLAN_UDP_PORT;
> +			l2_len +=3D sizeof(struct vxlanhdr);
> +		} else
> +			udp_dst =3D ETH_OVER_UDP_PORT;
> 		break;
> 	}
> 	flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
> @@ -171,14 +197,26 @@ static __always_inline int encap_ipv4(struct =
__sk_buff *skb, __u8 encap_proto,
> 	}
>=20
> 	/* add L2 encap (if specified) */
> +	l2_hdr =3D (__u8 *)&h_outer + olen;
> 	switch (l2_proto) {
> 	case ETH_P_MPLS_UC:
> -		*((__u32 *)((__u8 *)&h_outer + olen)) =3D mpls_label;
> +		*(__u32 *)l2_hdr =3D mpls_label;
> 		break;
> 	case ETH_P_TEB:
> -		if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
> -				       ETH_HLEN))
> +		flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2_ETH;
> +
> +		if (ext_proto & EXTPROTO_VXLAN) {
> +			struct vxlanhdr *vxlan_hdr =3D (struct vxlanhdr =
*)l2_hdr;
> +
> +			vxlan_hdr->vx_flags =3D VXLAN_FLAGS;
> +			vxlan_hdr->vx_vni =3D bpf_htonl((VXLAN_VNI & =
VXLAN_VNI_MASK) << 8);
> +
> +			l2_hdr +=3D sizeof(struct vxlanhdr);
> +		}
> +
> +		if (bpf_skb_load_bytes(skb, 0, l2_hdr, ETH_HLEN))
> 			return TC_ACT_SHOT;
> +
> 		break;
> 	}
> 	olen +=3D l2_len;
> @@ -214,14 +252,15 @@ static __always_inline int encap_ipv4(struct =
__sk_buff *skb, __u8 encap_proto,
> 	return TC_ACT_OK;
> }
>=20
> -static __always_inline int encap_ipv6(struct __sk_buff *skb, __u8 =
encap_proto,
> -				      __u16 l2_proto)
> +static __always_inline int __encap_ipv6(struct __sk_buff *skb, __u8 =
encap_proto,
> +				      __u16 l2_proto, __u16 ext_proto)
> {
> 	__u16 udp_dst =3D UDP_PORT;
> 	struct ipv6hdr iph_inner;
> 	struct v6hdr h_outer;
> 	struct tcphdr tcph;
> 	int olen, l2_len;
> +	__u8 *l2_hdr =3D NULL;
> 	__u16 tot_len;
> 	__u64 flags;
>=20
> @@ -249,7 +288,11 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
> 		break;
> 	case ETH_P_TEB:
> 		l2_len =3D ETH_HLEN;
> -		udp_dst =3D ETH_OVER_UDP_PORT;
> +		if (ext_proto & EXTPROTO_VXLAN) {
> +			udp_dst =3D VXLAN_UDP_PORT;
> +			l2_len +=3D sizeof(struct vxlanhdr);
> +		} else
> +			udp_dst =3D ETH_OVER_UDP_PORT;
> 		break;
> 	}
> 	flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2(l2_len);
> @@ -267,7 +310,7 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
> 		h_outer.l4hdr.udp.source =3D =
__bpf_constant_htons(cfg_udp_src);
> 		h_outer.l4hdr.udp.dest =3D bpf_htons(udp_dst);
> 		tot_len =3D bpf_ntohs(iph_inner.payload_len) + =
sizeof(iph_inner) +
> -			  sizeof(h_outer.l4hdr.udp);
> +			  sizeof(h_outer.l4hdr.udp) + l2_len;
> 		h_outer.l4hdr.udp.check =3D 0;
> 		h_outer.l4hdr.udp.len =3D bpf_htons(tot_len);
> 		break;
> @@ -278,13 +321,24 @@ static __always_inline int encap_ipv6(struct =
__sk_buff *skb, __u8 encap_proto,
> 	}
>=20
> 	/* add L2 encap (if specified) */
> +	l2_hdr =3D (__u8 *)&h_outer + olen;
> 	switch (l2_proto) {
> 	case ETH_P_MPLS_UC:
> -		*((__u32 *)((__u8 *)&h_outer + olen)) =3D mpls_label;
> +		*(__u32 *)l2_hdr =3D mpls_label;
> 		break;
> 	case ETH_P_TEB:
> -		if (bpf_skb_load_bytes(skb, 0, (__u8 *)&h_outer + olen,
> -				       ETH_HLEN))
> +		flags |=3D BPF_F_ADJ_ROOM_ENCAP_L2_ETH;
> +
> +		if (ext_proto & EXTPROTO_VXLAN) {
> +			struct vxlanhdr *vxlan_hdr =3D (struct vxlanhdr =
*)l2_hdr;
> +
> +			vxlan_hdr->vx_flags =3D VXLAN_FLAGS;
> +			vxlan_hdr->vx_vni =3D bpf_htonl((VXLAN_VNI & =
VXLAN_VNI_MASK) << 8);
> +
> +			l2_hdr +=3D sizeof(struct vxlanhdr);
> +		}
> +
> +		if (bpf_skb_load_bytes(skb, 0, l2_hdr, ETH_HLEN))
> 			return TC_ACT_SHOT;
> 		break;
> 	}
> @@ -372,6 +426,16 @@ int __encap_udp_eth(struct __sk_buff *skb)
> 		return TC_ACT_OK;
> }
>=20
> +SEC("encap_vxlan_eth")
> +int __encap_vxlan_eth(struct __sk_buff *skb)
> +{
> +	if (skb->protocol =3D=3D __bpf_constant_htons(ETH_P_IP))
> +		return encap_ipv4_with_ext_proto(skb, IPPROTO_UDP,
> +				ETH_P_TEB, EXTPROTO_VXLAN);
> +	else
> +		return TC_ACT_OK;
> +}
> +
> SEC("encap_sit_none")
> int __encap_sit_none(struct __sk_buff *skb)
> {
> @@ -444,6 +508,16 @@ int __encap_ip6udp_eth(struct __sk_buff *skb)
> 		return TC_ACT_OK;
> }
>=20
> +SEC("encap_ip6vxlan_eth")
> +int __encap_ip6vxlan_eth(struct __sk_buff *skb)
> +{
> +	if (skb->protocol =3D=3D __bpf_constant_htons(ETH_P_IPV6))
> +		return encap_ipv6_with_ext_proto(skb, IPPROTO_UDP,
> +				ETH_P_TEB, EXTPROTO_VXLAN);
> +	else
> +		return TC_ACT_OK;
> +}
> +
> static int decap_internal(struct __sk_buff *skb, int off, int len, =
char proto)
> {
> 	char buf[sizeof(struct v6hdr)];
> @@ -479,6 +553,9 @@ static int decap_internal(struct __sk_buff *skb, =
int off, int len, char proto)
> 		case ETH_OVER_UDP_PORT:
> 			olen +=3D ETH_HLEN;
> 			break;
> +		case VXLAN_UDP_PORT:
> +			olen +=3D ETH_HLEN + sizeof(struct vxlanhdr);
> +			break;
> 		}
> 		break;
> 	default:
> diff --git a/tools/testing/selftests/bpf/test_tc_tunnel.sh =
b/tools/testing/selftests/bpf/test_tc_tunnel.sh
> index 7c76b84..c9dde9b 100755
> --- a/tools/testing/selftests/bpf/test_tc_tunnel.sh
> +++ b/tools/testing/selftests/bpf/test_tc_tunnel.sh
> @@ -44,8 +44,8 @@ setup() {
> 	# clamp route to reserve room for tunnel headers
> 	ip -netns "${ns1}" -4 route flush table main
> 	ip -netns "${ns1}" -6 route flush table main
> -	ip -netns "${ns1}" -4 route add "${ns2_v4}" mtu 1458 dev veth1
> -	ip -netns "${ns1}" -6 route add "${ns2_v6}" mtu 1438 dev veth1
> +	ip -netns "${ns1}" -4 route add "${ns2_v4}" mtu 1450 dev veth1
> +	ip -netns "${ns1}" -6 route add "${ns2_v6}" mtu 1430 dev veth1
>=20
> 	sleep 1
>=20
> @@ -105,6 +105,12 @@ if [[ "$#" -eq "0" ]]; then
> 	echo "sit"
> 	$0 ipv6 sit none 100
>=20
> +	echo "ip4 vxlan"
> +	$0 ipv4 vxlan eth 2000
> +
> +	echo "ip6 vxlan"
> +	$0 ipv6 ip6vxlan eth 2000
> +
> 	for mac in none mpls eth ; do
> 		echo "ip gre $mac"
> 		$0 ipv4 gre $mac 100
> @@ -214,6 +220,9 @@ if [[ "$tuntype" =3D~ "udp" ]]; then
> 	targs=3D"encap fou encap-sport auto encap-dport $dport"
> elif [[ "$tuntype" =3D~ "gre" && "$mac" =3D=3D "eth" ]]; then
> 	ttype=3D$gretaptype
> +elif [[ "$tuntype" =3D~ "vxlan" && "$mac" =3D=3D "eth" ]]; then
> +	ttype=3D"vxlan"
> +	targs=3D"id 1 dstport 8472 udp6zerocsumrx"
> else
> 	ttype=3D$tuntype
> 	targs=3D""
> @@ -242,7 +251,7 @@ if [[ "$tuntype" =3D=3D "ip6udp" && "$mac" =3D=3D =
"mpls" ]]; then
> elif [[ "$tuntype" =3D~ "udp" && "$mac" =3D=3D "eth" ]]; then
> 	# No support for TEB fou tunnel; expect failure.
> 	expect_tun_fail=3D1
> -elif [[ "$tuntype" =3D~ "gre" && "$mac" =3D=3D "eth" ]]; then
> +elif [[ "$tuntype" =3D~ (gre|vxlan) && "$mac" =3D=3D "eth" ]]; then
> 	# Share ethernet address between tunnel/veth2 so L2 decap works.
> 	ethaddr=3D$(ip netns exec "${ns2}" ip link show veth2 | \
> 		  awk '/ether/ { print $2 }')
> --=20
> 1.8.3.1
>=20

