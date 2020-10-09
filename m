Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B2E288032
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 04:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgJICCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 22:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgJICCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 22:02:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C52C0613D2;
        Thu,  8 Oct 2020 19:02:21 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z1so8571686wrt.3;
        Thu, 08 Oct 2020 19:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jtYY0usC4ljvjDt/q/Hq+d0qiu79u2ckTDddE32ZHjw=;
        b=RIHjFwmyGjrOsoT8lGz36rK6jDa2e/iPgXesMm212sc/MFFTHw1Nj+Z9ZdvZbwz+pM
         IrU1/rDRsZY02AWYAmkGLpgZrdEz/W4YMlQRoV217nO25HIuEWENg8ABOXMDGLV4b4kM
         Bc4D5r21ktBWhOUJC382QRZ/sgFJ3hUjc8G/6k8mmSYjCRUsYIcMTGRPjJuyTibYIrwp
         14lvMEGUfIesxgUASCfedJ129DuIcb4ElXsfAmwlK0vgDoZKMhVar+TB/5ewGaz99f5f
         uU+0nxwFZp0BAYO+xI7KpKbXGqJHGw8mjH+Zg8/BlpEXwmYR9PwdsTvuvprXr8PjIjsW
         82yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jtYY0usC4ljvjDt/q/Hq+d0qiu79u2ckTDddE32ZHjw=;
        b=N4bVPCbA+wX9Ld1j3VCDK/95O28ITNkzhRg7OPgZGEW1tyl983sDtO9G73hP1ck/jL
         4i2evFjzS+XvUnMSGNDc4sjkJYKp9bEABX0w1YqXXMa4EMNNJtvveEG8vTX0woawxSut
         2LpIfk5dy3uaAz+UF1Ht5LSaFy3HDMyY1O5u8Rc0W1/A99gTzMfDShNEuJiyhoXl9uKs
         fYV1rk2rIi5sJB/QXj4Uq+IGk1AoREmWI9j6y4vgbX9AC5uS6XgKc7exh588BVwQ1tC1
         /Uf6/rdwXopTmhCnYpgl4xvMeQ2gbd8fRLA9ckQsTyMkTvsvwh7uk56U0+NoAhW+VGtI
         P0KA==
X-Gm-Message-State: AOAM5326cXSBhP3ih/OnppziMQEg7Mc/Sxf1ID0fnBP1qKS/qZ7zr/8+
        KtsQKVueP8t3ljyZykMAZCGS6xZO63HF1Oe/1UA=
X-Google-Smtp-Source: ABdhPJwXoxRECHBAaMj+m9L79cv79U241ZDeb1isq+pP0tAtESZH4F6XdACagBkvhV+r3Bo1ZN9RagyV7gpBAwlG6pU=
X-Received: by 2002:adf:ec06:: with SMTP id x6mr12042381wrn.404.1602208940667;
 Thu, 08 Oct 2020 19:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <8ce0fde0d093d62e8969d1788a13921ed1516ad6.1602150362.git.lucien.xin@gmail.com>
 <202010082357.BLEOWVCz-lkp@intel.com>
In-Reply-To: <202010082357.BLEOWVCz-lkp@intel.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Oct 2020 10:02:09 +0800
Message-ID: <CADvbK_f+Z=Z72bHuf0tGbQBAw4+hq5R=r7buxV_dGDgJTt632Q@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 17/17] sctp: enable udp tunneling socks
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

On Thu, Oct 8, 2020 at 11:46 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Xin,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on net-next/master]
>
> url:    https://github.com/0day-ci/linux/commits/Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 9faebeb2d80065926dfbc09cb73b1bb7779a89cd
> config: i386-randconfig-s002-20201008 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce:
>         # apt-get install sparse
>         # sparse version: v0.6.2-218-gc0e96d6d-dirty
>         # https://github.com/0day-ci/linux/commit/7dab31e8c96fab2089a651d5a6d06bcf92b011ad
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Xin-Long/sctp-Implement-RFC6951-UDP-Encapsulation-of-SCTP/20201008-175211
>         git checkout 7dab31e8c96fab2089a651d5a6d06bcf92b011ad
>         # save the attached .config to linux build tree
>         make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=i386
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> echo
> echo "sparse warnings: (new ones prefixed by >>)"
> echo
> >> net/sctp/sysctl.c:532:39: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] udp_port @@     got int udp_port @@
> >> net/sctp/sysctl.c:532:39: sparse:     expected restricted __be16 [usertype] udp_port
> >> net/sctp/sysctl.c:532:39: sparse:     got int udp_port
>
> vim +532 net/sctp/sysctl.c
>
>    500
>    501  static int proc_sctp_do_udp_port(struct ctl_table *ctl, int write,
>    502                                   void *buffer, size_t *lenp, loff_t *ppos)
>    503  {
>    504          struct net *net = current->nsproxy->net_ns;
>    505          unsigned int min = *(unsigned int *)ctl->extra1;
>    506          unsigned int max = *(unsigned int *)ctl->extra2;
>    507          struct ctl_table tbl;
>    508          int ret, new_value;
>    509
>    510          memset(&tbl, 0, sizeof(struct ctl_table));
>    511          tbl.maxlen = sizeof(unsigned int);
>    512
>    513          if (write)
>    514                  tbl.data = &new_value;
>    515          else
>    516                  tbl.data = &net->sctp.udp_port;
>    517
>    518          ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
>    519          if (write && ret == 0) {
>    520                  struct sock *sk = net->sctp.ctl_sock;
>    521
>    522                  if (new_value > max || new_value < min)
>    523                          return -EINVAL;
>    524
>    525                  net->sctp.udp_port = new_value;
>    526                  sctp_udp_sock_stop(net);
>    527                  ret = sctp_udp_sock_start(net);
>    528                  if (ret)
>    529                          net->sctp.udp_port = 0;
>    530
>    531                  lock_sock(sk);
>  > 532                  sctp_sk(sk)->udp_port = net->sctp.udp_port;
>    533                  release_sock(sk);
>    534          }
>    535
>    536          return ret;
>    537  }
>    538
I will add the restricted __be16 in these 3 patches.

Thanks.
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
