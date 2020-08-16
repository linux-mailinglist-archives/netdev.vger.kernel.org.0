Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA290245581
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 04:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbgHPC4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 22:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729929AbgHPC4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Aug 2020 22:56:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8071FC061786;
        Sat, 15 Aug 2020 19:56:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m71so6458228pfd.1;
        Sat, 15 Aug 2020 19:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nxRS4sovf6GjtcJdjWXmM4G6i1tYTrf7XYtnALv+02A=;
        b=u+OpWrD0xShZqRnowsZ+j9C/wDb3pI7Q2Lhmozbz+U68ef/uIpJcUza/iUSjp8zdvt
         B+vgWw2uhMcFfLZT9iSMKLFqBhRked1h7xYwspPP3S4Nd5xWzPv2knbmYcLe/nLOZmco
         1q2OG1Rw4sHkfXzmsiUXhxhfbZSdqp6kT5ZtLjDzmEfAzfo6zQTCGLY7mgS2vRbxx/DT
         cqZ4BxubTiD1QmpMfX+YoxCPuPv6FLIYQRaUyktClAQ/bcYj6OzZH4ecCK5GjKM21WCi
         tI0adCL8Qk3NkY6E+yNskpLyAg/KhcWFfWATX1q47nHa9Ot2GFD51gEYJZDjPHR+BY0A
         1/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nxRS4sovf6GjtcJdjWXmM4G6i1tYTrf7XYtnALv+02A=;
        b=HcaE6qt+3g+msQqbxhB8zjY/Pg0+9bzTVqF0Y7mS0dtwOu2NtQMKqXdloa8qzyHV+G
         r7+BsUiMsBKc3KLe6E34xxRlBswrO1i0eBrDxkaNnG2QOre0Rx6RdCx5R7jg/nLULGvr
         H0aDtxP7mGCjU8KNZ+YpuvLjMMySRxtkOjFwHerybqbNkUTPGFSPRzRqEGW7YD1AfO8L
         igQgTSaKIr/qqhiRLQcAnygOisQG7ZgtvGpzhgiuduySBCvCy1ahCqadLzEdcnFRI4OP
         ecSnWSHFTwB/KDGL1zI7i/vYrkpl+0rFvIhtrWWGDsvhSm6RZZfzzqScIm1WrU17j0Ht
         oL8Q==
X-Gm-Message-State: AOAM531CeH+i5suI4Deq1Xv4YNE188wTezrh7fcVDRL06augvawo9/Ia
        uQgVZzO3phT8AXqdUBrMyDI=
X-Google-Smtp-Source: ABdhPJyT/sTWHOZi9Lnw9jLyJtS7mOlgCDSJuClYdBR63itdEpMGQLJWxxZq1NnqawqJhGrCpLX04Q==
X-Received: by 2002:a62:1ad0:: with SMTP id a199mr7068906pfa.56.1597546606564;
        Sat, 15 Aug 2020 19:56:46 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id w7sm13597208pfi.164.2020.08.15.19.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Aug 2020 19:56:44 -0700 (PDT)
Date:   Sun, 16 Aug 2020 11:56:40 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>
Subject: Re: [RFC 1/3] Initialize devlink health dump framework for the dlge
 driver
Message-ID: <20200816025640.GA27529@f3>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
 <20200814160601.901682-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814160601.901682-2-coiby.xu@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-15 00:05 +0800, Coiby Xu wrote:
> Initialize devlink health dump framework for the dlge driver so the
> coredump could be done via devlink.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/Makefile      |  2 +-
>  drivers/staging/qlge/qlge.h        |  9 +++++++
>  drivers/staging/qlge/qlge_health.c | 43 ++++++++++++++++++++++++++++++
>  drivers/staging/qlge/qlge_health.h |  2 ++
>  drivers/staging/qlge/qlge_main.c   | 21 +++++++++++++++
>  5 files changed, 76 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/qlge/qlge_health.c
>  create mode 100644 drivers/staging/qlge/qlge_health.h
> 
> diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
> index 1dc2568e820c..0a1e4c8dd546 100644
> --- a/drivers/staging/qlge/Makefile
> +++ b/drivers/staging/qlge/Makefile
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_QLGE) += qlge.o
>  
> -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
> +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_health.o
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index fc8c5ca8935d..055ded6dab60 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2061,6 +2061,14 @@ struct nic_operations {
>  	int (*port_initialize) (struct ql_adapter *);
>  };
>  

