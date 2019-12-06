Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E67FC11540C
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 16:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbfLFPRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 10:17:06 -0500
Received: from mail-eopbgr50061.outbound.protection.outlook.com ([40.107.5.61]:14305
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726234AbfLFPRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 10:17:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knJx4Pozn6jATNSpv7ZlVshBwTmo0JBLBMdXSF4qhuBACH/ElgfUWVSLylUN0R0lD1KgWlzS4X/NnDKitCQYHHQTVQMJRK3PgMAKPsYvtFR+aMPbgx43/8VnyFts2o4p7oxJcQv62aDBGIUl74u1t88e+25Bewt98MSAhJm4Wa9xxxqTxY8g7SJXYuhGyuh9EkcAEmC0U0Klja5FQBSL24S110PwZAm434pzIq5/L652iUB+5naHWFRmm7TdkTstdJ+7SpggzP2k5y2BBNT4Z+52sa9fuXvz8Kat/c/sBFiRrMAUMie4wQNGvLPVq0c/YRtccXI7eT+4U2L6sBBJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAm63By2oXTnkKKyIeIUU8HKGPqGxB0JELgV09AZEH8=;
 b=CJO825DJ7bCNQaRR4fo1nvmSAUl6UVHxZ+YQqFOKKJ3DXMegdHpfwJENUt3L6TKJhWN5u2xkW4YLCZTqXWSWdkYhaxrIAj/2GLA33X7is0lvrzIWz4jW5St1fUJYDhFPuBlz+YKFVS4zIeM/UAU7tIqF8tEuWKUmBFekyvQjpOIHUqHOj7L1Szg5z/PTpIOBRmJRC5QwdrG8/L9ELbCO8wRMQcQLMac8Ie34w8PD0EWODE0Ry6z1GV/tUqj5wNZZ+KDfcn22CIq/dv0Ud5fKrqb/LCayaYxIzrC5pBryH3/XDo3ONMWdEibY534BDJd5POW2FpfQfAy/MWOxpEAzDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TAm63By2oXTnkKKyIeIUU8HKGPqGxB0JELgV09AZEH8=;
 b=o/QLKX7WOqf4699/pTofoKA3AXW0HVll0nqybCd2wW/EF0lJIxnLofw2UKPkmT0KWP+CsxxnWkYDKsnuuhuH+91LpofZf+M4R/z8zTtHm2Mz+usOIfVoqDoj2zImEX7m9VWioh2UVrhUri1DJlr3e3ase1qkhPN5N6qS5uZ++oY=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5311.eurprd04.prod.outlook.com (20.177.52.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.19; Fri, 6 Dec 2019 15:17:02 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b%6]) with mapi id 15.20.2495.014; Fri, 6 Dec 2019
 15:17:02 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
CC:     "Y.b. Lu" <yangbo.lu@nxp.com>
Subject: RE: [PATCH] enetc: disable EEE autoneg by default
Thread-Topic: [PATCH] enetc: disable EEE autoneg by default
Thread-Index: AQHVrBsggRDfw3WU6kizFPzyhCERhaetNzKA
Date:   Fri, 6 Dec 2019 15:17:02 +0000
Message-ID: <VI1PR04MB488028BB1C6A50236E89E1D7965F0@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <20191206095335.7450-1-yangbo.lu@nxp.com>
In-Reply-To: <20191206095335.7450-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3a9ed896-55b7-4c9a-161f-08d77a5f58bd
x-ms-traffictypediagnostic: VI1PR04MB5311:|VI1PR04MB5311:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5311C1675964FA7D8E940580965F0@VI1PR04MB5311.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(13464003)(189003)(199004)(8676002)(26005)(305945005)(8936002)(81166006)(229853002)(6506007)(102836004)(9686003)(86362001)(76176011)(44832011)(7696005)(4326008)(81156014)(186003)(5660300002)(55016002)(33656002)(66946007)(71190400001)(76116006)(110136005)(66446008)(52536014)(66556008)(99286004)(64756008)(478600001)(316002)(66476007)(2906002)(71200400001)(4744005)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5311;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ku/VBbKuVmwRQOPuhAokDw1k6TqtNe867lIW4zJTB1yn8FT3ZUztvsGEptGM6kFSPf5oEg92zI9llIw6W+nGNZ0n7sAj1jHf1tpNntOhx1uyeiq8Gz3tzcHxkRlpCtMhAR62k4SA64o/aOQdRXmFdZwUkjwderDN32yohIlnhDl8FYnlEXOCX94y6nUZqqvs3UdrlOs9X/pmRtNGOJBoA4416XeiKibrmIi4cUB0NUoI4P5j5NmahzMZ9HAa93dPpzF1A8Zfm+l5bNCYIotBZhdMqbUyIJHLbF/4T6SRbYs9COaNOOpRmb1YT76EcUsfGHHw8PmB/7esm8MHSItjgGXfb3O+BliQ9GihcU0iGTzEbQJa3Gyc1ni7RgZH5b9RVAYoPrsNByF5WiFgC0wFa9PZ8/NFBw8leRHu8bmrwW9yEFMpmbePZlWtWc806/lfmyLqSGw7UuUa/3Acyb8D+0+vPYNu5A2JCtyQgbZKeck/AEKQzF6b33ojTnRGrTvM
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a9ed896-55b7-4c9a-161f-08d77a5f58bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 15:17:02.4084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +QJaQjkn5O3DRfidhb2Hdfax7OfHBuYWkGEl3ueIvKGO7+MUUzQl7EejQxFRgHJtHRuirwAtaAPYNKGwJMhS7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5311
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Yangbo Lu <yangbo.lu@nxp.com>
>Sent: Friday, December 6, 2019 11:54 AM
[...]
>Subject: [PATCH] enetc: disable EEE autoneg by default
>
>The EEE support has not been enabled on ENETC, but it may connect
>to a PHY which supports EEE and advertises EEE by default, while
>its link partner also advertises EEE. If this happens, the PHY enters
>low power mode when the traffic rate is low and causes packet loss.
>This patch disables EEE advertisement by default for any PHY that
>ENETC connects to, to prevent the above unwanted outcome.
>
>Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
