Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D53322FDF
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 18:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhBWRqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 12:46:05 -0500
Received: from mail-eopbgr80110.outbound.protection.outlook.com ([40.107.8.110]:56199
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233777AbhBWRpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 12:45:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZTP/dLrl+ju4rnaSUi9XxQ2eQVxqZ6VfgNrT0iM3cjEq6DQmBKhA9+ay+SUJmuJ8o2y0MH/0QcK3TnavNd+SXIpEVq7uFWVZBfOMgmpy6XiWUHcC6rQO1ef4uf/VBV8EEd1FU3YP0bCiDk+sWmNydkp4yobFeB6003eounxfzTEZKIz6qKjX6u6EV2PAesD8HFu4s9MvNNAPK0TVXJ0G0g8NNzMl7Xtlf3+DUcW4YyB6HCZG5f/cIX/JX/jGaQEM/kJG5uvZAPfADVXso0Z/UrSixpb/0s+Jbr33Il//hc5/wjTUIwvWcZ3mLI1MhPtZD+/thfatg36JoLqWhQmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTbcntiPINoYPQEQ8DkhUp/08KR0ArPb1tS+Q+X2m3c=;
 b=jkCxTPGwUE+2FdXh3APDl5Kg+KuJI1xJPAj+n4bUa6QQYskljvazU9pD0uGaiqoTlGxwTextmXNZclnHCkhfXU4dJbwcjvXXkQW6Y/3P33VPemZdWOc1GuMtXh0+Nbmg8t4Tn48bq+k4fqjn57ntYSRgR7lyl4oxKoRTnfT4iCQp+4mmvhtfVMY1yB/Sq1NKHNLA+J1BUivsFtvofVff7YYTV4OtVztTjC1jotz2FHdxK0L34+WxQXj8/Th0ughSaLtSQ+jdOGzWn1O2okJd93/MmRAnWBI1JDTgSlMsP0HRO34rh+sXOLBJAT9ECELshk3U3nrOVB4kk0AMZU71AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=schleissheimer.de; dmarc=pass action=none
 header.from=schleissheimer.de; dkim=pass header.d=schleissheimer.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=schleissheimer.onmicrosoft.com; s=selector1-schleissheimer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTbcntiPINoYPQEQ8DkhUp/08KR0ArPb1tS+Q+X2m3c=;
 b=jxD97fGgtyyxXpaEaqUzRBco82PsKnFxbMVq/MKMLL1lbQ5MCHs2YdDt8sUQbRLhYVzYgoxeOLy8bY+mrcbd6U6UpcYJdPUt7XvHsPi1VWOlSDu1IlXVpgyuGC/MmqTzwxNM3D5ZPDD3Ky0flnmJZ7FMxbSC11Y0CNoAWSuHyJg=
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:12d::21)
 by DB9P190MB1257.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:22c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Tue, 23 Feb
 2021 17:44:57 +0000
