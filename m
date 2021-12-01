Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECA8464DD1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 13:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349230AbhLAM2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 07:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349118AbhLAM20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 07:28:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A14CC061574;
        Wed,  1 Dec 2021 04:24:58 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x6so100533121edr.5;
        Wed, 01 Dec 2021 04:24:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uB7rX2jWfilMdBbeOa95YRQNN9ifr/NBDq+w5QSmytg=;
        b=fRZh3Umu1JUc4qm+wiB0W4WbcHCbP+Z0c2mLGvgTKqOv0AjdkZEeCt0CiUzEps9UtJ
         U0spRMguH5mqpfODj1TUYDaOv/QtMCZlxzU8tLFb5Jp9tR2v8hAFsN77AumEUhbnSDpw
         NcbYcP2ezpfWgwicGyRcR8a9CMx/nw5CHdaY9Ze2ZiORpHixX1aVgRqKjzcxuk7kU1ce
         P44vmh9rGKsopj/XxpemADzG7qwPkCwwI30I8ELvR4dNlEzWFsY22/N57IBp1UjJTzjB
         n9es/ivByJrZmvZHCiXAPKtsuORgZgibhMn2X0yB3gS0RxOvFZs4nS3uYyK/Tfnk0FoN
         umzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uB7rX2jWfilMdBbeOa95YRQNN9ifr/NBDq+w5QSmytg=;
        b=NfFU0YIMLXUUVd54uPK6mUSaLm4e/H2jmgNVEipme3Q4dDx8eZCOF3AxMTrj7BI6cH
         y4E/uOjjNZvNvLCJSLzC+Qr3+7oem+7biOV3LZWPKjPCNx6DtJK4lxOogzjjLMgo19iN
         SxzyN/G+KqVhTU/haLtOr38Nn8jzAcxylccvXuLgXKucSQ6BfoPg/r+Pd8E55LYAwXdP
         p61keYPakfWQtipTW5tTxkkZgYdv9lYp6WhygMmsQHfa/SvdJ1kdV7bxWreQmMyIHhu9
         0NzWmmLh/j/rsz3X6rhMMbEYdK5IJ6H2Dp9DhhZoGX3r0cWEOciBuOpBoCTt+r+eavUi
         czkw==
X-Gm-Message-State: AOAM530zzbAfUS0BGxgIj9Dx/wuVqGlhfPUm92heKefAmExjDXSYnALe
        +XXkIO4F5z+PlaocQBVui0jEylTlbccRUZZdG6c=
X-Google-Smtp-Source: ABdhPJysnPpF8MeuZcQ+Z5NGuVld4+I5pdKBDK9GQolx+6iJvoB6yKadZp86gsQuNmCb+1AHpE49pPSFodVgJ7rJUTM=
X-Received: by 2002:aa7:c941:: with SMTP id h1mr8124336edt.319.1638361497040;
 Wed, 01 Dec 2021 04:24:57 -0800 (PST)
MIME-Version: 1.0
References: <20211130042021.869529-1-mudongliangabcd@gmail.com> <202112012029.0sSjB1Bn-lkp@intel.com>
In-Reply-To: <202112012029.0sSjB1Bn-lkp@intel.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Wed, 1 Dec 2021 20:24:31 +0800
Message-ID: <CAD-N9QUZg6k==cf6Jw3Efr608WTt6wkX+eha1Thz1efg3MBmVA@mail.gmail.com>
Subject: Re: [PATCH] dpaa2-eth: add error handling code for dpaa2_eth_dl_register
To:     kernel test robot <lkp@intel.com>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, kbuild-all@lists.01.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 1, 2021 at 8:04 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Dongliang,
>
> Thank you for the patch! Yet something to improve:
>
> [auto build test ERROR on linus/master]
> [also build test ERROR on v5.16-rc3 next-20211201]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Dongliang-Mu/dpaa2-eth-add-error-handling-code-for-dpaa2_eth_dl_register/20211130-122101
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git d58071a8a76d779eedab38033ae4c821c30295a5
> config: arm64-defconfig (https://download.01.org/0day-ci/archive/20211201/202112012029.0sSjB1Bn-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 11.2.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://github.com/0day-ci/linux/commit/8c2f20e67d1f8605b042655d121a18f5ce61faa7
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Dongliang-Mu/dpaa2-eth-add-error-handling-code-for-dpaa2_eth_dl_register/20211130-122101
>         git checkout 8c2f20e67d1f8605b042655d121a18f5ce61faa7
>         # save the config file to linux build tree
>         mkdir build_dir
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/net/
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c: In function 'dpaa2_eth_probe':
> >> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:4465:13: error: void value not ignored as it ought to be
>     4465 |         err = dpaa2_eth_dl_register(priv);
>          |             ^
>

Hi all,

please ignore my stupid patch.

>
> vim +4465 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
>
>   4464
> > 4465          err = dpaa2_eth_dl_register(priv);
>   4466          if (err < 0) {
>   4467                  dev_err(dev, "dpaa2_eth_dl_register failed\n");
>   4468                  goto err_dl_register;
>   4469          }
>   4470          dev_info(dev, "Probed interface %s\n", net_dev->name);
>   4471          return 0;
>   4472
>   4473  err_dl_register:
>   4474  #ifdef CONFIG_DEBUG_FS
>   4475          dpaa2_dbg_remove(priv);
>   4476  #endif
>   4477          unregister_netdev(net_dev);
>   4478  err_netdev_reg:
>   4479          dpaa2_eth_dl_port_del(priv);
>   4480  err_dl_port_add:
>   4481          dpaa2_eth_dl_traps_unregister(priv);
>   4482  err_dl_trap_register:
>   4483          dpaa2_eth_dl_free(priv);
>   4484  err_dl_alloc:
>   4485          dpaa2_eth_disconnect_mac(priv);
>   4486  err_connect_mac:
>   4487          if (priv->do_link_poll)
>   4488                  kthread_stop(priv->poll_thread);
>   4489          else
>   4490                  fsl_mc_free_irqs(dpni_dev);
>   4491  err_poll_thread:
>   4492          dpaa2_eth_free_rings(priv);
>   4493  err_alloc_rings:
>   4494  err_csum:
>   4495  err_netdev_init:
>   4496          free_percpu(priv->sgt_cache);
>   4497  err_alloc_sgt_cache:
>   4498          free_percpu(priv->percpu_extras);
>   4499  err_alloc_percpu_extras:
>   4500          free_percpu(priv->percpu_stats);
>   4501  err_alloc_percpu_stats:
>   4502          dpaa2_eth_del_ch_napi(priv);
>   4503  err_bind:
>   4504          dpaa2_eth_free_dpbp(priv);
>   4505  err_dpbp_setup:
>   4506          dpaa2_eth_free_dpio(priv);
>   4507  err_dpio_setup:
>   4508          dpaa2_eth_free_dpni(priv);
>   4509  err_dpni_setup:
>   4510          fsl_mc_portal_free(priv->mc_io);
>   4511  err_portal_alloc:
>   4512          destroy_workqueue(priv->dpaa2_ptp_wq);
>   4513  err_wq_alloc:
>   4514          dev_set_drvdata(dev, NULL);
>   4515          free_netdev(net_dev);
>   4516
>   4517          return err;
>   4518  }
>   4519
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
