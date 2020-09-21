Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB562725A1
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 15:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgIUNeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 09:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgIUNeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 09:34:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43739C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:34:00 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id e17so12163832wme.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 06:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=wPdlIs18KI5U0+lJGti5z8sy4m97lLcsvfJKYU71Zb4=;
        b=TJTi4cNhDBklHXlnU2BhmlFoP17GtWhHnpSTpszs6yBgkG0PNYcRp92G+rh3wR2wMB
         6wTDZy/tUFdfXBpBkaVMoX0+xPQifCnlheP0zbjLbul6t11emSIvi2IFXuJgJUAuhYif
         DAxKt1XmBh3zpBwP9Vf2PvxP8aeQJf1ut36EMeKkKcbRhmJdPrB9adJMPTFw0rloMKKB
         YfWBswgn5hTnD9AM3KzR01u1zNONJ7HjbNyCcZ53ZfymCCnNWz0wzMirDCFBBS6O0t/5
         q7YZA729DmydWYGDV4LZW24yTJdhFuMiH6b/9odBjqo7KtQvE/iDl2bNP+zunNrqsTpk
         8GWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=wPdlIs18KI5U0+lJGti5z8sy4m97lLcsvfJKYU71Zb4=;
        b=grou7AaKQGGqLg2T6a0q+dUYZYnA/T9piinLKPOTfnrrT8yv/Iqn4Lk9dOVH2zAcwN
         puZFXrtU3JeCBrZfridIP5QOilsdaztlxgSSfiRMfV4XeirXXnCqd4PnXwCkdaqSt0aI
         DWsh5kAluWPtQmAX/HhupGrFErhl6lMevDeRPVu/UexFU3mq7WmSNNDQw9GGI7uthhYq
         sOLU6uRpqlyt5IJm+ONyDuPwhjnIacwO3ry/iGUgGjROSq+pcNov0cCzmzstwbDtsNqR
         IVrLAs0MF+lIu/6qHQTFkrMBjF49TXxttxpmBnKvKm2re1JWHUyaA9csBcVZwWxcsLAO
         xOww==
X-Gm-Message-State: AOAM532H75mFxIhtmcqTa1/+tN93WE6/MP1wjAoKC9HU8acD7XiTLZ9w
        Fn5/3v05etvODLcR+VcQ54lgHQ==
X-Google-Smtp-Source: ABdhPJyOeMeACUunRhRyjQIarEzN5hQ5urTAIhwVTrIJKh+bb2lP9AAskI9HmHAzneGJWBAlNKrgOg==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr29570930wml.28.1600695238916;
        Mon, 21 Sep 2020 06:33:58 -0700 (PDT)
Received: from debil (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d18sm21301938wrm.10.2020.09.21.06.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 06:33:58 -0700 (PDT)
Message-ID: <79bea5b909046ae1259481d172c2eb2a6c62aabb.camel@blackwall.org>
Subject: Re: [PATCH net-next 06/16] net: bridge: mcast: rename br_ip's u
 member to dst
From:   Nikolay Aleksandrov <razor@blackwall.org>
Reply-To: razor@blackwall.org
To:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org
Date:   Mon, 21 Sep 2020 16:33:56 +0300
In-Reply-To: <202009212146.1IVUIG6Z%lkp@intel.com>
References: <20200921105526.1056983-7-razor@blackwall.org>
         <202009212146.1IVUIG6Z%lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 21:30 +0800, kernel test robot wrote:
> Hi Nikolay,
> 
> I love your patch! Yet something to improve:
> 
> [auto build test ERROR on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Nikolay-Aleksandrov/net-bridge-mcast-IGMPv3-MLDv2-fast-path-part-2/20200921-185933
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 3cec0369905d086a56a7515f3449982403057599
> config: riscv-allyesconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=riscv 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    net/batman-adv/multicast.c: In function 'batadv_mcast_mla_br_addr_cpy':
> > > net/batman-adv/multicast.c:564:20: error: 'const struct br_ip' has no member named 'u'
>      564 |   ip_eth_mc_map(src->u.ip4, dst);
>          |                    ^~
>    net/batman-adv/multicast.c:567:23: error: 'const struct br_ip' has no member named 'u'
>      567 |   ipv6_eth_mc_map(&src->u.ip6, dst);
>          |                       ^~
> 

Hrm, I'm pretty sure I tested batman, but apparently I missed
CONFIG_BATMAN_ADV_MCAST. I'll fix it up and send v2 after some
time to give people the chance to comment on the rest of the set.

Thanks!


