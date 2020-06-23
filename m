Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B289E205A51
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbgFWSLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728916AbgFWSLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:11:02 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C175EC061573;
        Tue, 23 Jun 2020 11:11:02 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id m9so3655207qvx.5;
        Tue, 23 Jun 2020 11:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O2wmligUR27w8LA2Qy6DCUHjNf5DcVfeHO3NE5QalRg=;
        b=q2DgWoiwA41+vZSqa9q4lYg5lefCQ5pBj1OKVRc3QFMO/VEwf0CSp6LChqXn9vhcK5
         5knsHVqhxmw14JrJ4L6DNgnbkMaUakObvz1c5gsBy+hm/C28HegM26QkN+CVtFiaaCdO
         WfV+smqfxYAR3RSpVd5Bw1d14VP1EIWlTE4+ETE7iYgBGafhD8q1hjC0TdfsXVcd2o0o
         VY/nwipQdYLD5xwOxVIz2D8kXL3tg7zjXqqyrBKKRCIH03XX9pxLdUc5dlAgaLIbjYvx
         UlKYZYCVu/hrVKydNCR8h221s7Ufo5J1sWUVpszrxR9wRk7Mte8ctiBZk52SHV/0ErFc
         GNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O2wmligUR27w8LA2Qy6DCUHjNf5DcVfeHO3NE5QalRg=;
        b=c6PNB9LU6pV6FWoH8uBB6t064y+BMYjIO7Q58IKxKMtv0UyFie6d6xBRPcJqQ8D0e2
         s6orS1UBArEkBfJ/WQFhA36jz7dp8tC2fnYEjx2h/Dj5HLwLZ26pN/b7eTh4ry55xiC6
         vi+YGtTTtAW03ZgTYcpRWDp2EsqMITOpZUc6Pbhc3SCpG3KUnddbLo5Xqxzq3lxBy/DY
         e14CeHLJ2Lfob4sAWY7Zv63eX3xM6DuNVcQuBhA2q8SWst6WbTm5K2za5zZzkJq3dB9i
         /ej07xhbSw+V/nTNhcm5pQ0unc/g4i3YJHSyziDHgiRBtxHuB/46+MqIu5+GFvhEHW3s
         Mcuw==
X-Gm-Message-State: AOAM530gsVMb+/pf713MY9D0gINN8lqNO+dynTjVJpUY4Lpg9UZI7Ypo
        ZaRQw7l4ohon7rLF8yS1J71YCkbz47IMohVL9I0=
X-Google-Smtp-Source: ABdhPJynTBryGmWIyZKFCAIgnndqiVQ1+rbKyR4fBn2vqHUS+frkjBcCW/jfBu9w4E5HddgMdZxD3PjfbLgNdF91Euk=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr15019911qvb.228.1592935861871;
 Tue, 23 Jun 2020 11:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200623124726.5039-1-cneirabustos@gmail.com>
In-Reply-To: <20200623124726.5039-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:10:51 -0700
Message-ID: <CAEf4BzYSKXE2aYkbE2XKa9z1Wc8Zv9-bkTmh=8unOM+Za-6uMw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] fold test_current_pid_tgid_new_ns into into test_progs
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 5:48 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> folds tests from test_current_pid_tgid_new_ns into test_progs.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 112 +++++++++++-
>  .../bpf/test_current_pid_tgid_new_ns.c        | 159 ------------------
>  3 files changed, 112 insertions(+), 162 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 22aaec74ea0a..7b2ea7adccb0 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -36,8 +36,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>         test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
>         test_cgroup_storage \
>         test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
> -       test_progs-no_alu32 \
> -       test_current_pid_tgid_new_ns
> +       test_progs-no_alu32

Please update .gitignore as well.

>
>  # Also test bpf-gcc, if present
>  ifneq ($(BPF_GCC),)

[...]

> +
> +       snprintf(nspath, sizeof(nspath) - 1, "/proc/%d/ns/pid", ppid);
> +       pidns_fd = open(nspath, O_RDONLY);
> +
> +       if (CHECK(unshare(CLONE_NEWPID),
> +               "unshare CLONE_NEWPID",
> +               "error: %s\n", strerror(errno)))
> +               return;
> +
> +       pid = vfork();

is vfork necessary()? Maybe just stick to fork(), as in original implementation?

> +       if (CHECK(pid < 0, "ns_current_pid_tgid_new_ns", "vfork error: %s\n",
> +           strerror(errno))) {
> +               return;
> +       }
> +       if (pid > 0) {
> +       printf("waiting pid is %u\n", pid);

indentation off?

> +               usleep(5);
> +               wait(NULL);

waitpid() for specific child would be more reliable, no?

> +               return;
> +       } else {

what if fork failed?

> +               const char *probe_name = "raw_tracepoint/sys_enter";
> +               const char *file = "test_ns_current_pid_tgid.o";
> +               int err, key = 0, duration = 0;
> +               struct bpf_link *link = NULL;
> +               struct bpf_program *prog;
> +               struct bpf_map *bss_map;
> +               struct bpf_object *obj;
> +               struct bss bss;
> +               struct stat st;
> +               __u64 id;
> +

[...]

> +               err = bpf_map_lookup_elem(bpf_map__fd(bss_map), &key, &bss);
> +               if (CHECK(err, "set_bss", "failed to get bss : %d\n", err))
> +                       goto cleanup;
> +
> +               if (CHECK(id != bss.pid_tgid, "Compare user pid/tgid vs bpf pid/tgid",
> +                       "User pid/tgid %llu BPF pid/tgid %llu\n", id, bss.pid_tgid))
> +                       goto cleanup;


Good half of all this code could be removed if you used BPF skeleton,
see other tests utilizing *.skel.h for inspiration.

> +cleanup:
> +               setns(pidns_fd, CLONE_NEWPID);
> +               bpf_link__destroy(link);
> +               bpf_object__close(obj);
> +       }
> +}
> +
> +void test_ns_current_pid_tgid(void)
> +{
> +       if (test__start_subtest("ns_current_pid_tgid_global_ns"))
> +               test_ns_current_pid_tgid_global_ns();
> +       if (test__start_subtest("ns_current_pid_tgid_new_ns"))
> +               test_ns_current_pid_tgid_new_ns();
> +}

[...]
