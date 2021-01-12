Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 486392F27A7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 06:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388604AbhALFYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 00:24:21 -0500
Received: from esa9.fujitsucc.c3s2.iphmx.com ([68.232.159.90]:41549 "EHLO
        esa9.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388548AbhALFYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 00:24:20 -0500
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 00:24:19 EST
IronPort-SDR: +Gqmma/PAMZq7tzfYCpNsdDzZ2JHZM1uwqg5aXXhjgO1jRF4SGCBa4bfHPUvacvC8l1PkO6zo8
 kI7v13qDbnwKahOwcz9t2TDVFh51olgxAD2qaoQbpjy+PyhCc8O6v1nFrAzVHoXGjnKbmOnjye
 AIGbE1bg6vWUQK6xDypw+wgGRs2w23k05CSpqqHxcieEgVW/K6rLvu03iCd61J6u2ITSl44BlL
 IpgQd4VAYYmVJt5Xt8lY/tNDGoyDuMYouBM4DWHFFbqhnz/f6XcZ2vv3fy5uwkfSxA5Q67Zrvq
 PdY=
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="24238466"
X-IronPort-AV: E=Sophos;i="5.79,340,1602514800"; 
   d="scan'208";a="24238466"
Received: from mail-os2jpn01lp2057.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.57])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2021 14:14:27 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O44G2EVDqwQ4D13aBHvqKRi/G4DQNJVet+yhFkUnx4CF09D8Tou/Dn+0A9Y9upbEmg3kBS4dDnibgfpbggKvmigKJaDkjXG7jAsLOeIPPp67BCF9sXFH2Ju7KNULi/sUl23iwsypKoSvY+dL4WYNCVEjt7GirrQCZ8VsxkVnhpAy1SrZ3orhetmJg1GhtbTP4jhgDqrud8WmNRP2HAN7KPchLLoqWT2eJ07lSaGFSgN4PzvzJRsRUXXKVg+3+afitAFol9uGOoB91l3CQ3A/7h0xrytal6yhNVDBplMuAJfM+lkGRcSF7w8F0qR2oq33eNdMX+F3Xlkm9pflyLVC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAGL3y44LxjFVIzK0zHOrDA7hN5VnHQVR3H+Gussa/k=;
 b=IoPytVlymfSiLWdFBNg84G3JSNWX2FaVzTyHF1uT9AI7VzHZbYt+V24XiITgl+ZmWFM8sRHnVT6nlb1r7mpjO1yjatGrvbMHGWO6qJ+/oXB+IioMpgNzXxEgg9MVcrOVrbMutl5VO8WPq3+HIVMZvgHFeaMD9nw6/2rF2uPER74nWjYc89yCxRSe0QaxBXSlxSJRE6HyldeDUl/m3ascIcjwfe/pTmmc6A3ApRS8jWzqPZJO8jmOncK0+BiGxHRJbZoxndEmD6kGMeYrv7MKPtxS5lbuS76sT6Dy6Al/s67pbRmmDYoIxmJf62QH69EFF3sp+DFUmLTw0NbQUO3KYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BAGL3y44LxjFVIzK0zHOrDA7hN5VnHQVR3H+Gussa/k=;
 b=MU9opy+i+QFcekEA2DhgdVE2v3bbav0/Jfiou7qZ3xyDPens/TCU1zV5yluK6FdNwPTNnf1TTTiUNClob+hBfeRuO1LAEV/b2q2mzB4wCnnOFPqW3ByCosDhe7NzNNfUWxwiKKU5hyeP3Mgp+Ac3j4LzElWLC7vIE9646Sd11oI=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSBPR01MB3333.jpnprd01.prod.outlook.com (2603:1096:604:2e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Tue, 12 Jan
 2021 05:14:21 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd%3]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 05:14:21 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: RE: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Topic: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Index: AQHW5y31ARgi0NV/wE25+9nETrMkFKohCyYAgAJo02A=
