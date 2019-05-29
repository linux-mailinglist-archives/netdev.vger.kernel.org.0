Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 561B42D3CE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE2C2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:28:14 -0400
Received: from mail-eopbgr720043.outbound.protection.outlook.com ([40.107.72.43]:6272
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725816AbfE2C2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:28:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sNxWvouK3CV1UqrX8DkSdHTrL9wyGpZB/ogiRK1+X8o=;
 b=d83GOlWS+g4RYLncJ1G1zOLBnvBXUjcvn9vikguWPHoRn/RsyYD75nUi7RecSWh8D7E+ZnGhvomiJMYTdl7rz5voZDk98wDDBUHBCtM/44Qk3u+QnKsCE9olVQQAPWY6uaHqZKPYelXz2A3Q6xj8AKSv7n6gP0fyrfLJSkJBDhQ=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB4166.namprd03.prod.outlook.com (20.177.184.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.22; Wed, 29 May 2019 02:28:10 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:28:10 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     David Miller <davem@davemloft.net>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: stmmac: Switch to devm_alloc_etherdev_mqs
Thread-Topic: [PATCH net-next] net: stmmac: Switch to devm_alloc_etherdev_mqs
Thread-Index: AQHVFH3ChMvditMZqEGruBoCTIEsdKaA142AgACJQQA=
Date:   Wed, 29 May 2019 02:28:10 +0000
Message-ID: <20190529101908.4b40512e@xhacker.debian>
References: <20190527190833.5955c851@xhacker.debian>
        <20190528.110753.377345658167716646.davem@davemloft.net>
In-Reply-To: <20190528.110753.377345658167716646.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: TYCPR01CA0032.jpnprd01.prod.outlook.com
 (2603:1096:405:1::20) To BYAPR03MB4773.namprd03.prod.outlook.com
 (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 241fa83d-d3a2-437d-4fb1-08d6e3dd4ab4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR03MB4166;
x-ms-traffictypediagnostic: BYAPR03MB4166:
x-microsoft-antispam-prvs: <BYAPR03MB416628A812F3632FA3DDC004ED1F0@BYAPR03MB4166.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(376002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(486006)(26005)(186003)(316002)(6436002)(86362001)(11346002)(476003)(446003)(9686003)(66066001)(71200400001)(6486002)(256004)(6916009)(71190400001)(229853002)(1076003)(68736007)(6246003)(478600001)(81166006)(102836004)(6506007)(386003)(558084003)(76176011)(14454004)(99286004)(2906002)(25786009)(53936002)(54906003)(4326008)(3846002)(6116002)(72206003)(64756008)(50226002)(52116002)(73956011)(8936002)(7736002)(66946007)(66476007)(66556008)(305945005)(66446008)(5660300002)(8676002)(81156014)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4166;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YcUcEOcu54XzmykvC0bxSST5NcHmIheWn93jnKM2eIJVpQaFktHtMS85DjZWKTH33WNLi76GHAJoosNZ22bDRGPcNxvP2HkcPSo81Afonlt9YkrPUPG93lnG4AwRdzKwZd+MQYiytg+iWaRBgj2NQIVyWDS/yH5L3Ht1Q6Wc/dtGL/YL8RXtPQ8SFpxleoFVJGShsbaA/wqcZIckCVX1aR/P+zb7mtcYuEIlSb43V6VWM7TRGcDUBjwhsbARTjYi9irkGE+YYM9Ac+kTrIX3NGEb3i2cx3SPNfBwmRmeMDN/Ul9G8geM4E+pYgOSe0+J4qlR/1d2pBtzsO8laRcr0FnHn3SrK40NVGMXPxSJU+E2KXC7gMhYXxrdC4wE1/XL0JXiZ7zv+jiBF+908yQlBMS1d8/NzvAm51AqmKNROq8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BBF8F748863E0047912AC6ABA17B32BA@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241fa83d-d3a2-437d-4fb1-08d6e3dd4ab4
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:28:10.4459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jiszha@synaptics.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 May 2019 11:07:53 -0700 David Miller wrote:

>=20
> You never even tried to compiled this patch.
>=20

oops, my bad. I patched the another branch and tested the patch but when I
manually patch net-next tree, I made a mistake. Sorry.

