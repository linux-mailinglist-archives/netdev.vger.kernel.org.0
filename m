Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C378332162
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCIIzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbhCIIzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:55:43 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF50C06174A;
        Tue,  9 Mar 2021 00:55:43 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id a188so9042355pfb.4;
        Tue, 09 Mar 2021 00:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bX1tvAsUjpJdgeGqAB8o58WEuzdntGtgUu6B20A5RO0=;
        b=RIWv7xzIriVW4H9gqnio58g4nFkFi5U3tkrfP16JXgTMaAoJ6kceJUVCV1vOJ5Bz6b
         Fxysqs5KO/VEyLYYlCKASNgIMIKt4YuC9v7b0SsuFEMk64Xk4bomvfpmpUGKAgt1+Int
         3462aKtgxcvgNRWAOiwGniWnth1JGtRUMkZXPEAa7hNH2j/sB2sFAZIuAoxqKY4tGuYw
         Wn5VB5Kr5YtDJ9yr4WdTDr5vX3lCYUdNF3dbtEk6EkJsXRZ0F38ecRsaNVJQLu5oGTf5
         MceJbSWx70Jp0vJTr7cy5wbLWMACCTlb47+dgErPm85EiGopOARxWZJqOz802YJzuXkL
         /piA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bX1tvAsUjpJdgeGqAB8o58WEuzdntGtgUu6B20A5RO0=;
        b=ZaZkpQH5qaaUtL55+slwuF5dj5OJGgaBGqO5Vn/5Rhz8x3fU4H3m2ahxdsRelc8u1K
         CR2dNSJP91M5CXS25f5VYtpBcc8U68wyhcj78i4Kd1f9FnXwKdMmPVuovXqcZXUq98n4
         Q066ZR95hiyWWHA6m66K/oNwcI3zAM+m70uj4Z0EG0IdVG2L4dD5hX85vYPmBzppBaPa
         hDqxMfEgCs3DI9ILqKfbrM1x0zWnjUnB4SnARml9bPqRUZffoOyJQZwBx1JVVKAzHPzG
         eOlsIEHVOkexXkfrMZ8rPsgEdmWpTQzmh9aRm2THfZtUhTdJCfC6rAGZo6bFBueSZyJD
         +6Gw==
X-Gm-Message-State: AOAM5310eiC1PQp+SpayC6Ccn83jFqZAFa8wAjiJoDgqSzcZoOT9zdGF
        aM0+FTp8uumi1kijQb9lnkU=
X-Google-Smtp-Source: ABdhPJx1CQyr1wn39QkDtW8zEFjxYcdouAeNIf0YsT0xGVq8cauqISgybKzeVcMPsCVKKNQQn1UGjg==
X-Received: by 2002:a63:181e:: with SMTP id y30mr23342211pgl.324.1615280142566;
        Tue, 09 Mar 2021 00:55:42 -0800 (PST)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b17sm13105530pfp.136.2021.03.09.00.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 00:55:42 -0800 (PST)
Date:   Tue, 9 Mar 2021 16:55:30 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     bpf@vger.kernel.org, kbuild-all@01.org, netdev@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next 2/4] xdp: extend xdp_redirect_map with broadcast
 support
Message-ID: <20210309085530.GW2900@Leo-laptop-t470s>
References: <20210309072948.2127710-3-liuhangbin@gmail.com>
 <202103091607.YXhmDMeL-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202103091607.YXhmDMeL-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 09, 2021 at 04:22:44PM +0800, kernel test robot wrote:
> Hi Hangbin,
> 
> Thank you for the patch! Yet something to improve:

Thanks, I forgot to modify it when rename the flag name.

Hangbin
> 
> [auto build test ERROR on bpf-next/master]
> 
> url:    https://github.com/0day-ci/linux/commits/Hangbin-Liu/xdp-extend-xdp_redirect_map-with-broadcast-support/20210309-153218
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: s390-randconfig-s031-20210309 (attached as .config)
> compiler: s390-linux-gcc (GCC) 9.3.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # apt-get install sparse
>         # sparse version: v0.6.3-262-g5e674421-dirty
>         # https://github.com/0day-ci/linux/commit/d0e1734db001fb56c1428e92145c7f3a001402f3
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Hangbin-Liu/xdp-extend-xdp_redirect_map-with-broadcast-support/20210309-153218
>         git checkout d0e1734db001fb56c1428e92145c7f3a001402f3
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=s390 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>    net/core/filter.c: In function '__bpf_tx_xdp_map':
> >> net/core/filter.c:3928:15: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
>     3928 |   if (flags & BPF_F_REDIR_BROADCAST)
>          |               ^~~~~~~~~~~~~~~~~~~~~
>          |               BPF_F_BROADCAST
>    net/core/filter.c:3928:15: note: each undeclared identifier is reported only once for each function it appears in
> >> net/core/filter.c:3930:20: error: 'BPF_F_REDIR_EXCLUDE_INGRESS' undeclared (first use in this function); did you mean 'BPF_F_EXCLUDE_INGRESS'?
>     3930 |            flags & BPF_F_REDIR_EXCLUDE_INGRESS);
>          |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>          |                    BPF_F_EXCLUDE_INGRESS
>    net/core/filter.c: In function 'xdp_do_generic_redirect_map':
>    net/core/filter.c:4090:19: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
>     4090 |   if (ri->flags & BPF_F_REDIR_BROADCAST)
>          |                   ^~~~~~~~~~~~~~~~~~~~~
>          |                   BPF_F_BROADCAST
>    net/core/filter.c:4092:24: error: 'BPF_F_REDIR_EXCLUDE_INGRESS' undeclared (first use in this function); did you mean 'BPF_F_EXCLUDE_INGRESS'?
>     4092 |            ri->flags & BPF_F_REDIR_EXCLUDE_INGRESS);
>          |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>          |                        BPF_F_EXCLUDE_INGRESS
>    net/core/filter.c: In function '____bpf_xdp_redirect_map':
>    net/core/filter.c:4182:44: error: 'BPF_F_REDIR_BROADCAST' undeclared (first use in this function); did you mean 'BPF_F_BROADCAST'?
>     4182 |  if (unlikely(!ri->tgt_value) && !(flags & BPF_F_REDIR_BROADCAST)) {
>          |                                            ^~~~~~~~~~~~~~~~~~~~~
>          |                                            BPF_F_BROADCAST
> 
> 
> vim +3928 net/core/filter.c
> 
>   3920	
>   3921	static int __bpf_tx_xdp_map(struct net_device *dev_rx, void *fwd,
>   3922				    struct bpf_map *map, struct xdp_buff *xdp,
>   3923				    u32 flags)
>   3924	{
>   3925		switch (map->map_type) {
>   3926		case BPF_MAP_TYPE_DEVMAP:
>   3927		case BPF_MAP_TYPE_DEVMAP_HASH:
> > 3928			if (flags & BPF_F_REDIR_BROADCAST)
>   3929				return dev_map_enqueue_multi(xdp, dev_rx, map,
> > 3930							     flags & BPF_F_REDIR_EXCLUDE_INGRESS);
>   3931			else
>   3932				return dev_map_enqueue(fwd, xdp, dev_rx);
>   3933		case BPF_MAP_TYPE_CPUMAP:
>   3934			return cpu_map_enqueue(fwd, xdp, dev_rx);
>   3935		case BPF_MAP_TYPE_XSKMAP:
>   3936			return __xsk_map_redirect(fwd, xdp);
>   3937		default:
>   3938			return -EBADRQC;
>   3939		}
>   3940		return 0;
>   3941	}
>   3942	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


