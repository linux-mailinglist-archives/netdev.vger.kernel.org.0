Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E9179FCE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 07:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgCEGKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 01:10:46 -0500
Received: from mail-vi1eur05on2063.outbound.protection.outlook.com ([40.107.21.63]:6129
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725839AbgCEGKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 01:10:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADmzXz3si0Xc1IOIvddPwa5IW81Uz56oJH5cga2qNenbr76lnfhfJ5nPZZnVCvcjOkgoDJHjSeF9lv7c1F8wgrdDwNeEFhiUq8UG0tpVc3Q/EPXHrSaTNUU3zN6XteaagpfswKIINc6VQ6U6eTkPgA8Mp9vIIBNqz5BViWiI0CQFnzhAU7VyFH3M/dQEuKCC6pEZIgYBRKfYCacg51vzlZlEu/LwxziGFJO+Ru9BMnkeTM+A2zFOzqYTDX6R/LwifwidVtJwqkolmjALmexBkb//x5xGBen9eApcr+5Piy5AvOyncx0dj6NDBqXZeweZ1CmsR4PMsSWgRN/fIUAvUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzBUgV3YWqOlDPB9z5Y4Sa7NvgP4blbN4kiW3Svl5dQ=;
 b=GXUU/SvZbjU+1tR10fWWuBLk37Y2qNq4vv4qLW96uoD3J+VyRwOKJ7jtcYV9U6zwLZo1nctnVpBWM5QIu0qezwB/yDenHaOZ/s9q7pGKlrK3NEEYDDbPa5N+sHMZYQ4h5nCFkYcT3cJY5M98Ba9/lK+kln7Zu2zcvI4BY85z9v1fXBFUbtj+t/DTxDfvzgNk+FBP32c+dPtompZNDzRrKAA1/oBZ4j1ou0nq64Y2/uPOwJuuEYUmEWqwiwr6EtfUDeHVjUoQt2kle42QxotQOXVuDZg+pJJTIwcUFsj9R7W1N5QfhnZW4KXKzo1nHkEgenqrDUiq7lEK9roSGQwAJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzBUgV3YWqOlDPB9z5Y4Sa7NvgP4blbN4kiW3Svl5dQ=;
 b=WFWKKUrvrW+dgXUUq+zPtLkgAb8V4vcHIlffudYLRJZh7vNwVSZWBwv9g8+9wdBVd1fMyt+LiGBWKHUv6tPswLJnqhxIIwcpDWL54hsLOxniBWF9mRQLul10ifglE0+MYliA1XFfxllx+qUGbcfjI4TfNJ47psGG9jSSt9qBR3M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB5911.eurprd05.prod.outlook.com (20.179.0.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Thu, 5 Mar 2020 06:10:42 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 06:10:42 +0000
Date:   Thu, 5 Mar 2020 08:10:39 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 8/8] ionic: drop ethtool driver version
Message-ID: <20200305061039.GP121803@unreal>
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-9-snelson@pensando.io>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305052319.14682-9-snelson@pensando.io>
X-ClientProxiedBy: FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13)
 To AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by FRYP281CA0003.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Thu, 5 Mar 2020 06:10:41 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9d2488c4-5094-4542-610f-08d7c0cbef0b
X-MS-TrafficTypeDiagnostic: AM6PR05MB5911:
X-Microsoft-Antispam-PRVS: <AM6PR05MB591152C03A2D2C9576A2CDFAB0E20@AM6PR05MB5911.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(366004)(396003)(346002)(39860400002)(136003)(376002)(189003)(199004)(66556008)(478600001)(66476007)(6496006)(66946007)(2906002)(8676002)(81166006)(52116002)(966005)(81156014)(9686003)(956004)(316002)(4326008)(26005)(6916009)(5660300002)(6486002)(186003)(1076003)(33716001)(16526019)(8936002)(33656002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5911;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4XdB7SIXzQt5XmB5G8qygqvOQ/o/2fQ2IcU5zvR6cTwnYtShWTyP7LfY0oUuuOPVUz+EGt54zmy2IGQrKznLvPIIfdANjbCRwDOrIvsrdOe2qhNiONTkCsTaG3z/cwc87mUDNO8JVKckm1NZ42e2czPsb96BkBxJdYr+86LKOJJI2SkJdLrCyfQ+wvBr0jkEjgsgRMvzxOU+DVepUmNRmmcSLkDGpF52Aj5uJ8L4WvlZ08pIMrTybWHpMhY++nfv6QVZ6w6cTX221iZrt5DrF/CwLSDP7Zc3WWUgakKL/HkiGwJgFMykXcfknyU13SzSAix6UlHleKev6vps1dBFMPMmfM1oNJsBvHALHFVaWh6yWkSv8Jmk1goi/pSI8xOLiNK+gUCgAEeBvveUfFkClSs/4byY0HpAtG3yOU7NMT8tGwuHNRyb4JWrUvMOM5hITrDTaYBBkAmYxS8B365JllhNw87YjhisaG8/DNa6fkHp+cqE5ixBl5Zz7OFT28l6iSvuQaPTOQQMlNaUiAyu8A==
X-MS-Exchange-AntiSpam-MessageData: FaAiMBi2mybwx/bKPzgyBFFMU2RC6Cn5DFOBP7LcmAmaeopHv9iPyKO6m/4lcbv+fTrpnNkrKZkXlHhBo2mM8rApqEDmQ8WAPz2GO7chSosr6zDZzBgEcUUuYLnetnH99Y30Eudhvp2rTeKhjJRfZw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d2488c4-5094-4542-610f-08d7c0cbef0b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 06:10:42.1156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wwc12PJWbLou8Tmu9DGDUe+QGBkGlfUqemRua3FKuKI9envMnkhdtR4NeJaZWFdbj2DiSPObQLlQhSnk8ELbLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5911
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 09:23:19PM -0800, Shannon Nelson wrote:
> Use the default kernel version in ethtool drv_info output
> and drop the module version.
>
> Cc: Leon Romanovsky <leonro@mellanox.com>
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
>  drivers/net/ethernet/pensando/ionic/ionic_main.c    | 6 ++----
>  3 files changed, 2 insertions(+), 6 deletions(-)
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
> index a8e3fb73b465..e4a76e66f542 100644
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

i see that you responded to my question about usage of this string [1]
and I can't say anything about netdev policy on that, but in other
subsystems, the idea that driver has duplicated debug functionalities
to the general kernel code is not welcomed.

[1] https://lore.kernel.org/netdev/e0cbc84c-7860-abf2-a622-4035be1479dc@pensando.io

>
>  	mutex_lock(&ionic->dev_cmd_lock);
> @@ -558,8 +558,6 @@ int ionic_port_reset(struct ionic *ionic)
>
>  static int __init ionic_init_module(void)
>  {
> -	pr_info("%s %s, ver %s\n",
> -		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
>  	ionic_debugfs_create();
>  	return ionic_bus_register_driver();
>  }
> --
> 2.17.1
>
