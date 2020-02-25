Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17216B981
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgBYGNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 01:13:25 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:42292 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgBYGNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:13:24 -0500
Received: by mail-qt1-f193.google.com with SMTP id r5so8325677qtt.9;
        Mon, 24 Feb 2020 22:13:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QPZ+m0jzaK3AguuQi17fySfR6a3rbVUsVNxqEHcKXuI=;
        b=opu4TTmDLKoBFWhRpEyqOjZ63yUTRzF3uAEFaa3/pymlIJJTn2VmkupLqS9oPU4mZF
         7tuRqsYcmzen6q/vhfaKFFEqqCJ4udMMblpTTg27T6ZzWK9FFVbHouM0MYAvSMZEXVF2
         ujW/O9grxcuUPC62kxuqpOdjxWs99d4c5YeVsICT26pwjhsDiKqwUK+IwvN3UJoHIh1S
         QhBYEY33U5UoQZLXiyHHOrwBb2InL/0jDNbwZleHriy4AT7IzC0bpTqRX9DL5Q/WEGal
         lO283gOfVcGWkAbyFYrMOQM46QoYlEPO+do0z039vQxijO8ZJDEFdQgIQXlo2ZBlx+V5
         sE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QPZ+m0jzaK3AguuQi17fySfR6a3rbVUsVNxqEHcKXuI=;
        b=AyHcT2/HZqUbHHJL9dhi17TAZdw56NXPOktj8W0zeORSPDLKjcVxqCQV0rYmuk8dwT
         3/Z7E5H8kZvLloyUuajFSb79j3p2MdZLj1jKXEF4kCvuFsEVOERTAeW+oE6M88yF4xJN
         TzEas+UPpnSY5jBzEBpG6MON5yxbj79eHbqkafwm91XkDjYW6fTYHEQPNDWE/cyr8tHk
         JvEb5YwzFYhRpmQM1OuWScIXpNYts4qVTc5xwz42blMCQ93h/e/Thzsm+DvZZVBzUFDw
         zDe+EIh/TGE6Y8F3b2qE+Rq5G6ULQ/c4cVKPk2Qm39JG/5YzW8+1MkjoqUV0C4J0USeu
         0efw==
X-Gm-Message-State: APjAAAXYdfZmOcc/sdEwWT7kZjNraPS/3zEQXhNKe+3ak9248gXgM9ty
        z3BUCOATDnYK6HUjXWqCCoi87SNlEl76cjw+F3M=
X-Google-Smtp-Source: APXvYqywBSqvd+8WDyYB8r5WxceDdPwbbNCsaTbz9t9gLrUOK2AnmzqcdzmxRf8Enz8JxTmZsMx1BI+eazeGa2wCajA=
X-Received: by 2002:ac8:7b29:: with SMTP id l9mr49843180qtu.141.1582611203393;
 Mon, 24 Feb 2020 22:13:23 -0800 (PST)
MIME-Version: 1.0
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com> <20200225044538.61889-4-forrest0579@gmail.com>
In-Reply-To: <20200225044538.61889-4-forrest0579@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 24 Feb 2020 22:13:12 -0800
Message-ID: <CAEf4Bza5k92bxYH=c1DP_rcugF6z3NLos7aPS7DPoi9-3B_JrQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 3/3] selftests/bpf: add selftest for
 get_netns_id helper
To:     Lingpeng Chen <forrest0579@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>, Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 8:47 PM Lingpeng Chen <forrest0579@gmail.com> wrote:
>
> adding selftest for new bpf helper function get_netns_id
>
> Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
> Acked-by: Song Liu <songliubraving@fb.com>
> ---

It would be nice if this selftests becomes part of test_progs. That
way it would be exercised regularly, both by committers, as well as by
automated CI in libbpf's Github repo. Using global variables and BPF
skeleton would also clean up both BPF and user-space code.

It seems like this test runs Python script for server, but doesn't
seem like that server is doing anything complicated, so writing that
in C shouldn't be a problem as well. Thoughts?

