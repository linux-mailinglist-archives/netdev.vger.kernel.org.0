Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D20288024
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgJIB7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730814AbgJIB7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:59:30 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809FCC0613D2;
        Thu,  8 Oct 2020 18:59:30 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k18so8264790wmj.5;
        Thu, 08 Oct 2020 18:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PH8qJjXyJjwPlc1da743kVRsFdYY4mOzElUAKLFycxA=;
        b=AvOS/p1k2uI0ZUZHJA6POHculGuwPfkTIqkuhQ+NJL/OHFTqOYX54YJ+pF01RYduWi
         j6MftIfizU38/2kZneMwzb+niNr1xpOEMCRcws2R2FU8iy+apFP3EoKYE03ZTQXUb3F0
         lu0D+RyD9mBLqNrDhMIu8803WSyPu+krtruufVKztLB0MfTiFZp831tK1mk+yE4MKMw+
         aBnnKi3XcXots2d9RUOZlPrr8KBJlnY/Rm2aRIXM9ZDQeAcZFqOr/UQ4UMTDA5gZKWDB
         jH6xbs8czQP7D2U7YekmBfU0a9IfitFVs6jT218zcdSSofLMKPwbN1n0y2o0OF9blKif
         ihXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PH8qJjXyJjwPlc1da743kVRsFdYY4mOzElUAKLFycxA=;
        b=TKieHq0yJY+O+2RLk3upnQfmPMlfZi1GKnD5birggI6bdvB0qLnFn1D0IcRurd9lsr
         YgH91mQzYnDH486Qc4zDpfKLytO2Xbf+NYVaCxw3K0aFkXoAmsU7g9aVeWvSU0a7REfz
         J8oN4k6ScT30AlrHXb+jP4iyQcAiLb0nFiw2B+jQ4Qy1nfh9DP0KcLFDlOVpIS6lm5GO
         1kGtgCBs7xJIzuB6pa1oCyU4QxhPtORQl7u/j+FwO3OhT4yNDnL1ry3cnWJG49YI2Aoa
         vT2uH+am/AEH8pg/sMFGQxgskQcJWEVwge3nKZ8I7/Gg+TV7P5sTql3VwWQ9gpAWcm0j
         8OJw==
X-Gm-Message-State: AOAM532ROVOOqGdzjvCPYk6oKJybln+TlD/G177HUt01BtRsMbSact/M
        8Igk9VbAGFEanlxgUOxIEuAteoJDJbPtjKSbgoI=
X-Google-Smtp-Source: ABdhPJxCOjfpvI6vjgn2q61fiU0UQT7xYSxp2HX01MPw7d46ntT8FefhjOxEg0MMo5Osqm/cyp96AqjiOyf1iHSNATU=
X-Received: by 2002:a7b:c2a9:: with SMTP id c9mr11494514wmk.87.1602208769149;
 Thu, 08 Oct 2020 18:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <6f5a15bba0e2b5d3da6be90fd222c5ee41691d32.1602150362.git.lucien.xin@gmail.com>
 <202010090235.YqoHRhHI-lkp@intel.com>
In-Reply-To: <202010090235.YqoHRhHI-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Oct 2020 09:59:18 +0800
Message-ID: <CADvbK_f2neAmkuHytPJ=Gc7TEf4nHjDZ1k2C_p6MUSBJtK6w5A@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 05/17] sctp: create udp4 sock and add its encap_rcv
To:     kernel test robot <lkp@intel.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        kbuild-all@lists.01.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        davem <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 2:30 AM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9faebeb2d80065926dfbc09cb73b1bb7779a89cd
> config: arm-keystone_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/55d6ef371ddfab66c7767da14b490f7576262f1a
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
>         git checkout 55d6ef371ddfab66c7767da14b490f7576262f1a
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_start':
> >> protocol.c:(.text+0x1084): undefined reference to `udp_sock_create4'
> >> arm-linux-gnueabi-ld: protocol.c:(.text+0x10b0): undefined reference to `setup_udp_tunnel_sock'
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_stop':
> >> protocol.c:(.text+0x1108): undefined reference to `udp_tunnel_sock_release'
diff --git a/net/sctp/Kconfig b/net/sctp/Kconfig
index 39d7fa9569f8..5da599ff84a9 100644
--- a/net/sctp/Kconfig
+++ b/net/sctp/Kconfig
@@ -11,6 +11,7 @@ menuconfig IP_SCTP
        select CRYPTO_HMAC
        select CRYPTO_SHA1
        select LIBCRC32C
+       select NET_UDP_TUNNEL
        help
          Stream Control Transmission Protocol

>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