Date:   Tue, 12 Jan 2021 05:14:21 +0000
Message-ID: <OSAPR01MB3844F3CE410F7BB24BAA54B6DFAA0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
In-Reply-To: <X/sptqSqUS7T5XWR@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 066a060e79ef4cbf85d6f50d6688659c
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [218.44.52.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2e6f42e-34f9-456a-3588-08d8b6b8ebcf
x-ms-traffictypediagnostic: OSBPR01MB3333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB333335A5E115E03596CEE705DFAA0@OSBPR01MB3333.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9dSMBHnG+OqjnI7UB1O3XsynwlT621Pe7JufC4Wfs5hYToao9lbqX5urG/hL8UdhaO3FU9Qc4eTnLcL2zt0d5Lu4KMOwViXHqcg46+jn0uuhZkKxiJcdpDrj9dAIjJkHQc0nWw5CfeBpbNRFTqrCpIinIIe6KaX8cvC+Y5Az73tOGm4d4p+YoF1UIl5/A/j7r1HiKV14c8uXv9B6eeDYC+NkHVt7fwvHqb4KI0nMx30nxFtWHrdw146nmIXMIM0/hVrBBj+JIDH2JSgBR5gxwK/NgjmsdT5n1uZxV5yhOKMPjNNY4G1U3PO7kN/E0qOY92JQzXB48/ZNox68VNs+cqadqMrluIq7x96tjxcZqGoaxF4Y9OPMtNQTkWEtG1KLpviTHTkIRDsVzrUnjtLGWJiGIZJMv5OJ5DZl4S+kZwBCS5Ne+IWk/MhA1dQmKS+d
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(136003)(376002)(83380400001)(2906002)(86362001)(6506007)(4326008)(26005)(186003)(107886003)(66446008)(478600001)(33656002)(52536014)(316002)(8676002)(54906003)(85182001)(5660300002)(7696005)(9686003)(71200400001)(55016002)(4744005)(66556008)(66946007)(8936002)(6916009)(76116006)(66476007)(64756008)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?VmYrZHJMTmlqT2JuOEJRZ2VXMWlodDNiUWhycE1CT29DUExSV054KzJD?=
 =?iso-2022-jp?B?cGNIWFQ2dzQwMWZ5aEQ4ZmVkZFJzT1dtVkZOQ0dBZGxMSTV0WjA5MHJX?=
 =?iso-2022-jp?B?U1RBQmpKRlUwM1UyeFVSZGhaeFdRWlJUTjBkV3J5TFFwTE5oSWZYSStF?=
 =?iso-2022-jp?B?a3pQd3VWUlU0NjgvNXpBWmVuc1h3dkNsd0xpVE0zT0xxZExud1V2dDUr?=
 =?iso-2022-jp?B?MnlzRWFuNFJYdWpDMTI4OXFzdlZTVEVjb1B5TVFPcEU2V2NNWWtZdlNJ?=
 =?iso-2022-jp?B?akczUzFpSjlaV2JyYlJhcUZQa2krK3BUNTJ0ekttMG44aXc5NklpTWM0?=
 =?iso-2022-jp?B?Z2gyaEZJVmZpQy9aMUc4bDZLVmM1TzkyMG9uT1ZaYnRaYXE3QllEbmdt?=
 =?iso-2022-jp?B?aXlMWmxtMWZRR2FncTlCekRlcERmWnlXeldrbkhuYVFnWDh4S1ArQWZP?=
 =?iso-2022-jp?B?M2FuMEV0OWVSdk9sdEtGMStxTnBpRDBOTDBLQ2I1SGNoNmxsY2YydVRp?=
 =?iso-2022-jp?B?YmV3ZWZKdkwwTVJHRkhZTFhieXZ6VnkxL1hXK1VoUmE3c1dtUVNEQ2p3?=
 =?iso-2022-jp?B?eit0ckhVWU10UXhKeUwxT3NmNWRDeXVqaFV3S1o0eFZNRWNjNVF4UEJN?=
 =?iso-2022-jp?B?Y1ZVdDkrUVpWZnZlQjVGVEorcHkrQko1OXNKaUZMV0VadlorYjRhTS9G?=
 =?iso-2022-jp?B?eEh1bXAxR1poaDVrMUpoNjZpNlJyMkQwZXN5SDhMTXlNUnBQLzdxeHRk?=
 =?iso-2022-jp?B?dXRoTkhWRW1KQlMzaHY1VWJkaDB6MWxjQmw0S2pOMUtLMUFBQjJINFRt?=
 =?iso-2022-jp?B?SXdWeVhrYkIzejN3a0xtWHVjSG9JTGtDVDNnQmdCUXJQQzNkNXQvbzFC?=
 =?iso-2022-jp?B?blh1UFRCSDEvd1czYllOZEUzT1dRRzlNU3VIOHNKb0c0djkwbnI2Mk5Q?=
 =?iso-2022-jp?B?N3p5QUhTQTFIRnFXOFJhaXk2clZHaHNMa1pBallGQkpRVy9id250MlNZ?=
 =?iso-2022-jp?B?UWZKT0Nlbm5KRGtCRkgwcThiWnV4ZHJ1czJ4TkF0Z3ZKcVgyY3BZRHhT?=
 =?iso-2022-jp?B?cmd1aTBEbnNHNkRsTDdLR21NMGorNHZReGFtb1NnOVJZbGNKcTVLUllo?=
 =?iso-2022-jp?B?TUY2Sk5hWVJieWtOeTd2UUFlcU5qc1ozOENLOUlIeEdjcms4VDJlZVoz?=
 =?iso-2022-jp?B?Tjd1Z0crY1BYd0hOMGFaOGpRVjZMMEdGSUlOc1VvM0Y4ZlR5YVlEQmJn?=
 =?iso-2022-jp?B?RUlkNmRaQ2FBaXQzcU80Q3dJN0RoelpLMnB5azJoSmlWM1hmS2QzV0dM?=
 =?iso-2022-jp?B?cTAxdERRb2VPbVA5ZVN4bFFkL0IwcGdkMWJiUjZ2N2c1Wjg4bVIzR0Ur?=
 =?iso-2022-jp?B?MXIvZTlTWHQzMzdxWTVWcU9LOGdxaGNkYkpKazFjbURSV09XWT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e6f42e-34f9-456a-3588-08d8b6b8ebcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2021 05:14:21.8778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rAvkgTNk5YetcimyqTg9qByCDfUppALKYrWBDyRVcq+ZdzGZe3DlT3xnqDalPgTMLDbT5WcY7GnPl8pGGVjB2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB3333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> For T1, it seems like Master is pretty important. Do you have
> information to be able to return the current Master/slave
> configuration, or allow it to be configured? See the nxp-tja11xx.c
> for an example.

I think it's possible to return a Master/Slave configuration.

By the way, do you need the cable test function as implemented in nxp-tja11=
xx.c?

Thanks & Best Regards,
Yuusuke Ashiduka