>  .../selftests/bpf/progs/test_tcpbpf_kern.c    | 11 +++++
>  .../testing/selftests/bpf/test_tcpbpf_user.c  | 46 ++++++++++++++++++-
>  2 files changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> index 1f1966e86e9f..d7d851ddd2cc 100644
> --- a/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> +++ b/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> @@ -28,6 +28,13 @@ struct {
>         __type(value, int);
>  } sockopt_results SEC(".maps");
>
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, __u32);
> +       __type(value, __u64);
> +} netns_number SEC(".maps");
> +
>  static inline void update_event_map(int event)
>  {
>         __u32 key = 0;
> @@ -61,6 +68,7 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>         int rv = -1;
>         int v = 0;
>         int op;
> +       __u64 netns_id;
>
>         op = (int) skops->op;
>
> @@ -144,6 +152,9 @@ int bpf_testcb(struct bpf_sock_ops *skops)
>                 __u32 key = 0;
>
>                 bpf_map_update_elem(&sockopt_results, &key, &v, BPF_ANY);
> +
> +               netns_id = bpf_get_netns_id(skops);
> +               bpf_map_update_elem(&netns_number, &key, &netns_id, BPF_ANY);
>                 break;
>         default:
>                 rv = -1;
> diff --git a/tools/testing/selftests/bpf/test_tcpbpf_user.c b/tools/testing/selftests/bpf/test_tcpbpf_user.c
> index 3ae127620463..fef2f4d77ecc 100644
> --- a/tools/testing/selftests/bpf/test_tcpbpf_user.c
> +++ b/tools/testing/selftests/bpf/test_tcpbpf_user.c
> @@ -76,6 +76,41 @@ int verify_sockopt_result(int sock_map_fd)
>         return ret;
>  }
>
> +int verify_netns(__u64 netns_id)
> +{
> +       char buf1[40];
> +       char buf2[40];
> +       int ret = 0;
> +       ssize_t len = 0;
> +
> +       len = readlink("/proc/self/ns/net", buf1, 39);
> +       sprintf(buf2, "net:[%llu]", netns_id);
> +
> +       if (len <= 0) {
> +               printf("FAILED: readlink /proc/self/ns/net");
> +               return ret;
> +       }
> +
> +       if (strncmp(buf1, buf2, len)) {
> +               printf("FAILED: netns don't match");
> +               ret = 1;
> +       }
> +       return ret;
> +}
> +
> +int verify_netns_result(int netns_map_fd)
> +{
> +       __u32 key = 0;
> +       __u64 res = 0;
> +       int ret = 0;
> +       int rv;
> +
> +       rv = bpf_map_lookup_elem(netns_map_fd, &key, &res);
> +       EXPECT_EQ(0, rv, "d");
> +
> +       return verify_netns(res);
> +}
> +
>  static int bpf_find_map(const char *test, struct bpf_object *obj,
>                         const char *name)
>  {
> @@ -92,7 +127,7 @@ static int bpf_find_map(const char *test, struct bpf_object *obj,
>  int main(int argc, char **argv)
>  {
>         const char *file = "test_tcpbpf_kern.o";
> -       int prog_fd, map_fd, sock_map_fd;
> +       int prog_fd, map_fd, sock_map_fd, netns_map_fd;
>         struct tcpbpf_globals g = {0};
>         const char *cg_path = "/foo";
>         int error = EXIT_FAILURE;
> @@ -137,6 +172,10 @@ int main(int argc, char **argv)
>         if (sock_map_fd < 0)
>                 goto err;
>
> +       netns_map_fd = bpf_find_map(__func__, obj, "netns_number");
> +       if (netns_map_fd < 0)
> +               goto err;
> +
>  retry_lookup:
>         rv = bpf_map_lookup_elem(map_fd, &key, &g);
>         if (rv != 0) {
> @@ -161,6 +200,11 @@ int main(int argc, char **argv)
>                 goto err;
>         }
>
> +       if (verify_netns_result(netns_map_fd)) {
> +               printf("FAILED: Wrong netns stats\n");
> +               goto err;
> +       }
> +
>         printf("PASSED!\n");
>         error = 0;
>  err:
> --
> 2.20.1
>
