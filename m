Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4075E228BBC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 23:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgGUVys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 17:54:48 -0400
Received: from mail-eopbgr750134.outbound.protection.outlook.com ([40.107.75.134]:2019
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbgGUVyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 17:54:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oj5MAo1eZ+h0I50EV1wbJcyzPPhalK/Iwal2PPrQLLk343uzZGQDbO5Buwejepy4uDLyesrcmPJ9WnPIQlnR0kW2cYHR4NdMAXVlmQVvUvvi0VOYYjZ02N/RxGq8UG5u+wxQUiv5B/mP3hif2/eYIfJSum3Mhlj1wDzlgQFzElGqWzZ58mPeoQV1srqfLBHNUdzl3QPq8gbMzsg/4wQ69JdaeKqrCdkMs/vmYTe+Vb6aEedR1pva6HmlI27HmT+Y88jQ4CqY9fgAMNvXSVbEijri8t144jxX0C/U0StESMtLjDnBGuUtrcYUTfb2J9/Qt5JATjlbs+WYiLNiepNFZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAvUQt7f4CPXi5WQRfSmbRwO9dQ3iEimH9kY7VkvRXA=;
 b=BghXY09a3hOSBJsleACADmPyBAbiVTqEfBVptFgztBzSyuUfdfHjFel2HHMgbp7nyKlXVP2xLZVwuVu1XPaJJOv0LJqvcsdH30mEb0XEyuerrnL6ixKia/bIfHpQ5fmunRFigZTovkTKuZ7b5hNl+1p3yDNEcGW1OVeiKh/+SlPx8SDlpprlwZEGoPxw18W5z6Z+hSaBSbGEOGSznEqU34qB1xYbCFw7NeYkqCaUMUj1dQLKkA8qudmah/JGR8Avp4X3cLgwwxPkK6IxLq7LSPczgDJ6DnAvuTlo/QaKdXQQXAxRvaosOE+vjl+1coTK5lhcuauc/WfWHVZF35zuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAvUQt7f4CPXi5WQRfSmbRwO9dQ3iEimH9kY7VkvRXA=;
 b=HM9ID6mJJQEJrqq6BhehVxuexFqr7cW2hJTI/8H9BgTlFrmAXFowO+ZJBFq4kXg30F4JuvARfP1iiy4ecM4IwxQAQhiPJr2G5lBpAXFDSBujUnKEr4Q8LZHexNvJMm1UySytiVOw/tlxAzHcmHc6aOk97zuixLfZjDmxzBh5UR4=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0897.namprd21.prod.outlook.com
 (2603:10b6:207:36::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Tue, 21 Jul
 2020 21:54:45 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.007; Tue, 21 Jul 2020
 21:54:45 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Chi Song <Song.Chi@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Miller <davem@davemloft.net>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Topic: [PATCH v6 net-next] net: hyperv: Add attributes to show TX
 indirection table
Thread-Index: AdZfG0GKTJv85JzZS3GaPc7Fu5spkQAjaFRA
Date:   Tue, 21 Jul 2020 21:54:44 +0000
Message-ID: <BL0PR2101MB0930C1EA0810250E5803225BCA780@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <PS1P15301MB028211A9D09DA5601EBEBEA298780@PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PS1P15301MB028211A9D09DA5601EBEBEA298780@PS1P15301MB0282.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-21T04:58:58Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d3b0d683-b31a-4af6-8e2f-f4e0d3c15ea6;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: microsoft.com; dkim=none (message not signed)
 header.d=none;microsoft.com; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d71f1aea-5fae-4b2a-ab87-08d82dc0ae12
x-ms-traffictypediagnostic: BL0PR2101MB0897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB0897660B83DDC920C97585E6CA780@BL0PR2101MB0897.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:397;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8qgpxs2bVDrFTPSX4+bMva0jFSzAunAuHkGSsFBWoyw9+C9uA6UXTDfPi3uG17UGL3ztfF2MWhpzrbKtWQos+v6x/MzkJ+IiBjcUQgwIA7E30/yrVUZtLDPiFxzdUbHwcQ0v6IUzNbGTZ86aug/BCEuvgCL0WtggdOrjjNzZB+N9rOBe6cvtE12yxVULqT5viZ02FHlsZUNhLoOyaEWNqHabtBlb8q6121ikNAjNNtWyFZtaFVVJY1QlgDecRMrpbLg0DZdcOm7rAE6dwJromFRx51Wp+3fPWdRQnH/adDK/bPKom05tQe7mzuxfoQOgrP0X2/mS4jqG2exKTDRdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(316002)(9686003)(110136005)(54906003)(4326008)(10290500003)(53546011)(6506007)(55016002)(7696005)(26005)(33656002)(86362001)(82950400001)(186003)(82960400001)(2906002)(71200400001)(5660300002)(52536014)(8990500004)(76116006)(66946007)(66476007)(66446008)(66556008)(64756008)(478600001)(83380400001)(4744005)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qNXj/pXEw60WVcFrxfjP48UvaWFhZTwm8a7H0NcJxlgycNgowQMWH9O+lDYUt+bX7N5uVzQwMAMB44i2zncMA9mqV84m4r8j+m19YXrnGRmtmZIz4Uu43KbV6BkRwh/va5W5nD2k+SYqCg+VAdCo/nvaaIV1uTErZbI0qZsS7n+hlmyFFdkAyQe4TVcRnXHOUXWQJ7w1OiN1b5e+9lBZ/lmnXpqYynX9C6vyF3o6Cj6pdGYjqGAXEfgT7oeTZvLjEkYLJ5+U/nBOKZxTr5tbi9NkIwdZH4utLR9r/ch9oVP8taHnDjInN0aZmqCXBvO+IjICRpqu6auRzGDiLTRVcnN0/ihCW2KD35g/TdV7ip5jC80V3Ll2PSJKL92ccB6arLHOdhtQ6vcVVuptzqrMRneoSmiuWNQJHVpiB5cnCmm852Ic4y5I2HkQBnNVzaM5S4Y+MWPvKlKkjd8aTzksET4fonysCAIJStfYbhuZ2cfC2yyqpW9HJBRRhc9pmDhHUIuK2yLgloJmjRdDhYQFQdkWTG/NjfzplcrGiimgvk+hQCTnfsL7Qi/iRm+CKC9tmmWpDH0F4xSCsvoOqbkJ22q/dR/CKTKwKfoYil714qspnnAFqbb/kkjV7GeO0VWzZWpE4sv7tvYieJ/j4XkF7g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d71f1aea-5fae-4b2a-ab87-08d82dc0ae12
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2020 21:54:44.7226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q62fPdhNJ7VhgWqpkcQ/QoP+AvsAUSaZrjDQF4Bh3VYu9yJTFl9QInk6HLrmGrL0IJragV3F2nmFOyd2bKYqrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0897
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Chi Song <Song.Chi@microsoft.com>
> Sent: Tuesday, July 21, 2020 12:59 AM
> To: Stephen Hemminger <stephen@networkplumber.org>; David Miller
> <davem@davemloft.net>; Haiyang Zhang <haiyangz@microsoft.com>; KY
> Srinivasan <kys@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; wei.liu@kernel.org; kuba@kernel.org; linux-
> hyperv@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH v6 net-next] net: hyperv: Add attributes to show TX indir=
ection
> table
>=20
> An imbalanced TX indirection table causes netvsc to have low performance.
> This table is created and managed during runtime. To help better diagnose
> performance issues caused by imbalanced tables, add device attributes to =
show
> the content of TX indirection tables.
>=20
> Signed-off-by: Chi Song <chisong@microsoft.com>

Thanks you!
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>


