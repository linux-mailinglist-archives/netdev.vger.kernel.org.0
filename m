Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC3E17A0B7
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgCEHwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:52:25 -0500
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:63424
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbgCEHwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 02:52:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpB+giYdMWNqIua2pCnEFJ2hgeO4LB3ErL2lcvbmWcKlW6W2MDqlsAXbXtQ2M1c/inoHS3kHXsnNl/m0LyHE5MaxgW10JKYiKFQ013Uj26sO3inik+2La++PlhyDPUahg3VkVaM4qjkaEKP7hdbiJZ2X4A0NA2bRWaGVKW8ZXn/JruJY5Q+G2tqD+iGG3pPAoaJRNnV9uRA1bmh7cqW0nLAjKUdcAE4rdDSW0IpCfv7DYa2/zLbu47zwGU28DokbgPq1oULdQlXT87qJbMcl0M94kFfuL6eJIjvKi/Ilo9jw5cwpJDwr/8RvScOIdCcnOuj2y5e/wHlK+X94SQECEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kB+0iqdQztXfBxr/QTJhUXRlizGn6BU7uLNYbXnTSsU=;
 b=dkdaorfeoe5HG31yBcLwX2amW9iSbPddd/P3gmvIRuTkjsHgHsNhJ8+GPKnjMBSXLnneze3mWFkJKTQRK3e31XLNARJZ8b2Gv0cCes6xmNuRPDG+06XSqfik2OeMF0/2pYK6oLAA4/LrAFxLY43izBZwMPebTTcJpBOsKUeONG4Ab+I6aZ5hHg6D9/UBmGMhmIVrMVkBAsWv7Cj8Sd+YUpUH49rLfk37ZTdGtC9sAVIy3OEGVVktuLPH8H8in4jHd2S+12UHFytSWwfNAJb11/JzJccUpLhjRQdPb5+cnz3CWvKbNtv3Li+vlZM/fRBGuPQVgJsqPfJgLhWNwqN3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kB+0iqdQztXfBxr/QTJhUXRlizGn6BU7uLNYbXnTSsU=;
 b=m3R2DcjRhkJv7fBjOwY0SZ3OcyFdtS/4uFK8Ey+YXFahtjRPXol3Lil4cKHZkrxvQlPyz1DGnzcgUUCf+RCH4hGY2oEs9atenMwSjyNuzAqfecJuZZsibZXE04RjA9K3kF0nS9XQCI/DEtx1reM8AcjESC8SyjNyylhmXbJC3h8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6264.eurprd05.prod.outlook.com (20.177.33.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Thu, 5 Mar 2020 07:52:18 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 07:52:18 +0000
Date:   Thu, 5 Mar 2020 09:52:16 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v3 net-next 8/8] ionic: drop ethtool driver version
Message-ID: <20200305075216.GA184088@unreal>
References: <20200305052319.14682-1-snelson@pensando.io>
 <20200305052319.14682-9-snelson@pensando.io>
 <20200305061039.GP121803@unreal>
 <32978b18-d607-9655-bbfa-7d1ec5c4d054@pensando.io>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32978b18-d607-9655-bbfa-7d1ec5c4d054@pensando.io>
