Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA704CD75
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 14:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbfFTMKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 08:10:39 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbfFTMKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 08:10:38 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5KBu476029010;
        Thu, 20 Jun 2019 05:10:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=b2Q0vyMkWNw+bzQTh5Ddj0lxPF1lRM8CRJetaakk9AA=;
 b=H6eIe5wrWQt6DwtKcho7thV55zfm0ZYcZainLM/fy0sa0qis2NtxmQOVuIybtPGsz7yQ
 OLTBOUNlhpkACmWIhpY6OZkmpB5Vk3r7liV6pJgccx8U56YkUMJbF9TixJsKpHsb9KF+
 jKU8oHnAjRXaS3fxxbi3IkBcsc5g0hLVXoK+T334CH3nQ+QPYB1vbyRYupbHCrDRZSiD
 wnic7uNUZPbnhxr7GJp53y4uHwOJGqfjlSt+s85bmkw1Vc5+cMQ8rpguyBQeX/uThMyz
 FDGQE1r31CrDLP6VzAPdTTxCrc4XBEyTePuRpNCgVcQrxXBSdkLk8mzwFalAahgdGben Lw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2t7vrk2hm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jun 2019 05:10:34 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 20 Jun
 2019 05:09:31 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 20 Jun 2019 05:09:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2Q0vyMkWNw+bzQTh5Ddj0lxPF1lRM8CRJetaakk9AA=;
 b=GASySWlA7y7TF+Tew8jMrmslQsBj0luYBnpA3H7Xua4gdhKLLf11dQzBeaiwW2Ot37+2rzKHA067IVpI95slILRNbYqPjBMlRokskkRvPAJVY3ebmocaqrRU5xTD01llcZAyux8q0TckVXSF9BF2PcO0i6oIZQVUbUEGEgUIKmw=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB3150.namprd18.prod.outlook.com (10.255.236.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Thu, 20 Jun 2019 12:09:30 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::5c9b:c441:b4d2:da19]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::5c9b:c441:b4d2:da19%7]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 12:09:29 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>, Jiri Pirko <jiri@resnulli.us>
Subject: RE: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Topic: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Index: AQHVJQJMBFYAJht0E0S8f7iw9+GZZqagdSOAgAPWPzA=
Date:   Thu, 20 Jun 2019 12:09:29 +0000
Message-ID: <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
        <20190617114528.17086-5-skalluru@marvell.com>
 <20190617155411.53cf07cf@cakuba.netronome.com>
In-Reply-To: <20190617155411.53cf07cf@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 372b43d3-df3b-44f2-6796-08d6f57825e2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3150;
x-ms-traffictypediagnostic: MN2PR18MB3150:
x-microsoft-antispam-prvs: <MN2PR18MB3150BAFB5EDF460534B00FF4D3E40@MN2PR18MB3150.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(346002)(376002)(39860400002)(366004)(189003)(199004)(13464003)(478600001)(6916009)(73956011)(55016002)(7736002)(66946007)(66446008)(66476007)(26005)(229853002)(66556008)(76116006)(6436002)(53936002)(64756008)(6246003)(476003)(486006)(14454004)(11346002)(4326008)(446003)(9686003)(86362001)(305945005)(33656002)(74316002)(186003)(8676002)(52536014)(6116002)(25786009)(3846002)(102836004)(53546011)(71200400001)(6506007)(71190400001)(99286004)(5660300002)(2906002)(54906003)(256004)(66066001)(8936002)(316002)(76176011)(7696005)(68736007)(81166006)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3150;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X/Nfkf2CCfO3O0AOkjQBA59TQVVEutx89YC8ug48T0ReXJYhG+s4NUmFY6UVDcRUjsBwRxv3Lz4FwDcEdBpX1nhx4XFHuCbV8wZqsjcMiAWZDCdJZYCzR2Vo/BVrZXvoJc2oUZoFmVaadjWPnhPscFaibcgzdQNAXOIdoUhTsTAbfh1cD1vwNsy8IQxzApTPcnpuqznzs7qTDELmWjgyQ/fvZ3lX3IpJHpPxfMu6rzPrQnDU+LGdOz86dFZ0iFytTb0/6YkyqnAh7x50Smzayu9DWL4W4dLkCpC4JqgFclE/SjRHIYwS6TtDpIatqK/fhT1nCOW/v3Qd5wtCuhLQv/Ujr8/H8gWm4CiGf71csU7Sto/DFSXBUCwPGeKQV9XwlIcmY1By1Ujr7AbQstc9Ju8RVoq9Ao+xqIvZfkiYLfA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 372b43d3-df3b-44f2-6796-08d6f57825e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 12:09:29.8879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3150
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-20_08:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, June 18, 2019 4:24 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> <jiri@resnulli.us>
> Subject: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> configuration attributes.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, 17 Jun 2019 04:45:28 -0700, Sudarsana Reddy Kalluru wrote:
> > This patch adds implementation for devlink callbacks for reading/
> > configuring the device attributes.
> >
> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
>=20
> You need to provide documentation for your parameters, plus some of them
> look like they should potentially be port params, not device params.

Thanks a lot for your review. Will add the required documentation. In case =
of Marvell adapter, any of the device/adapter/port parameters can be read/c=
onfigurable via any PF (ethdev) on the port. Hence adding the commands at d=
evice level. Hope this is fine.
