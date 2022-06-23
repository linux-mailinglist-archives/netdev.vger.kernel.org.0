Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1874C558BE4
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiFWXs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiFWXsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:48:25 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC1625C4C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:48:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id r1so591246plo.10
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=esBO+gxkP8xynJNoG1WYNo+VvW6Ql/lZluFwI8QCO6k=;
        b=mg9fqoZxdzawbh758EORRniXTZCsIHms9V14dVQk0Z3jtB5SKxq1A+fd0Dm63vg104
         LsCqMYttahIsoVdlazERddlPVNgotWXDgUx8J0iVVeGkExAilqZJyCVa1EbRyHMwuEG5
         S3/9fusa8fsTMta9Nj5d8pQ8PD/xKz1hA8cwrIwzqmo54NY93OqALiNnkpE2pYCZ6OoE
         ZoFALViH+RPbazF8SlWjsE67BZfCt4Xat+ZtimxIKUsxHTC8YNloU8i+r2EiTTFwms8y
         0vmDMSDfFXAWNle7gfqbaC9lM4/YHm3sUMEwCueGF+Bz0e1aP+OKCTaOIKkd63Q8cB+m
         nsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=esBO+gxkP8xynJNoG1WYNo+VvW6Ql/lZluFwI8QCO6k=;
        b=5F/s7OEUVN4WKfhi/N0E9NHiQHuJaC6e03AdmayZeWIGbeG6f1ejxtYtvFQuDIRZSd
         WRjqEYCUMvJniZbQAy4XfOakHZsRVEhAIf+41pNTbwneWFiQGdWhAEN8Eh01meqHJied
         Id+JzIKgMfP0Q00gxG+JUQaA2FkOdNfpsJYt7sS9QMJltO84qpuqG3Btqq1n4sl5xnqa
         xfpOz5G7R8IVoVnzfjBOxHSYNzm4CH+Cu3vhLaQE/TmV2rfZf4IOCWMSIVIZ4wrDJk0o
         to/qSY5SZqg9wS3fEPZat0c6tKU1lngENqdmMp5159Kl9BTGD9x0dNuOL/0AWpo4BtDj
         7cVA==
X-Gm-Message-State: AJIora+tKSdyQDrzE4VPxiG7CrKnPPfwj7C1RT3/QwXB3HSqRgnoZ70d
        /71R7uPx5VixxwYq+C0SYY1J1orFK7ziC9qMWiEwHw==
X-Google-Smtp-Source: AGRyM1tqJsXl4e9Qw3j0MwzvHB7S0yXplJHUxr5dAbm1HytVzR3gReXOHY2WLyEkaFYfFekC/+fNsISUE9DwJmdX8Dw=
X-Received: by 2002:a17:90b:194:b0:1ec:96dd:fef2 with SMTP id
 t20-20020a17090b019400b001ec96ddfef2mr495879pjs.195.1656028101539; Thu, 23
 Jun 2022 16:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220622160346.967594-1-sdf@google.com> <20220622160346.967594-12-sdf@google.com>
 <20220623223631.uu3uakauseipsx5a@kafai-mbp>
