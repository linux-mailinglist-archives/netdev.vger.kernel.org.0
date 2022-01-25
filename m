Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C8049BBFE
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 20:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiAYTYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 14:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbiAYTYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 14:24:34 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D7EC06173B
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:24:30 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c192so784755wma.4
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 11:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=2GxzEUJrbvJEXdIt4dxtW3JqvSSBS0SEXbo+rF+J2Es=;
        b=h/LU+OQkCLJaflAwiAhLZhROf9gu0u04QOiiywp8MbAdXWHbLv9BJWIWqdgLBJqXlQ
         jziDd2CzVsTHo9l/pMK7FMnADO1aIFzR7RehLiBIFJYQtWmj4qmOrQMgv1SEOxjkeksa
         /HWOr+68PnTLuFbyEPa22a3ia8ELcYfVJ1+TY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=2GxzEUJrbvJEXdIt4dxtW3JqvSSBS0SEXbo+rF+J2Es=;
        b=qFjaieIKT0caMgkGu6zUPnmt7cW3UdLqJTATj5guy9TjKhmxVcHxHobEJ2n//QUMp5
         FFyYbj5qNbC+1aIFCbW4j/+Fl+kzDdp+lJmCvXPK2NNPFZ/XVRzxgalkpaUYZ31tRHuL
         zrwamF7tjFntueGTP2kMPvTALSqRXRDs0YlPk22eMc2/3vZxLA3UVm5FR43NMKgMm6iT
         YBwfwGJ+GHXU1RbcQ/S8sTwXqp/06ZIU8kImSnB3TrbuxbJkWYyXot0Lqd6HjN5Wwcuh
         KmIh69itQgs8HN8MpXHdKpcIUFe0VkjLUqwF7DtpGUP8T13HZK9rKFGHH+vXpSfRrYkz
         M2Fg==
X-Gm-Message-State: AOAM531RFLNF/mjvE2RLQkIMfFWMo9lRtzP41+uFxbOH2swj0w7VxiWM
        BDe52RoFoBnWjmqBFhwjtIEa0Q==
X-Google-Smtp-Source: ABdhPJyGrZuTRIehTH5rIo4cKX3JZjHM45w9hw7K1RgCCI0IgmWRQrkgjedGBbyeSK4Ic7PRc0cpDg==
X-Received: by 2002:a05:600c:4e46:: with SMTP id e6mr4165180wmq.15.1643138669440;
        Tue, 25 Jan 2022 11:24:29 -0800 (PST)
Received: from cloudflare.com (2a01-110f-4809-d800-0000-0000-0000-0e00.aa.ipv6.supernova.orange.pl. [2a01:110f:4809:d800::e00])
        by smtp.gmail.com with ESMTPSA id h127sm1279065wmh.27.2022.01.25.11.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 11:24:28 -0800 (PST)
References: <20220113070245.791577-1-imagedong@tencent.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     menglong8.dong@gmail.com
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, mengensun@tencent.com,
        flyingpeng@tencent.com, mungerjiang@tencent.com,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct
 bpf_sock'
In-reply-to: <20220113070245.791577-1-imagedong@tencent.com>
Date:   Tue, 25 Jan 2022 20:24:27 +0100
Message-ID: <87sftbobys.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 13, 2022 at 08:02 AM CET, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
>
> The description of 'dst_port' in 'struct bpf_sock' is not accurated.
> In fact, 'dst_port' is not in network byte order, it is 'partly' in
> network byte order.
>
> We can see it in bpf_sock_convert_ctx_access():
>
>> case offsetof(struct bpf_sock, dst_port):
>> 	*insn++ = BPF_LDX_MEM(
>> 		BPF_FIELD_SIZEOF(struct sock_common, skc_dport),
>> 		si->dst_reg, si->src_reg,
>> 		bpf_target_off(struct sock_common, skc_dport,
>> 			       sizeof_field(struct sock_common,
>> 					    skc_dport),
>> 			       target_size));
>
> It simply passes 'sock_common->skc_dport' to 'bpf_sock->dst_port',
> which makes that the low 16-bits of 'dst_port' is equal to 'skc_port'
> and is in network byte order, but the high 16-bites of 'dst_port' is
> 0. And the actual port is 'bpf_ntohs((__u16)dst_port)', and
> 'bpf_ntohl(dst_port)' is totally not the right port.
>
> This is different form 'remote_port' in 'struct bpf_sock_ops' or
> 'struct __sk_buff':
>
>> case offsetof(struct __sk_buff, remote_port):
>> 	BUILD_BUG_ON(sizeof_field(struct sock_common, skc_dport) != 2);
>>
>> 	*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
>> 			      si->dst_reg, si->src_reg,
>> 				      offsetof(struct sk_buff, sk));
>> 	*insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->dst_reg,
>> 			      bpf_target_off(struct sock_common,
>> 					     skc_dport,
>> 					     2, target_size));
>> #ifndef __BIG_ENDIAN_BITFIELD
>> 	*insn++ = BPF_ALU32_IMM(BPF_LSH, si->dst_reg, 16);
>> #endif
>
> We can see that it will left move 16-bits in little endian, which makes
> the whole 'remote_port' is in network byte order, and the actual port
> is bpf_ntohl(remote_port).
>
> Note this in the document of 'dst_port'. ( Maybe this should be unified
> in the code? )
>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/uapi/linux/bpf.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index b0383d371b9a..891a182a749a 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -5500,7 +5500,11 @@ struct bpf_sock {
>  	__u32 src_ip4;
>  	__u32 src_ip6[4];
>  	__u32 src_port;		/* host byte order */
> -	__u32 dst_port;		/* network byte order */
> +	__u32 dst_port;		/* low 16-bits are in network byte order,
> +				 * and high 16-bits are filled by 0.
> +				 * So the real port in host byte order is
> +				 * bpf_ntohs((__u16)dst_port).
> +				 */
>  	__u32 dst_ip4;
>  	__u32 dst_ip6[4];
>  	__u32 state;

I'm probably missing something obvious, but is there anything stopping
us from splitting the field, so that dst_ports is 16-bit wide?

I gave a quick check to the change below and it seems to pass verifier
checks and sock_field tests.

IDK, just an idea. Didn't give it a deeper thought.

--8<--

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 4a2f7041ebae..344d62ccafba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5574,7 +5574,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__u16 unused;
+	__u16 dst_port;		/* network byte order */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
diff --git a/net/core/filter.c b/net/core/filter.c
index a06931c27eeb..c56b8ba82de5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8276,7 +8276,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, family):
 	case offsetof(struct bpf_sock, type):
 	case offsetof(struct bpf_sock, protocol):
-	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
@@ -8285,6 +8284,9 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
+	case offsetof(struct bpf_sock, dst_port):
+		bpf_ctx_record_field_size(info, sizeof(__u16));
+		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u16));
 	}

 	return size == size_default;
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4a2f7041ebae..344d62ccafba 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5574,7 +5574,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__u16 unused;
+	__u16 dst_port;		/* network byte order */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
