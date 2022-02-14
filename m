Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BA34B5BB5
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiBNU5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:57:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiBNU5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:57:32 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EE2111182
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:56:51 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id l12-20020a0568302b0c00b005a4856ff4ceso12390852otv.13
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:56:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EU+Y9g3fEOTeCxwfSeBDFv5C05e9O8lQDJWe/ZBWNNE=;
        b=lTseh7w20Jnxj+fNFqFAWy9pMiAj72iIQ8VpyKBS0mtvZ9bomPxPQv5xjoveonHNgM
         I/miWjNPgL6IW/V7Az2pPrhQ2I5rtEI7Pb90EZy3ppaCFwY9wc1bzwbrqiZAdjVLI6h5
         3XvzXGAmork7ca9dk/tNm1OHhZFO88aGZ4+oBQNRnN8tIwWSBWKLIbHUWTL7C74HZ3Ff
         Mzj/mStKAwcCodSvUCsZHTCkedRMJAzxpm3RZLof1A2FJ63Cw71IUMD1mG06zQl+J3Ai
         QLLNp4IvLfn/Z31ZbY79cqWYYvWHCeKeQ2UemelQVh+2q+TUETAfmVNbGEiReaphm2BU
         QQ3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EU+Y9g3fEOTeCxwfSeBDFv5C05e9O8lQDJWe/ZBWNNE=;
        b=KS2UGhldIT1dYNS6hDqF/2MIkZOt9SbwwTNe6rFbbSmFy1l2iUdqPl9X79pA/2AeRZ
         I+oXYbDJiAf5dNmnERpFDX0pwbj9s5HeGdZaKg7UOb1U1iDcYjJOPNS8BaxRrCNMQLjx
         MbzJicYlwk0S0tsbN60VGrOh5ePR9AqrF3u1vKhRLfLVzNEpcDlU8bCu5LGoychdWSqs
         jMoZ4tk31xl9YLg5dMAw072/tGr1LGEQqlRFZCdYA2DfYvHIczzDPYZZXKSF003Y/6M7
         UrBHpIEtgNJUnVvG1K6qIE8TYpILcL51v29OjDHRIq8ubIP9h79W0sX1TCDhBeip/XMr
         S3rg==
X-Gm-Message-State: AOAM5316KpLhRK3aotXfIXWHEcSSJP/cpfqJu66hoxc+trPzlTXorkVc
        DpEi28ptv8mGJrDHk9Kmulk4Or4+Jet4vo6EMTHXjvRZadwYYg==
X-Google-Smtp-Source: ABdhPJzf4TDeCRBpfOmKLg2Q4qlhEBwIL9J6HmR4ZqT0xMbBN9sD3QCUHsQIdmqjpdlKpwQVK4fo2Fl+RHRXhLVQ8Fk=
X-Received: by 2002:a81:3986:: with SMTP id g128mr89907ywa.129.1644864962072;
 Mon, 14 Feb 2022 10:56:02 -0800 (PST)
MIME-Version: 1.0
References: <202202120509.FMR7TEL1-lkp@intel.com> <CANn89iLS4N4cpX+Nh9ALjf_APOPQ4-aSPSX1P6iLpda8mJS8UQ@mail.gmail.com>
In-Reply-To: <CANn89iLS4N4cpX+Nh9ALjf_APOPQ4-aSPSX1P6iLpda8mJS8UQ@mail.gmail.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 15 Feb 2022 00:25:51 +0530
Message-ID: <CA+G9fYt07Kd2u88a_vOZ1fjE3QcTizFX3bBMSSDQJTPXMWea3A@mail.gmail.com>
Subject: Re: [net:master 21/30] net/netfilter/xt_socket.c:224:3: error:
 implicit declaration of function 'nf_defrag_ipv6_disable'
To:     Eric Dumazet <edumazet@google.com>
Cc:     kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
        kbuild-all@lists.01.org, netdev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 12 Feb 2022 at 08:14, Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Feb 11, 2022 at 1:55 PM kernel test robot <lkp@intel.com> wrote:
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> > head:   85d24ad38bc4658ce9a16b85b9c8dc0577d66c71
> > commit: 75063c9294fb239bbe64eb72141b6871fe526d29 [21/30] netfilter: xt_socket: fix a typo in socket_mt_destroy()
> > config: hexagon-randconfig-r045-20220211 (https://download.01.org/0day-ci/archive/20220212/202202120509.FMR7TEL1-lkp@intel.com/config)
> > compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project f6685f774697c85d6a352dcea013f46a99f9fe31)
> > reproduce (this is a W=1 build):
> >         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=75063c9294fb239bbe64eb72141b6871fe526d29
> >         git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
> >         git fetch --no-tags net master
> >         git checkout 75063c9294fb239bbe64eb72141b6871fe526d29
> >         # save the config file to linux build tree
> >         mkdir build_dir
> >         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/netfilter/
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All errors (new ones prefixed by >>):
> >
> > >> net/netfilter/xt_socket.c:224:3: error: implicit declaration of function 'nf_defrag_ipv6_disable' [-Werror,-Wimplicit-function-declaration]
> >                    nf_defrag_ipv6_disable(par->net);
> >                    ^
> >    net/netfilter/xt_socket.c:224:3: note: did you mean 'nf_defrag_ipv4_disable'?
> >    include/net/netfilter/ipv4/nf_defrag_ipv4.h:7:6: note: 'nf_defrag_ipv4_disable' declared here
> >    void nf_defrag_ipv4_disable(struct net *net);
> >         ^
> >    1 error generated.
> >
>
> I guess something like this is needed ?

The reported build error was fixed by this patch.

>
> diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
> index 662e5eb1cc39e544191b3aab388c3762674d9251..7013f55f05d1ebca3b13d29934d8f6abc1ef36f0
> 100644
> --- a/net/netfilter/xt_socket.c
> +++ b/net/netfilter/xt_socket.c
> @@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct
> xt_mtdtor_param *par)
>  {
>         if (par->family == NFPROTO_IPV4)
>                 nf_defrag_ipv4_disable(par->net);
> +#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
>         else if (par->family == NFPROTO_IPV6)
>                 nf_defrag_ipv6_disable(par->net);
> +#endif
>  }
>
>  static struct xt_match socket_mt_reg[] __read_mostly = {

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
