Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D541230258
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbgG1GHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbgG1GHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:07:05 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E87C061794;
        Mon, 27 Jul 2020 23:07:04 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id w9so14092901qts.6;
        Mon, 27 Jul 2020 23:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJ2nyEUf6g3YRAfphaZ0yk24OUdQAfDee52bXXzd+Ig=;
        b=FGsbCSXsvxN5PF8MuDcrm10znmbQiQrraFb2jQEoSpDDgFSlhBHJ/Trl+JLzFpYSN1
         sGI+bsIUtXeAgGPOGJBWkKsJMh0jc1DO6Wa9jYCLuHVajuxWe0dPqu0LFyCF6RzgN2wa
         btmjF1T1kyWWKIYfTSmRfn9rgJXiqptj1BNGJFoTgV90zAJXr10KbWS+lpS6piOkOI8g
         e1AlkzomxsaDaM5MmsvCZH5axzotNDEwYDSWMftdPJFymwy0Goi8Sd0Ag87XhLFrnrmU
         R3s/WtXQdqxg8eaDKG8LFL4OFOTgyEG4Eu4w9Djj4f+880lCZRXi53tjYqLMuAaCGGOj
         Yadg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJ2nyEUf6g3YRAfphaZ0yk24OUdQAfDee52bXXzd+Ig=;
        b=lGoFoVLEPTU/4M/j9Mvq+qgjkPC0eZ8UxBRImb2hXerh9JBC1U5TdAA7D2uueusXkq
         M0aOkG10CE1J0gkXLh697OQc7bVy5mo80UHFMoCFHK4VOy+sd3+skIMLjZ4ZkyIAHKzE
         vJX0E+ZSOdNDLNqrCCUF7rbUKQ10yhzPsi8mmWM53+4KKbworCT79ack5l44et/3rz5v
         BPduQE8k1ytOyTTKyYal2myCiykPrcItNJkip3VYaw49/t4qlYvAT3hXojdv+cyj7OA0
         FoL9qB2ms5in6XEQE7VCrpsNleBkF3tLbrZG6oc/wOF1b+KKB9LjeagJqzMOyJ7k7oVc
         IBjQ==
X-Gm-Message-State: AOAM530IylV96GHXRQPJOAUUpAZSgTwmiFTn/y6U3X/Rqq9lYWqb3awP
        Bsq0IJMsdAJqOUaInEQ5PFc+aU7TCugPXdREM1oRxg==
X-Google-Smtp-Source: ABdhPJyHHj6Q8xwIOI+EmFzsRLZkX6bbRjKHiC5+zkQolTx01IQl4U8rPzUas0dgpT5T5soQCzU7+hkrySMjmrq9F70=
X-Received: by 2002:aed:2cc5:: with SMTP id g63mr24858072qtd.59.1595916424229;
 Mon, 27 Jul 2020 23:07:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-33-guro@fb.com>
In-Reply-To: <20200727184506.2279656-33-guro@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Jul 2020 23:06:53 -0700
Message-ID: <CAEf4BzbCzEOKx2GMOcp6CTxBBN+BRAY-Z_mCJ26hoSto956KBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 32/35] bpf: selftests: delete bpf_rlimit.h
To:     Roman Gushchin <guro@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 12:25 PM Roman Gushchin <guro@fb.com> wrote:
>
> As rlimit-based memory accounting is not used by bpf anymore,
> there are no more reasons to play with memlock rlimit.
>
> Delete bpf_rlimit.h which contained a code to bump the limit.
>
> Signed-off-by: Roman Gushchin <guro@fb.com>
> ---

We run test_progs on old kernels as part of libbpf Github CI. We'll
need to either leave setrlimit() or do it conditionally, depending on
detected kernel feature support.

>  samples/bpf/hbm.c                             |  1 -
>  tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
>  .../selftests/bpf/flow_dissector_load.c       |  1 -
>  .../selftests/bpf/get_cgroup_id_user.c        |  1 -
>  .../bpf/prog_tests/select_reuseport.c         |  1 -
>  .../selftests/bpf/prog_tests/sk_lookup.c      |  1 -
>  tools/testing/selftests/bpf/test_btf.c        |  1 -
>  .../selftests/bpf/test_cgroup_storage.c       |  1 -
>  tools/testing/selftests/bpf/test_dev_cgroup.c |  1 -
>  tools/testing/selftests/bpf/test_lpm_map.c    |  1 -
>  tools/testing/selftests/bpf/test_lru_map.c    |  1 -
>  tools/testing/selftests/bpf/test_maps.c       |  1 -
>  tools/testing/selftests/bpf/test_netcnt.c     |  1 -
>  tools/testing/selftests/bpf/test_progs.c      |  1 -
>  .../selftests/bpf/test_skb_cgroup_id_user.c   |  1 -
>  tools/testing/selftests/bpf/test_sock.c       |  1 -
>  tools/testing/selftests/bpf/test_sock_addr.c  |  1 -
>  .../testing/selftests/bpf/test_sock_fields.c  |  1 -
>  .../selftests/bpf/test_socket_cookie.c        |  1 -
>  tools/testing/selftests/bpf/test_sockmap.c    |  1 -
>  tools/testing/selftests/bpf/test_sysctl.c     |  1 -
>  tools/testing/selftests/bpf/test_tag.c        |  1 -
>  .../bpf/test_tcp_check_syncookie_user.c       |  1 -
>  .../testing/selftests/bpf/test_tcpbpf_user.c  |  1 -
>  .../selftests/bpf/test_tcpnotify_user.c       |  1 -
>  tools/testing/selftests/bpf/test_verifier.c   |  1 -
>  .../testing/selftests/bpf/test_verifier_log.c |  2 --
>  27 files changed, 55 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
>

[...]
