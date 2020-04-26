Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3EF1B921C
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 19:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDZRda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 13:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgDZRda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 13:33:30 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92351C061A0F;
        Sun, 26 Apr 2020 10:33:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t7so57381plr.0;
        Sun, 26 Apr 2020 10:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Ym0PI+p8r0uaVASqdly3gL8lO43LfRGsjZqN0Jm/io=;
        b=X9K7ifeZ0k/SvUhQQWwSnalkGPgzyYZF2DU09USJUxPB/524f0nNdB2ngcxTOS0j+g
         C3hIydYtOQGlHltlziZwL+H/egwEpSJxxx85ECGENurKDitszrbVgrbiPn017DT3CCRC
         bgFmbFqn4nQCpZOCQhS5PbftZdrnhdV08KGRNW7ugw3jXxrMgym5WK1IMRvOlPVCvpIw
         DyNORNZ9uk8PyGWry+NnhwoiaBJdNfq+RhnJ7fZ1jWXprfNlY0ItVcNDdzsQrAQC9dAM
         /ARJS+clM/ZljWfnS3BmvDIa3Ta8EBz5xYur2P1gQXvhR1my1Ta+ynp+voJl9ZiuCROG
         jdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Ym0PI+p8r0uaVASqdly3gL8lO43LfRGsjZqN0Jm/io=;
        b=CAzxW+yJ5NpPvhWY4evYUvbBr2YLhJwAQVB/87al+p4cMs4Zt3Zw54mmxe1u4Z3rcv
         i86Ik2yy9yUKS/HxI9vhXqFqj8ej5kSQFW4v91V8WwW3dsHgnKPTXktJu6uUViV4R1Fn
         QQn6D0FZil/FQIqcU2vDA+vbNCwtR9lkqFXicIdJhovTDuevaLf0/5HBocSOBdYdPxIN
         3iS17dhfpf1LtVG6PMQOXKC+PPd7HVW9ObhvkEJkPKjgFf1cmDQZ4/cI0lLRPveouAFd
         yP2AvwI875mBdxwaw5k0SvOmlij1nyoNpzk2iewDu8akk4WFpMF0eD89v6o7lRo0QQBq
         Skxg==
X-Gm-Message-State: AGi0PuZcQitUow3AavgvDshxelXl6laS/XBcsVcTzz04NDmNAVBzMB4J
        mSCb1uxBvVQuQ6d8zuHa7R4=
X-Google-Smtp-Source: APiQypLCh20O6HwJpaQoXwuMKyIq2wNlaIOLqO8ujZVJShbhROEZ8jT9zvKU9wjGWhPJjIUzLbrF6A==
X-Received: by 2002:a17:90a:d17:: with SMTP id t23mr19816040pja.77.1587922407856;
        Sun, 26 Apr 2020 10:33:27 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9db4])
        by smtp.gmail.com with ESMTPSA id 82sm10163761pfv.214.2020.04.26.10.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2020 10:33:27 -0700 (PDT)
Date:   Sun, 26 Apr 2020 10:33:24 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        theojulienne@github.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
Message-ID: <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
References: <20200424185556.7358-1-lmb@cloudflare.com>
 <20200424185556.7358-2-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424185556.7358-2-lmb@cloudflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 07:55:55PM +0100, Lorenz Bauer wrote:
> cls_redirect is a TC clsact based replacement for the glb-redirect iptables
> module available at [1]. It enables what GitHub calls "second chance"
> flows [2], similarly proposed by the Beamer paper [3]. In contrast to
> glb-redirect, it also supports migrating UDP flows as long as connected
> sockets are used. cls_redirect is in production at Cloudflare, as part of
> our own L4 load balancer.

This is awesome. Thank you for contributing!
Applied.

> There are two major distinctions from glb-redirect: first, cls_redirect
> relies on receiving encapsulated packets directly from a router. This is
> because we don't have access to the neighbour tables from BPF, yet. See

Let's make it available then :)

> The code base started it's life on v4.19, so there are most likely still
> hold overs from old workarounds. In no particular order:
> 
> - The function buf_off is required to defeat a clang optimization
>   that leads to the verifier rejecting the program due to pointer
>   arithmetic in the wrong order.
> 
> - The function pkt_parse_ipv6 is force inlined, because it would
>   otherwise be rejected due to returning a pointer to stack memory.
> 
> - The functions fill_tuple and classify_tcp contain kludges, because
>   we've run out of function arguments.
> 
> - The logic in general is rather nested, due to verifier restrictions.
>   I think this is either because the verifier loses track of constants
>   on the stack, or because it can't track enum like variables.

Have you tried undoing these workarounds to check the latest verifier?
If they're still needed we certainly have to improve the verifier.

> +#include "test_cls_redirect.skel.h"

Do you use skeleton internally as well or was it just for selftests? ;)

