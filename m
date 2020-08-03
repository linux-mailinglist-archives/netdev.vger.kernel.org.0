Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298A223A0FD
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 10:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgHCI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 04:26:35 -0400
Received: from mail-am6eur05on2040.outbound.protection.outlook.com ([40.107.22.40]:31073
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725806AbgHCI0e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 04:26:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5+RByLtvjcr5bRdjYRTwzXv9i5iotHunoAF7PtDy8XM+MaFI+Q7/0kXTT7WRoyLJ9GZoGDYHtGfx1t9SPlG6N5cgbJ/iA6aUnNvIUF1Pj6q63ceKy8ZQXySgX2U8f3WvfuOK1iDuCkvAFXt2lnjLKRttKkk98FSDoAlIjHUxVSludmTMykjcpJTUEcTT+zLhvz+GntXBnZacovPnaLKqgNrtuAW4i5z/nHf85UaXeJwjKSm/jYTa6l9TVK55d+Jqv2n0eh3OFvm/EKcpqspJWKuwCxVDh7nsG3u4BMIfeeRVeFNVCXMS+ULSOFAnoNt8BKaK4s7PbXtQ5AlsWKekw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXJw+6VdEVlE7mTz5qRxvF08bL5zNpEfBfQPoHnP/Qo=;
 b=IPjtg0kbe4wFjq3lWItWGvUqF+8iimXGB1P9NlaT1eMkxKaqvszLhRNg/BMuXJmUYYhcipYmqSJ9MrLd2xpF/WXskAvl31C6adlGpS59x33JZj1Fgc5TNroOlddS/hCX3k2BbXLRKywyn7gMvZmUzn7lmjECvUeidVt28mTYGSD+zmkwfmqcdAMl6gS7jYhga5fgPtgksoeiFop4U2kF6K53aL2x2glwGzS3Xerh9iXHXt1Xtdu+aGUptOXVRRORq5+ydkpQKSWzOcmIyI8BnrVcsNO7ENZcJru9ZmvblQGN7vfko3Yza6qqZ9aZ8TuQO0QCl62/LximB0e0mb0iXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WXJw+6VdEVlE7mTz5qRxvF08bL5zNpEfBfQPoHnP/Qo=;
 b=PYb1qa1u2UvRsLIXD02wScyqq0Sg7I9EUKxAHo/mXamTqTXUGS89e/2xZ40qmBgPgS64Qn3PIP6IaGzf3971WhcI/73VrQ2mrr+9f5QiRG5MCys8IsFUF2j0bDSNsuxiBPVqApuGKRxcIENKkLl6IWoCPIuT/D8BFYkBbtsQO/A=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM7PR04MB6776.eurprd04.prod.outlook.com (2603:10a6:20b:103::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16; Mon, 3 Aug
 2020 08:26:31 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::f5cb:bc18:1991:c31f%2]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 08:26:31 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v3 0/5] DPAA FMan driver fixes
