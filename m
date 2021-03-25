Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE8C3495BC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhCYPgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:36:03 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:12082 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhCYPft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616686549; x=1648222549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+h05ippL4BHR/xBKtg3pPn20UfaFJ2T2rCEIcnFZLjc=;
  b=dPqcSXsUMX2Xtz7QNIYv5ff6JQEWjKF+BLxY/iVOMo0rL8Bbf8YTbB8h
   SxhHCAtpO+zwuc3vjvwgc3Xx6RBlui8EYZf9yOLSsG7aQ0J8PDi2q7Ef9
   VhA2sGg21pnFizFGqSHjmPtYVhNtQKWbuI7rnJiWVB9Ba7lr5KqwCgbSY
   rOxdWnZ8onJWzXpK3e2LV1nfDTWVkcGLKBNgD5xLWhei1JIN3dkRihYY1
   VC/4puGX8SauSdrint/5EDDCpqnA9HRJDExvTsT1BG/ki9YtvE/+Ssg3y
   wvV+1KlgFkuwBYxAAZtuuPnOpYrGFpyVYvEjVMpyZMWHKitnKOo4Zpe5j
   g==;
IronPort-SDR: smr6aV70gRsWUCXk4EoCaOJpYNIYxCqkbuuJykipc6OrJVm8Z4E6io2++F4E3SKO+lSbv1nvNp
 ya/GkFkWjHGvsiXvgVxdEspDHc9A4p5FORxiMBGvkV2aCMerfrboN3CCeaKDIEdfz+OshylPRW
 PE5/wpwnBfTMDFpQg2TlevE/pT/rVCz0qfk1qGgiGDs22jyVy3XrWaO5tiAEyjduTck5btEzp8
 U9qXpLd+TgyizpMEhF383QgHpg4wY20zCwnXK8+LTZznvz70m+w0m0dNdzxDN4FLzYS3F+TS5N
 o3c=
X-IronPort-AV: E=Sophos;i="5.81,277,1610434800"; 
   d="scan'208";a="108529675"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2021 08:35:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 08:35:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 25 Mar 2021 08:35:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGvnMG14U322EIWEBUTkXPLj812ZxMwo/BYOofLeLNzkVBvi/horiOz6qG4ljJMPdEiPZu9cOQh6sBUHGZ8Vsmz9yNsgby7bSXaIWzJa2pYGPguwOXuQFlU7Gz0/NlBdNlXOnAyHqs3L5ZRZMD+4YCr05d0hd583zg2GSwPTpVecOnqIULBbngoN/7ilGjvugRUGcaho1K6WA+PZZ/2mfLGfPfs9aVZ0ugEtBWfGx7aSg2Bc12IxfeqVZW+yPfwyPtmME/CkpEFxWbrl1xHLfqUWGWluSKwuamRcbCRdzoAmkXdT/8dy4mbbjNGBYAs1CS6ffVdyez6RfLNP5cBcbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BE7fWr8u5CJbUcyie32n4FDYweyBc4KpUmqKdl4a74g=;
 b=iEy+MLq002cE/qMMNW5CrjYR8Y7jBfbCOLJALpkxB+3FNPktWVbMCZJxYLXSoCmxI0wkNGHs4Y4O9f9hgPQCaAu9c1ZuYC1Su4mtwKwyhGQBulCjyYCXhx4Lcd7gGeFP+SeYN7tX6FpxyqxRTdpwZP+aGEdDr2cteyYAK5nT08Bg0xBN5Nl/UOrqH73Y/RWYYxcTyG/ojnCTK8LzfzTBedqN9TdO9xYMvL5Y8elxFduTG/W9lSaRmVCsQM60u3MlFBUYvRBVPJCFXincPf71Tc9uXwNK5pLSDxqPENCfwp/QXXQ8sVi//1y5b/T5W7pUnYLGK3Ls8OGaQisKN24yfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BE7fWr8u5CJbUcyie32n4FDYweyBc4KpUmqKdl4a74g=;
 b=HjnPecJ3OST/+Fnb6SC8hroNxsjNGnD6KqF5wlu+Qgbi6DrIb/qk0Pn807+msNPjSpQueVu7SoES6JR8HSvcZhJe2BDvhNBcGhiQ7g5vs8dmywT30XCwNoamlCe6O6ipcIOtGpW48YAxjSHspwuQkxGGrhZk2SPZPmVAZV0qGQg=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (2603:10b6:208:79::14)
 by BL0PR11MB3201.namprd11.prod.outlook.com (2603:10b6:208:6b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Thu, 25 Mar
 2021 15:35:43 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::2407:a9de:cd60:ad1d]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::2407:a9de:cd60:ad1d%7]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 15:35:43 +0000
