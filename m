Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03F985AF76F
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiIFVys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiIFVyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:54:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8ED24BFA;
        Tue,  6 Sep 2022 14:54:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B45BB81A6B;
        Tue,  6 Sep 2022 21:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F168AC43470;
        Tue,  6 Sep 2022 21:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662501279;
        bh=DSyRx2bBkTQsVsQY11wafbdQ9+J76SQa6EueQKCaLVk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NWR02DhEtG5iPhDB9GitNfXINspUdP3p6XlC5hfGIr9Sv7sf6E5gsn0YStYIVBn73
         DNc80x9ErRzOPGOdPsZGqA333iOCjwxsd4UkeY9WesR7m8vny5uFBwUUvr0pEYMAnD
         t8Q1myeHEMKvpxvIyfR/ahxSMmW0Wb3jljGCG185wIqQpm5gHw1BsTlUv5y2cqLO1x
         RXiEL4xxycsmzeMIa51ytBAPlzbLuRhnCGvj/dOnN7N1LJUcUlSaXUPEJRjXyt60X1
         RGsSohmp4HiEpywhI6Zft2D8OJuUEKANU9Oo09Uu4y1ul6PDApnkxwpOj631pp+znw
         16vNUbvS9kyGA==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-127dca21a7dso4271449fac.12;
        Tue, 06 Sep 2022 14:54:38 -0700 (PDT)
X-Gm-Message-State: ACgBeo0UtuVorFaMUaeaoqjoaLgL3f4Gw89tL7cELnC5hJ8iHR0514O3
        J6CXRQsEUhelmTIfaAKHpGAf/F+hjCoaUxMdrZQ=
X-Google-Smtp-Source: AA6agR5Yggwkyp/l6mS2xoV3DRxpkh94agwyPI6rnBh0EOtuGvz7rj4O5+TuiCCsr1rf/Dwb3FX5+SShl6BvHiwg5Gg=
X-Received: by 2002:a05:6870:32d2:b0:127:f0b4:418f with SMTP id
 r18-20020a05687032d200b00127f0b4418fmr219502oac.22.1662501278093; Tue, 06 Sep
 2022 14:54:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <6e77fb26ae5854061b6c2d004d6547bf971f7dcd.1662383493.git.lorenzo@kernel.org>
In-Reply-To: <6e77fb26ae5854061b6c2d004d6547bf971f7dcd.1662383493.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 14:54:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7J6UOihzNsmBm=tOk6QzNjok2YEh5S0yVJLXb__7t5eA@mail.gmail.com>
Message-ID: <CAPhsuW7J6UOihzNsmBm=tOk6QzNjok2YEh5S0yVJLXb__7t5eA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add tests for
 bpf_ct_set_nat_info kfunc
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce self-tests for bpf_ct_set_nat_info kfunc used to set the
> source or destination nat addresses/ports.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/testing/selftests/bpf/config            |  1 +
>  .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 ++
>  .../testing/selftests/bpf/progs/test_bpf_nf.c | 26 ++++++++++++++++++-
>  3 files changed, 28 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 3fc46f9cfb22..8ce48f7213cb 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -57,6 +57,7 @@ CONFIG_NF_CONNTRACK=y
>  CONFIG_NF_CONNTRACK_MARK=y
>  CONFIG_NF_DEFRAG_IPV4=y
>  CONFIG_NF_DEFRAG_IPV6=y
> +CONFIG_NF_NAT=y
>  CONFIG_RC_CORE=y
>  CONFIG_SECURITY=y
>  CONFIG_SECURITYFS=y
> diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> index 544bf90ac2a7..f16913f8fca2 100644
> --- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
> @@ -115,6 +115,8 @@ static void test_bpf_nf_ct(int mode)
>         ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
>         ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
>         ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
> +       ASSERT_EQ(skel->data->test_snat_addr, 0, "Test for source natting");
> +       ASSERT_EQ(skel->data->test_dnat_addr, 0, "Test for destination natting");
>  end:
>         if (srv_client_fd != -1)
>                 close(srv_client_fd);
> diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> index 2722441850cc..3f441595098b 100644
> --- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> +++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
> @@ -23,6 +23,8 @@ int test_insert_entry = -EAFNOSUPPORT;
>  int test_succ_lookup = -ENOENT;
>  u32 test_delta_timeout = 0;
>  u32 test_status = 0;
> +int test_snat_addr = -EINVAL;
> +int test_dnat_addr = -EINVAL;
>  __be32 saddr = 0;
>  __be16 sport = 0;
>  __be32 daddr = 0;
> @@ -53,6 +55,8 @@ void bpf_ct_set_timeout(struct nf_conn *, u32) __ksym;
>  int bpf_ct_change_timeout(struct nf_conn *, u32) __ksym;
>  int bpf_ct_set_status(struct nf_conn *, u32) __ksym;
>  int bpf_ct_change_status(struct nf_conn *, u32) __ksym;
> +int bpf_ct_set_nat_info(struct nf_conn *, union nf_inet_addr *,
> +                       __be16 *port, enum nf_nat_manip_type) __ksym;
>
>  static __always_inline void
>  nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
> @@ -140,10 +144,19 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
>         ct = alloc_fn(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def,
>                       sizeof(opts_def));
>         if (ct) {
> +               __be16 sport = bpf_get_prandom_u32();
> +               __be16 dport = bpf_get_prandom_u32();
> +               union nf_inet_addr saddr = {};
> +               union nf_inet_addr daddr = {};
>                 struct nf_conn *ct_ins;
>
>                 bpf_ct_set_timeout(ct, 10000);
> -               bpf_ct_set_status(ct, IPS_CONFIRMED);

So this is paired with the IPS_CONFIRMED change in 3/4?

Thanks,
Song
