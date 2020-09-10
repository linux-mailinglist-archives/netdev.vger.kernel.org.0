Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F92E265014
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgIJUA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgIJT7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:59:45 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD188C061573;
        Thu, 10 Sep 2020 12:59:44 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id p81so4844191ybc.12;
        Thu, 10 Sep 2020 12:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qur037Vz5TUenI6MKDgB4CXpzIqZKAUcS+9tJsqYAhw=;
        b=kMRzS7tpya7b/IJGsiYT2EaZYCHRMa9yJfwNIqq7ybD6rswZVHoORlIYPi2XzypqLW
         V/uuvGLA0liy5j7FgQ9oa6cIpCkkVSeAwDsygm7osDrdnxwD5I+OpSTcLAMWT35STbx7
         eBTZykafsPw305a2X7anFwfy/gUvwLtdq1kvEqz3FHoh2Ra8287GO7y7P7PNgFrjXAZT
         sTNuhlfEMoMXbkBlU8p4OAHTXIQ5y1gXI+f813kqUAtpyhgWHGe7l7inPqoLWXR5TlHH
         wsfYnyG44TJv8ldkKT43iVNyMt8xRx+XASZ4RHGzFeZ/2wCKyLoI5EKYFjmOAyZtqkTJ
         7X5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qur037Vz5TUenI6MKDgB4CXpzIqZKAUcS+9tJsqYAhw=;
        b=KoufzFiJeG8DfbnVNgdvYtCuzs7UlTq3RQnHHOh9jzh1sobVWQWyDim5K4jnHZJcWN
         siHQv1l8HZ2jjF1P3yDMpYOSB0QVPwPPeFGVjFsqLJ98wys5fx2G2JuI5RDKDdTAnjZ1
         EepHRl5SVt5+coAC6hAMBj5Mdd6B6DA7wV45/qMam0UYUbALkUN3mnoYyUnCLcj4zdHP
         iGfg3tU9czy9ZVHuOfoNHIjk4j0A+0jNVNeraTchdcr75XJjO8s7ZlpgpsIinSiALgN3
         4yui7P2qxmFQt13NVMNJusRBiKIfJ0qdSjGNOkWSXvzwl3wWbLzFISBMYYuJ8jSJSNvj
         JjGA==
X-Gm-Message-State: AOAM531a5UbXWyeWFCQaBMlnhTY5HW8wgA+dyIt5+5C7GV480hUO69CZ
        ytqlG4c67a5GRbe9bnveoSHerEH5xOLzg7eZ5Go=
X-Google-Smtp-Source: ABdhPJxaA9eECzBChjcI4rsjt4VT1ovgRLPJ7D9npVWq+HdoNGGi0oxGl8dpqfYO9qDcqxebbr10sFgCvjCM8xMS2Bw=
X-Received: by 2002:a25:c049:: with SMTP id c70mr15386024ybf.403.1599767983798;
 Thu, 10 Sep 2020 12:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200909182406.3147878-1-sdf@google.com> <20200909182406.3147878-6-sdf@google.com>
In-Reply-To: <20200909182406.3147878-6-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 10 Sep 2020 12:59:33 -0700
Message-ID: <CAEf4BzY7Ca9ZpL3x_EkjxM4tZXtNJV5kV=MPGTbibkv_bSFB9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 5/5] selftests/bpf: Test load and dump
 metadata with btftool and skel
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 11:25 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> This is a simple test to check that loading and dumping metadata
> in btftool works, whether or not metadata contents are used by the
> program.
>
> A C test is also added to make sure the skeleton code can read the
> metadata values.
>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

It would be good to test that libbpf does bind .rodata even if BPF
program doesn't use it. So for metadata_unused you can get
bpf_prog_info and check that it does contain the id of .rodata?

