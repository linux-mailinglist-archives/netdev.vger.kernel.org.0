Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760731BA040
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 11:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726914AbgD0Jpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 05:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726786AbgD0Jph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 05:45:37 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0E4C03C1A6
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 02:45:37 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id j26so25104645ots.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 02:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p/dkv8siYLu4BZqbzo9AEk9hetqwaOBV9gfUD96SYV4=;
        b=wkvZ/2OEzPmpzA1KGxW4Nr+32KgW8NQ3ymID5WWYJRWgS2Iqd28pDmJ1ydEcabxmEJ
         aMjxgUqk6DmpOe8Nq6FL9BwtAvgu4as/EpD+xJokAl+rmfPCznstgiVZjQOqTo9nga3x
         TZIwHcyjSEDL25xgeyK+DxhXbwkG8t1iJaNIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/dkv8siYLu4BZqbzo9AEk9hetqwaOBV9gfUD96SYV4=;
        b=jF+vJtH4VqHEHjqJLUY1nKkgBiy7+MOV3lLidIPRWLe7gN8vYSqoDa7+ZrOAlffGqJ
         JoNgULLC5+QimvrQiHU7n2mikL+DI9WG8zvrriCFujyA0nzuYKzXE+3wFEdXYOelc+Xt
         FQKylkoHL2ohfIKDg8pC/L3bn/3VALTL6oEDmVZiCM2nyqRXwY+/c82g3/z3KqB5qALE
         x1qSqIIhqy3T+ukJa0ZqjmDlb6sBi8l8i7k8+/FaJtAjaKVciP1qDPpZuJ5h1NNbDZhN
         /nktEJjjtUFVcNzAZZOMmB68jz9dluTHlWTXGb5dYBW8+dDf7RmEi7gxSIpdZdhvGlWh
         kJWg==
X-Gm-Message-State: AGi0PuYDMz8sJkoNPhOUPekENtD3IwvzHKnkHbHuv0NZA7xzvC9NZ6Sf
        6VFlJ6qe6qRzqBMzoxrvrJv6Na5pbz1tuL5xPcgEYQ==
X-Google-Smtp-Source: APiQypJb/0wG6doOweC6/06XgmGhy6G6Ty+M8bIB3K5ZRqyxCXC7fCfVf3fNxWjDKvYlAslCazWdOEbT8BFYiIP3+mg=
X-Received: by 2002:aca:5492:: with SMTP id i140mr13417819oib.13.1587980736077;
 Mon, 27 Apr 2020 02:45:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200424185556.7358-1-lmb@cloudflare.com> <20200424185556.7358-2-lmb@cloudflare.com>
 <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200426173324.5zg7isugereb5ert@ast-mbp.dhcp.thefacebook.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 27 Apr 2020 10:45:24 +0100
Message-ID: <CACAyw98nK_Vkstp-vEqNwKXtoCRnTOPr7Eh+ziH56tJGbnPsig@mail.gmail.com>
Subject: Re: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Theo Julienne <theojulienne@github.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Apr 2020 at 18:33, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 24, 2020 at 07:55:55PM +0100, Lorenz Bauer wrote:
> > cls_redirect is a TC clsact based replacement for the glb-redirect iptables
> > module available at [1]. It enables what GitHub calls "second chance"
> > flows [2], similarly proposed by the Beamer paper [3]. In contrast to
> > glb-redirect, it also supports migrating UDP flows as long as connected
> > sockets are used. cls_redirect is in production at Cloudflare, as part of
> > our own L4 load balancer.
>
> This is awesome. Thank you for contributing!
> Applied.
>
> > There are two major distinctions from glb-redirect: first, cls_redirect
> > relies on receiving encapsulated packets directly from a router. This is
> > because we don't have access to the neighbour tables from BPF, yet. See
>
> Let's make it available then :)

Yes, I've been dragging my feet on this. It seems like the fib_lookup does
almost what we want, but I need to experiment with it. In the best case,
we'd have a helper that does the following:

