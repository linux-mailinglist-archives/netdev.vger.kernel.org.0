Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4188F48CFD3
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiAMAzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiAMAzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:55:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C3CC06173F;
        Wed, 12 Jan 2022 16:55:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D812461BCE;
        Thu, 13 Jan 2022 00:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A74C36AED;
        Thu, 13 Jan 2022 00:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642035336;
        bh=22YPiBxoasOzJ1VuGD3O0ZDDyXLNAdlgz16CwH5U42E=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OngrHkLGSW+klCVyERlTcfeduji0FEJm6ECD2qMu8A98YQ1v9OijFUQaHoCnLfrdn
         5nIYLUfNtQcC7FBkU2bifyh5z6wVc2QX7DdzAva/7ANamYLJxFsFtBru/80yYMXYUE
         Itlf2/+Uq1erb8XY2D77Lj0d8nzgrBzuo08Psl+VyZuUX7aAfBUfrSnrNY0PTEzpt8
         VBhVeUMBKaj3lXuWu+6Wks+SrquEdRTr3YtzclhdNzzkjTqnW+tVsvVrJSY34xETYP
         wZt7KpyRPuWJrfqBE5TE7ZGoAKyWYfvkmEuOY3UQaUPMWfxDmvmT8DmE5cJ8QBiJ0b
         IeSfTBttExvow==
Received: by mail-yb1-f174.google.com with SMTP id h14so10478198ybe.12;
        Wed, 12 Jan 2022 16:55:36 -0800 (PST)
X-Gm-Message-State: AOAM533hSvmht5O5m70jR90L/fHXI5qYlY1qK16bh2gkAMF2FUFo/O7D
        Rl7lNJrpStxerAnqRjpO69GRpd5WICEm+8nPMYU=
X-Google-Smtp-Source: ABdhPJxlj6dWFRoZRlgkNvptELMLVSI/V6OpRw9j0sbaCSmlHIcbdQHeiW4+NOxy1riALdywcBEb+8DZh8k/ACaKvnE=
X-Received: by 2002:a25:248a:: with SMTP id k132mr3264716ybk.282.1642035335377;
 Wed, 12 Jan 2022 16:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20220113000650.514270-1-quic_twear@quicinc.com> <20220113000650.514270-2-quic_twear@quicinc.com>
In-Reply-To: <20220113000650.514270-2-quic_twear@quicinc.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 12 Jan 2022 16:55:24 -0800
X-Gmail-Original-Message-ID: <CAPhsuW53NOGCnEM366qfPqeGQuaKaStcSFb10wigMzpqhA1-xA@mail.gmail.com>
Message-ID: <CAPhsuW53NOGCnEM366qfPqeGQuaKaStcSFb10wigMzpqhA1-xA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 2/2] selftests/bpf: CGROUP_SKB test for skb_store_bytes()
To:     Tyler Wear <quic_twear@quicinc.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 4:07 PM Tyler Wear <quic_twear@quicinc.com> wrote:
>
> Patch adds a test case to check that the source IP and Port of
> packet are correctly changed for BPF_PROG_TYPE_CGROUP_SKB via
> skb_store_bytes().

Please revise the commit log based on guidance in
Documentation/process/submitting-patches.rst.

Specifically, please refer to this part:

Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
to do frotz", as if you are giving orders to the codebase to change
its behaviour.

>
> Test creates a client and server and checks that the packet
> received on the server has the updated source IP and Port
> that the bpf program modifies.
>
> Signed-off-by: Tyler Wear <quic_twear@quicinc.com>
> ---
>  .../bpf/prog_tests/cgroup_store_bytes.c       | 74 +++++++++++++++++++
>  .../selftests/bpf/progs/cgroup_store_bytes.c  | 52 +++++++++++++
>  2 files changed, 126 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
>  create mode 100644 tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..4338f9db2f88
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_store_bytes.c
> @@ -0,0 +1,74 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <test_progs.h>
> +#include <network_helpers.h>
> +
> +#include "cgroup_store_bytes.skel.h"
> +
> +static int duration;

I think duration is not needed.

