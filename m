Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F171C67D6
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 08:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgEFGEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 02:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725771AbgEFGEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 02:04:35 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0039BC061A0F;
        Tue,  5 May 2020 23:04:34 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id q13so477649qtp.7;
        Tue, 05 May 2020 23:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ChezaoH4CBgiAK6q2eFr5RaJbWQCYEoCXpcIjPeuga0=;
        b=O97Q0TAsHxn5Ou3PCxlC743R3Jvz7GgyzXYBwVwmHT2kLgIp3uxIpWXhdtASaBsYKB
         HHwsJtecyinvArseEPboRMKw9xZgsytjp3YT89PScSkgvJGfnGxJbSzNRcSmQeLnkJEy
         DW4UZKsv+ArLvcRNlk1z5tETASuhD6/rlblRxv/MUcDCxr+cOKKSnMhqk1puXr2On+bi
         NEsxqOy3QhF1eAGnh+FNsSnlaNWnidFGDiW/Hi4SFFN6vUcEeQhOwok/RdNZLmjq5vlD
         Gt+FhDXM0Lsx4ElC2sHvvcYhbhfqjAsiFyp1SoMYn8ezrRxCzJX1WCBsKv6WHXBgrQ1M
         WXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ChezaoH4CBgiAK6q2eFr5RaJbWQCYEoCXpcIjPeuga0=;
        b=trQH6Sk4Z3T83wx01gm8EIg5TmVVf87heyi58xGe/YzqEhwKJSVgOKzD+UFnipS5He
         VoWfZFl6AJtkyC7HFegc/7EdplJKKrKjU8s6Wr2dP2VCCzmszgfzf1Ntir0LHdgXduHI
         XGFcoibC/4xw6Ykvq1I1j78QRZvJXUNvrzViDcF6Vep/7tNLtygLjlCToVkkzns4Fhpf
         5rI2kU1wvlOfQ3mQyU0rvPzYp6kFGIge1jivKDY7qjeTMCarofgMj8wSwo+7M8ia6spC
         s860kM0FYjhzohJJGnq48CEhUWX6MPghMVOKuDEmb3kVngPQS8dh61LGZGiQIDWroH44
         Orfw==
X-Gm-Message-State: AGi0PuaLR62Fa+U0tiGX6Te+zJXopjH+khNYneAa1vj6DIxh8WTwh5Ri
        u+Ps0dbEgJ8pJjKzgaj1o6r5hoGIoM3tV/FcL5w=
X-Google-Smtp-Source: APiQypK0c0RlP045t4Z+aO4PZO6BAF78PBVGPNf5+s6eqALIrVyd3c6h2O0wN5FKfAzRTf8iV3VYQS+7oE4lowiTTvg=
X-Received: by 2002:ac8:468d:: with SMTP id g13mr6316293qto.59.1588745074062;
 Tue, 05 May 2020 23:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062608.2049044-1-yhs@fb.com>
In-Reply-To: <20200504062608.2049044-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 23:04:22 -0700
Message-ID: <CAEf4BzaGsk2hgLHvU=9b2gv7V0y788MNw0hwkSQxE4kg4zSe=w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 18/20] tools/bpf: selftests: add iterator
 programs for ipv6_route and netlink
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:30 PM Yonghong Song <yhs@fb.com> wrote:
>
> Two bpf programs are added in this patch for netlink and ipv6_route
> target. On my VM, I am able to achieve identical
> results compared to /proc/net/netlink and /proc/net/ipv6_route.
>
>   $ cat /proc/net/netlink
>   sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>   000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>   00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>   00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>   000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>   ....
>   00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>   000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>   00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>   000000008398fb08 16  0          00000000 0        0        0     2        0        27
>   $ cat /sys/fs/bpf/my_netlink
>   sk               Eth Pid        Groups   Rmem     Wmem     Dump  Locks    Drops    Inode
>   000000002c42d58b 0   0          00000000 0        0        0     2        0        7
>   00000000a4e8b5e1 0   1          00000551 0        0        0     2        0        18719
>   00000000e1b1c195 4   0          00000000 0        0        0     2        0        16422
>   000000007e6b29f9 6   0          00000000 0        0        0     2        0        16424
>   ....
>   00000000159a170d 15  1862       00000002 0        0        0     2        0        1886
>   000000009aca4bc9 15  3918224839 00000002 0        0        0     2        0        19076
>   00000000d0ab31d2 15  1          00000002 0        0        0     2        0        18683
>   000000008398fb08 16  0          00000000 0        0        0     2        0        27
>
>   $ cat /proc/net/ipv6_route
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   $ cat /sys/fs/bpf/my_ipv6_route
>   fe800000000000000000000000000000 40 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000001 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>   00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001       lo
>   fe80000000000000c04b03fffe7827ce 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80200001     eth0
>   ff000000000000000000000000000000 08 00000000000000000000000000000000 00 00000000000000000000000000000000 00000100 00000003 00000000 00000001     eth0
>   00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 00000000 00200200       lo
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Just realized, this is only BPF programs, right? It would be good to
have at least minimal user-space program that would verify and load
it. Otherwise we'll be just testing compilation and it might "bit rot"
a bit...

>  .../selftests/bpf/progs/bpf_iter_ipv6_route.c | 63 ++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_netlink.c    | 74 +++++++++++++++++++
>  2 files changed, 137 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ipv6_route.c
>  create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_netlink.c
>

[...]
