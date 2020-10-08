Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3062C287542
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730309AbgJHNcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 09:32:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40776 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgJHNcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 09:32:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098DUHoM176218;
        Thu, 8 Oct 2020 13:31:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=LEcGUa9H22JKnvVtH9cPX8MBnaEg/xzcx57mkd/XIwI=;
 b=Bd1WtwE5A8yoYdXEyLX4rxWReQ9p28v9Tq8TMIDOGICNCc8dj2jG4yUeXcMiFfZU1py3
 NLYadlN1YLzZ0xIgaPqcbQCoiBGHIkOJ/zMI5vmSW36oAvjj2f57U91RDvjM2edsAxYe
 svNDmr+0SQKnJsw1VsyeVDJtTyOyBOSi5nXAfJ26+mY3C2IwVIYAJicRW0Ze1+eYHhhv
 jjYuCl5z/jv3rEa36E/Jd/E0nFicNkXBCBdE8ecQW1dIueX7IYeAbmd+qiDOT1yo2E2V
 iVCAJVD0qlIaBaxnivQjMeVPhCfQD2x5B93vdK9T/OWf99UiDhgH7sWWqPrFZiAO6YME 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 33xetb7tvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 08 Oct 2020 13:31:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 098DVMDO180208;
        Thu, 8 Oct 2020 13:31:52 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vr1ubh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Oct 2020 13:31:52 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 098DVoOE029735;
        Thu, 8 Oct 2020 13:31:50 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 08 Oct 2020 06:31:49 -0700
Date:   Thu, 8 Oct 2020 16:31:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        open list <linux-kernel@vger.kernel.org>,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 1/6] staging: qlge: Initialize devlink health dump
 framework for the dlge driver
Message-ID: <20201008133142.GB1042@kadam>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-2-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008115808.91850-2-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=2 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010080101
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9767 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=2 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010080101
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 07:58:03PM +0800, Coiby Xu wrote:
> Initialize devlink health dump framework for the dlge driver so the
> coredump could be done via devlink.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/Kconfig        |  1 +
>  drivers/staging/qlge/Makefile       |  2 +-
>  drivers/staging/qlge/qlge.h         |  9 +++++++
>  drivers/staging/qlge/qlge_devlink.c | 38 +++++++++++++++++++++++++++++
>  drivers/staging/qlge/qlge_devlink.h |  8 ++++++
>  drivers/staging/qlge/qlge_main.c    | 28 +++++++++++++++++++++
>  6 files changed, 85 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/staging/qlge/qlge_devlink.c
>  create mode 100644 drivers/staging/qlge/qlge_devlink.h
> 
> diff --git a/drivers/staging/qlge/Kconfig b/drivers/staging/qlge/Kconfig
> index a3cb25a3ab80..6d831ed67965 100644
> --- a/drivers/staging/qlge/Kconfig
> +++ b/drivers/staging/qlge/Kconfig
> @@ -3,6 +3,7 @@
>  config QLGE
>  	tristate "QLogic QLGE 10Gb Ethernet Driver Support"
>  	depends on ETHERNET && PCI
> +	select NET_DEVLINK
>  	help
>  	This driver supports QLogic ISP8XXX 10Gb Ethernet cards.
>  
> diff --git a/drivers/staging/qlge/Makefile b/drivers/staging/qlge/Makefile
> index 1dc2568e820c..07c1898a512e 100644
> --- a/drivers/staging/qlge/Makefile
> +++ b/drivers/staging/qlge/Makefile
> @@ -5,4 +5,4 @@
>  
>  obj-$(CONFIG_QLGE) += qlge.o
>  
> -qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o
> +qlge-objs := qlge_main.o qlge_dbg.o qlge_mpi.o qlge_ethtool.o qlge_devlink.o
> diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
> index b295990e361b..290e754450c5 100644
> --- a/drivers/staging/qlge/qlge.h
> +++ b/drivers/staging/qlge/qlge.h
> @@ -2060,6 +2060,14 @@ struct nic_operations {
>  	int (*port_initialize)(struct ql_adapter *qdev);
>  };
>  
> +
> +

Having multiple blank lines in a row leads to a static checker warning.
Please run `checkpatch.pl --strict` over your patches.