>  tools/testing/selftests/bpf/Makefile          |  3 +-
>  .../selftests/bpf/prog_tests/metadata.c       | 81 ++++++++++++++++++
>  .../selftests/bpf/progs/metadata_unused.c     | 15 ++++
>  .../selftests/bpf/progs/metadata_used.c       | 15 ++++
>  .../selftests/bpf/test_bpftool_metadata.sh    | 82 +++++++++++++++++++
>  5 files changed, 195 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
>  create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
>  create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 65d3d9aaeb31..3c92db8a189a 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -68,7 +68,8 @@ TEST_PROGS := test_kmod.sh \
>         test_tc_edt.sh \
>         test_xdping.sh \
>         test_bpftool_build.sh \
> -       test_bpftool.sh
> +       test_bpftool.sh \
> +       test_bpftool_metadata.sh \
>
>  TEST_PROGS_EXTENDED := with_addr.sh \
>         with_tunnels.sh \
> diff --git a/tools/testing/selftests/bpf/prog_tests/metadata.c b/tools/testing/selftests/bpf/prog_tests/metadata.c
> new file mode 100644
> index 000000000000..dea8fa86b5fb
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/metadata.c
> @@ -0,0 +1,81 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +/*
> + * Copyright 2020 Google LLC.
> + */
> +
> +#include <test_progs.h>
> +#include <cgroup_helpers.h>
> +#include <network_helpers.h>
> +
> +#include "metadata_unused.skel.h"
> +#include "metadata_used.skel.h"
> +
> +static int duration;
> +
> +static void test_metadata_unused(void)
> +{
> +       struct metadata_unused *obj;
> +       int err;
> +
> +       obj = metadata_unused__open_and_load();
> +       if (CHECK(!obj, "skel-load", "errno %d", errno))
> +               return;
> +
> +       /* Assert that we can access the metadata in skel and the values are
> +        * what we expect.
> +        */
> +       if (CHECK(strncmp(obj->rodata->bpf_metadata_a, "foo",
> +                         sizeof(obj->rodata->bpf_metadata_a)),
> +                 "bpf_metadata_a", "expected \"foo\", value differ"))
> +               goto close_bpf_object;
> +       if (CHECK(obj->rodata->bpf_metadata_b != 1, "bpf_metadata_b",
> +                 "expected 1, got %d", obj->rodata->bpf_metadata_b))
> +               goto close_bpf_object;
> +
> +       /* Assert that binding metadata map to prog again succeeds. */
> +       err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
> +                               bpf_map__fd(obj->maps.rodata), NULL);
> +       CHECK(err, "rebind_map", "errno %d, expected 0", errno);
> +
> +close_bpf_object:
> +       metadata_unused__destroy(obj);
> +}
> +
> +static void test_metadata_used(void)
> +{
> +       struct metadata_used *obj;
> +       int err;
> +
> +       obj = metadata_used__open_and_load();
> +       if (CHECK(!obj, "skel-load", "errno %d", errno))
> +               return;
> +
> +       /* Assert that we can access the metadata in skel and the values are
> +        * what we expect.
> +        */
> +       if (CHECK(strncmp(obj->rodata->bpf_metadata_a, "bar",
> +                         sizeof(obj->rodata->bpf_metadata_a)),
> +                 "metadata_a", "expected \"bar\", value differ"))
> +               goto close_bpf_object;
> +       if (CHECK(obj->rodata->bpf_metadata_b != 2, "metadata_b",
> +                 "expected 2, got %d", obj->rodata->bpf_metadata_b))
> +               goto close_bpf_object;
> +
> +       /* Assert that binding metadata map to prog again succeeds. */
> +       err = bpf_prog_bind_map(bpf_program__fd(obj->progs.prog),
> +                               bpf_map__fd(obj->maps.rodata), NULL);
> +       CHECK(err, "rebind_map", "errno %d, expected 0", errno);
> +
> +close_bpf_object:
> +       metadata_used__destroy(obj);
> +}
> +
> +void test_metadata(void)
> +{
> +       if (test__start_subtest("unused"))
> +               test_metadata_unused();
> +
> +       if (test__start_subtest("used"))
> +               test_metadata_used();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/metadata_unused.c b/tools/testing/selftests/bpf/progs/metadata_unused.c
> new file mode 100644
> index 000000000000..db5b804f6f4c
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/metadata_unused.c
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +const char bpf_metadata_a[] SEC(".rodata") = "foo";
> +const int bpf_metadata_b SEC(".rodata") = 1;

please add volatile to ensure these are not optimized away

> +
> +SEC("cgroup_skb/egress")
> +int prog(struct xdp_md *ctx)
> +{
> +       return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/progs/metadata_used.c b/tools/testing/selftests/bpf/progs/metadata_used.c
> new file mode 100644
> index 000000000000..0dcb1ba2f0ae
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/metadata_used.c
> @@ -0,0 +1,15 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +const char bpf_metadata_a[] SEC(".rodata") = "bar";
> +const int bpf_metadata_b SEC(".rodata") = 2;

same about volatile

> +
> +SEC("cgroup_skb/egress")
> +int prog(struct xdp_md *ctx)
> +{
> +       return bpf_metadata_b ? 1 : 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";

[...]
