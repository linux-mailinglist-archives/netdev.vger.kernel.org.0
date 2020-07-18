Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE53C224D94
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 21:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgGRSx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 14:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgGRSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 14:53:56 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED289C0619D2
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:53:55 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so2402643pjd.3
        for <netdev@vger.kernel.org>; Sat, 18 Jul 2020 11:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KQ0gu/5Hh5Q+9P9R+O/Myovmxbwkp3lHGHtP06q+gic=;
        b=k/rCH+bE4VDJdnsnQph887pSuAPa1DklyXIO/nVVTnsJ/bAj3Aey62Zl/cC3QSYV27
         gDKNV9gZtXVNg/a48K4uWok6wwbLR9VxQdk1unpnGVIXXzXSrSbejEm3RJOWxUr1xcjP
         7oGpPmm4hQuK3W569hNs5UM8FHKCkFmEpzGpOwHXRS29LpCoThD2xMQDx6iM4Ux82iWn
         1ZlSoeaFZWuDIWZ6ogolUbF4QIko9m/nvt3S3UG9DayyyGdPdoKXthXLsZRhkY8L8ohO
         KlHbM/kfzZjwLUj+xo/TgwZCsz7gTQBK1/L9EPbzFFt4LOPYxWoHtWaFo+CKFQCj5TCK
         3qyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KQ0gu/5Hh5Q+9P9R+O/Myovmxbwkp3lHGHtP06q+gic=;
        b=hJVetq487hM3V3ahoMgIcWM7/H2c/3rm5+nCcSx0MOBlfYCXtmWXb71zd+7J2GYrT2
         Csw6bFYJT70l9/pP1m1D8pRqPFNiW+i8jpfbGKLtT0mr/6o/Dj2gv4WWT9hwomeROgK+
         QENQaNPdNLXNC+O2tDzn9CS+KS7hEdYb4zT16II+9+lIO+VfTDADQC3F/CYm5Ht5rP71
         eUZWK4s57y1JBf9DkkKXGW0e2WJd0FN+qE3/fstaS1hRrgGUO7d3D3vUi9ZQwFqXLaQ5
         KUUg7uvKaA0Y+LIfkSahRvdhvO30WRFReiZFwNJgi2QslffyiNqzv4KzngA2QB/uw+P1
         wxdQ==
X-Gm-Message-State: AOAM530UiMM5TNWwahzgVQlti/G519bdofCuVsCByrXaZ9Ovu5FrAWrw
        DRm5NT0+JtvT7YtN45NNQRc=
X-Google-Smtp-Source: ABdhPJyYUvpgUCAhGyBdNw1j0oD/lFY+5UPxawhwfYC652pWEs7ATpP2r3YFMgr7x+jZXnFfQkL/0A==
X-Received: by 2002:a17:902:d34a:: with SMTP id l10mr12308013plk.190.1595098435372;
        Sat, 18 Jul 2020 11:53:55 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id j8sm11572930pfd.145.2020.07.18.11.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 11:53:54 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: Add wrappers for overloaded
 ndo_ops
To:     kernel test robot <lkp@intel.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
References: <20200718030533.171556-3-f.fainelli@gmail.com>
 <202007181226.RGMXcERR%lkp@intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <df5b74aa-0b5f-555b-fe96-8db98cd24900@gmail.com>
Date:   Sat, 18 Jul 2020 11:53:52 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202007181226.RGMXcERR%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 9:53 PM, kernel test robot wrote:
> Hi Florian,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on net-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Florian-Fainelli/net-dsa-Setup-dsa_netdev_ops/20200718-110931
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git dcc82bb0727c08f93a91fa7532b950bafa2598f2
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-14) 9.3.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=i386 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    In file included from drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c:18:
>>> include/net/dsa.h:720:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
>      720 | dsa_build_ndo_op(ndo_do_ioctl, struct ifreq *, ifr, int, cmd);
>          | ^~~~~~~~~~~~~~~~
>    include/net/dsa.h:721:1: warning: 'inline' is not at beginning of declaration [-Wold-style-declaration]
>      721 | dsa_build_ndo_op(ndo_get_phys_port_name, char *, name, size_t, len);
>          | ^~~~~~~~~~~~~~~~
> 
> vim +/inline +720 include/net/dsa.h

This is a macro invocation, not function declaration so I am not exactly
sure why this is a problem here? I could capitalize the macro name if
that avoids the compiler thinking this is a function declaration or move
out the static inline away from the macro invocation.
-- 
Florian
