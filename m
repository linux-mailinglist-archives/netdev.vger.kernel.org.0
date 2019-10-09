Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F6AD1416
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731595AbfJIQdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:33:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35982 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729644AbfJIQdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:33:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id 23so1755379pgk.3
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QgwemIWq3VINHKqURhAdHEgxvF02MUo2zrpnX5QOSew=;
        b=r4Nd7VM+qwC4lYE8DHhMQNdVODWc3pSqCLEN44KTQwiHx0LJZKdZm2w4KOPa99RnpI
         wgYUkICPvelzxyLD9C9bFnzImlPf33E5lfSazvQOnprnw8bOoj5ZlZBuaoXIY0HzcWk/
         51iEFAWnRGJcmRnTK9mwfPZRYi27mhjNt6Aj9RyGIhyPp9aW4gp/fzeJefs31pd94Yk6
         dvdQrIujqb9yYNd057RMvXXTrJJXF1VWZX3Xy97hrbp/K+vsgAa592QjYo0DoBEqLwrg
         hxPEyZ+7sFg528uaFsg2lur5AlwycQSzPPzUBJswMkKQLf7Zz9vFyTSTSpQJAxAp+dtm
         w+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QgwemIWq3VINHKqURhAdHEgxvF02MUo2zrpnX5QOSew=;
        b=gcYYL+8PlaKy8jaB5kuj5Dd20YQikISQwOKaDRhK7kIDyoSac5Ga5MBt/pSHQqvtr8
         dtkuJa/JRMoCFG2rl4ZJm/AZGStLD34wpwWUXYpTFXQWm6P0GGP0pq3MjEYWvdHEP/Oy
         7EFOuXx2aAsvcGKMJ8jFDd5SWU+VP23UMW9GWAtJYxRK0+nMVTrz7JpXsjl+oBzk6PCa
         E4ThaxVhU8h1dgjbJ8yCW5cMmFzOYN9o+Bllpz9SOsztlk86k30nEnRv44v89SfImhbn
         IcPgE2JO6Vm3v5TdLJL7Kyykz2JPai7c0O0zuBrE1xU7uu0zixKhaZDuufGh2fcLOAJ3
         zOxA==
X-Gm-Message-State: APjAAAUxR8gabFoKf7aU2YkhJUJV3htg7HY+9b0AtEpVsrJgg1yIgHvx
        FH+PXmZh9tfQv2xmsinbEoXOVA==
X-Google-Smtp-Source: APXvYqxxB7Rwv1aOn/ZYgvJ9Oc9fhA+g5Yen89NZnTGR978Q3Oo1sGPvoG3g9Ja08rpG9PiLCc5BPw==
X-Received: by 2002:a63:5025:: with SMTP id e37mr2626785pgb.7.1570638823181;
        Wed, 09 Oct 2019 09:33:43 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 74sm4079234pfy.78.2019.10.09.09.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 09:33:42 -0700 (PDT)
Date:   Wed, 9 Oct 2019 09:33:41 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATH bpf-next 2/2] selftests/bpf: Check that flow dissector can
 be re-attached
Message-ID: <20191009163341.GE2096@mini-arch>
References: <20191009094312.15284-1-jakub@cloudflare.com>
 <20191009094312.15284-2-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009094312.15284-2-jakub@cloudflare.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/09, Jakub Sitnicki wrote:
> Make sure a new flow dissector program can be attached to replace the old
> one with a single syscall. Also check that attaching the same program twice
> is prohibited.
Overall the series looks good, left a bunch of nits/questions below.

> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  .../bpf/prog_tests/flow_dissector_reattach.c  | 93 +++++++++++++++++++
>  1 file changed, 93 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> new file mode 100644
> index 000000000000..0f0006c93956
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector_reattach.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Test that the flow_dissector program can be updated with a single
> + * syscall by attaching a new program that replaces the existing one.
> + *
> + * Corner case - the same program cannot be attached twice.
> + */
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <stdbool.h>
> +#include <unistd.h>
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf.h>
> +
> +#include "test_progs.h"
> +
[..]
> +/* Not used here. For CHECK macro sake only. */
> +static int duration;
nit: you can use CHECK_FAIL macro instead which doesn't require this.

if (CHECK_FAIL(expr)) {
	printf("something bad has happened\n");
	return/goto;
}

It may be more verbose than doing CHECK() with its embedded error
message, so I leave it up to you to decide on whether you want to switch
to CHECK_FAIL or stick to CHECK.

> +static bool is_attached(void)
> +{
> +	bool attached = true;
> +	int err, net_fd = -1;
nit: maybe don't need to initialize net_fd to -1 here as well.

> +	__u32 cnt;
> +
> +	net_fd = open("/proc/self/ns/net", O_RDONLY);
> +	if (net_fd < 0)
> +		goto out;
> +
> +	err = bpf_prog_query(net_fd, BPF_FLOW_DISSECTOR, 0, NULL, NULL, &cnt);
> +	if (CHECK(err, "bpf_prog_query", "ret %d errno %d\n", err, errno))
> +		goto out;
> +
> +	attached = (cnt > 0);
> +out:
> +	close(net_fd);
> +	return attached;
> +}
> +
> +static int load_prog(void)
> +{
> +	struct bpf_insn prog[] = {
> +		BPF_MOV64_IMM(BPF_REG_0, BPF_OK),
> +		BPF_EXIT_INSN(),
> +	};
> +	int fd;
> +
> +	fd = bpf_load_program(BPF_PROG_TYPE_FLOW_DISSECTOR, prog,
> +			      ARRAY_SIZE(prog), "GPL", 0, NULL, 0);
> +	CHECK(fd < 0, "bpf_load_program", "ret %d errno %d\n", fd, errno);
> +
> +	return fd;
> +}
> +
> +void test_flow_dissector_reattach(void)
> +{
> +	int prog_fd[2] = { -1, -1 };
> +	int err;
> +
> +	if (is_attached())
> +		return;
Should we call test__skip() here to indicate that the test has been
skipped?
Also, do we need to run this test against non-root namespace as well?

> +	prog_fd[0] = load_prog();
> +	if (prog_fd[0] < 0)
> +		return;
> +
> +	prog_fd[1] = load_prog();
> +	if (prog_fd[1] < 0)
> +		goto out_close;
> +
> +	err = bpf_prog_attach(prog_fd[0], 0, BPF_FLOW_DISSECTOR, 0);
> +	if (CHECK(err, "bpf_prog_attach-0", "ret %d errno %d\n", err, errno))
> +		goto out_close;
> +
> +	/* Expect success when attaching a different program */
> +	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
> +	if (CHECK(err, "bpf_prog_attach-1", "ret %d errno %d\n", err, errno))
> +		goto out_detach;
> +
> +	/* Expect failure when attaching the same program twice */
> +	err = bpf_prog_attach(prog_fd[1], 0, BPF_FLOW_DISSECTOR, 0);
> +	CHECK(!err || errno != EINVAL, "bpf_prog_attach-2",
> +	      "ret %d errno %d\n", err, errno);
> +
> +out_detach:
> +	err = bpf_prog_detach(0, BPF_FLOW_DISSECTOR);
> +	CHECK(err, "bpf_prog_detach", "ret %d errno %d\n", err, errno);
> +
> +out_close:
> +	close(prog_fd[1]);
> +	close(prog_fd[0]);
> +}
> -- 
> 2.20.1
> 
