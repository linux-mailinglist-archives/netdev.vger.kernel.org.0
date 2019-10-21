Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A9BDEC2A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfJUM1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:27:55 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:36934
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUM1z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:27:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDcUPR+sYyPoRD0kaPaUVeCgAxVfdYAhHJfb5Cywm55vOP0tbOQSLjkcFucPu2BE2TMoJuACHHqyabLCE7oJg2mpFN21sA1vxOlWhA0R8y2LbMSlXbKFD9cpkEROF1YzUmiXfy1lHrnq3SgStcueaubLVGmi8vXXrdMQOZ5Q5ccgJWmRlzJhxsTGTYm9rc1txMfsEcH/d0Jd90XT1wBgDNUGNQALdzrnqg0sFoivpVECx/hqrdyllW4R/RSW8q8wH4gynAttjrz5GyZ2f33R04GMgueMWKXd/lv359gThXLQ/ALvrIuBHFi9sjCoT9tDYO/i9zj9S5syAMpUDmGxVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRhTH2ykk9QtkIwMpwuM6I9Z/O/r3rbIzeSQ0KmmB60=;
 b=nfpukK6/CcjfH8EcU0dei66AWK3VgeKJx5q5SeZZs8twJRYygZUN4zGsJ4eF28lJgoFZb8zCy+wTfr9zLBbhtO2PL6RxKLwtn4R41gJuPKQCEd3GVHdjdLdz6Lh5wCFtflO+Hg40v0VpVLuCU/KNYWZo8ZyF/povmZsw9I3Mxn28ilBCblBFpCTJcM/I3aaUKBGg2/NWIFRopNed3BpefOpYYfNHHv/yBBv2m6t5RV3oYmpVaaEx+/BKowkFKLrLTkhFRRcqQmIeKXYwC6JB/gSnaeJIBTk8wtfLtYieUUFi+ERxRpEhrYneH/acgLbnNxy5xbrAoXEVvlZaqGfHVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRhTH2ykk9QtkIwMpwuM6I9Z/O/r3rbIzeSQ0KmmB60=;
 b=OwKKQvfHFiAaBYPdlCUDtBI2QC+iEifUUZRwoEDspiHBtFvOtzP3agdsKKObMdA7NiwtKtQp9aSDy1GgtvPFRP3tLSh+wEfmSAvdPaPsvOoq/HAENeUWNGfuS4fzGSOS4h4a+qTEXf4+MLD6b7hoVCYzol8oArNxLAjf56M10Qo=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB4526.eurprd04.prod.outlook.com (20.177.53.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Mon, 21 Oct 2019 12:27:51 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:27:51 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Topic: [PATCH net-next 0/6] DPAA Ethernet changes
Thread-Index: AQHViAr0ehww7MPYPUqedXDa00qudg==
Date:   Mon, 21 Oct 2019 12:27:51 +0000
Message-ID: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e644fbcb-4916-449d-110e-08d756221744
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB4526:|VI1PR04MB4526:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4526256D598DF905634D69BDEC690@VI1PR04MB4526.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(199004)(189003)(66066001)(8676002)(8936002)(2906002)(486006)(476003)(81156014)(81166006)(86362001)(2501003)(478600001)(25786009)(50226002)(3846002)(14454004)(66476007)(66556008)(64756008)(66446008)(66946007)(2616005)(52116002)(6116002)(3450700001)(43066004)(5660300002)(71200400001)(99286004)(4326008)(186003)(386003)(4744005)(7736002)(102836004)(6486002)(26005)(6512007)(316002)(256004)(110136005)(36756003)(54906003)(6436002)(6506007)(71190400001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4526;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N4zRjCcGsrrFKJdAJ5axB/fCHSKfkBjO5M7H8J6Uxz3BDZnxfeEC//5b8Q/jqwfB9EKxQ2MTe7LgDD2MrMbI8MTot8v/X7nXUJbSg2Ohzx7jGbvwfoWq24D6tjyVgkNNuw78iYFHLbQB62evmYiVjtyaqJ67h1nLuKUTA3hmBxV/xLO9ACh5IHQZWpIkoCAVV1sgKGZYBQRxrKttGOnoC2VhcTCt2QLNq59Q3ULPpSph1PO0S6rPKIGkybUhc1pq/m6PhiVWjUHaqA7aY5bUl1jIv9lDYPBlcaMCgJhg4vSYqygE89kjNXQcr11N3HP9hSezubL9T7kvzBZw5g+kh8IFaTRegtckvRdvVjTQ3D4C9lUfHLjfmZ2lC3G8R4VGHunxpKR16R5FnFZC5/hnX9zVqJGpqhQ5B5MUgE50G8JBQ3W+d2gGotFz6Nnyekcn
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7015AAFD74C0044291DF0779E52E0D42@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e644fbcb-4916-449d-110e-08d756221744
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:27:51.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BuqnY8Lzu5MC0v4uTuWThW7jtTIdvDwK/Ce39DseOaCmZKCYDs2+pog6CNECGUdDWixmaQ+lE4GyyskWb6XsCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4526
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a series of changes for the DPAA Ethernet, addressing minor
or unapparent issues in the codebase, adding probe ordering based on
a recently added DPAA QMan API, removing some redundant code.

Laurentiu Tudor (3):
  fsl/fman: don't touch liodn base regs reserved on non-PAMU SoCs
  dpaa_eth: defer probing after qbman
  fsl/fman: add API to get the device behind a fman port

Madalin Bucur (3):
  dpaa_eth: remove redundant code
  dpaa_eth: change DMA device
  fsl/fman: remove unused struct member

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c  | 128 +++++++++++++++-----=
----
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h  |   8 +-
 drivers/net/ethernet/freescale/fman/fman.c      |   6 +-
 drivers/net/ethernet/freescale/fman/fman_port.c |  17 +++-
 drivers/net/ethernet/freescale/fman/fman_port.h |   2 +
 5 files changed, 108 insertions(+), 53 deletions(-)

--=20
2.1.0

