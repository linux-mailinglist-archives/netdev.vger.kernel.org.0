Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993F438794
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 12:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbfFGKCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 06:02:21 -0400
Received: from mail-eopbgr1410122.outbound.protection.outlook.com ([40.107.141.122]:36128
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726584AbfFGKCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 06:02:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Z6z4LvArFmwjk5Kxar9ciw2QDAt5r84X13H7hbm+KM=;
 b=LOtqTM/lmjtjcbRSBlWhcYZum6zC8oxPYfPz/bJM2F+7bD4HIbxPrsSKKa3/RqSKrK9xH3PdN/NgNouvJ7HLMHJweMrzxV67Cle60t/cwBQHwWMmlaAlECZRdLhsvzfdmFe5B/UuVI82eZDbmBkOPgNvBjiXzpwywTjlIc42+hg=
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com (52.133.163.13) by
 TY1PR01MB1882.jpnprd01.prod.outlook.com (52.133.162.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Fri, 7 Jun 2019 10:02:14 +0000
Received: from TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::8a0:4174:3c3f:f05b]) by TY1PR01MB1770.jpnprd01.prod.outlook.com
 ([fe80::8a0:4174:3c3f:f05b%7]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 10:02:13 +0000
From:   Fabrizio Castro <fabrizio.castro@bp.renesas.com>
To:     Fabrizio Castro <fabrizio.castro@bp.renesas.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
Thread-Topic: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
Thread-Index: AQHVBpxEfaP7dJG4WES76lrhZ+ehP6aQILng
Date:   Fri, 7 Jun 2019 10:02:13 +0000
Message-ID: <TY1PR01MB1770D2AAF2ED748575CA4CBFC0100@TY1PR01MB1770.jpnprd01.prod.outlook.com>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
In-Reply-To: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fabrizio.castro@bp.renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3bb7a36a-2c04-4062-be2b-08d6eb2f3712
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TY1PR01MB1882;
x-ms-traffictypediagnostic: TY1PR01MB1882:
x-microsoft-antispam-prvs: <TY1PR01MB188207A4899633CE8973AC4EC0100@TY1PR01MB1882.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(396003)(39860400002)(199004)(189003)(66946007)(64756008)(66446008)(54906003)(66476007)(66556008)(102836004)(486006)(8676002)(81166006)(25786009)(74316002)(446003)(3846002)(6116002)(2906002)(68736007)(53936002)(7736002)(76176011)(4744005)(305945005)(7696005)(8936002)(99286004)(9686003)(110136005)(6246003)(186003)(6506007)(53546011)(71200400001)(71190400001)(5660300002)(66066001)(316002)(478600001)(52536014)(76116006)(73956011)(81156014)(14454004)(229853002)(476003)(86362001)(11346002)(413944005)(44832011)(55016002)(256004)(4326008)(33656002)(6436002)(26005)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:TY1PR01MB1882;H:TY1PR01MB1770.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: bp.renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dlDf+dk+pWb+C5qOZMtBKmrGye4JRFEkzhh21Tjj25vParGo5Dymx38yuu2up+iwgEGfhEPE2GGF2CgTpaslhJdwkcZJLwBH7TKeH6Qk/ddPm4KNlRLsON3+BZqCUXaw4g7N/pqPts/wVMrnSNmNlb0BkXMKnpH/OIOyb/PQbf0JVAXULGytIvvfzeq98Pr7Tos5Drs1BE8U2/FzIb1L/t3xgm7TThS1jNG6kNawsf+Iq4M1/2T7R6ku3VkdmqU9fdE+ZhtzRW4g0jltxKkAbYfvLIHctq8ygQ92Fv669md4w5/CuY5rjPSnTKQMB1x4Rm3n2VVgnKMdV/Qt+g6QGSzw0ZTQN7PurozkM2DIGh7dSqu03sRJoX6DGT/Wlr2yw6GqBbf1hT9ALhFmS8tfrCIgaqDDU14lyQBbFR5MT9k=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb7a36a-2c04-4062-be2b-08d6eb2f3712
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 10:02:13.7320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fabrizio.castro@bp.renesas.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY1PR01MB1882
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear All,

These patches have been around for a very long time now, is anybody willing=
 to take them?

Cheers,
Fab

> From: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Sent: 09 May 2019 20:20
> Subject: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
>=20
> Dear All,
>=20
> I am reposting some CAN and CANFD related dt-bindings changes for
> Renesas' R-Car and RZ/G devices that have been originally sent
> end of last year and beginning of this year.
>=20
> Thanks,
> Fab
>=20
> Fabrizio Castro (3):
>   dt-bindings: can: rcar_can: Fix RZ/G2 CAN clocks
>   dt-bindings: can: rcar_can: Add r8a774c0 support
>   dt-bindings: can: rcar_canfd: document r8a774c0 support
>=20
> Marek Vasut (2):
>   dt-bindings: can: rcar_canfd: document r8a77965 support
>   dt-bindings: can: rcar_canfd: document r8a77990 support
>=20
>  Documentation/devicetree/bindings/net/can/rcar_can.txt   | 13 ++++------=
---
>  Documentation/devicetree/bindings/net/can/rcar_canfd.txt | 16 ++++++++++=
------
>  2 files changed, 14 insertions(+), 15 deletions(-)
>=20
> --
> 2.7.4

