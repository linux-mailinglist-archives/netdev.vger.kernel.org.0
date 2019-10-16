Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 473AAD8844
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 07:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387897AbfJPFxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 01:53:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44491 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387661AbfJPFxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 01:53:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id u40so34335075qth.11;
        Tue, 15 Oct 2019 22:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RiGbgLQGOqRcMfw6Pw7ihRQxY8j/bmQuL3YdxeJeF00=;
        b=uoHrhHfekvYzxiFAAObCWtc6t6KNacE5Fh8CZ57faP9TfQ3qt/Q52ZvQvaDxrwlF0k
         U2yKTkHzldve567/j7Gb036Sz64XAMRLjawWteWaq5WvW7lDY8DIyc2mz0I+0ww0/0m0
         ZISjOhGwVvUAOpRRFs9zzwwUd+7nQ6ttufLfg+6wAsHKnleuvPQoX+jDXpVsb9mj1ldz
         WZ39VTkyfYhxfRJ2XusqKTiu07Wq0LeOC3CpA6viRvvCgzJZgua0XzkfN6fVOP/3ZB0a
         4WpYrkKeHzll64Kj22rjtwG7gUvkC91UkFlEuHgCZuYFqOjEI6m+R9j4TgZN7ICroKZI
         ksJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RiGbgLQGOqRcMfw6Pw7ihRQxY8j/bmQuL3YdxeJeF00=;
        b=PTof0G682I3wo0SevXzP+TnAOMZyEbh8FE50PdsrhIxmR4Q884M23cFvF+Xu2FE5QX
         L5bX9npcMh3FZPlFW1Gh9KJ8MIvRgbq1wbnidAsIFtS937Bts2lui+Fj/JVhm0zaI5cg
         d3wx6wXHCYLm2tlMEpm0jHRMHoRMmsgxVPG1VcQoedR9pbn/uKaMljMcmYeehu2ZtXVX
         8s/8+11epAJZwbdcYU9RVJReBPlW5khQr0zzcQsE0+4UiFYKLvhex/i5FI98OFzHXNcM
         xkmHLRRa7fygaTT+O721uY3TWtIOLWGvWBAzcd5fi1iYsdImlmODpywooIkQGwBg7GPn
         951g==
X-Gm-Message-State: APjAAAVHp2XYxYB7DlldFxTWFmqFgA2mTxWyH2LqWHF1SACR8lRAoDsH
        VYpK3fvvRB6hv7yBD1HjC54E5iIXPZcF+82qysg=
X-Google-Smtp-Source: APXvYqzpCRTJaR4sO8LDxV15wVTRL8gs4/GnUZ23hC586TTY2ZAaHkwS6XlQdjAtUpzHYmo0Rg74gzztf3GxoKxBMXU=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr8582962qtn.117.1571205193798;
 Tue, 15 Oct 2019 22:53:13 -0700 (PDT)
MIME-Version: 1.0
References: <20191016054945.1988387-1-andriin@fb.com> <20191016054945.1988387-8-andriin@fb.com>
In-Reply-To: <20191016054945.1988387-8-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Oct 2019 22:53:02 -0700
Message-ID: <CAEf4BzZDm5ZWhrtp0R78rEhaNYHjBCKgXdK3QXFzKrEqHMxx8Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 7/7] selftest/bpf: remove test_libbpf.sh and test_libbpf_open
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 10:50 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> test_progs is much more sophisticated superset of tests compared to
> test_libbpf.sh and test_libbpf_open. Remove test_libbpf.sh and
> test_libbpf_open.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/.gitignore       |   2 -
>  tools/testing/selftests/bpf/Makefile         |   3 +-
>  tools/testing/selftests/bpf/test_libbpf      | Bin 0 -> 384568 bytes
>  tools/testing/selftests/bpf/test_libbpf.sh   |  43 -------------------
>  tools/testing/selftests/bpf/test_libbpf_open | Bin 0 -> 396096 bytes

well this was certainly not intended, sorry about that

>  5 files changed, 1 insertion(+), 47 deletions(-)
>  create mode 100755 tools/testing/selftests/bpf/test_libbpf
>  delete mode 100755 tools/testing/selftests/bpf/test_libbpf.sh
>  create mode 100755 tools/testing/selftests/bpf/test_libbpf_open
>
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index c51f356f84b5..55d2adf64832 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -11,7 +11,6 @@ test_dev_cgroup
>  test_tcpbpf_user
>  test_verifier_log
>  feature
> -test_libbpf_open
>  test_sock
>  test_sock_addr
>  test_sock_fields
> @@ -30,7 +29,6 @@ flow_dissector_load
>  test_netcnt
>  test_section_names
>  test_tcpnotify_user
> -test_libbpf
>  test_tcp_check_syncookie_user
>  test_sysctl
>  libbpf.pc
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index db8c842ade73..9d7422a514c5 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -52,7 +52,6 @@ TEST_FILES =
>
>  # Order correspond to 'make run_tests' order
>  TEST_PROGS := test_kmod.sh \
> -       test_libbpf.sh \
>         test_xdp_redirect.sh \
>         test_xdp_meta.sh \
>         test_xdp_veth.sh \
> @@ -79,7 +78,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
>         test_xdp_vlan.sh
>
>  # Compile but not part of 'make run_tests'
> -TEST_GEN_PROGS_EXTENDED = test_libbpf_open test_sock_addr test_skb_cgroup_id_user \
> +TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
>         flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
>         test_lirc_mode2_user
>
> diff --git a/tools/testing/selftests/bpf/test_libbpf b/tools/testing/selftests/bpf/test_libbpf
> new file mode 100755
> index 0000000000000000000000000000000000000000..af5e18b8353486db7156dc81ac25b9eab3720370
> GIT binary patch
> literal 384568
> zcmd44e|%KM)jz%gB0<rOiW*z35w(I<8h>CxQ5R)(LDBdlidH3nASgd#ND!>iU`U(m

oops
