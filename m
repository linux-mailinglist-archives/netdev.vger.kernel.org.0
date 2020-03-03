Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 753B4176F85
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 07:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgCCGfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 01:35:18 -0500
Received: from mail-vi1eur05on2066.outbound.protection.outlook.com ([40.107.21.66]:6160
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725554AbgCCGfS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 01:35:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTAlGcsRS1uV0vMErSDNbkfNs9yvhv9+n5jTvzHIJoriHLuHBivEpr/ffI3bbKHpwHz6DAL1eoFluBF7Vd9EU2JX5p39RqmSwn5Jn8BQOGb9YTo8PaTa5TG6K8pe3nJUvLxLp6UNZzlIbGDpxMwGJR+BRR2vecRM23F9s+r1FhkLbzRHw6Hu6CErKtD6lPFCM3ueYuxcaMcCN9/bM79pHXA51tpzPozoNUPqbaDNPjFSUoybrofFOeYT6wr2BBRYlxK++ZHpyCT6FWegPzqVgjkOqPGHSj+PJ9iTecgAm8TcmBDJhSmRIuoY3tpbbyA/+Pnp3Opi6iz7+w8hLIHuTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuLMqbtdEx9NxLgjs4egcukLuPMIyw7kGprsvUyUtj8=;
 b=E6J3gVxU1rrn2pMzDJ/lLeaQ/BQnNoAOsXRxX9e88TLvj27XCcI/Ml9swol8XIx7susumW3Ux0Qgj7RzmrUTsXCY1DYKYSCmVtsb89j5GC4ljcWnjh6LkCCwLusgtKavOAokb/LsfJrj5QL4C35dI5aCs/HKIxeAMkpcmBkhR7ikGA/Ub7aC2vJ9zdRj2zf16uzwVtXUsyW4LOsLvFL80cpl5z/ihQE0cf8Nh4TkMnqGiLEWKCP70OKWQtE6ofHPzOyQhA069klb4TqdbgI59Twdu+8UlmfCI1Md2iikHSpYrU55xwhG03ljKe5rkW738WvhfVDyv0AmospNgdw8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuLMqbtdEx9NxLgjs4egcukLuPMIyw7kGprsvUyUtj8=;
 b=TW9rMyVHsAdS0E+XU6NBUVNQ4IgtKYqFL/EJeeoi2ltWLHufCi0TkUTGnUwKBF5MBwN3zWmZfl1RO1RwRIGZ2O/B5XhdhMwWjZUeU9sg+dgiTpcd5l2deNnk0XL4BdbYjaW9IBMmPiTyWgA1AbOy0t0Vy5VEQb/EV0S9Er/XreM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6359.eurprd05.prod.outlook.com (20.179.5.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.16; Tue, 3 Mar 2020 06:35:11 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 06:35:11 +0000
Date:   Tue, 3 Mar 2020 08:35:09 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] ionic: drop ethtool driver version
Message-ID: <20200303063509.GD121803@unreal>
References: <20200303041545.1611-1-snelson@pensando.io>
 <20200303041545.1611-9-snelson@pensando.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303041545.1611-9-snelson@pensando.io>
X-ClientProxiedBy: AM0PR0102CA0013.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::26) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM0PR0102CA0013.eurprd01.prod.exchangelabs.com (2603:10a6:208:14::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Tue, 3 Mar 2020 06:35:11 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15429ccc-3ccd-4a44-76f4-08d7bf3d0629
X-MS-TrafficTypeDiagnostic: AM6PR05MB6359:
X-Microsoft-Antispam-PRVS: <AM6PR05MB63594B1854D9B8FD44ED3244B0E40@AM6PR05MB6359.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(366004)(189003)(199004)(6496006)(4326008)(33656002)(6486002)(498600001)(52116002)(86362001)(33716001)(2906002)(8936002)(81166006)(8676002)(81156014)(5660300002)(9686003)(26005)(66946007)(6916009)(66476007)(1076003)(66556008)(186003)(16526019)(956004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6359;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 22QKHt2ZnhBwBlo5kuVKnsIMOlUdunl57Uwz6sOGCD4+l+cWDAar780UERaIxZ/ifvRSYk4CecY0M/Xv1ScbS85d6BBGVEuu8yQHn5cOuK1QBusrw9wH0v8Gzo2MUW4HDQPedXwwaUJ+bmjfJNqYtFtxr4MV1rv4nJLRiv4NWdo9XYGz8McXNosimmB2JhLQ9P+tuhqFiC3pGSlSyDlueagwgvUI6ruxhmow+zFe4JWlNwjkbZ+o0KDRYdeuOz8D+ky7DX2CyO3BJSe8mBMmZDgN2rx+ZQL/hLydZ5E9UoFsPe0whL1suZcwMMvg8mDBdE8zYEuLAH36PwfnXE8VEjCAx4xPujR2G1Boa7qx84TixjwCcFLjpMUtwOaqMH/Q20mGT4tM4IlaAl60UJF7Fxc2kiKllbkQH6MRTZznSH/BmmoeR+cgUAT5u6vBZWov
X-MS-Exchange-AntiSpam-MessageData: FOnYhZUFCx8ymXe+hHmdT5ZA7JHj5yI1PGfT8ari6XJlSfSXf3nE7e4wp0bwiM9lyKWPcwSKbaugRJErnRTxWUTe4PR+tTV6FMSkKaWn14GYhZfWNVlyzSn8YZGOU9ZH1Oz0MM5gN7dITVEyZDxoEQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15429ccc-3ccd-4a44-76f4-08d7bf3d0629
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 06:35:11.4934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q+UVI5Jq4vb7YVgDn6TNcjFhVbwPTgaCfpLB6gZDVlCvIzsGKvruxoGlsPjAklNxfAnp4dnVBOKsvja18w4MBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6359
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 08:15:45PM -0800, Shannon Nelson wrote:
> Use the default kernel version in ethtool drv_info output
> and drop the module version.
>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_main.c    | 7 +++----
>  3 files changed, 3 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
> index c8ff33da243a..1c720759fd80 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> @@ -12,7 +12,6 @@ struct ionic_lif;
>
>  #define IONIC_DRV_NAME		"ionic"
>  #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
> -#define IONIC_DRV_VERSION	"0.20.0-k"
>
>  #define PCI_VENDOR_ID_PENSANDO			0x1dd8
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> index acd53e27d1ec..bea9b78e0189 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> @@ -86,7 +86,6 @@ static void ionic_get_drvinfo(struct net_device *netdev,
>  	struct ionic *ionic = lif->ionic;
>
>  	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
> -	strlcpy(drvinfo->version, IONIC_DRV_VERSION, sizeof(drvinfo->version));
>  	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
>  		sizeof(drvinfo->fw_version));
>  	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index a8e3fb73b465..5428af885fa7 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -6,6 +6,7 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/utsname.h>
> +#include <linux/vermagic.h>
>
>  #include "ionic.h"
>  #include "ionic_bus.h"
> @@ -15,7 +16,6 @@
>  MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
>  MODULE_AUTHOR("Pensando Systems, Inc");
>  MODULE_LICENSE("GPL");
> -MODULE_VERSION(IONIC_DRV_VERSION);
>
>  static const char *ionic_error_to_str(enum ionic_status_code code)
>  {
> @@ -414,7 +414,7 @@ int ionic_identify(struct ionic *ionic)
>  	memset(ident, 0, sizeof(*ident));
>
>  	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
> -	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
> +	strncpy(ident->drv.driver_ver_str, UTS_RELEASE,
>  		sizeof(ident->drv.driver_ver_str) - 1);

Strange, I see that you are issuing command IONIC_CMD_IDENTIFY with this
data, doesn't the other side expect specific format? Can I send any
string here? and what will be result?

>
>  	mutex_lock(&ionic->dev_cmd_lock);
> @@ -558,8 +558,7 @@ int ionic_port_reset(struct ionic *ionic)
>
>  static int __init ionic_init_module(void)
>  {
> -	pr_info("%s %s, ver %s\n",
> -		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
> +	pr_info("%s %s\n", IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION);

While cleaning from driver versions, we are removing such code too.
It is done for three reasons:
1. In case of success, there is no need in dmesg to know about the fact
that driver is going to be up.
2. In case of failure, there will/should be error prints.
3. There are so many options to know about execution of every function
and module init/exit that extra print is definitely useless.

Thanks

>  	ionic_debugfs_create();
>  	return ionic_bus_register_driver();
>  }
> --
> 2.17.1
>