* Try and find a neighbour
* Return it if one exists
* Otherwise, asynchronously trigger neighbour discovery (if it makes sense)
* And return the default gateway

I should probably start a new thread about this on the list.

>
> > The code base started it's life on v4.19, so there are most likely still
> > hold overs from old workarounds. In no particular order:
> >
> > - The function buf_off is required to defeat a clang optimization
> >   that leads to the verifier rejecting the program due to pointer
> >   arithmetic in the wrong order.
> >
> > - The function pkt_parse_ipv6 is force inlined, because it would
> >   otherwise be rejected due to returning a pointer to stack memory.
> >
> > - The functions fill_tuple and classify_tcp contain kludges, because
> >   we've run out of function arguments.
> >
> > - The logic in general is rather nested, due to verifier restrictions.
> >   I think this is either because the verifier loses track of constants
> >   on the stack, or because it can't track enum like variables.
>
> Have you tried undoing these workarounds to check the latest verifier?
> If they're still needed we certainly have to improve the verifier.
>
> > +#include "test_cls_redirect.skel.h"
>
> Do you use skeleton internally as well or was it just for selftests? ;)

Only for selftests :) Our internal tooling is all Go based. skeleton
is really nice
though, so I'll make sure to steal some ideas!

>
> > +_Static_assert(
> > +     sizeof(flow_ports_t) !=
> > +             offsetofend(struct bpf_sock_tuple, ipv4.dport) -
> > +                     offsetof(struct bpf_sock_tuple, ipv4.sport) - 1,
> > +     "flow_ports_t must match sport and dport in struct bpf_sock_tuple");
>
> Nice. I didn't realize clang supports it. Of course it should.
>
> > +/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
> > + * or not aligned if the arch supports efficient unaligned access.
> > + *
> > + * Since the verifier ensures that eBPF packet accesses follow these rules,
> > + * we can tell LLVM to emit code as if we always had a larger alignment.
> > + * It will yell at us if we end up on a platform where this is not valid.
> > + */
> > +typedef uint8_t *net_ptr __attribute__((align_value(8)));
>
> Wow. I didn't know about this attribute.
> I wonder whether it can help Daniel's memcpy hack.

Yes, I think so.

