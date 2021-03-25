Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADB3495C0
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhCYPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:36:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:13644 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhCYPgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 11:36:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616686565; x=1648222565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LrnQMEmah38QA7CP63Tuk0n0J5GskIpVJnn+JxEX6Rk=;
  b=zITOxb3uV9MlrTyKHdk+qsR87ZRXQLsiDjqtnSGExCWibsMFIMfvv6gS
   4Y0rDi7sgcz3WjeescsyUabDSj/GILp4EWPHs4wAslJU24Uq+gYaq9N8i
   GHDpU7/Z9+TqxlYOIoWfGoW2O5D13FD5+amw4Q0vni/dqh9RpdgMSuWDN
   1adBgHe/ZK++Ef9i/NFIc4VsTkAi2m/3hEVicpA36nKVJWKUXnnymHnyW
   sS1HbHDyRPFgVk8LpEWuFgj4qWBL+YXzmjjgnHPGBoPAXWigSADZ0c82q
   yuCSYkbfRa4WdDjnbY4H6GL+zAWPU63uHbtQTk7dla+L8M99F3hkP8lTB
   A==;
IronPort-SDR: 5wH8IBeNT4It0Aect0JUmoQoaJhRf5oLsPV4BT9TT3mAHfmiJ0JMUnwqshX4XxIQK9KdA3xrif
 QwQq13qfJb9Ai7x4w5IsilOBb2CAuCV/r4shVjD2UsHRtg/GBqz/5agwOoQqG0AVvEIYb24IDZ
 rLNTbkMwm7GEElGUvC0puq69Q42aG+H63qxQMzKxhxEiTA2WRvU31s1pX69tKSsGfMrEiyvFdW
 sLbsUtnnmzHzhoW0dwBi9aD2x/OMKV9GE/o/rYCWgzsmGYiQ2pS1TzptyWPxyrhO4x6ZcNLwIr
 dOw=
X-IronPort-AV: E=Sophos;i="5.81,277,1610434800"; 
   d="scan'208";a="120469108"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Mar 2021 08:36:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 25 Mar 2021 08:36:03 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2
 via Frontend Transport; Thu, 25 Mar 2021 08:36:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNMn/WQh/d40wQQ9VZv/Qb6IDgGM6EQlQf7oymc5NOazu9tH/TFLmEK+VCOvCZHUDS2iJ3U+0Yi3dBsMdhjGv8AA34GJrU+8a7LtSBrCMNYyumMvYMizxfQPBPcm3f7uxH9gG7K4GBXu64JDCGMgmj5u2iV4tTR2c0zwXEdbopBzhAo2x2818ZDClGnSKPJZoGMH08UvrfmI5oQWr46DLnx2s235O7OqSk1cI9Py40U76MYaVaaQ4zvDF3qcbPEz0nq5qcBHdFeQAnlGGRgHdavV2TtrTSWnNbaxX5GgMiO7SoOyKqUOLju8hrncwo4Ooag2ppzHPs7KstXim036Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWtZg1QMCfD+PD4arW/r3JSRCejFU7smc5barW7SC2E=;
 b=I2RbNJHqWyMez84qi7gAFzjBkCNVsbaz/1EpFgtpgd8QHOGcL6eMJ0FSH2S5Bw3+OQVpPT/3jj/iOJ+08Ps9EVMDmuA1UKdgFhxBsEKJW3ydjpr7r/V5FbHG2J4I84qxfYp32QUpWvaVGZ68ebvdF0YXY6eyBedw9of5K1D+atNteAsnZu2bj3ovEWDLtu8U1X27VqXxeImZyi10GGKEo78PMFIMw8MKdJO6yNkXT0bymFcNff6wNcbGmAHwSMjAgJEEI+nW4tc0vrBa9Gxm61B50CYvAGONj2QxKHPeIbjmAM3rs5OvowhI4n28E9JxAtMeykXZKirq5uLJ8bUpJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWtZg1QMCfD+PD4arW/r3JSRCejFU7smc5barW7SC2E=;
 b=RDnu8+k5E/ADliecQchmhsSGlLLTOMmR+T/6QjJoYuFQ30i32L91le6HMDS7+NEG4MVSzqJEivfU3cGqsVOrMN0LdJwd4KT6V4n3NI2gS2aiWKWOwCr5U0hmawfFaIna+nXezak5OAA97yrWkWDExQVlXlrgI8XQ3G7ONn828U0=
