Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 960D380CA3
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfHDUnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 16:43:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38216 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbfHDUnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 16:43:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so38521971pfn.5;
        Sun, 04 Aug 2019 13:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QXemZGNKKSXaemQaQ7I2h0ppDpm757mVpb0u6Ipg/zY=;
        b=Ci8DEuemiGJTvmtxDYZntIO4I3dCHvdICgkJ9JPV/JZNfhqjjxW0/RkOZ2IIgm2OzJ
         hZfguJ7UcHTb+MWxe/on+Vaj4r5CVrO1Q76QDEUUQaCzPtyAkR9BKDjMPwg/TooahkPV
         mRN2Vv8rUgyZeoj3Zx1DqzN1gR08fLQ3jwJqGhvyDOLF1GbJ/1Bunq8duzqhQfkNQJl7
         /uatMz8xPqEqJdvCWu0ChHgyxJezs+wzKDrZBnGVfvrOptnzVaRp4zDX20vSrxV/Tqzv
         JbswhyMM+LNYxYDDpA8XktF71PbhRslzvma2xHv1W54y6tLhcXWWLAYzMpu5RrMfioS0
         TxLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QXemZGNKKSXaemQaQ7I2h0ppDpm757mVpb0u6Ipg/zY=;
        b=daI48xfqUlqavF51mWGJj7V1mbr9GF1hKk54qlSJ0pT0FmAQ4u5BJZNhYnjBjQsPYm
         YgmT2QNedsoP8qseoCqL++tx7slT2UU5hvDocoUxxh2iW8MB/b7JuY5QMoLDJCA57NiE
         8PsnqHgm+EPmr71bZg6zuVqRRJBgjfFbBg8iYZSRJVHAB7m3cVUNQz7I3D97Zq9F3jKm
         BRQTa9vj97WQYIjr57fRXvw0rUIkcIu1XqZLfOkn4N0wWkIArbUXE6hHi7nQA01ShEBP
         lKxFT0xf1nkzsg7hdzQJYFmVWu3N/Ld5q8Itj+58DP6/0vN7W3aMU8LnC7aZ0SmxhYqU
         EPRA==
X-Gm-Message-State: APjAAAUsDVgOhGHV2lIvOkhIN2qCxMLPD+nr0sUgIb2AalNpfWNQ0rWi
        1e6SxiC40VJ+xlRJUF76Rrns9GAg9UWt6FO5IDk=
X-Google-Smtp-Source: APXvYqweie4tsXgeXS4l7m40fPNiOzWI4ifFbqNi/NEF/3xuuypXNwYcjlPs7IYlTK9L8/DTw73l/0gHU2Opf+lx6uw=
X-Received: by 2002:a62:1bca:: with SMTP id b193mr68260873pfb.57.1564951428540;
 Sun, 04 Aug 2019 13:43:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
 <20190803044320.5530-2-farid.m.zakaria@gmail.com> <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
 <CACCo2jmcYAfY8zHJiT7NCb-Ct7Wguk9XHRc8QmZa7V3eJy0WTg@mail.gmail.com>
In-Reply-To: <CACCo2jmcYAfY8zHJiT7NCb-Ct7Wguk9XHRc8QmZa7V3eJy0WTg@mail.gmail.com>
From:   Farid Zakaria <farid.m.zakaria@gmail.com>
Date:   Sun, 4 Aug 2019 13:43:37 -0700
Message-ID: <CACCo2j=RAua1E0d6E+tVoOG=q1sSLuZpLqx32dY4mmhYNtDzvg@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
To:     Y Song <ys114321@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* re-sending as I've sent previously as HTML ... sorry *

First off, thank you for taking the time to review this patch.

It's not clear to me the backport you'd like for libbpf, I have been following
the documentation outlined in
https://www.kernel.org/doc/html/latest/bpf/index.html
I will hold off on changes to this patch as you've asked for it going forward.

