Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56CED5DCA0
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfGCCqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:46:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:25486 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726430AbfGCCqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 22:46:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x632ajxm024177;
        Tue, 2 Jul 2019 19:46:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=8cUCrPMFYn3RR4V3pVU1X1xLeexsf6Odxj/aGqrayPU=;
 b=tk7Okjo9GTFvYw8RZw8ynd8RVBa2l530OylHuIxHb8SUlWEnQiZZO9oUzMwYEuTNNbN4
 +AgcU3dGQvqF4eiOCz7zPcuAweiZvtwurFYm0r4zCLpCFDYdSrB2mwdA99KVRfrVgFw1
 4s4XNdxE8BYFZWCi5EPIBMMnYqMpJ18mybl07rq9LOwPLTV6MsT3u5cQ3+DUNO9QTaTT
 jt8jdkDWqEYvX96ColQm/E6uFlL8deDfkl1wo6FcFt5TrjzuMpQ2Dy4KiwwXT+aolr4y
 RTI3FY/Ay1T1CDQSNiru1iyUmGFBHTUsSozotJ9dsvWZvyOhhB1h+QPT9u5+cYDPlctJ sw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tg5733je7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 19:46:43 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 2 Jul
 2019 19:46:41 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (104.47.49.58) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 2 Jul 2019 19:46:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cUCrPMFYn3RR4V3pVU1X1xLeexsf6Odxj/aGqrayPU=;
 b=Ll2rzZ/TM4AoPwGoPXhxt89v8sx4iwvenGLrp5wxw6b0cI8qVcdbTZkoe/se162N/mjw0QN2emGBkiErPGXwPQHa5VeVskWLd4DaKRxtE5GJWVevbo2dkH8ijWgQxZwL0QK62e4lm4ng6earKkkn0LdH56dJu6CpwAoEvqP+ukY=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2766.namprd18.prod.outlook.com (20.178.255.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 02:46:35 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 02:46:35 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Parav Pandit <parav@mellanox.com>, Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Topic: [PATCH net-next 1/1] devlink: Add APIs to publish/unpublish the
 port parameters.
Thread-Index: AQHVMPpBpknp8pmVkkqrkESNlCeW4qa4LMJg
Date:   Wed, 3 Jul 2019 02:46:35 +0000
Message-ID: <MN2PR18MB25280E0966EF3B8D9BEBF4F7D3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190702152056.31728-1-skalluru@marvell.com>
 <20190702161133.GP30468@lunn.ch>
 <AM0PR05MB4866D7B26F48AF0BED9055EED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164844.GA28471@lunn.ch>
 <AM0PR05MB4866CBFB93C42453068376DED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB4866CBFB93C42453068376DED1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a5a85ad6-7ab2-41ba-44c3-08d6ff60aa27
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2766;
x-ms-traffictypediagnostic: MN2PR18MB2766:
x-microsoft-antispam-prvs: <MN2PR18MB27662BF3A795C2ECC5117408D3FB0@MN2PR18MB2766.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(13464003)(189003)(199004)(81166006)(54906003)(8676002)(81156014)(55016002)(33656002)(6246003)(2906002)(8936002)(229853002)(316002)(305945005)(53936002)(66446008)(74316002)(6436002)(446003)(7736002)(476003)(11346002)(71190400001)(71200400001)(486006)(9686003)(110136005)(478600001)(102836004)(14454004)(66476007)(52536014)(66066001)(55236004)(64756008)(4326008)(68736007)(76116006)(26005)(186003)(5660300002)(25786009)(256004)(66556008)(14444005)(66946007)(86362001)(6116002)(76176011)(3846002)(99286004)(53546011)(6506007)(7696005)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2766;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I80ytVEuRNm3NA7QFQ1/FfusIekl3yu8ZbZGdfGXt4F6nX3oNSE0PuLmvZw4+lsP6u2MmeLwaYoXlCrBUfqzaCyWVMxgmiwmJ6pV3Y4u1zRBcQ+BN6nR7I4Lr+8kVCfJ05iU95FKlsC285dXx5UON4wvqG5/bhz2WQaboafGR52MGWDqMJvZubioTqHGmDzURM+KEVj/noDik0mTIAOUVaRYqNuYuAxNqctk5VwkZ2zl8/Va/769rh1tJ1FLEfcZawrGUs6KdA45eoTW7YLuf/2wv2dIeVHujr32L0J9NlWtJt1WGlgrVjQ9ICuQxrWu1bKhsy83wEWspdkqzDyqOTKVeZ3zHBESHQ62HleMpnxnJGHqRiM657PweEtzRd91IJxsMYS0jEA95aXOyBZ4msf0wIBRq6AtMczkWYwhfCU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a85ad6-7ab2-41ba-44c3-08d6ff60aa27
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 02:46:35.4598
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2766
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Parav Pandit <parav@mellanox.com>
> Sent: Tuesday, July 2, 2019 10:49 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>;
> jiri@resnulli.us
> Subject: [EXT] RE: [PATCH net-next 1/1] devlink: Add APIs to
> publish/unpublish the port parameters.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
>=20
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Tuesday, July 2, 2019 10:19 PM
> > To: Parav Pandit <parav@mellanox.com>
> > Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> > davem@davemloft.net; netdev@vger.kernel.org;
> mkalderon@marvell.com;
> > aelior@marvell.com; jiri@resnulli.us
> > Subject: Re: [PATCH net-next 1/1] devlink: Add APIs to
> > publish/unpublish the port parameters.
> >
> > > A vendor driver calling these APIs is needed at minimum.
> >
> > Not a vendor driver, but a mainline driver.
> >
> My apologies for terminology.
> I meant to say that a NIC/hw driver from the kernel tree that created the
> devlink port should call this API (as user) in the patch.
> You said it rightly below. Thanks.
>=20
> > But yes, a new API should not be added without at least one user.
> >
> >     Andrew
Thanks a lot for your reviews.
Marvell NIC driver has a requirement to support the display/configuration o=
f device attributes. Sent the proposed changes with following 'subject line=
',
     [PATCH net-next 4/4] qed: Add devlink support for configuration attrib=
utes.
Have received a comment (from community) suggesting to move some of the att=
ributes to devlink-port interface, which
requires the proposed APIs.

Will update the commit message and send it with the Marvel driver patch ser=
ies which use this functionality.
