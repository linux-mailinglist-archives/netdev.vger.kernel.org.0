Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13A0288026
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbgJIB7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgJIB7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:59:50 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7187CC0613D2;
        Thu,  8 Oct 2020 18:59:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id v12so8281432wmh.3;
        Thu, 08 Oct 2020 18:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DoFqJFIxavJSoKhccIwLtfmVgpVXYVJLyinAOFpfL1E=;
        b=XpCPypviMymEXCkmhl6/mIWPstM//L5uRvLIU/K56Oi3g0OBDyhpKiBRHuy8OYG6jn
         sI7RIbPFt2grhSaTrVSt8xze+2hrX1tmypg4U7TSNfbMo6t855oVkjWGt1/pCfLfnMF3
         THIjPimDeLeWwewqC/32GZMVFfUzRwE5O5qHNE5xvFkuZnLPzkIEFVoePyYoK/2tDhau
         7CPeZEAOTum+DCwcAatySYKG/iT4I6OTlQHpt/6uH3N7Q/EnO30ZCUO3aV5JrkMfZ6Q1
         9Hq7DEUuwqbQ3sHhLt9iMBCjsjhiQVR5X4Hv87q3oygZgPvodRr4pviCkM+PoNWnOvhT
         a6YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DoFqJFIxavJSoKhccIwLtfmVgpVXYVJLyinAOFpfL1E=;
        b=J/DXLZA1mhW5AcE+c62LQJMozV7IdNjTPcV+ANKs05OTGoAQSGcqhxFAAIY1ktfYTr
         OihRTlqNSvM2mEYKhb2wewUnMEKqEZnVGU+18ayHk47t/ygzcCgm+uDk3Hg4xMLLYMnY
         wBGo+WXGGcFAzuSnhSCDW0ww/KltDRIVXWOlRbRGoZn5rB0b1PgrDAa4gjG3kKprU3Ng
         DIkVCfHdCORmRo5K7H40K0vxbitFOjSN0DAKa+7wp00x5RxK9Ha0FaI0RzGTph48nnkX
         PblaKOngPIGlKzM5kVAzDkRsHu/0Jr1IMdofWKX6GCkscPsKJkeivTgkzeS85tt9CVyK
         EyuQ==
X-Gm-Message-State: AOAM53296N1vINpzBYLkh9HUt8J+fDmy0LpMIw7wWeYGJlmmR+aWeeu7
        OvrTFUiaKNW6LQVzGlVw/SmUDRFtPEnIDkdAjPY=
X-Google-Smtp-Source: ABdhPJxRhTmOi+QC4G5S+r0+/VePOxoulpuO1XpwBVa7w2b+o8XcgVKGCDF0IcUDmJDfwebajo6IXf1tukhKIlovlIg=
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr11321204wmc.122.1602208789095;
 Thu, 08 Oct 2020 18:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <af7bd8219b32d7f864eaef8ed8e970fc9bde928c.1602150362.git.lucien.xin@gmail.com>
 <202010090541.hDe5mdXB-lkp@intel.com>
In-Reply-To: <202010090541.hDe5mdXB-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Oct 2020 09:59:37 +0800
Message-ID: <CADvbK_d3u=M6BwLRDeiPVkCT7awix+Lcw=GOy4UcD=s9FPtpHA@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 06/17] sctp: create udp6 sock and set its encap_rcv
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

On Fri, Oct 9, 2020 at 5:20 AM kernel test robot <lkp@intel.com> wrote:
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
>         # https://github.com/0day-ci/linux/commit/60851a8f9ae9fd55f1199581dd78f6030bed63c7
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
>         git checkout 60851a8f9ae9fd55f1199581dd78f6030bed63c7
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=arm
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_start':
>    protocol.c:(.text+0x108c): undefined reference to `udp_sock_create4'
>    arm-linux-gnueabi-ld: protocol.c:(.text+0x10b8): undefined reference to `setup_udp_tunnel_sock'
> >> arm-linux-gnueabi-ld: protocol.c:(.text+0x111c): undefined reference to `udp_sock_create6'
>    arm-linux-gnueabi-ld: protocol.c:(.text+0x113c): undefined reference to `setup_udp_tunnel_sock'
> >> arm-linux-gnueabi-ld: protocol.c:(.text+0x1180): undefined reference to `udp_tunnel_sock_release'
>    arm-linux-gnueabi-ld: net/sctp/protocol.o: in function `sctp_udp_sock_stop':
>    protocol.c:(.text+0x11b4): undefined reference to `udp_tunnel_sock_release'
>    arm-linux-gnueabi-ld: protocol.c:(.text+0x11d0): undefined reference to `udp_tunnel_sock_release'
>
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

> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