This patch doesn't apply over the latest staging tree. I think your tree
is missing commit d923bb6bf508 ("staging: qlge: qlge.h: Function
definition arguments should have names.")

> +
> +
> +struct qlge_devlink {
> +        struct ql_adapter *qdev;
> +        struct net_device *ndev;

I don't have experience implementing devlink callbacks but looking at
some other devlink users (mlx4, ionic, ice), all of them use devlink
priv space for their main private structure. That would be struct
ql_adapter in this case. Is there a good reason to stray from that
pattern?

> +        struct devlink_health_reporter *reporter;
> +};
> +
>  /*
>   * The main Adapter structure definition.
>   * This structure has all fields relevant to the hardware.
> @@ -2078,6 +2086,7 @@ struct ql_adapter {
>  	struct pci_dev *pdev;
>  	struct net_device *ndev;	/* Parent NET device */
>  
> +	struct qlge_devlink *devlink;
>  	/* Hardware information */
>  	u32 chip_rev_id;
>  	u32 fw_rev_id;
> diff --git a/drivers/staging/qlge/qlge_health.c b/drivers/staging/qlge/qlge_health.c
> new file mode 100644
> index 000000000000..292f6b1827e1
> --- /dev/null
> +++ b/drivers/staging/qlge/qlge_health.c
> @@ -0,0 +1,43 @@
> +#include "qlge.h"
> +#include "qlge_health.h"
> +
> +static int
> +qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> +			struct devlink_fmsg *fmsg, void *priv_ctx,
> +			struct netlink_ext_ack *extack)
> +{
> +	return 0;
> +}
> +
> +static const struct devlink_health_reporter_ops qlge_reporter_ops = {
> +		.name = "dummy",
> +		.dump = qlge_reporter_coredump,
> +};

I think
	select NET_DEVLINK
should be added to drivers/staging/qlge/Kconfig

> +
> +int qlge_health_create_reporters(struct qlge_devlink *priv)
> +{
> +	int err;
> +
> +	struct devlink_health_reporter *reporter;
> +	struct devlink *devlink;
> +
> +	devlink = priv_to_devlink(priv);
> +	reporter =
> +		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
> +					       0,
> +					       priv);
> +	if (IS_ERR(reporter)) {
> +		netdev_warn(priv->ndev,
> +			    "Failed to create reporter, err = %ld\n",
> +			    PTR_ERR(reporter));
> +		return PTR_ERR(reporter);
> +	}
> +	priv->reporter = reporter;
> +
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +

Stray newlines

> diff --git a/drivers/staging/qlge/qlge_health.h b/drivers/staging/qlge/qlge_health.h
> new file mode 100644
> index 000000000000..07d3bafab845
> --- /dev/null
> +++ b/drivers/staging/qlge/qlge_health.h
> @@ -0,0 +1,2 @@
> +#include <net/devlink.h>
> +int qlge_health_create_reporters(struct qlge_devlink *priv);

I would suggest to put this in qlge.h instead of creating a new file.

> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 1650de13842f..b2be7f4b7dd6 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -42,6 +42,7 @@
>  #include <net/ip6_checksum.h>
>  
>  #include "qlge.h"
> +#include "qlge_health.h"
>  
>  char qlge_driver_name[] = DRV_NAME;
>  const char qlge_driver_version[] = DRV_VERSION;
> @@ -4550,6 +4551,8 @@ static void ql_timer(struct timer_list *t)
>  	mod_timer(&qdev->timer, jiffies + (5 * HZ));
>  }
>  
> +static const struct devlink_ops qlge_devlink_ops;
> +
>  static int qlge_probe(struct pci_dev *pdev,
>  		      const struct pci_device_id *pci_entry)
>  {
> @@ -4557,6 +4560,13 @@ static int qlge_probe(struct pci_dev *pdev,
>  	struct ql_adapter *qdev = NULL;
>  	static int cards_found;
>  	int err = 0;
> +	struct devlink *devlink;
> +	struct qlge_devlink *qlge_dl;
> +
> +	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
> +	if (!devlink)
> +		return -ENOMEM;
> +	qlge_dl = devlink_priv(devlink);
>  
>  	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>  				 min(MAX_CPUS,
> @@ -4615,6 +4625,15 @@ static int qlge_probe(struct pci_dev *pdev,
>  		free_netdev(ndev);
>  		return err;
>  	}
> +
> +	err = devlink_register(devlink, &pdev->dev);
> +	if (err)
> +		devlink_free(devlink);

Are you sure it's safe to continue devlink init after an error here?
Again, that does not resemble usage of devlink in other drivers (ex.
bnxt).

> +
> +	qlge_health_create_reporters(qlge_dl);
> +	qlge_dl->qdev = qdev;
> +	qlge_dl->ndev = ndev;
> +	qdev->devlink = qlge_dl;
>  	/* Start up the timer to trigger EEH if
>  	 * the bus goes dead
>  	 */
> @@ -4647,6 +4666,8 @@ static void qlge_remove(struct pci_dev *pdev)
>  	unregister_netdev(ndev);
>  	ql_release_all(pdev);
>  	pci_disable_device(pdev);
> +	devlink_unregister(priv_to_devlink(qdev->devlink));
> +	devlink_health_reporter_destroy(qdev->devlink->reporter);

Isn't the order of those two calls mixed up?

>  	free_netdev(ndev);
>  }
>  
> -- 
> 2.27.0
> 
