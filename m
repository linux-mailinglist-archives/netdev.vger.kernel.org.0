Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13E213206
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 05:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgGCDFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 23:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgGCDFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 23:05:35 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D64BC08C5C1;
        Thu,  2 Jul 2020 20:05:35 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t4so12913159iln.1;
        Thu, 02 Jul 2020 20:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C8+UQwuXxC+Hk3b/RHaKYib5FH1f4hDdnk1vs6FzplY=;
        b=rQB1Gr6B2JLCZdZMlpDDPYmtUXdmlci/ut3szK2nGMpgrgDKccBRZAdg7fM3tFmJTm
         SuEKqBqdyoSbj98eRtt5au0pjnW+ssSxt0i0mB6mYkfly1bWvVaww+ki975o0IK/G5+I
         6oig7P8QXjKuD4bWBxbVtlJX0bDAPUmg85lXUCYHf/FiXgm1oq5rF1WvAfM4S8JSL8+t
         Gr2oet6kSZgQcQuZ3H3NsK5sMeOCZlFiwz54Gf+qF0Fcy/FLIvALpVM440td7cnOW+0O
         upMPb8cz/cqRBhnfWNycYTqsl52w7uE/YMH54czeX3ACQ/yKpavTldf7HhisQzyBwYod
         BJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C8+UQwuXxC+Hk3b/RHaKYib5FH1f4hDdnk1vs6FzplY=;
        b=s4QjCKQY35ArgU2bMvfI29QDK1x3Oi77v7CcI9Cvc18Ot7bD67PDC1z9oYY2SoSbQU
         azv0nNOkRA6reVU+t2GvCA/+proOF+Xqxv+qdJRZOIJb1bUiYBXGyWIq8z3LDBy/BAPe
         uz8qmDKPjfNjbicb4+9Kkop8ZwreVarMcFY02Eabc6/k4knDirkc4sjSVTQV/kEbnKPY
         no1ze6oDyybJ4V3f0gWk6Lxz4UpyUKsT4jmIxO8MirvSxvWys0fBJpxP1A3zMXn9IDpn
         K4fRVc83mUHca1GzNJp2rqn4VkqWj+GRJR4CMgzRXwitt0bevfxlsN9miJWtHIZLOnPJ
         GhyA==
X-Gm-Message-State: AOAM531jQigfrKSAxpnj7jNOiZ+uiWKEtjMA8/aBOJdayBGkYkX4vAlV
        QvoeRBZTmEZYFcKIJ5KRNm4bRs4yte/9SzSNfiU=
X-Google-Smtp-Source: ABdhPJz4+ioeA2nP9zgX8fa88ROeI1ZyFyxLz8J8nizj7PhHFLtQKDEM9PXwCV1FqYNWrRydgcUhR8hBHGE4zJATX/A=
X-Received: by 2002:a92:cc50:: with SMTP id t16mr15622736ilq.180.1593745534863;
 Thu, 02 Jul 2020 20:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200702105351.363880-3-vaibhavgupta40@gmail.com> <202007030309.DqqVrhAQ%lkp@intel.com>
In-Reply-To: <202007030309.DqqVrhAQ%lkp@intel.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Fri, 3 Jul 2020 08:33:54 +0530
Message-ID: <CAPBsFfDcugy2=wzd49riVkG+_CZJ01j4i9M44zpdDjGYEHFu8Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] smsc9420: use generic power management
To:     kernel test robot <lkp@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>, bjorn@helgaas.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Jul 2020 at 01:38, kernel test robot <lkp@intel.com> wrote:
>
> Hi Vaibhav,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on linus/master]
> [also build test WARNING on v5.8-rc3 next-20200702]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/smsc-use-generic-power-management/20200702-185914
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git cd77006e01b3198c75fb7819b3d0ff89709539bb
> config: x86_64-allyesconfig (attached as .config)
> compiler: clang version 11.0.0 (https://github.com/llvm/llvm-project 003a086ffc0d1affbb8300b36225fb8150a2d40a)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install x86_64 cross compiling tool for clang build
>         # apt-get install binutils-x86-64-linux-gnu
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>):
>
> >> drivers/net/ethernet/smsc/smsc9420.c:1466:6: warning: variable 'err' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
>            if (netif_running(dev)) {
>                ^~~~~~~~~~~~~~~~~~
>    drivers/net/ethernet/smsc/smsc9420.c:1471:9: note: uninitialized use occurs here
>            return err;
>                   ^~~
>    drivers/net/ethernet/smsc/smsc9420.c:1466:2: note: remove the 'if' if its condition is always true
>            if (netif_running(dev)) {
>            ^~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/net/ethernet/smsc/smsc9420.c:1460:9: note: initialize the variable 'err' to silence this warning
>            int err;
>                   ^
>                    = 0
>    1 warning generated.
>
> vim +1466 drivers/net/ethernet/smsc/smsc9420.c
>
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1456
> 7d465053ec82e2 drivers/net/ethernet/smsc/smsc9420.c Vaibhav Gupta     2020-07-02  1457  static int __maybe_unused smsc9420_resume(struct device *dev_d)
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1458  {
> 7d465053ec82e2 drivers/net/ethernet/smsc/smsc9420.c Vaibhav Gupta     2020-07-02  1459          struct net_device *dev = dev_get_drvdata(dev_d);
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1460          int err;
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1461
> 7d465053ec82e2 drivers/net/ethernet/smsc/smsc9420.c Vaibhav Gupta     2020-07-02  1462          pci_set_master(to_pci_dev(dev_d));
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1463
> 7d465053ec82e2 drivers/net/ethernet/smsc/smsc9420.c Vaibhav Gupta     2020-07-02  1464          device_wakeup_disable(dev_d);
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1465
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11 @1466          if (netif_running(dev)) {
> b5a80837b7e125 drivers/net/ethernet/smsc/smsc9420.c Francois Romieu   2012-03-09  1467                  /* FIXME: gross. It looks like ancient PM relic.*/
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1468                  err = smsc9420_open(dev);
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1469                  netif_device_attach(dev);
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1470          }
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1471          return err;
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1472  }
> 2cb377283f3469 drivers/net/smsc9420.c               Steve Glendinning 2008-12-11  1473
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Fixed. Thanks!
-- Vaibhav Gupta
