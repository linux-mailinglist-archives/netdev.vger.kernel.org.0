Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3041EF299
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfKEB1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:27:14 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:53572
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729632AbfKEB1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 20:27:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag+iit+aCjrsh5sHt1gptRtHzk06M4Ph0NISAuWpFCifc6/uTB9KC5hsywWNrLCVcRf7tGsbhwPzP2ksyrNmMBWVOsXT4k3ej3R+MToUgTwsAVWn16QxjE94ZQTy+Rx3oxJTu7eMMBPE5r43YogEbHCHnjQQaI3TzSQ/Nmx3dqJCeYQ3qsaRnMqDPJPwkGCSjvJXkeOniiSEQTEEJiryRJ3fXMWuUf0jZQ+AV0RhQDPoCyF4z86zwCb//ERzLIxOGXFoyC52obJBO01frOzGnqNKhJyawTL/fO1jh2IEGwGmXeJJwpCbv7BkmuP6+ypAXokp2tSgaxxnGzcPOXut+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMOVjAt1VYYboK4zPX1TqnonFZseXvy6Pkc5OG8z1xs=;
 b=iD5iDzG1VqdyX6C39IGGG/L+joIPOWspunYBDapm5YZzf39QrW8DTP+cWHOGoQ8mGxkqKSi4lvD1W+Jig6mNIBxK1Qs60vrtz4wvaqepxdQ233cgAwMXsPUid+SGUEUuF/V/K1jZ7HGvUKIbanK8FxWpk6/l/bMueFwfRU4CvEJUvjRk4J2RcYrmQBWtARpEv8TGLQmJMUgfrRZFgaEa3hYStwnvl1xQWa9kI+Pqpn2K04Z7THd1hzwePL8u9cMBmKifCmWGCu5YaD9waFCKFtXDnnEPfu+cD7w0Uw6H41PmSWtvLUUDESIdyNSSV6jMnqUwkHqBiT/UG6M3lC+VFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMOVjAt1VYYboK4zPX1TqnonFZseXvy6Pkc5OG8z1xs=;
 b=XefkI+MrN3apsTL5lsG+4t+H/EYaeMKJWK02YArSi64RuET5lJ2eMLhxyJiErBMxX5/HoKqpjjIzVUjEnUjFcRgrHWGixXUnHOdd4aPwSx+L3OV8tXHFgj3fXlJNefDUGqbae+6ajaawEta/JOHeZJnaZzbYfl+PHLhm4Bi9OrE=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3951.eurprd04.prod.outlook.com (52.134.13.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:27:10 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::5dd6:297c:51e5:2b52%7]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:27:10 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "hslester96@gmail.com" <hslester96@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Topic: [EXT] Re: [PATCH] net: fec: add missed clk_disable_unprepare in
 remove
Thread-Index: AQHVk0caR3l97muk7USTxO6JUo1aF6d7yY3A
Date:   Tue, 5 Nov 2019 01:27:10 +0000
Message-ID: <VI1PR0402MB360095D673E33032706C5BEAFF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
 <20191104.113601.407489006150341765.davem@davemloft.net>
In-Reply-To: <20191104.113601.407489006150341765.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40607455-b0a0-413f-0912-08d7618f47a7
x-ms-traffictypediagnostic: VI1PR0402MB3951:
x-microsoft-antispam-prvs: <VI1PR0402MB39514A282B29CFAE9378A302FF7E0@VI1PR0402MB3951.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:475;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(189003)(199004)(66556008)(66476007)(7736002)(2906002)(305945005)(52536014)(66066001)(256004)(25786009)(7696005)(6116002)(3846002)(316002)(186003)(476003)(26005)(110136005)(76176011)(99286004)(8936002)(6246003)(4744005)(86362001)(54906003)(64756008)(66446008)(2501003)(5660300002)(81156014)(81166006)(102836004)(66946007)(4326008)(486006)(8676002)(446003)(55016002)(229853002)(6436002)(14454004)(74316002)(478600001)(71200400001)(11346002)(71190400001)(6506007)(9686003)(76116006)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3951;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X9kg83riwu5xjNGFvuJC5+m7cACBSLQbTXwQu62fBVFS/KUSxjgMP/nnpNcKJVIef5Ueo2QAfTHkVVtVQxinmPLGJq5CJfguOC/RUgjV1hmWjo2Xu0Ai3h7HnN8q5WwqV1rowmeAtysRIOIedDtGQPOm7cyGyo96tcomRoV0EUJJpMyf6AzWSYY8RZFYC5yQpvUeS5z5tVylwK73s98ei22DLfZF3jZiH23BAlC07OxSNTAyYd+asFkLUus1IJ13OWVXCr2nXybxaR7WAtn41fwtbBjdJTyb7NFYRFm+kpXqNoLDLy9E4pVSKg7iHmpfkz71c7glQXI0U2lYjooqq+FIbx5ddumYXjiRNWSXDiA8MNdHqn7As0vAXM/cuicUpfWUYTcC/vS1ZbJAx5zRmgedG3V/T7Ax5Gyfd50UlzsNP8HYGuDvBuEAN1J9fj+Q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40607455-b0a0-413f-0912-08d7618f47a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:27:10.5581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3pID87XMWsXnsEBRst9Cqlwcw5XHUy94CRCrPsVfRa52EqCwJbxFVsLy1TNwpPbmisYmJulyt5uGnRa0Gdt98A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3951
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Tuesday, November 5, 2019 3:=
36 AM
> From: Chuhong Yuan <hslester96@gmail.com>
> Date: Mon,  4 Nov 2019 23:50:00 +0800
>=20
> > This driver forgets to disable and unprepare clks when remove.
> > Add calls to clk_disable_unprepare to fix it.
> >
> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>=20
> Applied.

David, the patch introduces clock count mismatch issue, please drop it.

Regards,
Andy
