Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF632027
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 19:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfFAR3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 13:29:42 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56448 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfFAR3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jun 2019 13:29:41 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x51HQW7o025981;
        Sat, 1 Jun 2019 10:29:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=VEXJAPUyXQ1tmq30nNNR7Z+xEWFfQ24I/OO1e5N8kcw=;
 b=dH+gSu3faad4e+X3cLXGb7vcn8vFTYTQmPQng5mGb3OSqBAJylhovg6k2TP39oQ+XFy8
 073XfRLhUvKR8PUDsy0OhFHbsMzousP5b5WSxEwUHi9LFSscadW65fGM9YVoHVTohzAM
 Hns1jxji0cVpsHhWoZGrAO+Wv4C1shxMQ+bWVTQjtfZDLz9DX8Q3Drxh+im+kfGahnw4
 bNwvmImDgTxsU5/H0tM6YQ1bBAI2Xu720gLzXjfWuAY1a00Xd0cw17g7eSZIEloZnUb0
 Ntro0w2bbuD/1Uug0RbVyschEoN5HNVKK5KVpqxAgLqwSMt3ZZzWR/dldW37r6x1hEm4 VQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2survk0uyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 01 Jun 2019 10:29:33 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sat, 1 Jun
 2019 10:29:31 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sat, 1 Jun 2019 10:29:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VEXJAPUyXQ1tmq30nNNR7Z+xEWFfQ24I/OO1e5N8kcw=;
 b=ZS0PZKzo5/Hkdx/MQ6sT2R9cwObT/4NETW0y5KIwp1+K1HdzxcAfT+NowZKCaasMjfZJURM4j+USHGqCbXXsrXKnpPIrQwtIIbETgdzvrqdXV7M7bGFUJP7rchDW0Px1qIpEceVFO2l1hROh01AhrEkXzcWUdJIeLu2ZOME/EXU=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2784.namprd18.prod.outlook.com (20.179.23.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Sat, 1 Jun 2019 17:29:26 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8%7]) with mapi id 15.20.1922.021; Sat, 1 Jun 2019
 17:29:26 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Colin King <colin.king@canonical.com>
CC:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] mwifiex: check for null return from skb_copy
Thread-Topic: [EXT] Re: [PATCH] mwifiex: check for null return from skb_copy
Thread-Index: AQHU8i7/8jDHsxlJZE+NM+DVVJab26aHWmow
Date:   Sat, 1 Jun 2019 17:29:26 +0000
Message-ID: <MN2PR18MB2637DAA4852542EDA2BBC01DA01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <20190413161438.6376-1-colin.king@canonical.com>
 <20190413192729.GL6095@kadam>
In-Reply-To: <20190413192729.GL6095@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.45.208.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2330b682-847b-41f0-dbba-08d6e6b6b242
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2784;
x-ms-traffictypediagnostic: MN2PR18MB2784:
x-microsoft-antispam-prvs: <MN2PR18MB2784803E6C38B29B07054C7DA01A0@MN2PR18MB2784.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(396003)(136003)(39850400004)(376002)(199004)(189003)(3846002)(2906002)(229853002)(6116002)(476003)(6246003)(25786009)(73956011)(11346002)(446003)(66946007)(14454004)(4326008)(7736002)(66556008)(64756008)(486006)(52536014)(558084003)(256004)(66476007)(33656002)(5660300002)(71190400001)(71200400001)(86362001)(66446008)(305945005)(76116006)(68736007)(99286004)(6506007)(53936002)(316002)(66066001)(7696005)(54906003)(26005)(110136005)(478600001)(81166006)(81156014)(55016002)(7416002)(74316002)(8936002)(9686003)(102836004)(76176011)(8676002)(186003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2784;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GoyTU02FbGE9T7qAX/L3AsFXKsRsAvVuirybqJr1cj9LBLMKN8k28BBHAaRWdLtvU7HyM2oq6IXk6/l6ePcDcojvMS4lYw4yTFacHOlzN6AA74KmytcemA+Yf8HH2hzcCjr3M8yxLx9hsaslb8I7zroaFZYSAIXrqcVr4DUZKgY8YhrcalnMpgehGmaxT9r8pIRpBYrMCDstiM2+1d4uE9Twx3WfrkodXHo+gxdz5JzIJw2CsuDv1XW+Ml71mazPR6UIBfX/x4s5UP/XTNlvCiqIgNkzMIKegXQyipNE88VN0KSBjX6ks3nbvRa1Hhh1wCZoEjgCAkP1MUr2yl1YLNp98FHjnLsiCaKHfc9/8RwAnOBgJiXInrFExF2an09YIrQeyZSDbywA5tkcE5k2Bzy7dza2g1j6ejPcnl59rIM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2330b682-847b-41f0-dbba-08d6e6b6b242
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2019 17:29:26.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2784
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-01_12:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> >  	if (is_multicast_ether_addr(ra)) {
> >  		skb_uap =3D skb_copy(skb, GFP_ATOMIC);
> > +		if (!skb_uap)
> > +			return -ENOMEM;
>=20
> I think we would want to free dev_kfree_skb_any(skb) before returning.
I think if the pointer is NULL, no need to free it;=20

Regards,
Ganapathi
