Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5960D20D845
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387468AbgF2Thx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387447AbgF2Tho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:37:44 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B362C03140A;
        Mon, 29 Jun 2020 10:08:24 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i25so18029840iog.0;
        Mon, 29 Jun 2020 10:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frtiYAYIRYzf0c7+OgXqsn5Y4WKcJhLf7MblWKEL3MA=;
        b=KcVKFDX0aWv+4QnWokmKVfaYBiydsC8d4y04AFFqnqRTa8TX66glEnwA4LAx7jrcHO
         aHjNlbLp8Fw7EqJrIE3NblKbq0ItY2uaETkpyHeezSbKT8I/F0tmUjNkeyG9jzVrjMSO
         rJWjqHlIj/YxLkgY/M4hqNysJtlYr/cVXngCANAuqogcbUtjbjSQ95FEl+D/kmhCTsKy
         idEiC55+sejV6tPeFdAePpRZr9pPMufXyF9bpVZ7fQdeWzkD7pc267kvzZghk+1wgj3V
         skFuRFwlVk+WlcCA8THFcmZRPyIC4/MQMmMx8c8NqUXdVzxJMJp5oTrFDmDYVqMgosLK
         2hyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frtiYAYIRYzf0c7+OgXqsn5Y4WKcJhLf7MblWKEL3MA=;
        b=SO0Iq0tcI9GLU//X2XFqrUWkn2LZO372Ms1DxwpguYuzNj67Azd4gjwMtjLEh4C8+o
         wK5s9zu7Z4kQ5B85N1K2RYdKZJVA4O5AUHNXBlgzsZsCou7R12RZrXUqJ4O5KpDAsuqi
         oexeZ1ft3B6PhslWfwola5LVev3/LJ5QHuQJqG99OaJQ4yVSCeEt3vmOxBopNC2IeAB6
         XgLMGQZKFuJvfRuy9zRkKG9I4h+l4JjGccBX0nzwlpT2yTYYtp7svziIuBDfRIw9QRY/
         GeoKO6F0Y/aVglnFpg0L8uuEHdJwS2wiwyVZqHcfbksf9SZeKyhw5TatNjHYiBRG3vgM
         MbJA==
X-Gm-Message-State: AOAM530+ESqpyB0BRhNhrgs20Lndjtj8FoeV4FU1TCaz2jcuV/81Jhkp
        FzQ4iPF5fpWhk8AOXdntz+vORLMrf5PHi97UUDI=
X-Google-Smtp-Source: ABdhPJwM8dA8f98ng1O4Ad9g0kEaSLHoAQus5mbh10axsYJMT/LexW2plXFhLFquWtBxTRJo3Sp3xpOjdyhOkK9dUEM=
X-Received: by 2002:a02:a408:: with SMTP id c8mr19198600jal.59.1593450502896;
 Mon, 29 Jun 2020 10:08:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200629082819.216405-2-vaibhavgupta40@gmail.com> <202006300026.hCr1U7Sc%lkp@intel.com>
In-Reply-To: <202006300026.hCr1U7Sc%lkp@intel.com>
From:   Vaibhav Gupta <vaibhav.varodek@gmail.com>
Date:   Mon, 29 Jun 2020 22:36:45 +0530
Message-ID: <CAPBsFfD8pNFtry605zUs+1uaQi+t8X12iuAiSWbnYqVLDpuBbA@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] qlge/qlge_main.c: use genric power management
To:     kernel test robot <lkp@intel.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>, bjorn@helgaas.com,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kbuild-all@lists.01.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        skhan@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 at 21:39, kernel test robot <lkp@intel.com> wrote:
>
> Hi Vaibhav,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on staging/staging-testing]
> [also build test ERROR on v5.8-rc3 next-20200629]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Vaibhav-Gupta/drivers-staging-use-generic-power-management/20200629-163141
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git 347fa58ff5558075eec98725029c443c80ffbf4a
> config: x86_64-rhel-7.6 (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-13) 9.3.0
> reproduce (this is a W=1 build):
>         # save the attached .config to linux build tree
>         make W=1 ARCH=x86_64
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/staging/qlge/qlge_main.c: In function 'qlge_resume':
> >> drivers/staging/qlge/qlge_main.c:4793:17: error: 'pdev' undeclared (first use in this function); did you mean 'qdev'?
>     4793 |  pci_set_master(pdev);
>          |                 ^~~~
>          |                 qdev
>    drivers/staging/qlge/qlge_main.c:4793:17: note: each undeclared identifier is reported only once for each function it appears in
>
> vim +4793 drivers/staging/qlge/qlge_main.c
>
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4786
> 1aed508211e137 drivers/staging/qlge/qlge_main.c Vaibhav Gupta 2020-06-29  4787  static int __maybe_unused qlge_resume(struct device *dev_d)
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4788  {
> 1aed508211e137 drivers/staging/qlge/qlge_main.c Vaibhav Gupta 2020-06-29  4789          struct net_device *ndev = dev_get_drvdata(dev_d);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4790          struct ql_adapter *qdev = netdev_priv(ndev);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4791          int err;
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4792
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18 @4793          pci_set_master(pdev);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4794
> 1aed508211e137 drivers/staging/qlge/qlge_main.c Vaibhav Gupta 2020-06-29  4795          device_wakeup_disable(dev_d);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4796
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4797          if (netif_running(ndev)) {
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4798                  err = ql_adapter_up(qdev);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4799                  if (err)
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4800                          return err;
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4801          }
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4802
> 72046d84f0d6e3 drivers/net/qlge/qlge_main.c     Breno Leitao  2010-07-01  4803          mod_timer(&qdev->timer, jiffies + (5 * HZ));
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4804          netif_device_attach(ndev);
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4805
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4806          return 0;
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4807  }
> c4e84bde1d595d drivers/net/qlge/qlge_main.c     Ron Mercer    2008-09-18  4808
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
This is a genuine error. I remember taking care of it when I upgraded
the driver.
Must have been caused by some unnoticed reverts at my side.

I will fix it and send a v2 patch-set. Thanks for reporting.

-- Vaibhav gupta
