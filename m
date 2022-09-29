Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC075EEB3A
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234756AbiI2Bts (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 21:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiI2BtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 21:49:17 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C42A12164B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:49:03 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id v130so199829oie.2
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 18:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Bxq9cI+zlUWQx7u5d55Qg0rIB29NoUYaY5T41Jjr2u8=;
        b=pyrYL+eZLGZx7Cf75R0xer0qJxhN+LkZ71/lEkrKDOs+2Mg43odAQI12yuoZra9YOd
         YVUihaTTjZQo2YhOrHJWVh7QQEomGavV3ki97VsBwBLSPP+v793eVgXsRVTHdGnQ9nhz
         KMzBtIUyl/VwQsqPt6/ItmVZby642x1iGCe413+ibI8HLnNnDjzEgrwRhWwOkUb5r4VC
         nEbKroQ40otp/RWRMV5zdxqjARJ0A+dm3Mse+b4JUgcz3PGd22VqfLKJzPW4Xg7qsNha
         P7n2DpAHA3RAyjWTDXFvJq3xPDSu2+Nr533mkq15xonIWAzPsUsaTn1UQ/MExU4EP6Gk
         rNiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Bxq9cI+zlUWQx7u5d55Qg0rIB29NoUYaY5T41Jjr2u8=;
        b=kYJIgVSomBn2Mdav4Iai5A2D9nnwlU7x/P71iOr3hbVVGh70Ru779K+w78OTzAkjDb
         7RxruB7zIqXyFeMHj1E7b/XJERxbBMY3hG0e4o+oHFTdezdbzhM4sO/YmLJBeXLRfAdv
         JxUbIv45YgAmZQIf/Ao8VDSW1AZqmUhkgD4GX4ZobeJkKPvsYAd74YgGQatlmSdYExDz
         /xFzWqQr1DL5SPR4xixWSzb/d3Aqu/mhGY6tMmfgOQKzoIejrqe0GeYfmR4bCKLcWASd
         vZ+K44IrVWNFmr69mJYA/hhRGBR6DBkkfwfQzHPkE/JzHYKp7KZv+QeY69f4biTo9GZw
         LSXQ==
X-Gm-Message-State: ACrzQf3q7AzWFfWnpwwaELuTIaGbszOv3l3/RgCkIZ9yWwh7dHQXWGv5
        +qPQKMPIfMkDHn4RIhHN2BrkF50pIiAbhKwZpW/EXA==
X-Google-Smtp-Source: AMsMyM5kTZMRktCsNgBsfGAKOZD78DkMvRn0A+9Q8vOTxaJDnkuvtHTFrLhN82b5/2Ze7dXj2kW73rqS8MRg1c11a8o=
X-Received: by 2002:a05:6808:1a8d:b0:34f:dbe0:5bf5 with SMTP id
 bm13-20020a0568081a8d00b0034fdbe05bf5mr5758029oib.147.1664416142950; Wed, 28
 Sep 2022 18:49:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220928083733.252290-1-shaozhengchao@huawei.com>
In-Reply-To: <20220928083733.252290-1-shaozhengchao@huawei.com>
From:   Victor Nogueira <victor@mojatatu.com>
Date:   Wed, 28 Sep 2022 22:48:52 -0300
Message-ID: <CA+NMeC81H2wOfbi32SB0VVs1Lw10a4YWb57Sk-M_nUaJKfttbg@mail.gmail.com>
Subject: Re: [PATCH net-next] selftests/tc-testing: update qdisc/cls/action
 features in config
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        shuah@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 5:29 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> Since three patchsets "add tc-testing test cases", "refactor duplicate
> codes in the tc cls walk function", and "refactor duplicate codes in the
> qdisc class walk function" are merged to net-next tree, the list of
> supported features needs to be updated in config file.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  tools/testing/selftests/tc-testing/config | 25 ++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
> index 2b2c2a835757..5ec7418a3c29 100644
> --- a/tools/testing/selftests/tc-testing/config
> +++ b/tools/testing/selftests/tc-testing/config
> @@ -13,15 +13,28 @@ CONFIG_NET_SCHED=y
>  # Queueing/Scheduling
>  #
>  CONFIG_NET_SCH_ATM=m
> +CONFIG_NET_SCH_CAKE=m
> +CONFIG_NET_SCH_CBQ=m
> +CONFIG_NET_SCH_CBS=m
>  CONFIG_NET_SCH_CHOKE=m
>  CONFIG_NET_SCH_CODEL=m
> +CONFIG_NET_SCH_DRR=m
> +CONFIG_NET_SCH_DSMARK=m
>  CONFIG_NET_SCH_ETF=m
>  CONFIG_NET_SCH_FQ=m
> +CONFIG_NET_SCH_FQ_CODEL=m
>  CONFIG_NET_SCH_GRED=m
> +CONFIG_NET_SCH_HFSC=m
>  CONFIG_NET_SCH_HHF=m
> +CONFIG_NET_SCH_HTB=m
> +CONFIG_NET_SCH_INGRESS=m
> +CONFIG_NET_SCH_MQPRIO=m
> +CONFIG_NET_SCH_MULTIQ=m
> +CONFIG_NET_NET_SCH_NETEM=m

I think it should be CONFIG_NET_SCH_NETEM.

> +CONFIG_NET_SCH_PIE=m
>  CONFIG_NET_SCH_PLUG=m
>  CONFIG_NET_SCH_PRIO=m
> -CONFIG_NET_SCH_INGRESS=m
> +CONFIG_NET_SCH_QFQ=m
>  CONFIG_NET_SCH_SFB=m
>  CONFIG_NET_SCH_SFQ=m
>  CONFIG_NET_SCH_SKBPRIO=m
> @@ -37,6 +50,15 @@ CONFIG_NET_CLS_FW=m
>  CONFIG_NET_CLS_U32=m
>  CONFIG_CLS_U32_PERF=y
>  CONFIG_CLS_U32_MARK=y
> +CONFIG_NET_CLS_BASIC=m
> +CONFIG_NET_CLS_BPF=m
> +CONFIG_NET_CLS_CGROUP=m
> +CONFIG_NET_CLS_FLOW=m
> +CONFIG_NET_CLS_FLOWER=m
> +CONFIG_NET_CLS_MATCHALL=m
> +CONFIG_NET_CLS_ROUTE4=m
> +CONFIG_NET_CLS_RSVP=m
> +CONFGI_NET_CLS_TCINDEX=m

I think there's a typo here.
Should be CONFIG_NET_CLS_TCINDEX.

>  CONFIG_NET_EMATCH=y
>  CONFIG_NET_EMATCH_STACK=32
>  CONFIG_NET_EMATCH_CMP=m
> @@ -68,6 +90,7 @@ CONFIG_NET_ACT_IFE=m
>  CONFIG_NET_ACT_TUNNEL_KEY=m
>  CONFIG_NET_ACT_CT=m
>  CONFIG_NET_ACT_MPLS=m
> +CONFIG_NET_ACT_GATE=m
>  CONFIG_NET_IFE_SKBMARK=m
>  CONFIG_NET_IFE_SKBPRIO=m
>  CONFIG_NET_IFE_SKBTCINDEX=m
> --
> 2.17.1
>
