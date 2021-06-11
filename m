Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC4C3A462E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhFKQLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKQLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:11:35 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CAAC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:09:23 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i94so6665738wri.4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tm0i4ZRiw071gfbneeD3WBys+y2c9gDppQDlJO1W8Xc=;
        b=beqlJRZ+HBI7dFbyEDmeseRkiL8KIpvtantI5PgSHFILBJdvtQjxcI59OJcDUuSh1P
         /pSl+KEMVnWptnsqifTvGWdIyD8h8M8RRFCIxxp+dDqmmFvI4Rs/Bs8HrslJRRwGS46U
         2PYoDAzrce/ioRH0tFpIek9tb1KZh/2I8CA/zRKfBnIBo+VX4qzFpovhq2zqTGQTcSs0
         QG9aVJ1TGRX508Mj5aomRZpIaZxQthHuiE6bVC2iIwl2pGEH5cz1/Va3HWkpu7xAriJg
         Jmjqmkb6t3pDbTuiW9+B8k+yggUNG7BFdr9/L51snHuS5uilDOQXRwJo/wy6/gyaCTqF
         3jYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tm0i4ZRiw071gfbneeD3WBys+y2c9gDppQDlJO1W8Xc=;
        b=re3ah4Q7MkEFhxdBuqc96GiOSq7oMhHqjPW+cGzzWZ/f8mzaZro3GaMrMg2clnduya
         UAtV/0G0OUR9Mcv6nepGn+zNqqXtRa6FLouQ1BzXsfAS5mp6ao4Km2UPV5TJvNq0oSpY
         6XjOxR5fauXrko8eX2berFMYR9nXhPwdRMOeesThbRAn6/YL7XcOCB7uTek75m0LhsAn
         xfM46Q9+vTUj0o0pR6ijt/UFEq1vma4BtrxuCrYAxO42QXcDSvPV+4HsXVkQ3CXYwrMp
         ufM3oWDTtdKGNMavy3OynbH3volUPIHgKKfoGzJIM3XPVXSzFtVsiReA2i28MSkBMpAL
         LWwQ==
X-Gm-Message-State: AOAM530dDdPUda+pZyJ8ITy+5EYyBWkmO9OE9Cf0s0cA2xu968ZfQV0m
        IH0cD6yQZDMZgjO3Ov0TKguJhmUtvv06tCeLVus=
X-Google-Smtp-Source: ABdhPJwRK/J9Cpi6XFQRd1ruJFV+VTd6ENOzakMATgtqJ1ZdIyuj63CX6mFqh8bPO0do8I+uWFvFtB8Er9znJBvfALA=
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr4867308wrn.217.1623427761769;
 Fri, 11 Jun 2021 09:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <202106111102.iUAxbjgy-lkp@intel.com>
In-Reply-To: <202106111102.iUAxbjgy-lkp@intel.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Fri, 11 Jun 2021 11:09:11 -0500
Message-ID: <CAOhMmr5AC66WuU+ScsnLm7G1MKhPYJRxc8jCjBdC_BHqjbscUg@mail.gmail.com>
Subject: Re: [net-next:master 183/184] drivers/net/ethernet/ibm/ibmvnic.c:855:2:
 warning: enumeration value 'VNIC_DOWN' not handled in switch
To:     kernel test robot <lkp@intel.com>
Cc:     Cristobal Forno <cforno12@linux.ibm.com>, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Thomas Falcon <tlfalcon@linux.ibm.com>,
        Dany Madden <drt@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 10:33 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> head:   76cf404c40ae8efcf8c6405535a3f6f69e6ba2a5
