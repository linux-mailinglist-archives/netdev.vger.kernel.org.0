Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4A81CBADC
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 00:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgEHWpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 18:45:44 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:32863
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727816AbgEHWpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 18:45:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1588977941; bh=JDti47bbUCBboOeKAswekykgBNQeBOGdkekWBkV0pNw=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=uC8rX8jRM7IAIdZBeyOwBOuGHdueZEkn/oNxnAzhJpNKvWUDA9XIEzq+BI2YAdBe3uu5LAW93APFCUz77mHI67a9+/j0a1MiV+4x/t4OAj27IMM+2I7dKYw06RSIZH4mxcz/QtHvBPCKJnOntVDCMGq6qIwBIC5DKVCV+yKqheqfH60PiXAksVNa7/jEVlZPBXNjOfkXU+mYiwhYp0jTiAd7/Pc+25koLwzgYI6J7b74cbJ5UWRPHerW5GtyrvubLPQ+0N/kXTCZ31LmAK6d3RcpZ9JTljN/22uGRj5G6hcn3E1HrL0PAfF3IRjJnl4eVuWq3Y/QSeJJCUOJn+X+1w==
X-YMail-OSG: 9PxM0cAVM1n29Zkyhh7OHyTS6a6f1idnVF94aycgVPCp7OErJ1wPBioB._YSbYO
 ez65F6Rq1Z06dnTl5BJiqWTQDTXSpf2wf5e_3Rgg0PTjUYEhGg6Rn7zdjmX_6i4_k4seRa5EJ7bm
 MySt9Zbd1r95p4JR1mQp5DknLv3fFiUdhY9p9PIHRnEIAZPkfRxJtCMk_Rl0qpmbpcvB7dhmrTzz
 Np2hdCywZ36fz_R7KXOV.zdEfQgC16iMf5hYX.yLgIFKrpZ6m0b6q.hf_XUEoygL2iF7vetqmfPO
 QM0d.kxjjGCEW4fkX3TFGUjVukS7.NBcp6iXl.DI9k5mmAgDsa9mBX1U0cmFf6R0m8hHxENBrcOk
 YIruG.B.HmUz6o.8YwHGM7iXOHB1e8sxI7RgMYPwdx9snPtYVejtS.Y1CQhP45o1L7zH0HhV9IhF
 rgUj5QRncCnLiTj9H4aMFD32DR6NK3xGXZeOzK8dIMxvAs7QiVw3YFTbUgvyeTPeMF8GzVZ_C958
 AWnffLEo_8nBjXNtCt9KZ7S9dwhpBayilMo.IMRYpc3Xd4q9MaNePWqiydanK_GRpcuM5zU9x.TQ
 MiYbYl3cSK2eCgsb8f6dVlKhxYfoA7YDuoDGKxBx.bh2IQdU5AMPJpbR7wZ4qQ4qo9jLRBDHvkEs
 OtvW_TAjUj3SUzcRjHKZ7KHnykDfCw2qeurl9X2jiqi0alDtLbPLSTcMXy0I1uM.jKeKNkX1XI96
 6C_ceD_.7DM9ZvDl5D_tVvlYp5PqtaHcSRc5C0Wqp68smmbuDpc3yhvVVkHfJWzZ5Oytj.zA1xfk
 ZSMRl1T.3dT_iOZF9T0.sWeu2Flma89AA8elstOwxfmlOce1olOPC7JX.AdfuSeVqpahweXPg88J
 Wzrq2JZVMqOAhOMmuUtikBjRIgRsO0V2K8q1GHoEMVEHkQ9WAyidLCCDUENTCm.Qq7F5s143FiBQ
 Nu9xHrPLmx5GZ5tthZIN2kqNVuetVQNh.RJMXHz71mJco9xDvVSMI5GfadAosN3Ly1Wa0gjoYqUH
 HN0Qvue15xwzcNjFkoZQbUBq56wSzZr7I8dnCavC352QXyfBSSlfzkRdySjxmvPYbAscSsA6TvnN
 mRMaZ4zYzwKYJnCsfHQGhpRt5Sxd_Q3t2FJaOqVOg4iKCb9_PKpenfEdyirnYwXfZZ9U9wFN3_KJ
 5KHeswfqb7efA8OIXaOr.LulMqceGEwKX7jmdg0tfECNydc4av20ep4YEPObwMK3B9XoG1SgU.KH
 _x6TCOg5JDBTN.31r_0yPQzBfKxlJ8HZM0De.5EZHk4xCOwjp1K2oMz.4pdT4zkKF6.pex7ec5P.
 IzXPlgiOPugEhFoc5djk8w3.oR608K3Qb5ivCD5DhAEM245lw8VwN.rfyGPmxjui5N3b3HXJpQNe
 4caT_6mdBE7xIldRSJBpxaRb6PQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Fri, 8 May 2020 22:45:41 +0000
Received: by smtp423.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 41f8f2b1c8ba52094465d0462e5684c7;
          Fri, 08 May 2020 22:45:37 +0000 (UTC)
Subject: Re: [PATCH v5 bpf-next 0/3] Introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        davem@davemloft.net
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com, linux-security-module@vger.kernel.org,
        acme@redhat.com, jamorris@linux.microsoft.com, jannh@google.com,
        kpsingh@google.com, Casey Schaufler <casey@schaufler-ca.com>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <71f66e31-02d9-a661-af3b-f493140a53e2@schaufler-ca.com>