This patch is inspired by a MPLSoUDP (https://tools.ietf.org/html/rfc7510)]
kernel module that was ported to eBPF -- our implementation is slightly
modified for our custom use case.

The Linux kernel provides a single abstraction for the src port for
UDP tunneling
via udp_flow_src_port. If it's improved eBPF filters would benefit if
the call is the same.

Exposing this function to eBPF programs would maintain feature parity
with other kernel
tunneling implementations.

Farid Zakaria

Farid Zakaria



On Sun, Aug 4, 2019 at 1:41 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
>
> First off, thank you for taking the time to review this patch.
>
> It's not clear to me the backport you'd like for libbpf, I have been following
> the documentation outlined in https://www.kernel.org/doc/html/latest/bpf/index.html
> I will hold off on changes to this patch as you've asked for it going forward.
>
> This patch is inspired by a MPLSoUDP (https://tools.ietf.org/html/rfc7510)]
> kernel module that was ported to eBPF -- our implementation is slightly
> modified for our custom use case.
>
> The Linux kernel provides a single abstraction for the src port for UDP tunneling
> via udp_flow_src_port. If it's improved eBPF filters would benefit if the call is the same.
>
> Exposing this function to eBPF programs would maintain feature parity with other kernel
> tunneling implementations.
>
> Cheers,
> Farid Zakaria
>
>
>
> On Sat, Aug 3, 2019 at 11:52 PM Y Song <ys114321@gmail.com> wrote:
>>
>> On Sat, Aug 3, 2019 at 8:29 PM Farid Zakaria <farid.m.zakaria@gmail.com> wrote:
>> >
>> > Foo over UDP uses UDP encapsulation to add additional entropy
>> > into the packets so that they get beter distribution across EMCP
>> > routes.
>> >
>> > Expose udp_flow_src_port as a bpf helper so that tunnel filters
>> > can benefit from the helper.
>> >
>> > Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
>> > ---
>> >  include/uapi/linux/bpf.h                      | 21 +++++++--
>> >  net/core/filter.c                             | 20 ++++++++
>> >  tools/include/uapi/linux/bpf.h                | 21 +++++++--
>> >  tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
>> >  .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
>> >  .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
>> >  6 files changed, 131 insertions(+), 8 deletions(-)
>> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
>> >  create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c
>>
>> First, for each review, backport and sync with libbpf repo, in the future,
>> could you break the patch to two patches?
>>    1. kernel changes (net/core/filter.c, include/uapi/linux/bpf.h)
>>    2. tools/include/uapi/linux/bpf.h
>>    3. tools/testing/ changes
>>
>> Second, could you explain why existing __sk_buff->hash not enough?
>> there are corner cases where if __sk_buff->hash is 0 and the kernel did some
>> additional hashing, but maybe you can approximate in bpf program?
>> For case, min >= max, I suppose you can get min/max port values
>> from the user space for a particular net device and then calculate
>> the hash in the bpf program?
>> What I want to know if how much accuracy you will lose if you just
>> use __sk_buff->hash and do approximation in bpf program.
>>
>> >
>> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> > index 4393bd4b2419..90e814153dec 100644
>> > --- a/include/uapi/linux/bpf.h
>> > +++ b/include/uapi/linux/bpf.h
>> > @@ -2545,9 +2545,21 @@ union bpf_attr {
>> >   *             *th* points to the start of the TCP header, while *th_len*
>> >   *             contains **sizeof**\ (**struct tcphdr**).
>> >   *
>> > - *     Return
>> > - *             0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
>> > - *             error otherwise.
>> > + *  Return
>> > + *      0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
>> > + *      error otherwise.
>> > + *
>> > + * int bpf_udp_flow_src_port(struct sk_buff *skb, int min, int max, int use_eth)
>> > + *  Description
>> > + *      It's common to implement tunnelling inside a UDP protocol to provide
>> > + *      additional randomness to the packet. The destination port of the UDP
>> > + *      header indicates the inner packet type whereas the source port is used
>> > + *      for additional entropy.
>> > + *
>> > + *  Return
>> > + *      An obfuscated hash of the packet that falls within the
>> > + *      min & max port range.
>> > + *      If min >= max, the default port range is used
>> >   *
>> >   * int bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
>> >   *     Description
>> > @@ -2853,7 +2865,8 @@ union bpf_attr {
>> >         FN(sk_storage_get),             \
>> >         FN(sk_storage_delete),          \
>> >         FN(send_signal),                \
>> > -       FN(tcp_gen_syncookie),
>> > +       FN(tcp_gen_syncookie),  \
>> > +       FN(udp_flow_src_port),
>> >
>> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>> >   * function eBPF program intends to call
>> > diff --git a/net/core/filter.c b/net/core/filter.c
>> > index 5a2707918629..fdf0ebb8c2c8 100644
>> > --- a/net/core/filter.c
>> > +++ b/net/core/filter.c
>> > @@ -2341,6 +2341,24 @@ static const struct bpf_func_proto bpf_msg_pull_data_proto = {
>> >         .arg4_type      = ARG_ANYTHING,
>> >  };
>> >
>> > +BPF_CALL_4(bpf_udp_flow_src_port, struct sk_buff *, skb, int, min,
>> > +          int, max, int, use_eth)
>> > +{
>> > +       struct net *net = dev_net(skb->dev);
>> > +
>> > +       return udp_flow_src_port(net, skb, min, max, use_eth);
>> > +}
>> > +
>> [...]