Thread-Topic: [PATCH net v3 0/5] DPAA FMan driver fixes
Thread-Index: AQHWaWTTu6rv82yb40iH+bUNSp5ZT6kmDMlQ
Date:   Mon, 3 Aug 2020 08:26:31 +0000
Message-ID: <AM6PR04MB39765DF82C41B84D41FBEE5DEC4D0@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
In-Reply-To: <1596438454-4895-1-git-send-email-florinel.iordache@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e60e4736-7b4c-4243-3360-08d83786ece8
x-ms-traffictypediagnostic: AM7PR04MB6776:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM7PR04MB677607D21A3D9ADCDD48E358AD4D0@AM7PR04MB6776.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nIdShuGluIoY1X+BC0gF/Tixi/oG6wA7jc+P/txU986z9Km+4dseVotqTd2Xk8xnxuZ3KzsUEdyFhz65pfDHK76/pMxOVdOlvAOibvYN3JsqiGW9nNybuRXwFZO2t2SD6sMo/073agZ8HOOfQcyf7wpYmf/G+N1W2Oev2IwgfPR/60BUI7FdSXnj/r4F5j9A0fnu+no2BYgfU9kMBXlNLZUcbhEjHqvdBV+8Sc9vKORz1wd3TY0h36SczRbtmyMgo7N8t1/U3JxeW/s9UjHUVGNRMdU7KJ18qrjUIfg1P8FO87iocPOGzmNZwFJki7gooMb2oevafi0BJPh/FjTWjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(33656002)(316002)(5660300002)(6506007)(71200400001)(53546011)(26005)(110136005)(186003)(2906002)(478600001)(83380400001)(86362001)(76116006)(9686003)(66946007)(8936002)(66556008)(64756008)(55016002)(66476007)(7696005)(52536014)(66446008)(8676002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 63YSK+ZcoRxq8NqTHs7dp1BcZE4/kxwPsTQ+Ek3nDsVdc+9GnIf7Mpsiin9ZFTtWhwhYpqu8W/6d780En1g2YigyCKt+xi/t3n62YYsdHeETiVcDTnfs7Gh6ZTtYXD29+dIH4qZZSrhE0AH/MYL+tGXCyQ3JR/y7VwQoUiUljwXWgHFUCaZD+vJmlCRaV7nIoxh3MPUCE1/0ZQzSCsmPSWDycECJlKgDrewZb/vtIAfodMvYxxP9enydD0sGI0uP/uaiWctAhYjMvVOA29WMo9P/W43B+rn+tuW3O3wkYkxwQg+8eZL84vxZW6laZbWjUZF9WYOzNqXyZ8g60x1EoMVLOpH4UOS7hx6uZ4sCoaiIWp3K1dTwhcUSueiO1iIw3BdXPh98RNEl4VP9R6imqygd63IX5j3jqlX2x9p29SiLQk/x30foPk7l5F6r4x7LIRTs43YiiuB4+cEGIBjUAUZA8M7WY7FLksezPiNkliFtgcFdJrblqujSnpmKfLRYtBRmOpHQZCIsCplDlzVt9Za7weY8tBzBOug6bgRKH1MXADk5dbybVRQdjNxVxRLhZtPm43V+iK65tHxgumhECHErUsL3yG1xuNzV62xueUwxujNXCZHJ1tCu6KXk1bUOi2pG4HSv7VPbaqfPokwZ6g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e60e4736-7b4c-4243-3360-08d83786ece8
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 08:26:31.1351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lvw9nJXtOh6y3rHkgq+/Wa/M5gPJMdAi9yGMnPrhWywUktIczVF3eShdU6CASdCrFXN9yC8eCaW3jLaFKBYymQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6776
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Florinel Iordache
> Sent: 03 August 2020 10:07
> To: Madalin Bucur <madalin.bucur@nxp.com>; davem@davemloft.net;
> kuba@kernel.org; netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Florinel Iordache
> <florinel.iordache@nxp.com>
> Subject: [PATCH net v3 0/5] DPAA FMan driver fixes
>=20
> Here are several fixes for the DPAA FMan driver.
>=20
> v2 changes:
> * corrected patch 4 by removing the line added by mistake
> * used longer fixes tags with the first 12 characters of the SHA-1 ID
>=20
> v3 changes:
> * remove the empty line inserted after fixes tag
>=20
> Florinel Iordache (5):
>   fsl/fman: use 32-bit unsigned integer
>   fsl/fman: fix dereference null return value
>   fsl/fman: fix unreachable code
>   fsl/fman: check dereferencing null pointer
>   fsl/fman: fix eth hash table allocation
>=20
>  drivers/net/ethernet/freescale/fman/fman.c       | 3 +--
>  drivers/net/ethernet/freescale/fman/fman_dtsec.c | 4 ++--
>  drivers/net/ethernet/freescale/fman/fman_mac.h   | 2 +-
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +--
>  drivers/net/ethernet/freescale/fman/fman_port.c  | 9 ++++++++-
>  drivers/net/ethernet/freescale/fman/fman_tgec.c  | 2 +-
>  6 files changed, 14 insertions(+), 9 deletions(-)
>=20
> --
> 1.9.1

For the series,

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