> > +
> > +typedef struct buf {
> > +     struct __sk_buff *skb;
> > +     net_ptr head;
> > +     /* NB: tail musn't have alignment other than 1, otherwise
> > +     * LLVM will go and eliminate code, e.g. when checking packet lengths.
> > +     */
> > +     uint8_t *const tail;
> > +} buf_t;
> > +
> > +static size_t buf_off(const buf_t *buf)
> > +{
> > +     /* Clang seems to optimize constructs like
> > +      *    a - b + c
> > +      * if c is known:
> > +      *    r? = c
> > +      *    r? -= b
> > +      *    r? += a
> > +      *
> > +      * This is a problem if a and b are packet pointers,
> > +      * since the verifier allows subtracting two pointers to
> > +      * get a scalar, but not a scalar and a pointer.
> > +      *
> > +      * Use inline asm to break this optimization.
> > +      */
> > +     size_t off = (size_t)buf->head;
> > +     asm("%0 -= %1" : "+r"(off) : "r"(buf->skb->data));
> > +     return off;
> > +}
>
> We need to look into this one.
> This part is not gated by allow_ptr_leaks.
> if (dst_reg == off_reg) {
>         /* scalar -= pointer.  Creates an unknown scalar */
>         verbose(env, "R%d tried to subtract pointer from scalar\n",
>                 dst);
>         return -EACCES;
> }
> Hopefully not too hard to fix.
>
> > +
> > +static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
> > +                                         const struct ipv6hdr *ipv6,
> > +                                         uint8_t *upper_proto,
> > +                                         bool *is_fragment)
> > +{
> > +     /* We understand five extension headers.
> > +      * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
> > +      * headers should occur once, except Destination Options, which may
> > +      * occur twice. Hence we give up after 6 headers.
> > +      */
> > +     struct {
> > +             uint8_t next;
> > +             uint8_t len;
> > +     } exthdr = {
> > +             .next = ipv6->nexthdr,
> > +     };
> > +     *is_fragment = false;
> > +
> > +#pragma clang loop unroll(full)
> > +     for (int i = 0; i < 6; i++) {
>
> unroll is still needed even with bounded loop support in the verifier?

I've just tried removing this on bpf-next. pkt_ipv4_checksum works
without the pragma,
pkt_skip_ipv6_extension_headers fails with the following message:

libbpf: load bpf program failed: Invalid argument
libbpf: -- BEGIN DUMP LOG ---
libbpf:
476: for (int i = 0; i < 6; i++) {
477: switch (exthdr.next) {
back-edge from insn 476 to 477
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
peak_states 0 mark_read 0

libbpf: -- END LOG --
libbpf: failed to load program 'classifier/cls_redirect'
libbpf: failed to load object 'test_cls_redirect'
libbpf: failed to load BPF skeleton 'test_cls_redirect': -4007
test_cls_redirect:FAIL:385
#10 cls_redirect:FAIL
Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

>
>
> > +/* This function has to be inlined, because the verifier otherwise rejects it
> > + * due to returning a pointer to the stack. This is technically correct, since
> > + * scratch is allocated on the stack. However, this usage should be safe since
> > + * it's the callers stack after all.
> > + */
>
> Interesting. The verifier can recognize that ptr to stack can be safe in some cases.
> When I added that check I didn't think that the code can be as tricky as this :)
>
> > +static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
> > +{
> > +     switch (ipv4->protocol) {
> > +     case IPPROTO_ICMP:
> > +             return process_icmpv4(pkt, metrics);
> > +
> > +     case IPPROTO_TCP:
> > +             return process_tcp(pkt, ipv4, sizeof(*ipv4), metrics);
> > +
> > +     case IPPROTO_UDP:
> > +             return process_udp(pkt, ipv4, sizeof(*ipv4), metrics);
> > +
> > +     default:
> > +             metrics->errors_total_unknown_l4_proto++;
> > +             return INVALID;
> > +     }
> > +}
> > +
> > +static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
> > +     if (is_fragment) {
> > +             metrics->errors_total_fragmented_ip++;
> > +             return INVALID;
> > +     }
> > +
> > +     switch (l4_proto) {
> > +     case IPPROTO_ICMPV6:
> > +             return process_icmpv6(pkt, metrics);
> > +
> > +     case IPPROTO_TCP:
> > +             return process_tcp(pkt, ipv6, sizeof(*ipv6), metrics);
> > +
> > +     case IPPROTO_UDP:
> > +             return process_udp(pkt, ipv6, sizeof(*ipv6), metrics);
> > +
> > +     default:
> > +             metrics->errors_total_unknown_l4_proto++;
> > +             return INVALID;
> > +     }
> > +}
> > +
> > +SEC("classifier/cls_redirect")
> > +int cls_redirect(struct __sk_buff *skb)
> > +{
> ...
> > +     verdict_t verdict;
> > +     switch (encap->gue.proto_ctype) {
> > +     case IPPROTO_IPIP:
> > +             verdict = process_ipv4(&pkt, metrics);
> > +             break;
> > +
> > +     case IPPROTO_IPV6:
> > +             verdict = process_ipv6(&pkt, metrics);
> > +             break;
>
> The code flow looks pretty clean.
> I didn't find the copy-paste of ipv[46] -> tcp/udp
> you were mentioning.
> So that old issue is now gone?

The biggest offenders are fill_tuple (which is purely a hack) as well
as classify_tcp.
I'd really like to call classify_tcp from cls_redirect(), using saved
packet pointers and lengths.
Right now the function is called starting from process_ipv4 and
process_ipv6, which
means all of those arguments have to be passed down somehow.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