Received: from DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d]) by DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
 ([fe80::64eb:97b0:de3c:4c5d%6]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 17:44:57 +0000
From:   Sven Schuchmann <schuchmann@schleissheimer.de>
To:     Dan Murphy <dmurphy@ti.com>,
        "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: net: phy: ti: implement generic .handle_interrupt() callback
Thread-Topic: RE: net: phy: ti: implement generic .handle_interrupt() callback
Thread-Index: AdcKC41VqgAALwodStOMhfH0LIc3Fg==
Date:   Tue, 23 Feb 2021 17:44:57 +0000
Message-ID: <DB8P190MB0634C73B4363753F62FCE4B6D9809@DB8P190MB0634.EURP190.PROD.OUTLOOK.COM>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ti.com; dkim=none (message not signed)
 header.d=none;ti.com; dmarc=none action=none header.from=schleissheimer.de;
x-originating-ip: [62.153.209.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f46609c9-0ffc-4933-2dc4-08d8d822bca2
x-ms-traffictypediagnostic: DB9P190MB1257:
x-microsoft-antispam-prvs: <DB9P190MB125712C2E32C90B3A488B61BD9809@DB9P190MB1257.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NOi6ZXiFnY5nzadDGLvpqNDSZMLSEWeTpi4z6ukNyk91uWz9iGDERQBmGjMzy8/JB7iNqArH91zQySomWfwDbQHVW9YRBplH1xHbjsXQym+hEHcmK834Z/TVyqMRSxecqVx4lR4SyQ/uR/u8L//LPGUtvpqGRMQbofT9ak5pEnKturRg9qjoHL0dUJTIHpjypxFkjPsRk+LDRS0tXAwNHCKHyUUSwcNMqO/psnxeYf6OtXbHV9zWEyBS5xpUpz/n6wbThZ4wWtSUAYNokZsh4LdrQE1ZOP90v9NXWGjaQj2+sHKm12+lRHzp28k97tqhMxwfhvzzdrcllP4MJdHKcz2CD1fjmcTf41UkR9yjSXiHNT4t9TZZGNDF3U+SsYMIDIFHs9LafVrSN6TZ4B+vxnGyoemFgotTcs6J84S4q5zpwxrYS4Iacl83S6g/fTB0f2tRrR12wl6hMyrh9gl0S6ndXqAq9GqN4DpBhpu66LgRHJznJsr35X2nwFFSROEHBXBbyNWN4K8KSXPEyE8bP3Adk6NrU3RQtZVl694jvrwBSmLiJHvjJwyV9d0oimXIk+e30XV+OKgqy7vFWMrEElUl/jDG0HblnoMDBOYeRVuNpfhfx3C3y2YoR9VJ/DnMrp/9j0BdsOzgJs1x4qW77oB4gpH1N1/OiwDyg7QjtPg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8P190MB0634.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(346002)(39830400003)(396003)(5660300002)(66556008)(478600001)(71200400001)(54906003)(76116006)(52536014)(2906002)(4744005)(7696005)(966005)(8676002)(55016002)(316002)(64756008)(6506007)(66946007)(66446008)(9686003)(26005)(110136005)(186003)(8936002)(4326008)(66476007)(33656002)(86362001)(41533002)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?N/YL445XeQ60g3KBZrF9IMp1pJsfwqmJ+9pt4cAMgjrwPUKMV/5+X7MUJqUX?=
 =?us-ascii?Q?m25jjXxLVIJNRoXD0r1UJJNa/ch6MTVTxmXDxXzyLsLU1+q9Gi5dd1ECiPX0?=
 =?us-ascii?Q?1ILmTclw3KFpQkyYG/XsqBI+Zxd+nZeYKg8vRpWC+GfuQovjRkgZoArwRk1d?=
 =?us-ascii?Q?XaJYeBk2WhlvYZji9swY6+AOik670R7954YawEb+3xmBVu7SgJ1EdOhW395s?=
 =?us-ascii?Q?hacnKpETq3ZUownYsqYi8ees1hed4zZ9oCAF0IlDnndTSkcpInOUnvD2dkdT?=
 =?us-ascii?Q?46Rlwvh0UyXZQA6tCvbQjAINJx51sVVmxcOA+x0UPFPMIEcbAA6arteSfPPV?=
 =?us-ascii?Q?q4xQNteF39VSctR+HbxfawvR5cho3Id2OAZ0H2D90qBPKIcqe7+UgGJRNVKe?=
 =?us-ascii?Q?xQPe3RRRKyY6bX7k4IGt0Mn9NZjpW5/5G1LwKwKNdm5SMPykYPxDn6jpzTtc?=
 =?us-ascii?Q?s0pzMK73kjVJlYo1JPxJi1ANHSJ97TfPoYbX1ave/PEndBPeXkTXXFTWBsxb?=
 =?us-ascii?Q?l3esPt6oNYuOXM6T0sVAUe1wMGeQeB8ciEtjbnAzIFfCh/fh6HeWlIx8Ji9T?=
 =?us-ascii?Q?MKTXnhF1cMoNfbgSqzHjhxFEj1rlSE3Hqx2pMx7xhN6UTdGs/XjY3qiA0mNJ?=
 =?us-ascii?Q?9at/vzem7zWbFbbwTFq5ViX2iI4hIhLegBnDeUvmp2lF+Son/U31AWEYb+gQ?=
 =?us-ascii?Q?brwNJtOs429aIkFh7hG+YcYZ1oOHSk3DDoPbsdkSztXjWSmuvm69F6N/blUY?=
 =?us-ascii?Q?VOqyGXlByS3NOMARTIJipSE1FepTAGKGxSTxaOgZr5YW2RXJGb3akfN3+R9i?=
 =?us-ascii?Q?X7/wiXgKs7nuVpHUESOw8N+BGw9Wj7lVhU4oA0T3C/v/VnDUY7nnYut+buO2?=
 =?us-ascii?Q?y5GrpPF9UiUkYZykoZV8jKtM4EEiRgeCVbL7J4wzeiGOFtI81BMdu9yHxgOo?=
 =?us-ascii?Q?R/ySvrTR2tiMLRN5xK9MslULevlqMNlJ4KWanAIRbWQb1s+AVhdxCLBAoX+v?=
 =?us-ascii?Q?lbY12paQJdpmMTuhdlOH/+5rhBmBfs5ipPvYdpNHf6/mCIAgfWXwPt7INqla?=
 =?us-ascii?Q?eC7/W/BibJQaBYV9/GweoWFx+vkMvibbaJ1GQvWYCLlw1cgZgSOx/1qah4ab?=
 =?us-ascii?Q?2K6vsPE4s7U58WuBJOT6mhyUGgw3LkPm0ii0KZwOgzYKC9jt6aomA4SoewS+?=
 =?us-ascii?Q?3KwJF08LOeqGfhKDJ6NobWIYnUwLT94LVX+nLXh387qwYWi4Q8mftph9FNHw?=
 =?us-ascii?Q?5utYHPjTy6VydUW9APIuYuCY6jg6OSkeI+9xS9RXE3uRp2DT2RMg6Me148k3?=
 =?us-ascii?Q?UL5J7/rJiesH4YbdcWiOfyTd?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: schleissheimer.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8P190MB0634.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f46609c9-0ffc-4933-2dc4-08d8d822bca2
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 17:44:57.7167
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ba05321a-a007-44df-8805-c7e62d5887b5
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7+wp8wemplUSBSm2SkM9etP2fJFqBToUtaKwvr7nP9EOcnMSaAcS/DAFNU2pOiBuuKzZ7nS2dTQrvk99mFJVp9ej6keAip1zRClg4eaorCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P190MB1257
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I am working with the DP83TC811R but for now on the 5.10 kernel.
I have seen this patch on the latest dev
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/d=
rivers/net/phy/dp83tc811.c?h=3Dv5.11&id=3D1d1ae3c6ca3ff49843d73852bb2a8153c=
e16f432

I did not test it yet, but I wonder about one thing:
What happens when there are 2 Flags set e.g.
in INT_STAT1 and one in INT_STAT2?
What I see from the code is that it would
only read (and acknowledge) the first one and
then quit out to trigger_machine.

Any thoughts about this?


Best Regards,

   Sven