From:   <Woojung.Huh@microchip.com>
To:     <zhengyongjun3@huawei.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <hulkci@huawei.com>
Subject: RE: [PATCH net-next] net: usb: lan78xx: remove unused including
 <linux/version.h>
Thread-Topic: [PATCH net-next] net: usb: lan78xx: remove unused including
 <linux/version.h>
Thread-Index: AQHXIR9pb22NhxwKFkeeyMm5haj7rKqU1prw
Date:   Thu, 25 Mar 2021 15:35:43 +0000
Message-ID: <BL0PR11MB3012ACC55E5252878436FDF9E7629@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20210325024800.1240388-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210325024800.1240388-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 079decf1-1b28-4735-4c52-08d8efa3a73d
x-ms-traffictypediagnostic: BL0PR11MB3201:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB32017C3B7C43407F2820441DE7629@BL0PR11MB3201.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iBVzi78XpMSbjMS0HaC1Q9cUVVbO2egtbkGUDC2vo3rFP7YhqwO9EocBVhjhjyQ3uqHVJ3jIhaU0tGsR/y9Jis2/5mt6nEIv1MWoq8ZNGwt3Ac9ephz1FsGDLbomiNqhWEt34MZkPC+sca0i73jPnoKiefhkN4PKKSyas25Cusx9Zu5L4pDP1fliq+T9dgqoujgyp8qdxPZSjjioqGm0rrFRlKJQGgJ0solNa5viiFuinM4GJJtZCeVxeSUGiZO3XfA4R6u7n92IaPy1/8Dyhiwxep7lDG1G1Nc9ZuarvxXhgVOPTZLZNkMu2UtHeBLm9gvlVjQXQGGqXahLQO1ygDKCyXjDApLoHa8W3mOp5+fux+Q+GZE6X10OZgdO9QiBtEcPejwrFCRxFDLBuusDrqpclJtCs9pJ6exAvZ+/Zmaj8q2x7Eb8q1aqN3QFZD1rbEyygcUKku8wj3jBZUtHAxOIXWSilY42GU1UA3s9nX+5kQVGscf11hK5WpPeFX6zZAS8LJut4NeZyazxkkIzlNna4HNSWCz9TKpIMY0axKLsjfHPDAzsviSZbK0tObGAuov3kFQkRnO06eTFfRScCBLL9xPVBnscKJvG8Lh0cnFf3ENxO1pZqQj/l70yS5YEpAmJ37MCSudlwH6yLYyL3anczoLbbEnOIE89VXH10Ck=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39850400004)(346002)(316002)(55016002)(8936002)(86362001)(4326008)(8676002)(71200400001)(478600001)(9686003)(6506007)(4744005)(83380400001)(5660300002)(66446008)(186003)(76116006)(26005)(33656002)(110136005)(52536014)(7696005)(64756008)(38100700001)(66946007)(66556008)(66476007)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4CkM1QLBvy+/K9Xe+SqgWxSKYqrfCcetbmFUEbXHflQOo4yOSchwHvlCekOx?=
 =?us-ascii?Q?TNXnL4JD6St/YHsFea6vACOts+7nxtTMj/UQWuiUZ28/78jdrTPRc4xlkcuN?=
 =?us-ascii?Q?YzFC4KkpB9IhwLJFqamGxOYQfuucM28nlu5E2GjhvvDiW2Zag6OD5Nc6Ov0t?=
 =?us-ascii?Q?rijIVW3hVKlKbr+CsZMsg6yFMeEoRUX8erQIn3qE0NOkpYQkXUQn+lEZyGO0?=
 =?us-ascii?Q?GyqcR6/a2BgcKbp0XdPxm1MF6xk7AuruNr9AVA0Mh0h3cjVVLGvf5YwsvZ/c?=
 =?us-ascii?Q?jvtPg7DGe3xReeLfnSd2YIvF5TL6oFqt9SOJjjKpQr8BwR2jNZIlpF5+NSei?=
 =?us-ascii?Q?Zm9doP/qpzTNmV60beueWi5BaNTdHh34alBzjIqiCL9IfxuOxFnLd7PXC/qr?=
 =?us-ascii?Q?S8jHb/uhI+PA1SU0UMEF5kmCxeEhwOnAkcgWpLqgRVTqYf1lkkyR5fEelc9Z?=
 =?us-ascii?Q?/AuVa3wIMe+hToFBKkjpYG63q7gvdVmBAezYFOzsGTucN04If8GKrPBT8/AJ?=
 =?us-ascii?Q?9TcXFN1WoSE4L1ZhN5KNpr1WPH+pAK5PiygW1scjbiAdWPuykb3giw0lisxG?=
 =?us-ascii?Q?MCxcmiTGvdtqxmvRqBB8kCBq/ZkL1QtsD/HyOdU9SdCKDHsmjJfOykB5Bdge?=
 =?us-ascii?Q?yc9aFaqzl8s4cZwA2U9q7dnbZNhoNbbW8jXNbCdUqpqz1YjkFjIyXdyKtdq/?=
 =?us-ascii?Q?4G5VX3tyDLv8gKJmSKPSTZoawUOofwnwlMCBjzIikDw1OcCHI0xiaz3W8NYs?=
 =?us-ascii?Q?Bda91j5HXATo6aVnxczRWnM3E9+bHqH0XN/vYYnJpW9hYO0ucGoYRH2zE+GP?=
 =?us-ascii?Q?o1HbJWWDimluta9sA+qQoKT0KqYAqBQ9V2qrmcD/kCCwAAV9iyPDcfvx8oJV?=
 =?us-ascii?Q?N4DWqgf/h607nDO1zsiBR2nFisC6gsev1nrv86x0yP0tvpbsppqlvgIhUwx3?=
 =?us-ascii?Q?wGQPnI6f8RF17JMVIYl0VBsbZ7xXGSF22VTejdzfw2h2/QzC+2REKKXULkue?=
 =?us-ascii?Q?41nYczjta6qVBwsbPOJEw/mRMvMvHiVem8TuuZIfOoPpeULWhTqc/JZu5Vlt?=
 =?us-ascii?Q?NKKP0FHX5TIYtC4qpAPeMCg8pWn6VPwDDSo26ICgcVxuIGbpGLkPcnCK8nXO?=
 =?us-ascii?Q?8+P++ZB3NyYF3JzezqBNdZoZlwkrFYkOw5vjj8pptKIlLbumOmBuzOy/5W5F?=
 =?us-ascii?Q?N1JqICla5gSLfjubEB4IaCes9nKW3fbeY8Y4Y5slP9nh6CV2FlwJ1IsAwICv?=
 =?us-ascii?Q?ZFtu9p8Wdl+OfAlNQgnhFt5KXByBcm2VX++hvO4lcZ7BZnQRKPkhFTuXvyPT?=
 =?us-ascii?Q?OL/nxGv7H6FUFP4dffRevPs3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079decf1-1b28-4735-4c52-08d8efa3a73d
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 15:35:43.6745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7JalKY/mzJkOUalYJX2OYpJZKeu3UkE+hcO82sk5PLTNLMiUOjPgYfJM0ACT0Rs9jLk7W+JK9z6hM2noPQtiSWiyVyd+lc5yANYuW72NhgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3201
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  drivers/net/usb/lan78xx.c | 1 -
>  1 file changed, 1 deletion(-)
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c index
> e81c5699c952..6acc5e904518 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -2,7 +2,6 @@
>  /*
>   * Copyright (C) 2015 Microchip Technology
>   */
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>

Acked-by: Woojung Huh <Woojung.Huh@microchip.com>