In-Reply-To: <20220623223631.uu3uakauseipsx5a@kafai-mbp>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 23 Jun 2022 16:48:10 -0700
Message-ID: <CAKH8qBshDVf6eMb4-ON5fACcqgqew9EuefXNF1Up0Gfx9Z_uRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v10 11/11] selftests/bpf: lsm_cgroup functional test
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 23, 2022 at 3:36 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Jun 22, 2022 at 09:03:46AM -0700, Stanislav Fomichev wrote:
> > diff --git a/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> > new file mode 100644
> > index 000000000000..a96057ec7dd4
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
> > @@ -0,0 +1,277 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <sys/types.h>
> > +#include <sys/socket.h>
> > +#include <test_progs.h>
> > +#include <bpf/btf.h>
> > +
> > +#include "lsm_cgroup.skel.h"
> > +#include "cgroup_helpers.h"
> > +#include "network_helpers.h"
> > +
> > +static __u32 query_prog_cnt(int cgroup_fd, const char *attach_func)
> > +{
> > +     LIBBPF_OPTS(bpf_prog_query_opts, p);
> > +     static struct btf *btf;
> > +     int cnt = 0;
> > +     int i;
> > +
> > +     ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
> > +
> > +     if (!attach_func)
> > +             return p.prog_cnt;
> > +
> > +     /* When attach_func is provided, count the number of progs that
> > +      * attach to the given symbol.
> > +      */
> > +
> > +     if (!btf)
> > +             btf = btf__load_vmlinux_btf();
> This needs a btf__free().  Probably at the end of test_lsm_cgroup().

Ack. Let me move it out of the function in this case.

> > +     if (!ASSERT_OK(libbpf_get_error(btf), "btf_vmlinux"))
> > +             return -1;
> > +
> > +     p.prog_ids = malloc(sizeof(u32) * p.prog_cnt);
> > +     p.prog_attach_flags = malloc(sizeof(u32) * p.prog_cnt);
> and these mallocs too ?

Ack. I'm being sloppy with the tests :-(

> > +     ASSERT_OK(bpf_prog_query_opts(cgroup_fd, BPF_LSM_CGROUP, &p), "prog_query");
> > +
> > +     for (i = 0; i < p.prog_cnt; i++) {
> > +             struct bpf_prog_info info = {};
> > +             __u32 info_len = sizeof(info);
> > +             int fd;
> > +
> > +             fd = bpf_prog_get_fd_by_id(p.prog_ids[i]);
> > +             ASSERT_GE(fd, 0, "prog_get_fd_by_id");
> > +             ASSERT_OK(bpf_obj_get_info_by_fd(fd, &info, &info_len), "prog_info_by_fd");
> > +             close(fd);
> > +
> > +             if (info.attach_btf_id ==
> > +                 btf__find_by_name_kind(btf, attach_func, BTF_KIND_FUNC))
> > +                     cnt++;
> > +     }
> > +
> > +     return cnt;
> > +}
> > +
> > +static void test_lsm_cgroup_functional(void)
> > +{
> > +     DECLARE_LIBBPF_OPTS(bpf_prog_attach_opts, attach_opts);
> > +     DECLARE_LIBBPF_OPTS(bpf_link_update_opts, update_opts);
> > +     int cgroup_fd, cgroup_fd2, err, fd, prio;
> > +     int listen_fd, client_fd, accepted_fd;
> > +     struct lsm_cgroup *skel = NULL;
> > +     int post_create_prog_fd2 = -1;
> > +     int post_create_prog_fd = -1;
> > +     int bind_link_fd2 = -1;
> > +     int bind_prog_fd2 = -1;
> > +     int alloc_prog_fd = -1;
> > +     int bind_prog_fd = -1;
> > +     int bind_link_fd = -1;
> > +     int clone_prog_fd = -1;
> > +     socklen_t socklen;
> > +
> > +     cgroup_fd = test__join_cgroup("/sock_policy");
> > +     if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
> > +             goto close_skel;
> > +
> > +     cgroup_fd2 = create_and_get_cgroup("/sock_policy2");
> > +     if (!ASSERT_GE(cgroup_fd2, 0, "create second cgroup"))
> cgroup_fd needs to close in this error case
>
> > +             goto close_skel;
>
> A valid cgroup_fd2 should be closed later also.

Will initialize to -1 and unconditionally close in close_skel.

> > +
> > +     skel = lsm_cgroup__open_and_load();
> > +     if (!ASSERT_OK_PTR(skel, "open_and_load"))
> > +             goto close_cgroup;
> > +
> > +     post_create_prog_fd = bpf_program__fd(skel->progs.socket_post_create);
> > +     post_create_prog_fd2 = bpf_program__fd(skel->progs.socket_post_create2);
> > +     bind_prog_fd = bpf_program__fd(skel->progs.socket_bind);
> > +     bind_prog_fd2 = bpf_program__fd(skel->progs.socket_bind2);
> > +     alloc_prog_fd = bpf_program__fd(skel->progs.socket_alloc);
> > +     clone_prog_fd = bpf_program__fd(skel->progs.socket_clone);
> > +
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 0, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 0, "total prog count");
> > +     err = bpf_prog_attach(alloc_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
> > +     if (!ASSERT_OK(err, "attach alloc_prog_fd"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_sk_alloc_security"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 1, "total prog count");
> > +
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 0, "prog count");
> > +     err = bpf_prog_attach(clone_prog_fd, cgroup_fd, BPF_LSM_CGROUP, 0);
> > +     if (!ASSERT_OK(err, "attach clone_prog_fd"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_inet_csk_clone"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 2, "total prog count");
> > +
> > +     /* Make sure replacing works. */
> > +
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 0, "prog count");
> > +     err = bpf_prog_attach(post_create_prog_fd, cgroup_fd,
> > +                           BPF_LSM_CGROUP, 0);
> > +     if (!ASSERT_OK(err, "attach post_create_prog_fd"))
> > +             goto close_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
> > +
> > +     attach_opts.replace_prog_fd = post_create_prog_fd;
> > +     err = bpf_prog_attach_opts(post_create_prog_fd2, cgroup_fd,
> > +                                BPF_LSM_CGROUP, &attach_opts);
> > +     if (!ASSERT_OK(err, "prog replace post_create_prog_fd"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_post_create"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 3, "total prog count");
> > +
> > +     /* Try the same attach/replace via link API. */
> > +
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 0, "prog count");
> > +     bind_link_fd = bpf_link_create(bind_prog_fd, cgroup_fd,
> > +                                    BPF_LSM_CGROUP, NULL);
> > +     if (!ASSERT_GE(bind_link_fd, 0, "link create bind_prog_fd"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> > +
> > +     update_opts.old_prog_fd = bind_prog_fd;
> > +     update_opts.flags = BPF_F_REPLACE;
> > +
> > +     err = bpf_link_update(bind_link_fd, bind_prog_fd2, &update_opts);
> > +     if (!ASSERT_OK(err, "link update bind_prog_fd"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> > +
> > +     /* Attach another instance of bind program to another cgroup.
> > +      * This should trigger the reuse of the trampoline shim (two
> > +      * programs attaching to the same btf_id).
> > +      */
> > +
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, "bpf_lsm_socket_bind"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 0, "prog count");
> > +     bind_link_fd2 = bpf_link_create(bind_prog_fd2, cgroup_fd2,
> > +                                     BPF_LSM_CGROUP, NULL);
> > +     if (!ASSERT_GE(bind_link_fd2, 0, "link create bind_prog_fd2"))
> > +             goto detach_cgroup;
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd2, "bpf_lsm_socket_bind"), 1, "prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd, NULL), 4, "total prog count");
> > +     ASSERT_EQ(query_prog_cnt(cgroup_fd2, NULL), 1, "total prog count");
> > +
> > +     /* AF_UNIX is prohibited. */
> > +
> > +     fd = socket(AF_UNIX, SOCK_STREAM, 0);
> > +     ASSERT_LT(fd, 0, "socket(AF_UNIX)");
> close on fd >=0 case.

Here also seems to be safe to unconditionally close.

> > +
> > +     /* AF_INET6 gets default policy (sk_priority). */
> > +
> > +     fd = socket(AF_INET6, SOCK_STREAM, 0);
> > +     if (!ASSERT_GE(fd, 0, "socket(SOCK_STREAM)"))
> > +             goto detach_cgroup;
> > +
> > +     prio = 0;
> > +     socklen = sizeof(prio);
> > +     ASSERT_GE(getsockopt(fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
> > +               "getsockopt");
> > +     ASSERT_EQ(prio, 123, "sk_priority");
> > +
> > +     close(fd);
> > +
> > +     /* TX-only AF_PACKET is allowed. */
> > +
> > +     ASSERT_LT(socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL)), 0,
> > +               "socket(AF_PACKET, ..., ETH_P_ALL)");
> > +
> > +     fd = socket(AF_PACKET, SOCK_RAW, 0);
> > +     ASSERT_GE(fd, 0, "socket(AF_PACKET, ..., 0)");
> > +
> > +     /* TX-only AF_PACKET can not be rebound. */
> > +
> > +     struct sockaddr_ll sa = {
> > +             .sll_family = AF_PACKET,
> > +             .sll_protocol = htons(ETH_P_ALL),
> > +     };
> > +     ASSERT_LT(bind(fd, (struct sockaddr *)&sa, sizeof(sa)), 0,
> > +               "bind(ETH_P_ALL)");
> > +
> > +     close(fd);
> > +
> > +     /* Trigger passive open. */
> > +
> > +     listen_fd = start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
> > +     ASSERT_GE(listen_fd, 0, "start_server");
> > +     client_fd = connect_to_fd(listen_fd, 0);
> > +     ASSERT_GE(client_fd, 0, "connect_to_fd");
> > +     accepted_fd = accept(listen_fd, NULL, NULL);
> > +     ASSERT_GE(accepted_fd, 0, "accept");
> This listen/client/accept_fd needs a close.

Will do.

> > +
> > +     prio = 0;
> > +     socklen = sizeof(prio);
> > +     ASSERT_GE(getsockopt(accepted_fd, SOL_SOCKET, SO_PRIORITY, &prio, &socklen), 0,
> > +               "getsockopt");
> > +     ASSERT_EQ(prio, 234, "sk_priority");
> > +
> > +     /* These are replaced and never called. */
> > +     ASSERT_EQ(skel->bss->called_socket_post_create, 0, "called_create");
> > +     ASSERT_EQ(skel->bss->called_socket_bind, 0, "called_bind");
> > +
> > +     /* AF_INET6+SOCK_STREAM
> > +      * AF_PACKET+SOCK_RAW
> > +      * listen_fd
> > +      * client_fd
> > +      * accepted_fd
> > +      */
> > +     ASSERT_EQ(skel->bss->called_socket_post_create2, 5, "called_create2");
> > +
> > +     /* start_server
> > +      * bind(ETH_P_ALL)
> > +      */
> > +     ASSERT_EQ(skel->bss->called_socket_bind2, 2, "called_bind2");
> > +     /* Single accept(). */
> > +     ASSERT_EQ(skel->bss->called_socket_clone, 1, "called_clone");
> > +
> > +     /* AF_UNIX+SOCK_STREAM (failed)
> > +      * AF_INET6+SOCK_STREAM
> > +      * AF_PACKET+SOCK_RAW (failed)
> > +      * AF_PACKET+SOCK_RAW
> > +      * listen_fd
> > +      * client_fd
> > +      * accepted_fd
> > +      */
> > +     ASSERT_EQ(skel->bss->called_socket_alloc, 7, "called_alloc");
> > +
> > +     /* Make sure other cgroup doesn't trigger the programs. */
> > +
> > +     if (!ASSERT_OK(join_cgroup(""), "join root cgroup"))
> In my qemu setup, I am hitting this:
> (cgroup_helpers.c:166: errno: Device or resource busy) Joining Cgroup
> test_lsm_cgroup_functional:FAIL:join root cgroup unexpected error: 1 (errno 16)
>
> A quick tracing leads to the non zero dst_cgrp->subtree_control
> in cgroup_migrate_vet_dst().
>
> This is likely due to the enable_all_controllers() in cgroup_helpers.c
> that enabled the 'memory' controller in my setup.  Avoid this function
> worked around the issue.  Do you know how to solve this ?

Ugh, yeah, that's due to some controller enabled on v2 and
"no-process-in-non-leaf-cgroup" restriction :-(
Let me see how to do it more carefully. Probably easier to create
another temporary leaf cgroup..