> commit: 53f8b1b25419a14b784feb6706bfe5bac03c5a75 [183/184] ibmvnic: Allow device probe if the device is not ready at boot
> config: powerpc-allyesconfig (attached as .config)
> compiler: powerpc64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=53f8b1b25419a14b784feb6706bfe5bac03c5a75
>         git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>         git fetch --no-tags net-next master
>         git checkout 53f8b1b25419a14b784feb6706bfe5bac03c5a75
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=powerpc
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/ethernet/ibm/ibmvnic.c: In function 'adapter_state_to_string':
> >> drivers/net/ethernet/ibm/ibmvnic.c:855:2: warning: enumeration value 'VNIC_DOWN' not handled in switch [-Wswitch]
>      855 |  switch (state) {
>          |  ^~~~~~
>    drivers/net/ethernet/ibm/ibmvnic.c: In function 'reset_reason_to_string':
> >> drivers/net/ethernet/ibm/ibmvnic.c:1958:2: warning: enumeration value 'VNIC_RESET_PASSIVE_INIT' not handled in switch [-Wswitch]
>     1958 |  switch (reason) {
>          |  ^~~~~~

https://lore.kernel.org/netdev/20210611153537.83420-1-lijunp213@gmail.com/T/#u

>    In file included from include/linux/string.h:269,
>                     from arch/powerpc/include/asm/paca.h:15,
>                     from arch/powerpc/include/asm/current.h:13,
>                     from include/linux/thread_info.h:22,
>                     from include/asm-generic/preempt.h:5,
>                     from ./arch/powerpc/include/generated/asm/preempt.h:1,
>                     from include/linux/preempt.h:78,
>                     from include/linux/spinlock.h:51,
>                     from include/linux/mmzone.h:8,
>                     from include/linux/gfp.h:6,
>                     from include/linux/umh.h:4,
>                     from include/linux/kmod.h:9,
>                     from include/linux/module.h:16,
>                     from drivers/net/ethernet/ibm/ibmvnic.c:35:
>    In function 'strncpy',
>        inlined from 'handle_vpd_rsp' at drivers/net/ethernet/ibm/ibmvnic.c:4388:3:
>    include/linux/fortify-string.h:27:30: warning: '__builtin_strncpy' output truncated before terminating nul copying 3 bytes from a string of the same length [-Wstringop-truncation]
>       27 | #define __underlying_strncpy __builtin_strncpy
>          |                              ^
>    include/linux/fortify-string.h:38:9: note: in expansion of macro '__underlying_strncpy'
>       38 |  return __underlying_strncpy(p, q, size);
>          |         ^~~~~~~~~~~~~~~~~~~~
>
>

https://lore.kernel.org/netdev/20210611160529.88936-1-lijunp213@gmail.com/T/#u

> vim +/VNIC_DOWN +855 drivers/net/ethernet/ibm/ibmvnic.c
>
> 86f669b2b7491b Nathan Fontenot 2018-02-19  852
> 0666ef7f61ca76 Lijun Pan       2021-04-12  853  static const char *adapter_state_to_string(enum vnic_state state)
> 0666ef7f61ca76 Lijun Pan       2021-04-12  854  {
> 0666ef7f61ca76 Lijun Pan       2021-04-12 @855          switch (state) {
> 0666ef7f61ca76 Lijun Pan       2021-04-12  856          case VNIC_PROBING:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  857                  return "PROBING";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  858          case VNIC_PROBED:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  859                  return "PROBED";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  860          case VNIC_OPENING:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  861                  return "OPENING";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  862          case VNIC_OPEN:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  863                  return "OPEN";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  864          case VNIC_CLOSING:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  865                  return "CLOSING";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  866          case VNIC_CLOSED:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  867                  return "CLOSED";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  868          case VNIC_REMOVING:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  869                  return "REMOVING";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  870          case VNIC_REMOVED:
> 0666ef7f61ca76 Lijun Pan       2021-04-12  871                  return "REMOVED";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  872          }
> 07b5dc1d515a9a Michal Suchanek 2021-05-20  873          return "UNKNOWN";
> 0666ef7f61ca76 Lijun Pan       2021-04-12  874  }
> 0666ef7f61ca76 Lijun Pan       2021-04-12  875
>
> :::::: The code at line 855 was first introduced by commit
> :::::: 0666ef7f61ca763897fdcd385d65555dd4764514 ibmvnic: print adapter state as a string
>
> :::::: TO: Lijun Pan <lijunp213@gmail.com>
> :::::: CC: David S. Miller <davem@davemloft.net>
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org


Thanks,
Lijun