> +
> +void test_cgroup_store_bytes(void)
> +{
> +       int server_fd, cgroup_fd, client_fd, err, bytes;
> +       struct sockaddr server_addr;
> +       socklen_t addrlen = sizeof(server_addr);
> +       char buf[] = "testing";
> +       struct sockaddr_storage ss;
> +       socklen_t slen = sizeof(ss);
> +       char recv_buf[BUFSIZ];
> +       struct in_addr addr;
> +       unsigned short port;
> +       struct cgroup_store_bytes *skel;
> +
> +       cgroup_fd = test__join_cgroup("/cgroup_store_bytes");
> +       if (!ASSERT_GE(cgroup_fd, 0, "cgroup_fd"))
> +               return;
> +
> +       skel = cgroup_store_bytes__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel"))
> +               goto close_cgroup_fd;
> +       if (!ASSERT_OK_PTR(skel->bss, "check_bss"))
> +               goto close_cgroup_fd;

No need to check skel->bss

> +
> +       skel->links.cgroup_store_bytes = bpf_program__attach_cgroup(
> +                       skel->progs.cgroup_store_bytes, cgroup_fd);
> +       if (!ASSERT_OK_PTR(skel, "cgroup_store_bytes"))
> +               goto close_skeleton;

I think we need to check skel->links.cgroup_store_bytes here, not skel.

> +
> +       server_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +       if (!ASSERT_GE(server_fd, 0, "server_fd"))
> +               goto close_skeleton;
> +
> +       client_fd = start_server(AF_INET, SOCK_DGRAM, NULL, 0, 0);
> +       if (!ASSERT_GE(client_fd, 0, "client_fd"))
> +               goto close_server_fd;
> +
> +       err = getsockname(server_fd, &server_addr, &addrlen);
> +       if (!ASSERT_OK(err, "getsockname"))
> +               goto close_client_fd;
> +
> +       bytes = sendto(client_fd, buf, sizeof(buf), 0, &server_addr,
> +                       sizeof(server_addr));
> +       if (!ASSERT_EQ(bytes, sizeof(buf), "sendto"))
> +               goto close_client_fd;
> +
> +       bytes = recvfrom(server_fd, &recv_buf, sizeof(recv_buf), 0,
> +                       (struct sockaddr *)&ss, &slen);
> +       if (!ASSERT_GE(bytes, 0, "recvfrom"))
> +               goto close_client_fd;
> +
> +       addr = ((struct sockaddr_in *)&ss)->sin_addr;
> +
> +       ASSERT_EQ(skel->bss->test_result, 1, "bpf program returned failure");
> +       port = ((struct sockaddr_in *)&ss)->sin_port;
> +       ASSERT_EQ(port, 5555, "bpf program failed to change port");
> +
> +close_client_fd:
> +       close(client_fd);
> +close_server_fd:
> +       close(server_fd);
> +close_skeleton:
> +       cgroup_store_bytes__destroy(skel);
> +close_cgroup_fd:
> +       close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> new file mode 100644
> index 000000000000..c77b360ef4b0
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/cgroup_store_bytes.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <errno.h>
> +#include <linux/bpf.h>
> +#include <linux/if_ether.h>
> +#include <linux/ip.h>
> +#include <netinet/in.h>
> +#include <netinet/udp.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define IP_SRC_OFF offsetof(struct iphdr, saddr)
> +#define UDP_SPORT_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, source))
> +
> +#define IS_PSEUDO 0x10
> +
> +#define UDP_CSUM_OFF (sizeof(struct iphdr) + offsetof(struct udphdr, check))
> +#define IP_CSUM_OFF offsetof(struct iphdr, check)
> +
> +int test_result;

Let's use

int test_result = 0;

to make old clang happy.

> +
> +SEC("cgroup_skb/egress")
> +int cgroup_store_bytes(struct __sk_buff *skb)
> +{
> +       struct ethhdr eth;
> +       struct iphdr iph;
> +       struct udphdr udph;
> +
> +       __u32 map_key = 0;
> +       __u32 test_passed = 0;
> +       __u16 new_port = 5555;
> +       __u16 old_port;
> +       __u32 old_ip;
> +
> +       if (bpf_skb_load_bytes_relative(skb, 0, &iph, sizeof(iph), BPF_HDR_START_NET))
> +               goto fail;
> +
> +       if (bpf_skb_load_bytes_relative(skb, sizeof(iph), &udph, sizeof(udph), BPF_HDR_START_NET))
> +               goto fail;
> +
> +       old_port = udph.source;
> +       bpf_l4_csum_replace(skb, UDP_CSUM_OFF, old_port, new_port,
> +                                               IS_PSEUDO | sizeof(new_port));
> +       if (bpf_skb_store_bytes(skb, UDP_SPORT_OFF, &new_port, sizeof(new_port), 0) < 0)
> +               goto fail;
> +
> +       test_passed = 1;

We can just use test_result here, and remove test_passed, right?

> +
> +fail:
> +       test_result = test_passed;
> +
> +       return 1;
> +}
> --
> 2.25.1
>
