Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DDA21673F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgGGHVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:21:44 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:58211
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725825AbgGGHVn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 03:21:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crda7jdyqEwJRHajgkJFy72WHUb6meMw/YNV2aYi9GSHeggdcPai1WOSvzbqK5vwTnDK+6RbNomhQwqEnbZ4bAVpkSn91zhug05H0wr4GbZJidmm6uzDY8/LV2rOlldHXOyVx/eAGQLrMQPeZ0Qg0lqkQZ2vhbmzHv2ovTtrk/+Zc25LRzb9uCIf0MhnDB3OBcxZquPGML6zjABgCdX8UvI0zNgLAFFK4wcziCKfnvqRvJzjOjyuHv7bEV69Rfnd13gEWppu+qAiON/oxLmLXpMD1+DZk9zjEqhXhqzyXDpDbla31GSlV1h1w9wEw0hnvYdmN8x5bVR01AzdIPjUYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOXvbG4EWJhsWF/k9oH2j1dc0MQ4vzKH8zDUnbHwS1w=;
 b=HV+MrQRkPveTRHeY2MgzZ48PQv/crbBzsgsuFce2nZr+kKcsgpP/V5hEdN/nsz9C29/Tx4cjIin4PjDTFryRWVXgw5QVwexgW2Rk4lHUFNcsOAntxmNynd89u+VhjATQkjcUoNQFTghJ4qOd5OcfCQEa+t/LAmO9v3dDH2vLei+i4+R5hoJ68KXRwvvl7xCYo9X7X3I18ziyxYCwE3ool+TBri18O9NC4jsgd3CiEpixc4B9m1Q5m5SIhqSHVw+/Fz1VTgGBy4csMOTDMNuiuS3utCo/TbvZcmSz9S7a6M6lWunfwENEFFQlieLRVo9OIj2bBpXcCIbGI0q1W+MNEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOXvbG4EWJhsWF/k9oH2j1dc0MQ4vzKH8zDUnbHwS1w=;
 b=CpWVorzv9OctGr8VEzFc1NgY5CKMSZ8pN1uU3pYqUZ/zKd00hF+XTO1AhxJf4KQ84L4ca/++f4C5y5aH6wz8YabmlaXckAubPS33yi+I8U4qLqrGEEu4I26kqle884LYTZsn5MquZjE/pENlnMTm/PSkNzht9cdACWB3G0VyVNk=
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com (2603:10a6:803:3d::27)
 by VI1PR04MB5837.eurprd04.prod.outlook.com (2603:10a6:803:ec::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Tue, 7 Jul
 2020 07:21:39 +0000
Received: from VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09]) by VI1PR04MB4366.eurprd04.prod.outlook.com
 ([fe80::8102:b59d:36b:4d09%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 07:21:39 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     =?utf-8?B?UGFsaSBSb2jDoXI=?= <pali@kernel.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] mwifiex: Fix reporting 'operation not supported'
 error code
Thread-Topic: [EXT] [PATCH] mwifiex: Fix reporting 'operation not supported'
 error code
Thread-Index: AQHWUSxGeMcJM+WKlk+t0TapJn5iJ6j7u8Dw
Date:   Tue, 7 Jul 2020 07:21:39 +0000
Message-ID: <VI1PR04MB4366C310C7F50DB7CAFB733A8F660@VI1PR04MB4366.eurprd04.prod.outlook.com>
References: <20200703112151.18917-1-pali@kernel.org>
In-Reply-To: <20200703112151.18917-1-pali@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [103.54.18.180]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e57b1137-3c09-4144-d403-08d822466418
x-ms-traffictypediagnostic: VI1PR04MB5837:
x-microsoft-antispam-prvs: <VI1PR04MB58372BE426D6F5BB1146FBB08F660@VI1PR04MB5837.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k8zBLoNweWEV13Q09kIUrjDgarz2KCNDs7JpaK59vDyc7o33jlTgsHR4gJY2LDRV4aAOZSRYy3oeVWvyuepWaQXhKfW+kvF+KGSy0HhsJhzuQM34bD/UVb9HSdXVOIyd8HC1BR5/A3IJ5QB38uqR6pU7F1BIb4jyyBd4ZsxQi8ZYo5qQRlvnALJjiEsm9xfpxK4v+NSJ9MvHO0IrEPYS71xwreRKFgW20fIV27ENFgbNzt+hgJ+PKb3Y2weNT+Wzic/CXSWedC6eQQ20xPB/5JXvM/4CH731d9zelH05avPO0fIYn/sEazmVUN5lfkYp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4366.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(5660300002)(71200400001)(52536014)(2906002)(44832011)(66446008)(86362001)(4326008)(64756008)(66556008)(76116006)(66946007)(66476007)(9686003)(55016002)(8936002)(26005)(33656002)(7696005)(478600001)(6506007)(186003)(4744005)(8676002)(316002)(110136005)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: otYjQphSnVS2FRxTUIpS/G9qNbF0BtVOh7tSCXqnUJ0rFv6haW6j4JxWct0beYu3qvAcqFsLbfzeM1qip11isHcDj8l/myRVP1TREqguUjS/52+XEDOLqWtCKauUWdCjVtyFGuReGtGgYx8q5aZwcIrdkrFaeLWgnHwXZcsqURs06qOmVByiWHUMEC4ih5ftzLSoyRgH3VZXExfuO7Ilu+X8LOZbyV7KpnPRmw25OkIBrfCkE29n8Yt3l2JXXYKrgvl5QDx1kvNjbD630aAa4U3p/Kc2+6q1EHFCJD70cdGuRGaBFXyPB7gClEklWiMucNduXBFZXdT5vbG4x+4ynIEiFlZ5BACzGPhFD59I327imGa0x2I0svNRp9V+krOalNZKnLvXeii0tiOtiexNbR60FlS40bid0neb6fYibgTyTBbZ6nIDBi7yDvE++F15gaavaYwxOPJujdFnuNEITEu1gmW/twAdKU8+99ReiUY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4366.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e57b1137-3c09-4144-d403-08d822466418
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 07:21:39.2880
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KkyOMPdQeu89FxbIZIBoPbuA7M5Gn/Pq4LkUSdLIFH8cNHtAIeosAc8fHfzcbFs8cn/0cpMmCcwKx9+zcUCb0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5837
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGFsaSwNCg0KPiBUaGlzIHBhdGNoIGZpeGVzIHByb2JsZW0gdGhhdCBtd2lmaWV4IGtlcm5l
bCBkcml2ZXIgc2VuZHMgdG8gdXNlcnNwYWNlDQo+IHVuc3VwcG9ydGVkIGVycm9yIGNvZGVzIGxp
a2U6ICJmYWlsZWQ6IC01MjQgKE5vIGVycm9yIGluZm9ybWF0aW9uKSIuDQo+IEFmdGVyIGFwcGx5
aW5nIHRoaXMgcGF0Y2ggdXNlcnNwYWNlIHNlZTogImZhaWxlZDogLTk1IChOb3Qgc3VwcG9ydGVk
KSIuDQo+IA0KDQoNCk9LLCB5ZXMgdGhpcyB3YXMgYSBtaXN0YWtlLiBUaGFuayB5b3UgZm9yIHRo
aXMgY2hhbmdlLg0KDQpBY2tlZC1ieTogR2FuYXBhdGhpIEJoYXQgPGdhbmFwYXRoaS5iaGF0QG54
cC5jb20+DQoNClJlZ2FyZHMsDQpHYW5hcGF0aGkNCg==
