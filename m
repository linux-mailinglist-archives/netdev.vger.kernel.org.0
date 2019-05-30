Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C293057E
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfE3Xjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:39:49 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34509 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3Xjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:39:49 -0400
Received: by mail-qt1-f196.google.com with SMTP id h1so9269314qtp.1
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 16:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hXLpKROCv0+/QznwBAodrkIURDr6M1pqnw0YoSzBCmo=;
        b=uvduLde2jsnwTcCSfzCB4PetbpYt2VIBgWX80CCCZG37Wv4BI8LqFXs8yBq5I3nKO6
         KApc7LC0v5MCxnpZ6UvBXDa0wvt9LEck41fi2pdRcKZWL4zyexchFQqyBrdFTJ9OsVu7
         cD0hl8rkYhzHKiU+h7U9+odKH89sZ6OZiO6Olt5ZrRHksyB0iGVSBym6JAgszB1/KONc
         cN+7Huo0OSStqNxPrF1oSVEpZjFXm2pGb6f6jdl53jTB0e6ZXXqqoSqv9YNAdUOWgnUx
         4Mpy96xXw5XFSqUVX5Hk9hK6CxAJrt1zBRHusvd26IA8VngARjJ4/D14GM/ZpJPxTm0m
         iYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hXLpKROCv0+/QznwBAodrkIURDr6M1pqnw0YoSzBCmo=;
        b=KLG1bOGYeKNkgnwMYDz7GmCQlk+YijvlBLJdFtxrQ7oFxgXkJaAw8fRFrTsmq8NWuE
         kb89zhhuiFRFmkmfn3Iwr0TefHYnNYrhQAL9DSzEcOXjEMgyr/+al2lpPLPEcU/vyI/0
         xwzbrVOjLFDTTeVn9YkV0MJhILAudgOu6RIcbyT6K59+fJLMhT0ybf8sMTNJyookCZUJ
         24xMSB5Gfo+RWsAebBgLvWIfe78uGIGTl85fzWN35BYsIVhF0Ex7MFp3jqWJdjTRPB5x
         OTzKyb4VwgI94gLIz5g/98Hj6rlS3FrMLeLwrEywm3PYg+GlKvA8cBEWhlC2ITJH8+fu
         TwKw==
X-Gm-Message-State: APjAAAX9U6BlDyHKtERgk+ZI2Cf6GoujH7jHJ3kX8dQK7Jpj0B+Qr7qk
        4JuE5sHNRhkukGlXaX6y/PDRRWiZtvqdEqnoRozyHw==
X-Google-Smtp-Source: APXvYqxTCwwv1Qa+RL2ppA/YYndRSGPo+6MwP0WIZDDPZ13CAu+hcmRE2uMZ0uCqJGngxUTAeHFzuv0L913XzG/m2S8=
X-Received: by 2002:ad4:53c2:: with SMTP id k2mr5772487qvv.15.1559259587329;
 Thu, 30 May 2019 16:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1526143526.git.m.xhonneux@gmail.com> <7839e5fff52b4b96e5eb0ae8a72a76f8a1e76a8e.1526143526.git.m.xhonneux@gmail.com>
In-Reply-To: <7839e5fff52b4b96e5eb0ae8a72a76f8a1e76a8e.1526143526.git.m.xhonneux@gmail.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Thu, 30 May 2019 16:39:36 -0700
Message-ID: <CALx6S35EeDm09zhsjdYwLwDC9=Fs-shWK0eqUUYozjTf1q-R9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/6] bpf: Add IPv6 Segment Routing helpers
To:     Mathieu Xhonneux <m.xhonneux@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        dlebrun@google.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 12, 2018 at 8:26 AM Mathieu Xhonneux <m.xhonneux@gmail.com> wro=
te:
>
> The BPF seg6local hook should be powerful enough to enable users to
> implement most of the use-cases one could think of. After some thinking,
> we figured out that the following actions should be possible on a SRv6
> packet, requiring 3 specific helpers :
>     - bpf_lwt_seg6_store_bytes: Modify non-sensitive fields of the SRH
>     - bpf_lwt_seg6_adjust_srh: Allow to grow or shrink a SRH
>                                (to add/delete TLVs)