> +struct qlge_devlink {
> +        struct ql_adapter *qdev;
> +        struct net_device *ndev;
> +        struct devlink_health_reporter *reporter;
> +};
> +
>  /*
>   * The main Adapter structure definition.
>   * This structure has all fields relevant to the hardware.
> @@ -2077,6 +2085,7 @@ struct ql_adapter {
>  	struct pci_dev *pdev;
>  	struct net_device *ndev;	/* Parent NET device */
>  
> +	struct qlge_devlink *ql_devlink;
>  	/* Hardware information */
>  	u32 chip_rev_id;
>  	u32 fw_rev_id;
> diff --git a/drivers/staging/qlge/qlge_devlink.c b/drivers/staging/qlge/qlge_devlink.c
> new file mode 100644
> index 000000000000..aa45e7e368c0
> --- /dev/null
> +++ b/drivers/staging/qlge/qlge_devlink.c
> @@ -0,0 +1,38 @@
> +#include "qlge.h"
> +#include "qlge_devlink.h"
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

Indented too far.

> +};
> +
> +int qlge_health_create_reporters(struct qlge_devlink *priv)
> +{
> +	int err;
> +

No blanks in the middle of declarations.

> +	struct devlink_health_reporter *reporter;
> +	struct devlink *devlink;

Generally this driver declares variables in "Reverse Christmas Tree"
order.  The names are orderred by the length of the line from longest
to shortest.

	type long_name;
	type medium;
	type short;

> +
> +	devlink = priv_to_devlink(priv);
> +	reporter =
> +		devlink_health_reporter_create(devlink, &qlge_reporter_ops,
> +					       0,
> +					       priv);

Break this up like so:

	reporter = devlink_health_reporter_create(devlink, &qlge_reporter_ops,
						  0, priv);


> +	if (IS_ERR(reporter)) {
> +		netdev_warn(priv->ndev,
> +			    "Failed to create reporter, err = %ld\n",
> +			    PTR_ERR(reporter));
> +		return PTR_ERR(reporter);

No point in returning an error if the caller doesn't check?

> +	}
> +	priv->reporter = reporter;
> +
> +	return err;

err is uninitialized.  "return 0;"

> +}
> diff --git a/drivers/staging/qlge/qlge_devlink.h b/drivers/staging/qlge/qlge_devlink.h
> new file mode 100644
> index 000000000000..c91f7a29e805
> --- /dev/null
> +++ b/drivers/staging/qlge/qlge_devlink.h
> @@ -0,0 +1,8 @@
> +#ifndef QLGE_DEVLINK_H
> +#define QLGE_DEVLINK_H
> +
> +#include <net/devlink.h>
> +
> +int qlge_health_create_reporters(struct qlge_devlink *priv);
> +
> +#endif /* QLGE_DEVLINK_H */
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 27da386f9d87..135225530e51 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -42,6 +42,7 @@
>  #include <net/ip6_checksum.h>
>  
>  #include "qlge.h"
> +#include "qlge_devlink.h"
>  
>  char qlge_driver_name[] = DRV_NAME;
>  const char qlge_driver_version[] = DRV_VERSION;
> @@ -4549,6 +4550,8 @@ static void ql_timer(struct timer_list *t)
>  	mod_timer(&qdev->timer, jiffies + (5 * HZ));
>  }
>  
> +static const struct devlink_ops qlge_devlink_ops;
> +
>  static int qlge_probe(struct pci_dev *pdev,
>  		      const struct pci_device_id *pci_entry)
>  {
> @@ -4556,6 +4559,13 @@ static int qlge_probe(struct pci_dev *pdev,
>  	struct ql_adapter *qdev = NULL;
>  	static int cards_found;
>  	int err = 0;
> +	struct devlink *devlink;
> +	struct qlge_devlink *ql_devlink;
> +
> +	devlink = devlink_alloc(&qlge_devlink_ops, sizeof(struct qlge_devlink));
> +	if (!devlink)
> +		return -ENOMEM;
> +	ql_devlink = devlink_priv(devlink);
>  
>  	ndev = alloc_etherdev_mq(sizeof(struct ql_adapter),
>  				 min(MAX_CPUS,
> @@ -4614,6 +4624,16 @@ static int qlge_probe(struct pci_dev *pdev,
>  		free_netdev(ndev);
>  		return err;
>  	}
> +
> +	err = devlink_register(devlink, &pdev->dev);
> +	if (err) {
> +		goto devlink_free;
> +	}

Checkpatch warning.

regards,
dan carpenter

