Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03E562DEC
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfGICJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:09:07 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35362 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726258AbfGICJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:09:07 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6925OkA027106;
        Mon, 8 Jul 2019 19:09:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rsCI6/PgCcovrD9kCfadwzXMrQc51cbvqdFk0ARMKt8=;
 b=VMBq6apN77TTY7X9Ayzvemr4+XBhOfI9PMRDe/EPmWIwNSQoD5uCCcBhMgav62ohcZlg
 VzQktf0swG2VWlXf4y2Boncos8ebrOEWA4/+LZ17o+tZtPBm9p2A9zU46gNk8NLu9cg/
 MxbViGg3JHoegpbH9NPRQExyYtH982w4p6Ao7Pg92Y9wIE/nV3wxDbgDUPfXbqT7dvva
 cCpJAYDOBQ/gKyF9H5jy+NG/uRuruyNauSU4EQQSgDhC7RlQIduBBrOX6qB6/mthUklV
 JjbIAOMNQV+GxAJeF6HUa952HotquGBVmZGoXLPV32mlPpQxJm4gkTaAI3isXYnsZthh ew== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tmce1h3h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 19:09:02 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 8 Jul
 2019 19:09:01 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.55) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 8 Jul 2019 19:09:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsCI6/PgCcovrD9kCfadwzXMrQc51cbvqdFk0ARMKt8=;
 b=aku4ytLWu42XwIMMC+sc8x7gj986cbI34UHk3ayUpQaF8j3B+PzYy6KTMVBgCNI2sBJUMSjZRalXSTxK4x9+UMXqK8r7UtOmMy12astswHiza+QSXrxpyto2Rqcu3vr6pfpeORpKtoeO13lVzfONyZHLKX8yNo+F0Q67FsCgW+o=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2879.namprd18.prod.outlook.com (20.179.22.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 02:08:55 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 02:08:55 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>, Jiri Pirko <jiri@resnulli.us>
Subject: RE: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
 configuration attributes.
Thread-Topic: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
 configuration attributes.
Thread-Index: AQHVMmtwhWoVnFWq60mWQbIco+QP4qa7BPyAgACQbqCAANhdgIADliGQgAFEoACAAEi1MA==
Date:   Tue, 9 Jul 2019 02:08:55 +0000
Message-ID: <MN2PR18MB2528DEE167EAB85E72564AA8D3F10@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
        <20190704150747.05fd63f4@cakuba.netronome.com>
        <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
        <20190705123907.1918581f@cakuba.netronome.com>
        <MN2PR18MB25280224F5DDDFE8D86B234CD3F60@MN2PR18MB2528.namprd18.prod.outlook.com>
 <20190708144706.46ad7a50@cakuba.netronome.com>
In-Reply-To: <20190708144706.46ad7a50@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b86c8518-79cb-4473-6996-08d7041265a5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2879;
x-ms-traffictypediagnostic: MN2PR18MB2879:
x-microsoft-antispam-prvs: <MN2PR18MB2879FFB82012603E6FB4915FD3F10@MN2PR18MB2879.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(199004)(13464003)(189003)(478600001)(74316002)(6436002)(5660300002)(14444005)(86362001)(53936002)(53546011)(7736002)(7696005)(6246003)(76176011)(4326008)(33656002)(6506007)(99286004)(256004)(55236004)(55016002)(9686003)(305945005)(446003)(229853002)(316002)(52536014)(25786009)(73956011)(11346002)(66946007)(81166006)(68736007)(81156014)(6116002)(102836004)(76116006)(3846002)(2906002)(8936002)(66066001)(66446008)(486006)(26005)(476003)(6916009)(8676002)(71190400001)(66476007)(66556008)(186003)(14454004)(64756008)(71200400001)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2879;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ldxa+DoMQl0hy7tEoVnAQZQe5oJVstNFjG3x+7wMvL6U6hxztGfXrFqDqY3n7OzpuKp5V48+ok2DUvikfAMXNvPVkdTZqKNpRzsJfZqdaYybbt/AR+EnCB5r3yON23MNiz2me7DLP+AuybbmnfHjdl/WYYD5pvu6GOTfEC45k0IS5P6vyAY1E0lCyGkPQ0LImp0hTPzu7YdNz9fdWodOtXHfvJ61G1FU4flBU0ILfV/vGEhryGKrdE4XTtCTMVuhRyv4ZUranVujeafldstXJciwqojTxbksiFCtxDMOfaoOleDbqiIJAyZYk5Xzj1cFr6sHx3UjTXj8wE/hqFcKjxKVql7zXL8OJwsHdfcuXTZT94IQImVe6sjvg41hSkAvkZkZEmzQTHSGWDm3CWDSCyD/50TB2lktq+9OagGX3ps=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b86c8518-79cb-4473-6996-08d7041265a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 02:08:55.5247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2879
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Tuesday, July 9, 2019 3:17 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> <jiri@resnulli.us>
> Subject: Re: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support =
for
> configuration attributes.
>=20
> On Mon, 8 Jul 2019 02:31:15 +0000, Sudarsana Reddy Kalluru wrote:
> > > > > > +			Type: u8
> > > > > > +			Configuration mode: Permanent
> > > > > > +
> > > > > > +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> > > > > > +			Configure DCBX mode for the device.
> > > > > > +			Supported dcbx modes are,
> > > > > > +			    Disabled(0), IEEE(1), CEE(2) and
> > > > > > Dynamic(3)
> > > > > > +			Type: u8
> > > > > > +			Configuration mode: Permanent
> > > > >
> > > > > Why is this a permanent parameter?
> > > > >
> > > > This specifies the dcbx_mode to be configured in non-volatile memor=
y.
> > > > The value is persistent and is used in the next load of OS or the m=
fw.
> > >
> > > And it can't be changed at runtime?
> >
> > Run time dcbx params are not affected via this interface, it only
> > updates config on permanent storage of the port.
>=20
> IOW it affects the defaults after boot?  It'd be preferable to have the D=
CB
> uAPI handle "persistent"/default settings if that's the case.
Yes, it's effective after the reboot. Thanks for your suggestion.