> +_Static_assert(
> +	sizeof(flow_ports_t) !=
> +		offsetofend(struct bpf_sock_tuple, ipv4.dport) -
> +			offsetof(struct bpf_sock_tuple, ipv4.sport) - 1,
> +	"flow_ports_t must match sport and dport in struct bpf_sock_tuple");

Nice. I didn't realize clang supports it. Of course it should.

> +/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
> + * or not aligned if the arch supports efficient unaligned access.
> + *
> + * Since the verifier ensures that eBPF packet accesses follow these rules,
> + * we can tell LLVM to emit code as if we always had a larger alignment.
> + * It will yell at us if we end up on a platform where this is not valid.
> + */
> +typedef uint8_t *net_ptr __attribute__((align_value(8)));

Wow. I didn't know about this attribute.
I wonder whether it can help Daniel's memcpy hack.

> +
> +typedef struct buf {
> +	struct __sk_buff *skb;
> +	net_ptr head;
> +	/* NB: tail musn't have alignment other than 1, otherwise
> +	* LLVM will go and eliminate code, e.g. when checking packet lengths.
> +	*/
> +	uint8_t *const tail;
> +} buf_t;
> +
> +static size_t buf_off(const buf_t *buf)
> +{
> +	/* Clang seems to optimize constructs like
> +	 *    a - b + c
> +	 * if c is known:
> +	 *    r? = c
> +	 *    r? -= b
> +	 *    r? += a
> +	 *
> +	 * This is a problem if a and b are packet pointers,
> +	 * since the verifier allows subtracting two pointers to
> +	 * get a scalar, but not a scalar and a pointer.
> +	 *
> +	 * Use inline asm to break this optimization.
> +	 */
> +	size_t off = (size_t)buf->head;
> +	asm("%0 -= %1" : "+r"(off) : "r"(buf->skb->data));
> +	return off;
> +}

We need to look into this one.
This part is not gated by allow_ptr_leaks.
if (dst_reg == off_reg) {
        /* scalar -= pointer.  Creates an unknown scalar */
        verbose(env, "R%d tried to subtract pointer from scalar\n",
                dst);
        return -EACCES;
}
Hopefully not too hard to fix.

> +
> +static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
> +					    const struct ipv6hdr *ipv6,
> +					    uint8_t *upper_proto,
> +					    bool *is_fragment)
> +{
> +	/* We understand five extension headers.
> +	 * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
> +	 * headers should occur once, except Destination Options, which may
> +	 * occur twice. Hence we give up after 6 headers.
> +	 */
> +	struct {
> +		uint8_t next;
> +		uint8_t len;
> +	} exthdr = {
> +		.next = ipv6->nexthdr,
> +	};
> +	*is_fragment = false;
> +
> +#pragma clang loop unroll(full)
> +	for (int i = 0; i < 6; i++) {

unroll is still needed even with bounded loop support in the verifier?


> +/* This function has to be inlined, because the verifier otherwise rejects it
> + * due to returning a pointer to the stack. This is technically correct, since
> + * scratch is allocated on the stack. However, this usage should be safe since
> + * it's the callers stack after all.
> + */

Interesting. The verifier can recognize that ptr to stack can be safe in some cases.
When I added that check I didn't think that the code can be as tricky as this :)

> +static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
> +{
> +	switch (ipv4->protocol) {
> +	case IPPROTO_ICMP:
> +		return process_icmpv4(pkt, metrics);
> +
> +	case IPPROTO_TCP:
> +		return process_tcp(pkt, ipv4, sizeof(*ipv4), metrics);
> +
> +	case IPPROTO_UDP:
> +		return process_udp(pkt, ipv4, sizeof(*ipv4), metrics);
> +
> +	default:
> +		metrics->errors_total_unknown_l4_proto++;
> +		return INVALID;
> +	}
> +}
> +
> +static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
> +	if (is_fragment) {
> +		metrics->errors_total_fragmented_ip++;
> +		return INVALID;
> +	}
> +
> +	switch (l4_proto) {
> +	case IPPROTO_ICMPV6:
> +		return process_icmpv6(pkt, metrics);
> +
> +	case IPPROTO_TCP:
> +		return process_tcp(pkt, ipv6, sizeof(*ipv6), metrics);
> +
> +	case IPPROTO_UDP:
> +		return process_udp(pkt, ipv6, sizeof(*ipv6), metrics);
> +
> +	default:
> +		metrics->errors_total_unknown_l4_proto++;
> +		return INVALID;
> +	}
> +}
> +
> +SEC("classifier/cls_redirect")
> +int cls_redirect(struct __sk_buff *skb)
> +{
...
> +	verdict_t verdict;
> +	switch (encap->gue.proto_ctype) {
> +	case IPPROTO_IPIP:
> +		verdict = process_ipv4(&pkt, metrics);
> +		break;
> +
> +	case IPPROTO_IPV6:
> +		verdict = process_ipv6(&pkt, metrics);
> +		break;

The code flow looks pretty clean. 
I didn't find the copy-paste of ipv[46] -> tcp/udp
you were mentioning.
So that old issue is now gone?
