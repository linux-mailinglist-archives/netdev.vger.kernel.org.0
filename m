Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C83374B32BF
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiBLCoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:44:00 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLCoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:44:00 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0153207A
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:43:57 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v63so3002636ybv.10
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1JOx1p3HsJ2taUJ8lrTvJOAknO2/dl1PDm0p2eNNr1U=;
        b=Ti3jumDjZGXPLHqjAABBdvQExq137bv2iIyI9sJUiF/1K+Aevqlb/At+zjC8V/h/+2
         0UpFidZylv/mwx3xeUIH23xtOWQM9qrMJv+YdwcprbVteYlgoRO7MmiC6G/4gA06R+A9
         TGV8KQFBEGwBsFB37PWXJDi16NjbfntlfGKTVWr0sAJ0cPPyNMdYbA4dCHdNby3UFyVq
         ok3dDow8ecg7lsNEp6A/0EMyGUSPm+MkAn6on3woj1jwFc6Es6NO4MwxlRce3czV7PEY
         Zqf+424J3CJ3jlEYL+IYOET6MaOXavKUyPlwU4mo4iEz0BktyD2oNIIoxrxNh0hBuz5t
         WMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1JOx1p3HsJ2taUJ8lrTvJOAknO2/dl1PDm0p2eNNr1U=;
        b=mtQmsU318nm3dhX8GAizR4VdslRs6PSUqM2YF5txGN3PCmcD7gI+mrVDSxOd/vFaaf
         CdUD17E0Qjlt/mSeANtErUmHCvEOEHKqH+wnGyhSOFtODrlW7/6Nhy4fnyCMBnILrAlI
         93Cu6hGQUOdiJqTK050YwF48a3vqwkGECOcsVhGPF5XQN6pB2AqoS1uihsaKwa0sICnN
         ur+pVbyaoDYQ3mRzJ64k81QI4VlPucEFvyDHxmVh7yN+Hg1ktwu/NJ0NY5Rqmh6Nymvm
         Vi/wG5gqeKlMJzI/U2r4/LRPMtN5ZMWOQnxuj8Q+hCitq9/zQW6WOlaJbq1ieG1LJZMd
         Bpsg==
X-Gm-Message-State: AOAM532xqK8aWEQr+rw6TRFYrI0/YTUqEibZttEnzK7sU9yQdPk1nbF+
        4aDKt+gPoOTghh0FsHnzslllARh2JmzinHIhgoXIiuo/1zRqFXJM
X-Google-Smtp-Source: ABdhPJwL+nePN8pP5ChEtiGDzKtW/vDGHPQ2tg2HfujbPaa2+BI5q61dMVi8abMMEIG/nZ0+ydokPF/cwGVpjKfEs/I=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr4216918ybb.156.1644633836709;
 Fri, 11 Feb 2022 18:43:56 -0800 (PST)
MIME-Version: 1.0
References: <202202120509.FMR7TEL1-lkp@intel.com>
In-Reply-To: <202202120509.FMR7TEL1-lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Feb 2022 18:43:45 -0800
Message-ID: <CANn89iLS4N4cpX+Nh9ALjf_APOPQ4-aSPSX1P6iLpda8mJS8UQ@mail.gmail.com>
Subject: Re: [net:master 21/30] net/netfilter/xt_socket.c:224:3: error:
 implicit declaration of function 'nf_defrag_ipv6_disable'
To:     kernel test robot <lkp@intel.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
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

On Fri, Feb 11, 2022 at 1:55 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> head:   85d24ad38bc4658ce9a16b85b9c8dc0577d66c71
> commit: 75063c9294fb239bbe64eb72141b6871fe526d29 [21/30] netfilter: xt_socket: fix a typo in socket_mt_destroy()
> config: hexagon-randconfig-r045-20220211 (https://download.01.org/0day-ci/archive/20220212/202202120509.FMR7TEL1-lkp@intel.com/config)
> compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project f6685f774697c85d6a352dcea013f46a99f9fe31)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=75063c9294fb239bbe64eb72141b6871fe526d29
>         git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
>         git fetch --no-tags net master
>         git checkout 75063c9294fb239bbe64eb72141b6871fe526d29
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/netfilter/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> net/netfilter/xt_socket.c:224:3: error: implicit declaration of function 'nf_defrag_ipv6_disable' [-Werror,-Wimplicit-function-declaration]
>                    nf_defrag_ipv6_disable(par->net);
>                    ^
>    net/netfilter/xt_socket.c:224:3: note: did you mean 'nf_defrag_ipv4_disable'?
>    include/net/netfilter/ipv4/nf_defrag_ipv4.h:7:6: note: 'nf_defrag_ipv4_disable' declared here
>    void nf_defrag_ipv4_disable(struct net *net);
>         ^
>    1 error generated.
>

I guess something like this is needed ?

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 662e5eb1cc39e544191b3aab388c3762674d9251..7013f55f05d1ebca3b13d29934d8f6abc1ef36f0
100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -220,8 +220,10 @@ static void socket_mt_destroy(const struct
xt_mtdtor_param *par)
 {
        if (par->family == NFPROTO_IPV4)
                nf_defrag_ipv4_disable(par->net);
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
        else if (par->family == NFPROTO_IPV6)
                nf_defrag_ipv6_disable(par->net);
+#endif
 }

 static struct xt_match socket_mt_reg[] __read_mostly = {