Note that the current draft of SRH does not allow TLVs to be added or
deleted in flight (draft-ietf-6man-segment-routing-header-19). Neither
is it permissible to change the size of an extension header of a
packet in flight. Is this code enabling that?

Tom

>     - bpf_lwt_seg6_action: Apply some SRv6 network programming actions
>                            (specifically End.X, End.T, End.B6 and
>                             End.B6.Encap)
>
> The specifications of these helpers are provided in the patch (see
> include/uapi/linux/bpf.h).
>
> The non-sensitive fields of the SRH are the following : flags, tag and
> TLVs. The other fields can not be modified, to maintain the SRH
> integrity. Flags, tag and TLVs can easily be modified as their validity
> can be checked afterwards via seg6_validate_srh. It is not allowed to
> modify the segments directly. If one wants to add segments on the path,
> he should stack a new SRH using the End.B6 action via
> bpf_lwt_seg6_action.
>
> Growing, shrinking or editing TLVs via the helpers will flag the SRH as
> invalid, and it will have to be re-validated before re-entering the IPv6
> layer. This flag is stored in a per-CPU buffer, along with the current
> header length in bytes.
>
> Storing the SRH len in bytes in the control block is mandatory when using
> bpf_lwt_seg6_adjust_srh. The Header Ext. Length field contains the SRH
> len rounded to 8 bytes (a padding TLV can be inserted to ensure the 8-byt=
es
> boundary). When adding/deleting TLVs within the BPF program, the SRH may
> temporary be in an invalid state where its length cannot be rounded to 8
> bytes without remainder, hence the need to store the length in bytes
> separately. The caller of the BPF program can then ensure that the SRH's
> final length is valid using this value. Again, a final SRH modified by a
> BPF program which doesn=E2=80=99t respect the 8-bytes boundary will be di=
scarded
> as it will be considered as invalid.
>
> Finally, a fourth helper is provided, bpf_lwt_push_encap, which is
> available from the LWT BPF IN hook, but not from the seg6local BPF one.
> This helper allows to encapsulate a Segment Routing Header (either with
> a new outer IPv6 header, or by inlining it directly in the existing IPv6
> header) into a non-SRv6 packet. This helper is required if we want to
> offer the possibility to dynamically encapsulate a SRH for non-SRv6 packe=
t,
> as the BPF seg6local hook only works on traffic already containing a SRH.
> This is the BPF equivalent of the seg6 LWT infrastructure, which achieves
> the same purpose but with a static SRH per route.
>
> These helpers require CONFIG_IPV6=3Dy (and not =3Dm).
>
> Signed-off-by: Mathieu Xhonneux <m.xhonneux@gmail.com>
> Acked-by: David Lebrun <dlebrun@google.com>
> ---
>  include/net/seg6_local.h |   8 ++
>  include/uapi/linux/bpf.h |  97 +++++++++++++++-
>  net/core/filter.c        | 282 +++++++++++++++++++++++++++++++++++++++++=
++----
>  net/ipv6/Kconfig         |   5 +
>  net/ipv6/seg6_local.c    |   2 +
>  5 files changed, 369 insertions(+), 25 deletions(-)
>
> diff --git a/include/net/seg6_local.h b/include/net/seg6_local.h
> index 57498b23085d..661fd5b4d3e0 100644
> --- a/include/net/seg6_local.h
> +++ b/include/net/seg6_local.h
> @@ -15,10 +15,18 @@
>  #ifndef _NET_SEG6_LOCAL_H
>  #define _NET_SEG6_LOCAL_H
>
> +#include <linux/percpu.h>
>  #include <linux/net.h>
>  #include <linux/ipv6.h>
>
>  extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nha=
ddr,
>                                u32 tbl_id);
>
> +struct seg6_bpf_srh_state {
> +       bool valid;
> +       u16 hdrlen;
> +};
> +
> +DECLARE_PER_CPU(struct seg6_bpf_srh_state, seg6_bpf_srh_states);
> +
>  #endif
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 02e4112510f8..0349c91329fd 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1828,7 +1828,6 @@ union bpf_attr {
>   *     Return
>   *             0 on success, or a negative error in case of failure.
>   *
> - *
>   * int bpf_fib_lookup(void *ctx, struct bpf_fib_lookup *params, int plen=
, u32 flags)
>   *     Description
>   *             Do FIB lookup in kernel tables using parameters in *param=
s*.
> @@ -1855,6 +1854,90 @@ union bpf_attr {
>   *             Egress device index on success, 0 if packet needs to cont=
inue
>   *             up the stack for further processing or a negative error i=
n case
>   *             of failure.
> + *
> + * int bpf_lwt_push_encap(struct sk_buff *skb, u32 type, void *hdr, u32 =
len)
> + *     Description
> + *             Encapsulate the packet associated to *skb* within a Layer=
 3
> + *             protocol header. This header is provided in the buffer at
> + *             address *hdr*, with *len* its size in bytes. *type* indic=
ates
> + *             the protocol of the header and can be one of:
> + *
> + *             **BPF_LWT_ENCAP_SEG6**
> + *                     IPv6 encapsulation with Segment Routing Header
> + *                     (**struct ipv6_sr_hdr**). *hdr* only contains the=
 SRH,
> + *                     the IPv6 header is computed by the kernel.
> + *             **BPF_LWT_ENCAP_SEG6_INLINE**
> + *                     Only works if *skb* contains an IPv6 packet. Inse=
rt a
> + *                     Segment Routing Header (**struct ipv6_sr_hdr**) i=
nside
> + *                     the IPv6 header.
> + *
> + *             A call to this helper is susceptible to change the underl=
aying
> + *             packet buffer. Therefore, at load time, all checks on poi=
nters
> + *             previously done by the verifier are invalidated and must =
be
> + *             performed again, if the helper is used in combination wit=
h
> + *             direct packet access.
> + *     Return
> + *             0 on success, or a negative error in case of failure.
> + *
> + * int bpf_lwt_seg6_store_bytes(struct sk_buff *skb, u32 offset, const v=
oid *from, u32 len)
> + *     Description
> + *             Store *len* bytes from address *from* into the packet
> + *             associated to *skb*, at *offset*. Only the flags, tag and=
 TLVs
> + *             inside the outermost IPv6 Segment Routing Header can be
> + *             modified through this helper.
> + *
> + *             A call to this helper is susceptible to change the underl=
aying
> + *             packet buffer. Therefore, at load time, all checks on poi=
nters
> + *             previously done by the verifier are invalidated and must =
be
> + *             performed again, if the helper is used in combination wit=
h
> + *             direct packet access.
> + *     Return
> + *             0 on success, or a negative error in case of failure.
> + *
> + * int bpf_lwt_seg6_adjust_srh(struct sk_buff *skb, u32 offset, s32 delt=
a)
> + *     Description
> + *             Adjust the size allocated to TLVs in the outermost IPv6
> + *             Segment Routing Header contained in the packet associated=
 to
> + *             *skb*, at position *offset* by *delta* bytes. Only offset=
s
> + *             after the segments are accepted. *delta* can be as well
> + *             positive (growing) as negative (shrinking).
> + *
> + *             A call to this helper is susceptible to change the underl=
aying
> + *             packet buffer. Therefore, at load time, all checks on poi=
nters
> + *             previously done by the verifier are invalidated and must =
be
> + *             performed again, if the helper is used in combination wit=
h
> + *             direct packet access.
> + *     Return
> + *             0 on success, or a negative error in case of failure.
> + *
> + * int bpf_lwt_seg6_action(struct sk_buff *skb, u32 action, void *param,=
 u32 param_len)
> + *     Description
> + *             Apply an IPv6 Segment Routing action of type *action* to =
the
> + *             packet associated to *skb*. Each action takes a parameter
> + *             contained at address *param*, and of length *param_len* b=
ytes.
> + *             *action* can be one of:
> + *
> + *             **SEG6_LOCAL_ACTION_END_X**
> + *                     End.X action: Endpoint with Layer-3 cross-connect=
.
> + *                     Type of *param*: **struct in6_addr**.
> + *             **SEG6_LOCAL_ACTION_END_T**
> + *                     End.T action: Endpoint with specific IPv6 table l=
ookup.
> + *                     Type of *param*: **int**.
> + *             **SEG6_LOCAL_ACTION_END_B6**
> + *                     End.B6 action: Endpoint bound to an SRv6 policy.
> + *                     Type of param: **struct ipv6_sr_hdr**.
> + *             **SEG6_LOCAL_ACTION_END_B6_ENCAP**
> + *                     End.B6.Encap action: Endpoint bound to an SRv6
> + *                     encapsulation policy.
> + *                     Type of param: **struct ipv6_sr_hdr**.
> + *
> + *             A call to this helper is susceptible to change the underl=
aying
> + *             packet buffer. Therefore, at load time, all checks on poi=
nters
> + *             previously done by the verifier are invalidated and must =
be
> + *             performed again, if the helper is used in combination wit=
h
> + *             direct packet access.
> + *     Return
> + *             0 on success, or a negative error in case of failure.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -1926,7 +2009,11 @@ union bpf_attr {
>         FN(skb_get_xfrm_state),         \
>         FN(get_stack),                  \
>         FN(skb_load_bytes_relative),    \
> -       FN(fib_lookup),
> +       FN(fib_lookup),                 \
> +       FN(lwt_push_encap),             \
> +       FN(lwt_seg6_store_bytes),       \
> +       FN(lwt_seg6_adjust_srh),        \
> +       FN(lwt_seg6_action),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which he=
lper
>   * function eBPF program intends to call
> @@ -1993,6 +2080,12 @@ enum bpf_hdr_start_off {
>         BPF_HDR_START_NET,
>  };
>
> +/* Encapsulation type for BPF_FUNC_lwt_push_encap helper. */
> +enum bpf_lwt_encap_mode {
> +       BPF_LWT_ENCAP_SEG6,
> +       BPF_LWT_ENCAP_SEG6_INLINE
> +};
> +
>  /* user accessible mirror of in-kernel sk_buff.
>   * new fields can only be added to the end of this structure
>   */
> diff --git a/net/core/filter.c b/net/core/filter.c
> index ca60d2872da4..67b4ab4ec404 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -64,6 +64,10 @@
>  #include <net/ip_fib.h>
>  #include <net/flow.h>
>  #include <net/arp.h>
> +#include <net/ipv6.h>
> +#include <linux/seg6_local.h>
> +#include <net/seg6.h>
> +#include <net/seg6_local.h>
>
>  /**
>   *     sk_filter_trim_cap - run a packet through a socket filter
> @@ -3326,28 +3330,6 @@ static const struct bpf_func_proto bpf_xdp_redirec=
t_map_proto =3D {
>         .arg3_type      =3D ARG_ANYTHING,
>  };
>
> -bool bpf_helper_changes_pkt_data(void *func)
> -{
> -       if (func =3D=3D bpf_skb_vlan_push ||
> -           func =3D=3D bpf_skb_vlan_pop ||
> -           func =3D=3D bpf_skb_store_bytes ||
> -           func =3D=3D bpf_skb_change_proto ||
> -           func =3D=3D bpf_skb_change_head ||
> -           func =3D=3D bpf_skb_change_tail ||
> -           func =3D=3D bpf_skb_adjust_room ||
> -           func =3D=3D bpf_skb_pull_data ||
> -           func =3D=3D bpf_clone_redirect ||
> -           func =3D=3D bpf_l3_csum_replace ||
> -           func =3D=3D bpf_l4_csum_replace ||
> -           func =3D=3D bpf_xdp_adjust_head ||
> -           func =3D=3D bpf_xdp_adjust_meta ||
> -           func =3D=3D bpf_msg_pull_data ||
> -           func =3D=3D bpf_xdp_adjust_tail)
> -               return true;
> -
> -       return false;
> -}
> -
>  static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
>                                   unsigned long off, unsigned long len)
>  {
> @@ -4295,6 +4277,261 @@ static const struct bpf_func_proto bpf_skb_fib_lo=
okup_proto =3D {
>         .arg4_type      =3D ARG_ANYTHING,
>  };
>
> +#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
> +static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr,=
 u32 len)
> +{
> +       int err;
> +       struct ipv6_sr_hdr *srh =3D (struct ipv6_sr_hdr *)hdr;
> +
> +       if (!seg6_validate_srh(srh, len))
> +               return -EINVAL;
> +
> +       switch (type) {
> +       case BPF_LWT_ENCAP_SEG6_INLINE:
> +               if (skb->protocol !=3D htons(ETH_P_IPV6))
> +                       return -EBADMSG;
> +
> +               err =3D seg6_do_srh_inline(skb, srh);
> +               break;
> +       case BPF_LWT_ENCAP_SEG6:
> +               skb_reset_inner_headers(skb);
> +               skb->encapsulation =3D 1;
> +               err =3D seg6_do_srh_encap(skb, srh, IPPROTO_IPV6);
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +       if (err)
> +               return err;
> +
> +       ipv6_hdr(skb)->payload_len =3D htons(skb->len - sizeof(struct ipv=
6hdr));
> +       skb_set_transport_header(skb, sizeof(struct ipv6hdr));
> +
> +       return seg6_lookup_nexthop(skb, NULL, 0);
> +}
> +#endif /* CONFIG_IPV6_SEG6_BPF */
> +
> +BPF_CALL_4(bpf_lwt_push_encap, struct sk_buff *, skb, u32, type, void *,=
 hdr,
> +          u32, len)
> +{
> +       switch (type) {
> +#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
> +       case BPF_LWT_ENCAP_SEG6:
> +       case BPF_LWT_ENCAP_SEG6_INLINE:
> +               return bpf_push_seg6_encap(skb, type, hdr, len);
> +#endif
> +       default:
> +               return -EINVAL;
> +       }
> +}
> +
> +static const struct bpf_func_proto bpf_lwt_push_encap_proto =3D {
> +       .func           =3D bpf_lwt_push_encap,
> +       .gpl_only       =3D false,
> +       .ret_type       =3D RET_INTEGER,
> +       .arg1_type      =3D ARG_PTR_TO_CTX,
> +       .arg2_type      =3D ARG_ANYTHING,
> +       .arg3_type      =3D ARG_PTR_TO_MEM,
> +       .arg4_type      =3D ARG_CONST_SIZE
> +};
> +
> +BPF_CALL_4(bpf_lwt_seg6_store_bytes, struct sk_buff *, skb, u32, offset,
> +          const void *, from, u32, len)
> +{
> +#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
> +       struct seg6_bpf_srh_state *srh_state =3D
> +               this_cpu_ptr(&seg6_bpf_srh_states);
> +       void *srh_tlvs, *srh_end, *ptr;
> +       struct ipv6_sr_hdr *srh;
> +       int srhoff =3D 0;
> +
> +       if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
> +               return -EINVAL;
> +
> +       srh =3D (struct ipv6_sr_hdr *)(skb->data + srhoff);
> +       srh_tlvs =3D (void *)((char *)srh + ((srh->first_segment + 1) << =
4));
> +       srh_end =3D (void *)((char *)srh + sizeof(*srh) + srh_state->hdrl=
en);
> +
> +       ptr =3D skb->data + offset;
> +       if (ptr >=3D srh_tlvs && ptr + len <=3D srh_end)
> +               srh_state->valid =3D 0;
> +       else if (ptr < (void *)&srh->flags ||
> +                ptr + len > (void *)&srh->segments)
> +               return -EFAULT;
> +
> +       if (unlikely(bpf_try_make_writable(skb, offset + len)))
> +               return -EFAULT;
> +
> +       memcpy(ptr, from, len);
> +       return 0;
> +#else /* CONFIG_IPV6_SEG6_BPF */
> +       return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_lwt_seg6_store_bytes_proto =3D {
> +       .func           =3D bpf_lwt_seg6_store_bytes,
> +       .gpl_only       =3D false,
> +       .ret_type       =3D RET_INTEGER,
> +       .arg1_type      =3D ARG_PTR_TO_CTX,
> +       .arg2_type      =3D ARG_ANYTHING,
> +       .arg3_type      =3D ARG_PTR_TO_MEM,
> +       .arg4_type      =3D ARG_CONST_SIZE
> +};
> +
> +BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
> +          u32, action, void *, param, u32, param_len)
> +{
> +#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
> +       struct seg6_bpf_srh_state *srh_state =3D
> +               this_cpu_ptr(&seg6_bpf_srh_states);
> +       struct ipv6_sr_hdr *srh;
> +       int srhoff =3D 0;
> +       int err;
> +
> +       if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
> +               return -EINVAL;
> +       srh =3D (struct ipv6_sr_hdr *)(skb->data + srhoff);
> +
> +       if (!srh_state->valid) {
> +               if (unlikely((srh_state->hdrlen & 7) !=3D 0))
> +                       return -EBADMSG;
> +
> +               srh->hdrlen =3D (u8)(srh_state->hdrlen >> 3);
> +               if (unlikely(!seg6_validate_srh(srh, (srh->hdrlen + 1) <<=
 3)))
> +                       return -EBADMSG;
> +
> +               srh_state->valid =3D 1;
> +       }
> +
> +       switch (action) {
> +       case SEG6_LOCAL_ACTION_END_X:
> +               if (param_len !=3D sizeof(struct in6_addr))
> +                       return -EINVAL;
> +               return seg6_lookup_nexthop(skb, (struct in6_addr *)param,=
 0);
> +       case SEG6_LOCAL_ACTION_END_T:
> +               if (param_len !=3D sizeof(int))
> +                       return -EINVAL;
> +               return seg6_lookup_nexthop(skb, NULL, *(int *)param);
> +       case SEG6_LOCAL_ACTION_END_B6:
> +               err =3D bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6_INLIN=
E,
> +                                         param, param_len);
> +               if (!err)
> +                       srh_state->hdrlen =3D
> +                               ((struct ipv6_sr_hdr *)param)->hdrlen << =
3;
> +               return err;
> +       case SEG6_LOCAL_ACTION_END_B6_ENCAP:
> +               err =3D bpf_push_seg6_encap(skb, BPF_LWT_ENCAP_SEG6,
> +                                         param, param_len);
> +               if (!err)
> +                       srh_state->hdrlen =3D
> +                               ((struct ipv6_sr_hdr *)param)->hdrlen << =
3;
> +               return err;
> +       default:
> +               return -EINVAL;
> +       }
> +#else /* CONFIG_IPV6_SEG6_BPF */
> +       return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_lwt_seg6_action_proto =3D {
> +       .func           =3D bpf_lwt_seg6_action,
> +       .gpl_only       =3D false,
> +       .ret_type       =3D RET_INTEGER,
> +       .arg1_type      =3D ARG_PTR_TO_CTX,
> +       .arg2_type      =3D ARG_ANYTHING,
> +       .arg3_type      =3D ARG_PTR_TO_MEM,
> +       .arg4_type      =3D ARG_CONST_SIZE
> +};
> +
> +BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
> +          s32, len)
> +{
> +#if IS_ENABLED(CONFIG_IPV6_SEG6_BPF)
> +       struct seg6_bpf_srh_state *srh_state =3D
> +               this_cpu_ptr(&seg6_bpf_srh_states);
> +       void *srh_end, *srh_tlvs, *ptr;
> +       struct ipv6_sr_hdr *srh;
> +       struct ipv6hdr *hdr;
> +       int srhoff =3D 0;
> +       int ret;
> +
> +       if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
> +               return -EINVAL;
> +       srh =3D (struct ipv6_sr_hdr *)(skb->data + srhoff);
> +
> +       srh_tlvs =3D (void *)((unsigned char *)srh + sizeof(*srh) +
> +                       ((srh->first_segment + 1) << 4));
> +       srh_end =3D (void *)((unsigned char *)srh + sizeof(*srh) +
> +                       srh_state->hdrlen);
> +       ptr =3D skb->data + offset;
> +
> +       if (unlikely(ptr < srh_tlvs || ptr > srh_end))
> +               return -EFAULT;
> +       if (unlikely(len < 0 && (void *)((char *)ptr - len) > srh_end))
> +               return -EFAULT;
> +
> +       if (len > 0) {
> +               ret =3D skb_cow_head(skb, len);
> +               if (unlikely(ret < 0))
> +                       return ret;
> +
> +               ret =3D bpf_skb_net_hdr_push(skb, offset, len);
> +       } else {
> +               ret =3D bpf_skb_net_hdr_pop(skb, offset, -1 * len);
> +       }
> +       if (unlikely(ret < 0))
> +               return ret;
> +
> +       hdr =3D (struct ipv6hdr *)skb->data;
> +       hdr->payload_len =3D htons(skb->len - sizeof(struct ipv6hdr));
> +
> +       bpf_compute_data_pointers(skb);
> +       srh_state->hdrlen +=3D len;
> +       srh_state->valid =3D 0;
> +       return 0;
> +#else /* CONFIG_IPV6_SEG6_BPF */
> +       return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static const struct bpf_func_proto bpf_lwt_seg6_adjust_srh_proto =3D {
> +       .func           =3D bpf_lwt_seg6_adjust_srh,
> +       .gpl_only       =3D false,
> +       .ret_type       =3D RET_INTEGER,
> +       .arg1_type      =3D ARG_PTR_TO_CTX,
> +       .arg2_type      =3D ARG_ANYTHING,
> +       .arg3_type      =3D ARG_ANYTHING,
> +};
> +
> +bool bpf_helper_changes_pkt_data(void *func)
> +{
> +       if (func =3D=3D bpf_skb_vlan_push ||
> +           func =3D=3D bpf_skb_vlan_pop ||
> +           func =3D=3D bpf_skb_store_bytes ||
> +           func =3D=3D bpf_skb_change_proto ||
> +           func =3D=3D bpf_skb_change_head ||
> +           func =3D=3D bpf_skb_change_tail ||
> +           func =3D=3D bpf_skb_adjust_room ||
> +           func =3D=3D bpf_skb_pull_data ||
> +           func =3D=3D bpf_clone_redirect ||
> +           func =3D=3D bpf_l3_csum_replace ||
> +           func =3D=3D bpf_l4_csum_replace ||
> +           func =3D=3D bpf_xdp_adjust_head ||
> +           func =3D=3D bpf_xdp_adjust_meta ||
> +           func =3D=3D bpf_msg_pull_data ||
> +           func =3D=3D bpf_xdp_adjust_tail ||
> +           func =3D=3D bpf_lwt_push_encap ||
> +           func =3D=3D bpf_lwt_seg6_store_bytes ||
> +           func =3D=3D bpf_lwt_seg6_adjust_srh ||
> +           func =3D=3D bpf_lwt_seg6_action
> +           )
> +               return true;
> +
> +       return false;
> +}
> +
>  static const struct bpf_func_proto *
>  bpf_base_func_proto(enum bpf_func_id func_id)
>  {
> @@ -4703,7 +4940,6 @@ static bool lwt_is_valid_access(int off, int size,
>         return bpf_skb_is_valid_access(off, size, type, prog, info);
>  }
>
> -
>  /* Attach type specific accesses */
>  static bool __sock_filter_check_attach_type(int off,
>                                             enum bpf_access_type access_t=
ype,
> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index 6794ddf0547c..f0e8a762ae0c 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
> @@ -330,4 +330,9 @@ config IPV6_SEG6_HMAC
>
>           If unsure, say N.
>
> +config IPV6_SEG6_BPF
> +       def_bool y
> +       depends on IPV6_SEG6_LWTUNNEL
> +       depends on IPV6 =3D y
> +
>  endif # IPV6
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index e9b23fb924ad..ae68c1ef8fb0 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -449,6 +449,8 @@ static int input_action_end_b6_encap(struct sk_buff *=
skb,
>         return err;
>  }
>
> +DEFINE_PER_CPU(struct seg6_bpf_srh_state, seg6_bpf_srh_states);
> +
>  static struct seg6_action_desc seg6_action_table[] =3D {
>         {
>                 .action         =3D SEG6_LOCAL_ACTION_END,
> --
> 2.16.1
>