Date:   Fri, 8 May 2020 15:45:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.15902 hermes Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/8/2020 2:53 PM, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>
> v4->v5:
>
> Split BPF operations that are allowed under CAP_SYS_ADMIN into combination of
> CAP_BPF, CAP_PERFMON, CAP_NET_ADMIN and keep some of them under CAP_SYS_ADMIN.
>
> The user process has to have
> - CAP_BPF and CAP_PERFMON to load tracing programs.
> - CAP_BPF and CAP_NET_ADMIN to load networking programs.
> (or CAP_SYS_ADMIN for backward compatibility).

Is there a case where CAP_BPF is useful in the absence of other capabilities?
I generally object to new capabilities in cases where existing capabilities
are already required.

>
> CAP_BPF solves three main goals:
> 1. provides isolation to user space processes that drop CAP_SYS_ADMIN and switch to CAP_BPF.
>    More on this below. This is the major difference vs v4 set back from Sep 2019.
> 2. makes networking BPF progs more secure, since CAP_BPF + CAP_NET_ADMIN
>    prevents pointer leaks and arbitrary kernel memory access.
> 3. enables fuzzers to exercise all of the verifier logic. Eventually finding bugs
>    and making BPF infra more secure. Currently fuzzers run in unpriv.
>    They will be able to run with CAP_BPF.
>
> The patchset is long overdue follow-up from the last plumbers conference.
> Comparing to what was discussed at LPC the CAP* checks at attach time are gone.
> For tracing progs the CAP_SYS_ADMIN check was done at load time only. There was
> no check at attach time. For networking and cgroup progs CAP_SYS_ADMIN was
> required at load time and CAP_NET_ADMIN at attach time, but there are several
> ways to bypass CAP_NET_ADMIN:
> - if networking prog is using tail_call writing FD into prog_array will
>   effectively attach it, but bpf_map_update_elem is an unprivileged operation.
> - freplace prog with CAP_SYS_ADMIN can replace networking prog
>
> Consolidating all CAP checks at load time makes security model similar to
> open() syscall. Once the user got an FD it can do everything with it.
> read/write/poll don't check permissions. The same way when bpf_prog_load
> command returns an FD the user can do everything (including attaching,
> detaching, and bpf_test_run).
>
> The important design decision is to allow ID->FD transition for
> CAP_SYS_ADMIN only. What it means that user processes can run
> with CAP_BPF and CAP_NET_ADMIN and they will not be able to affect each
> other unless they pass FDs via scm_rights or via pinning in bpffs.
> ID->FD is a mechanism for human override and introspection.
> An admin can do 'sudo bpftool prog ...'. It's possible to enforce via LSM that
> only bpftool binary does bpf syscall with CAP_SYS_ADMIN and the rest of user
> space processes do bpf syscall with CAP_BPF isolating bpf objects (progs, maps,
> links) that are owned by such processes from each other.
>
> Another significant change from LPC is that the verifier checks are split into
> allow_ptr_leaks and bpf_capable flags. The allow_ptr_leaks disables spectre
> defense and allows pointer manipulations while bpf_capable enables all modern
> verifier features like bpf-to-bpf calls, BTF, bounded loops, indirect stack
> access, dead code elimination, etc. All the goodness.
> These flags are initialized as:
>   env->allow_ptr_leaks = perfmon_capable();
>   env->bpf_capable = bpf_capable();
> That allows networking progs with CAP_BPF + CAP_NET_ADMIN enjoy modern
> verifier features while being more secure.
>
> Some networking progs may need CAP_BPF + CAP_NET_ADMIN + CAP_PERFMON,
> since subtracting pointers (like skb->data_end - skb->data) is a pointer leak,
> but the verifier may get smarter in the future.
>
> Please see patches for more details.
>
> Alexei Starovoitov (3):
>   bpf, capability: Introduce CAP_BPF
>   bpf: implement CAP_BPF
>   selftests/bpf: use CAP_BPF and CAP_PERFMON in tests
>
>  drivers/media/rc/bpf-lirc.c                   |  2 +-
>  include/linux/bpf_verifier.h                  |  1 +
>  include/linux/capability.h                    |  5 ++
>  include/uapi/linux/capability.h               | 34 +++++++-
>  kernel/bpf/arraymap.c                         |  2 +-
>  kernel/bpf/bpf_struct_ops.c                   |  2 +-
>  kernel/bpf/core.c                             |  4 +-
>  kernel/bpf/cpumap.c                           |  2 +-
>  kernel/bpf/hashtab.c                          |  4 +-
>  kernel/bpf/helpers.c                          |  4 +-
>  kernel/bpf/lpm_trie.c                         |  2 +-
>  kernel/bpf/queue_stack_maps.c                 |  2 +-
>  kernel/bpf/reuseport_array.c                  |  2 +-
>  kernel/bpf/stackmap.c                         |  2 +-
>  kernel/bpf/syscall.c                          | 87 ++++++++++++++-----
>  kernel/bpf/verifier.c                         | 24 ++---
>  kernel/trace/bpf_trace.c                      |  3 +
>  net/core/bpf_sk_storage.c                     |  4 +-
>  net/core/filter.c                             |  4 +-
>  security/selinux/include/classmap.h           |  4 +-
>  tools/testing/selftests/bpf/test_verifier.c   | 44 ++++++++--
>  tools/testing/selftests/bpf/verifier/calls.c  | 16 ++--
>  .../selftests/bpf/verifier/dead_code.c        | 10 +--
>  23 files changed, 191 insertions(+), 73 deletions(-)
>
