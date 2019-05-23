Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D909273F2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfEWBYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:24:23 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:36525 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727691AbfEWBYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 21:24:23 -0400
Received: by mail-yw1-f68.google.com with SMTP id e68so1633878ywf.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 18:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bjAbbIYFQQgM8rkDzM9O/E0pBXjIXC95/8Lg75mn2P8=;
        b=ToXW41tRyScIehVJNHdnriWDUWNRe7B6hH0zYckRyjnLOC8z5w8Au8Ig+AZYKklznh
         NH2VcxMNTVFIdN7ri6lVnbelbKKe4/5Mk/v4ojxh8sPvHgS/0EfCtcExDeaBNMvoWFxu
         aqZpMT6EV8HKFaFjVtNXAysJrKC62typLEsE080TyoddjVxSKPAkgWnAzWWaxQH8XSAe
         P89W9E2xs87A4rYvDyy7dTcoKlHesYIJC0iUs8gSP/Qx1u9GLXKPkEH0UG+35VBVPOU9
         QvOxnFHeDyuXkFg178XVX01V/fLuaFoi8Wx8zhqdsGFRaO76NbypNBdsJBWkg+nK/+Vt
         r+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bjAbbIYFQQgM8rkDzM9O/E0pBXjIXC95/8Lg75mn2P8=;
        b=lh422rwFp2UF5YVEObToL9NH0Xt3uwDf/nb9pGU6RvSkb1xMWlzsHBYkowmdjJI0aV
         jfMMsod77AphG+8be8/7nuNRMQOdH1j9ZHL8NyBF5u/ScSYANSKo19GDkmUbZqmHj0lm
         OBk/2yJzxuwD2hOBxW/NOwuhOhuDNB9u6PBcE8ftTdLZkYB8d9m0m0JtkNwWxUD8Fa0U
         56bX11dzrU9wGVdKRfZDtDN38+fT835olFHjncKkRAkE+FErgSsyhHTFjNausL7jwlun
         r+4Z+1g2wd1Dbt7EPc/3Nl9ZIn3F7kGlkqYo6j/GLXQw3qH6kt7aPOQxU4GWdvr4B9Q8
         xb1w==
X-Gm-Message-State: APjAAAXPHjmGKKIthHfml5aeqbaWKHjQ/PyMf/3Y3ZizdHuCkOYUmMnU
        ycLuT2ivd5+mee7zwpPLXSdayZwD32mI+xs7LylL9CZco5uXbw==
X-Google-Smtp-Source: APXvYqyZoVc9vEXUJKGpYSNlnnMrRldCcJoJYl+4lfjzkcVJDZRurYiZ9+PhI4hi+6K1RT926889fTmhKzkUibgqE/k=
X-Received: by 2002:a81:83d7:: with SMTP id t206mr41612405ywf.146.1558574662101;
 Wed, 22 May 2019 18:24:22 -0700 (PDT)
MIME-Version: 1.0
References: <201905230906.JByCbvIZ%lkp@intel.com>
In-Reply-To: <201905230906.JByCbvIZ%lkp@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 22 May 2019 18:24:10 -0700
Message-ID: <CANn89iJMrpjTGASLPzTbA_UZPoyb_He-CnKGK5RtWCpJAt6dTg@mail.gmail.com>
Subject: Re: [net:master 11/11] net//ipv4/igmp.c:2157:2: error: implicit
 declaration of function 'ip_sf_list_clear_all'; did you mean 'ip_mc_filter_del'?
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@01.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 6:19 PM kbuild test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> head:   3580d04aa674383c42de7b635d28e52a1e5bc72c
> commit: 3580d04aa674383c42de7b635d28e52a1e5bc72c [11/11] ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
> config: i386-randconfig-x073-201920 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
> reproduce:
>         git checkout 3580d04aa674383c42de7b635d28e52a1e5bc72c
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    net//ipv4/igmp.c: In function 'ip_mc_clear_src':
> >> net//ipv4/igmp.c:2157:2: error: implicit declaration of function 'ip_sf_list_clear_all'; did you mean 'ip_mc_filter_del'? [-Werror=implicit-function-declaration]
>      ip_sf_list_clear_all(tomb);
>      ^~~~~~~~~~~~~~~~~~~~
>      ip_mc_filter_del
>    cc1: some warnings being treated as errors

Oh right, I will send a followup patch (if/when CONFIG_IP_MULTICAST is
not defined)

Thanks