X-ClientProxiedBy: AM4PR0701CA0023.eurprd07.prod.outlook.com
 (2603:10a6:200:42::33) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (193.47.165.251) by AM4PR0701CA0023.eurprd07.prod.outlook.com (2603:10a6:200:42::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 07:52:17 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c2090f0c-3fd2-443e-8a88-08d7c0da20c7
X-MS-TrafficTypeDiagnostic: AM6PR05MB6264:
X-Microsoft-Antispam-PRVS: <AM6PR05MB62645DF702FDF8AF1810C806B0E20@AM6PR05MB6264.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(199004)(189003)(26005)(16526019)(956004)(86362001)(478600001)(66556008)(66946007)(9686003)(186003)(966005)(4326008)(66476007)(6486002)(81166006)(8676002)(1076003)(81156014)(2906002)(316002)(33716001)(52116002)(5660300002)(33656002)(6916009)(53546011)(8936002)(6496006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6264;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n/jD0iud+iEGaSyuJevKxNEfiTvdAFP1z/3xBj6ddtvx3n1TC/TF2jqZS0rHa6/33w1k/h7A+1HIlHbnBS2521GupwdsBsPHGw/Cd+3J8X6+aJew7MI9f0QeS+xFwReMWzUdAatWSUtI221BSMpkfFDRGerfKOfPF77IyK5w1owPTpfRnmHTD9ZPTJjc8nk5YerKAPoTCdVws26H1M6l4r06AmwawsXYzvfqgLm/Z1W7lqXMSSYeIpnUllTEcpUWMvucox4xRbU/5s+S8qv9ZU3043sssLSYW+Ru9iBdTbnocC9JwYyl8ZIpAbnLTUKBTMll4P43164xX2LLVng/RHqZSCojAdcENM9ohBpJVU74EYYfIq9in7dWT2XB3JuXqHCJkuMxrd4qCM9TCK1q6FMtLKnB+dDDptlSUsB1O3o6xW3YujFern2URduzNbD5gwqzksSEn/Zxph57zLUhAqBeiSe2U5UqAnQG2YmIB9P3VGJnCR2aa7cFn6WCpGfJ4gbd8SfGLn+HJ5LreH/g1w==
X-MS-Exchange-AntiSpam-MessageData: tF7mWZMuNNLS6gfROAqCszSo74XR1S+qWY0gHMmOhoGX+zKE4vEY5WEjjOIBXFALTsO2Rcp40PaAQfu3oYJz74IXKaCHkRICC0w7H3YGX3/bOXM2PQAtk6wZoMqNWiPNi+wmME5LKan1qiGcb/pqQQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2090f0c-3fd2-443e-8a88-08d7c0da20c7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 07:52:18.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AANvdbrpfe6XyysFI2jWLwTDsHOUrPWs60Jus5R4B7/JTQPFBQFngwdiQLo4yb4dZ70uA9YnSES2thkAGM126A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:20:11PM -0800, Shannon Nelson wrote:
> On 3/4/20 10:10 PM, Leon Romanovsky wrote:
> > On Wed, Mar 04, 2020 at 09:23:19PM -0800, Shannon Nelson wrote:
> > > Use the default kernel version in ethtool drv_info output
> > > and drop the module version.
> > >
> > > Cc: Leon Romanovsky <leonro@mellanox.com>
> > > Signed-off-by: Shannon Nelson <snelson@pensando.io>
> > > ---
> > >   drivers/net/ethernet/pensando/ionic/ionic.h         | 1 -
> > >   drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 1 -
> > >   drivers/net/ethernet/pensando/ionic/ionic_main.c    | 6 ++----
> > >   3 files changed, 2 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
> > > index c8ff33da243a..1c720759fd80 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic.h
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic.h
> > > @@ -12,7 +12,6 @@ struct ionic_lif;
> > >
> > >   #define IONIC_DRV_NAME		"ionic"
> > >   #define IONIC_DRV_DESCRIPTION	"Pensando Ethernet NIC Driver"
> > > -#define IONIC_DRV_VERSION	"0.20.0-k"
> > >
> > >   #define PCI_VENDOR_ID_PENSANDO			0x1dd8
> > >
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > index acd53e27d1ec..bea9b78e0189 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
> > > @@ -86,7 +86,6 @@ static void ionic_get_drvinfo(struct net_device *netdev,
> > >   	struct ionic *ionic = lif->ionic;
> > >
> > >   	strlcpy(drvinfo->driver, IONIC_DRV_NAME, sizeof(drvinfo->driver));
> > > -	strlcpy(drvinfo->version, IONIC_DRV_VERSION, sizeof(drvinfo->version));
> > >   	strlcpy(drvinfo->fw_version, ionic->idev.dev_info.fw_version,
> > >   		sizeof(drvinfo->fw_version));
> > >   	strlcpy(drvinfo->bus_info, ionic_bus_info(ionic),
> > > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> > > index a8e3fb73b465..e4a76e66f542 100644
> > > --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> > > +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> > > @@ -6,6 +6,7 @@
> > >   #include <linux/module.h>
> > >   #include <linux/netdevice.h>
> > >   #include <linux/utsname.h>
> > > +#include <linux/vermagic.h>
> > >
> > >   #include "ionic.h"
> > >   #include "ionic_bus.h"
> > > @@ -15,7 +16,6 @@
> > >   MODULE_DESCRIPTION(IONIC_DRV_DESCRIPTION);
> > >   MODULE_AUTHOR("Pensando Systems, Inc");
> > >   MODULE_LICENSE("GPL");
> > > -MODULE_VERSION(IONIC_DRV_VERSION);
> > >
> > >   static const char *ionic_error_to_str(enum ionic_status_code code)
> > >   {
> > > @@ -414,7 +414,7 @@ int ionic_identify(struct ionic *ionic)
> > >   	memset(ident, 0, sizeof(*ident));
> > >
> > >   	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
> > > -	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
> > > +	strncpy(ident->drv.driver_ver_str, UTS_RELEASE,
> > >   		sizeof(ident->drv.driver_ver_str) - 1);
> > i see that you responded to my question about usage of this string [1]
> > and I can't say anything about netdev policy on that, but in other
> > subsystems, the idea that driver has duplicated debug functionalities
> > to the general kernel code is not welcomed.
> >
> > [1] https://lore.kernel.org/netdev/e0cbc84c-7860-abf2-a622-4035be1479dc@pensando.io
>
> This DSC (Distributed Services Card) is more than a simple NIC, and in
> several use cases is intended to be managed centrally and installed in hosts
> that can be handed out to customers as bare-metal machines to which the
> datacenter personnel cannot access.  The device can be accessed through a
> separate management network port, similar to an ilom or cimc other similar
> host management gizmo. Getting a little information about the driver into
> the card's logfiles allows for a little better debugging context from the
> management side without having access to the host.
>
> Yes, we want to keep functionality duplication to a minimum, but I think
> this is a different case.  We also want to keep customer information leakage
> to a minimum, which is why we were using only the individual driver version
> info before it was replaced with the kernel version.  I'd like to keep at
> least some bit of driver context information available to those on the
> management side of this PCI device.

Again, I'm not netdev person and say nothing about if it is ok or not.
However, this string is completely unreliable, especially if user
changes your driver in his bare-metal machine.

Thanks

>
> sln
>
> > >   	mutex_lock(&ionic->dev_cmd_lock);
> > > @@ -558,8 +558,6 @@ int ionic_port_reset(struct ionic *ionic)
> > >
> > >   static int __init ionic_init_module(void)
> > >   {
> > > -	pr_info("%s %s, ver %s\n",
> > > -		IONIC_DRV_NAME, IONIC_DRV_DESCRIPTION, IONIC_DRV_VERSION);
> > >   	ionic_debugfs_create();
> > >   	return ionic_bus_register_driver();
> > >   }
> > > --
> > > 2.17.1
> > >
>
