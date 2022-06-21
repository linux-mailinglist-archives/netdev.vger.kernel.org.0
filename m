Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED345532D2
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345250AbiFUNCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 09:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiFUNCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 09:02:43 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E13CC4
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:02:42 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id e4so11682182ybq.7
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 06:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSRRGgJaWx5LrJiPUsRPKv/ynG0xwMU7DZej5R/GU6w=;
        b=s2JOkh7BOT1AsKOuTArumE1N4uk1/GW8uoUF9YA5WKbv5cHZQNr3T2ssLPgOEqORfI
         9Pp2hSCMc2cnosKFk/bO74CaPTXDdRyVqKfN5om3WyMYwetoRexu9DhBoiOwbJdZf/8V
         /kruX+QH3rDqNaxPy/VW3Lvo/qCa92i8MKES+JZYEuqEG3opuHyhErSzURh5u5N34t6X
         1xIGuw1u/xKPJpGFkNGzzuQYxQ1w66+Cz6uwLhM+gBOrdGM3EiwMC9Wol9hm8zziPEpe
         rwo7m56NNfS3ifdU6eKd1i19lBrEKGRXS4CFyjRN9ddYu71Uz1eJKq4x3fOj1g1tmFXb
         MRvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSRRGgJaWx5LrJiPUsRPKv/ynG0xwMU7DZej5R/GU6w=;
        b=Id3LR8s/UMb7WiB7uqygjaLVslyHgqnmlAfbUdSiZpm2o/owRqL/ysXo10UPhUeAIl
         EtfJv2OPwYfuiDnq4y+gNwjGFLeZH5+XeQoVnZtQyduWJ0XcAk0se+TtAGhMSPLLYUms
         TYx2hgaWAxSBq4c6/bkRGayu4F6X8SBG4S+NaqRzARwGqmExogBa5xCuR0zSjiXHwB0S
         ukIgVWdEscMR+LJqP7fovTj+0x/DIzdlXBuRXAU0wzcXNSpoVIywUYDOVISq1UoT+69i
         SuRdsH4EFwJIv1GoZfZQNFHKWK26d+uVG5I6ztvUG9bQyZsVce6IZbvK3xoubqCVfshz
         +sjg==
X-Gm-Message-State: AJIora/rBbf1sTKhz9V4dx/NmdhyjBj0CJbWUoj/q7DV1Y/TiJkBouYF
        ilLkbGWgkjU0K1wEhF5HKXU/oZzGqya85AsWCrdElKwBVHafrw==
X-Google-Smtp-Source: AGRyM1uroVI9iTR2yiASeo3PCrpupnOvCkjxqjQzpyMhFPsIwEssjy4vMK7L2NSJUN34MwRMQSFQBso07Bw5Xmx01ek=
X-Received: by 2002:a25:8181:0:b0:668:c835:eb7c with SMTP id
 p1-20020a258181000000b00668c835eb7cmr22430340ybk.598.1655816561029; Tue, 21
 Jun 2022 06:02:41 -0700 (PDT)
MIME-Version: 1.0
References: <202206212033.3lgl72Fw-lkp@intel.com>
In-Reply-To: <202206212033.3lgl72Fw-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Jun 2022 15:02:29 +0200
Message-ID: <CANn89i+-T0iPKASSrHZvn4Cj4+UMYCpQWq5mg+Mc1hXsv_9BcQ@mail.gmail.com>
Subject: Re: [linux-next:master 3790/4834] net/ipv6/raw.c:338:33: warning:
 variable 'daddr' set but not used
To:     kernel test robot <lkp@intel.com>
Cc:     netdev <netdev@vger.kernel.org>
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

On Tue, Jun 21, 2022 at 2:42 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   34d1d36073ea4d4c532e8c8345627a9702be799e
> commit: ba44f8182ec299c5d1c8a72fc0fde4ec127b5a6d [3790/4834] raw: use more conventional iterators
> config: i386-randconfig-a012-20220620 (https://download.01.org/0day-ci/archive/20220621/202206212033.3lgl72Fw-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project af6d2a0b6825e71965f3e2701a63c239fa0ad70f)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=ba44f8182ec299c5d1c8a72fc0fde4ec127b5a6d
>         git remote add linux-next https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>         git fetch --no-tags linux-next master
>         git checkout ba44f8182ec299c5d1c8a72fc0fde4ec127b5a6d
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash net/ipv6/
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> net/ipv6/raw.c:338:33: warning: variable 'daddr' set but not used [-Wunused-but-set-variable]
>            const struct in6_addr *saddr, *daddr;
>                                           ^
> >> net/ipv6/raw.c:338:25: warning: variable 'saddr' set but not used [-Wunused-but-set-variable]
>            const struct in6_addr *saddr, *daddr;
>                                   ^
>    2 warnings generated.
>

Yep, a cleanup is possible.

I will submit this when my workstation is up again.

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 46b560aacc11352ee9f2043c277709c28f85e610..722de9dd0ff78fbb2535165935c92fe7d7e6a8c2
100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -332,7 +332,6 @@ static void rawv6_err(struct sock *sk, struct sk_buff *skb,
 void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
                u8 type, u8 code, int inner_offset, __be32 info)
 {
-       const struct in6_addr *saddr, *daddr;
        struct net *net = dev_net(skb->dev);
        struct hlist_nulls_head *hlist;
        struct hlist_nulls_node *hnode;
@@ -345,8 +344,6 @@ void raw6_icmp_error(struct sk_buff *skb, int nexthdr,
        sk_nulls_for_each(sk, hnode, hlist) {
                /* Note: ipv6_hdr(skb) != skb->data */
                const struct ipv6hdr *ip6h = (const struct ipv6hdr *)skb->data;
-               saddr = &ip6h->saddr;
-               daddr = &ip6h->daddr;

                if (!raw_v6_match(net, sk, nexthdr, &ip6h->saddr, &ip6h->daddr,
                                  inet6_iif(skb), inet6_iif(skb)))
