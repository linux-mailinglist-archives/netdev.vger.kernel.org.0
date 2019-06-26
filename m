Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D178565BF
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFZJip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:38:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:1230 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725379AbfFZJin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:38:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5Q9bwPj031847;
        Wed, 26 Jun 2019 02:38:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=HB2vGhv66t+qEztwM6cFxmKSZzk1s8n3GCxYxA//ZYc=;
 b=Fy/C05ebcT+rTu8AEpO1A3Y8ssLWXrI9EKbgfhhoK4bCsy/MxXhnmWxUYAGfoLZ15WZ0
 pIaoAcnaOfiEA5MkhH8bchoB2mdoY+XPQzkDx8kyFuxOGSipsIE8l5WKIuKGF4AYgoVa
 hkx+NEtuodeFz5Ir5RAFjyxta5+Lxy/GAa8utEXdwn2GLOIB0N5ZGBuTLrQp+BqA9KtF
 HVQ8WWp6cF6OsD0uXt/MZGqONlrOpOy470ySSU40N/galiaqMEBEw4Gp3iBdeEAGFqLm
 bxjCWIyjaOTcNngHRfVmym+I1HssZl34A297VMHUUbs+EXGMvjyU5BOT5fMz3bdbdlDJ qA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tc3s6rj8x-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 Jun 2019 02:38:38 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 26 Jun
 2019 02:36:48 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 26 Jun 2019 02:36:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB2vGhv66t+qEztwM6cFxmKSZzk1s8n3GCxYxA//ZYc=;
 b=TGyBtfkOnX/Edgw3zgwAipSTY6KuxDVzNRTDUbsQpPJtwQ09IE37zMByQ40MG29E4ED5xToRZ5NgefCOKSuDvILLj7EN5EHWpbTH5p+vqzvESSlO00cu2lfPpL4xSvoHrnpREYMZdIzwfmyKJMMesQDZNCwqAU0Drg74wgQTTVo=
Received: from DM6PR18MB2697.namprd18.prod.outlook.com (20.179.49.204) by
 DM6PR18MB3083.namprd18.prod.outlook.com (20.179.48.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 09:36:47 +0000
Received: from DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631]) by DM6PR18MB2697.namprd18.prod.outlook.com
 ([fe80::4121:8e6e:23b8:b631%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 09:36:47 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Benjamin Poirier <bpoirier@suse.com>,
        GR-Linux-NIC-Dev <GR-Linux-NIC-Dev@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
Thread-Topic: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
Thread-Index: AQHVJOFHnq6yxj24UEOkyPPO15KlRaatuzeA
Date:   Wed, 26 Jun 2019 09:36:47 +0000
Message-ID: <DM6PR18MB269776CBA6B979855AD215A8ABE20@DM6PR18MB2697.namprd18.prod.outlook.com>
References: <20190617074858.32467-1-bpoirier@suse.com>
 <20190617074858.32467-5-bpoirier@suse.com>
In-Reply-To: <20190617074858.32467-5-bpoirier@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 239ad112-c01b-4f55-1645-08d6fa19cefe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB3083;
x-ms-traffictypediagnostic: DM6PR18MB3083:
x-microsoft-antispam-prvs: <DM6PR18MB3083FDA115F9947DA5130272ABE20@DM6PR18MB3083.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(39860400002)(366004)(376002)(346002)(199004)(189003)(13464003)(55016002)(25786009)(186003)(256004)(53936002)(305945005)(68736007)(6436002)(7736002)(73956011)(76116006)(81156014)(5660300002)(8936002)(66946007)(81166006)(4744005)(8676002)(66556008)(64756008)(66446008)(316002)(110136005)(66476007)(86362001)(52536014)(478600001)(66066001)(76176011)(71200400001)(99286004)(3846002)(6116002)(26005)(53546011)(229853002)(102836004)(6506007)(74316002)(9686003)(14454004)(6246003)(446003)(476003)(11346002)(2906002)(486006)(33656002)(7696005)(71190400001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB3083;H:DM6PR18MB2697.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: beVHmsoY9+zr4WySNyv9v7ei0xv/MCt3sSZrmRow3StRdROXef0X1zj6MbNT+SrbaOp1fdQFIBao81NbhLj9mCidG7kkMwG5GdVXJMA1lwq3oiZy8fRxpBMIGoIfEaDB55h1Ig4CSecCtDhJS0srJmujTThwL8diBUjZ6uRGVeaqiZELjpINDtvXG+lLzWHG+GYw8KFVB/6cdakapCMXKYsxht28AAqCVsX6w8B9rqeZj/eJGTlLo76sNQSOrQHVblRKC++4Dr8a/slMReCVF9tUUufT1hpBWZn6lhnO2YLeDW3M0igHOganbvS59fZ8AqHoYaQv48czr2b6rS++CcCGRAqLKcpVW7LBuggA9R0gcqLTqq0MjnMaCvGp2YqNd1oU9CqzeYB0blRMGo8BWNhs88HbdvbkcPjTkJg8k4E=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 239ad112-c01b-4f55-1645-08d6fa19cefe
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 09:36:47.2449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: manishc@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3083
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Benjamin Poirier <bpoirier@suse.com>
> Sent: Monday, June 17, 2019 1:19 PM
> To: Manish Chopra <manishc@marvell.com>; GR-Linux-NIC-Dev <GR-Linux-
> NIC-Dev@marvell.com>; netdev@vger.kernel.org
> Subject: [EXT] [PATCH net-next 05/16] qlge: Remove rx_ring.sbq_buf_size
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Tx rings have sbq_buf_size =3D 0 but there's no case where the code actua=
lly
> tests on that value. We can remove sbq_buf_size and use a constant instea=
d.
>=20

Seems relevant to RX ring, not the TX ring ?