Received: from BL0PR11MB3012.namprd11.prod.outlook.com (2603:10b6:208:79::14)
 by BL0PR11MB3409.namprd11.prod.outlook.com (2603:10b6:208:31::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Thu, 25 Mar
 2021 15:35:59 +0000
Received: from BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::2407:a9de:cd60:ad1d]) by BL0PR11MB3012.namprd11.prod.outlook.com
 ([fe80::2407:a9de:cd60:ad1d%7]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 15:35:59 +0000
From:   <Woojung.Huh@microchip.com>
To:     <zhengyongjun3@huawei.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <hulkci@huawei.com>
Subject: RE: [PATCH net-next] net: usb: lan78xx: remove unused including
 <linux/version.h>
Thread-Topic: [PATCH net-next] net: usb: lan78xx: remove unused including
 <linux/version.h>
Thread-Index: AQHXIR/V+II0aDtYpk2EzoUq8P/Q8qqU1szg
Date:   Thu, 25 Mar 2021 15:35:59 +0000
Message-ID: <BL0PR11MB3012A504DD2049D71D7E7F3BE7629@BL0PR11MB3012.namprd11.prod.outlook.com>
References: <20210325025108.1286677-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210325025108.1286677-1-zhengyongjun3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 025608f3-d76f-405a-2b54-08d8efa3b06f
x-ms-traffictypediagnostic: BL0PR11MB3409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB34098CAB685A676527447C9FE7629@BL0PR11MB3409.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MKvhywoXk4G3i8p3oZJ8PqZ4Uf9d6rF95ygtZPvELGOzvPCJszZRBqOttedQN0jijenWBdPAbA7LTq9tj6g6BIThO89QrluY5czV00HfafkwDCzSchXLm/HwB38S+aPChurEpqheINwDai6GFW8qM5QOG0Do1kSt4Bwylf7DG+Es4gVnxrgWTDhC03V8s1h62v8WbQQlCAykxzrF+touf2j5BR0RquqU8JuIa4/aOQ0AbAEo3PEiWYnxqr5lJhClvtBmdhrZPNNY0YrGNuhh8SR/Ai+07mQb3c24tLS1+8V7yUWJsSWfEP70CJjwNIGWnmTwI3sZ5IphYxheGCiLycwNtX1llLuB+kiH+IKxLWy40RnPCbkQ8YfW0m+31XguweA9jaXdK3N+K8prBGJVBMMGYHLU3K2s258Tkkv9rUXOK9LOi2RM5sRQ4KK00eCsI3Yuh9rs6JyIPC6rT75JeW0uABrMlB+QR6tGXo0RI94ladQd2A2adrsQ61jcGgJygCAva07f+ZfsHeum8WBWopSK8zjhJL+5NBl0rMiPMqbLAdMawKya7YqZtOfG4uCF096qen6G20MhuaTXFCOP5hZsXL7AHUQuJe/aV0ay7ftIycdQ13U4PFhKvPYGmQ1snFVcwwHUBxbQn3+nwiCrGXJH39rXdvXn4omYbM0n6uM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(39850400004)(136003)(54906003)(110136005)(66446008)(316002)(66946007)(64756008)(52536014)(38100700001)(26005)(86362001)(76116006)(5660300002)(66476007)(55016002)(478600001)(71200400001)(8936002)(4326008)(83380400001)(66556008)(6506007)(9686003)(33656002)(186003)(8676002)(2906002)(7696005)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?AS0RN7DyBNFrgnY2yF4A+fy/19CBf8zXkRI9HGgZgDHv+wu1vs+5e20RPaY9?=
 =?us-ascii?Q?zKSLBGLh01ftV+geH1H1bIMnbFWcbIh1188oX5YGDABBTh2Zia81nM8rSDyi?=
 =?us-ascii?Q?UitQ+e2LGSvQUCTtAaAFFgF9BSSWFEEtxTfXzoD1mrt7w/Q7gPnV4ITI2kZG?=
 =?us-ascii?Q?VRHvxbago7qjrgTC3O+cOzTAvJWhrgQEVKjhCD84dqhqM+D1MQsb1n30rbnr?=
 =?us-ascii?Q?sMCUwFhWJu+EzEUHBJdKllALEnin7sXCOlDXPPskH4Idh+aWw8DjHAffMSQj?=
 =?us-ascii?Q?ha8NR5MYMlamqUjwPcr2DaUkgmeXpGbVx821cMNulCKzZByYsOPfQmIpW/Jl?=
 =?us-ascii?Q?Pi2fGQa7Gl2D6oFagROfD/WuAuzi00fsyxmHR8eOgjRe8c9U87HH4DcZQbW8?=
 =?us-ascii?Q?Cacl54HoGy1qKhY5TYdtNFH55Eo7C+UjypxZKu7Y6EGKZ9VfriLQNtxYHzAb?=
 =?us-ascii?Q?bZbxSLB/SudL+L+G/L9rwR6J4ocvJTuTbRfqEgZcV7eeMurFfYwW3FZYFWMH?=
 =?us-ascii?Q?fGOUCqO1mbbyOV+r0P1RATJqoVolExiBF4zzIFmHhlWoJ5R+iH9LGiH3WW1c?=
 =?us-ascii?Q?GyIis0Gu4F+NTQ1MWuWU1yAWhsH+KJQ8yMglnlIT2T6HLEfYJWT7zOKTs7IB?=
 =?us-ascii?Q?9TIjkDhrUfOEuhAWqT5kozDrlscONC6J6x4lW9fp17H3Z+s0JMJ0bmcV5lpW?=
 =?us-ascii?Q?NadJCsnlYCGZNIXEYqYiLiBzKl9HGelVrKa9bWjlai0IY+vYUM6fDle1UCMW?=
 =?us-ascii?Q?yctHKpMTneSNDMPJ7S4q2+aA7c6y/zwp29oPGnx32p0/3NizHuNeFF5r7nSQ?=
 =?us-ascii?Q?i4mAqhc7RcE340lM4joQ7rLfKVItXgv1qT7tFsd6S9zGV//fFLqEMlq3lDO3?=
 =?us-ascii?Q?k+rZqSRFEGkMcRo/KxJL0Nd/2jUZwIShR3p1YmKKwYQcaFVs9lxk6moMXZS5?=
 =?us-ascii?Q?cS8usR2X/Rqc9GgHyRNudv9XElZ8gvtr/t+3uXN08yRAFcWa0sfWaW0jvCrb?=
 =?us-ascii?Q?YQCDftMAQh4YKaa4ksmKVneZtRdv4h3ZVpuqfYucC5yh3O1i9006JqM34u0y?=
 =?us-ascii?Q?hAjNtiQz4x3LL2q8jK56CYI8+SFyfB0v5peNsY9XnhDiu1c+R4vDs5tU250U?=
 =?us-ascii?Q?xStNhnT4uyVPOwxZNLMQ/KSTdx8IyT1eTQWWPbNp/0tL1jZPziF8SojRGuMW?=
 =?us-ascii?Q?GypR3wu5/wpFhGZxTiof3yQ+E9VJzwTgfs+g+QvSGUmimKjAuHXR4RcL0OUp?=
 =?us-ascii?Q?sU7R+lG6K+D5hit629JnJ1k/UJICFueZJxwxwIn5LZladD42E2p1+zE5B8MN?=
 =?us-ascii?Q?LYQSjO5x1EmDYMNnlhGNEazJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025608f3-d76f-405a-2b54-08d8efa3b06f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2021 15:35:59.0948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtOCJL21h0i530pH+eFaRDxeNUPc8gEiURgt4oLrZUX1VzWKNT5dgCIB2VvIYc4R9nAL/uvO/vKLTwEZ4N97XmMegMCLCEbgpxmENaKqXMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3409
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Zheng Yongjun <zhengyongjun3@huawei.com>
>=20
> Remove including <linux/version.h> that don't need it.
>=20
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
