Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492B25E4A2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:56:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbfGCM4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:56:46 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:3302 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725847AbfGCM4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:56:46 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x63CtZxA027959;
        Wed, 3 Jul 2019 05:56:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KrIV6vvVwI+TqZBJMV1DUpn4Qn9zisnMSgxGdIkbNFM=;
 b=UQSomYeNvvOk4XXyG030y8oKQx2YWvqUvES3i4qilwIME1TYWQhzyk0q2QQtZkUNbjbS
 D4mgyFsGcvAfTLImTgFj6Y/c0RHhna+q1nkqGZFi1+nxHJDHATO9iZ16HFaW308HI0sD
 yO+x/6/1++Io/dbEINrsjEIgNMPEBwz6rse36lPUAxpUyx02E74OsBl9z8hMX8Yhhw78
 lQ/RFRA8SFHin/bS9TFEZSrLU/NvF97b+3P/IK7xHIG9lbq0m+uDh76mpfSd2QEAdczX
 CHZPP6ic5Z9EQxn6KCsSzMAZqSW7fxg1aLlqTtfoaA4GmFGxs4fkkQwbhO0GiVRKs7mF 9g== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tgtf70jcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Jul 2019 05:56:42 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 3 Jul
 2019 05:56:40 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 3 Jul 2019 05:56:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KrIV6vvVwI+TqZBJMV1DUpn4Qn9zisnMSgxGdIkbNFM=;
 b=Pn+aLFaIxw+wm2sFhN6N7/oB46oYSMdUuVL9nEo7/22zWDdA9lISihvt0UIpODTOqbn/WlRTQ41UjcVBGzEtUH+CIF47+ui1jFD20hmUK8BnUwhLOuXzAZa9phs9+oGCvURNiq1roR5oASkLTbz7LzvrjpmHwgESwlsruCorKqk=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2509.namprd18.prod.outlook.com (20.179.80.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 12:56:39 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 12:56:39 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Topic: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Index: AQHVJQJMBFYAJht0E0S8f7iw9+GZZqagdSOAgAPWPzCAAEVLAIAUUSeg
Date:   Wed, 3 Jul 2019 12:56:39 +0000
Message-ID: <MN2PR18MB2528065BE3D46045F7EA1888D3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
 <20190617114528.17086-5-skalluru@marvell.com>
 <20190617155411.53cf07cf@cakuba.netronome.com>
 <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
 <20190620133748.GD2504@nanopsycho>
In-Reply-To: <20190620133748.GD2504@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b61673f6-52ea-444a-6972-08d6ffb5e3b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2509;
x-ms-traffictypediagnostic: MN2PR18MB2509:
x-microsoft-antispam-prvs: <MN2PR18MB25094AE9144BAEF6BC7531C2D3FB0@MN2PR18MB2509.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(189003)(199004)(13464003)(81166006)(66066001)(33656002)(81156014)(561944003)(14454004)(2906002)(3846002)(476003)(11346002)(446003)(486006)(71190400001)(74316002)(7736002)(8676002)(107886003)(256004)(4326008)(6116002)(86362001)(71200400001)(305945005)(55016002)(186003)(53936002)(8936002)(53546011)(55236004)(5660300002)(9686003)(52536014)(229853002)(6436002)(478600001)(76176011)(25786009)(99286004)(316002)(110136005)(102836004)(54906003)(7696005)(26005)(6246003)(76116006)(66946007)(66446008)(68736007)(66556008)(64756008)(66476007)(6506007)(73956011);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2509;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /Q7zFT15FtQaQxPohd3nOd3sXiPmq8j/UKuFuM0q+55XH7lpNwGnRxbbD/Dt8Ta6ArJUq/12dPl3Fc3/OEKFri5f2SeF5QEAAQqiBS5scPbhC3Ao/XaWB79zOQqrt5WSq54ZgO4H0tREvkvuNk6aiF/2kGMiz43gZGqSnKo140kSyTskxDLQ25Y1oEN3A3fjesOvzdHikY8BM26IjJBgl6z9++WbnWHyNI1ZRUtaCkSIfJpEoq9plydz+b5fe2EQOs7WXIWJojeX7zZn+HyEPqu8psLtkMvvwpVo01HKGEOosJCPk/gB2t0jOg8kFrgkevz8xmdOPs1/tCzumD5bFb8I0kYbA5t026wN8Dyt5fvNTjsGwfctAUdLTc5hacpeVhumsjjwB81MKW4imqdAxYXX7iZda0FPKFjx8A3O5TI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b61673f6-52ea-444a-6972-08d6ffb5e3b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 12:56:39.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2509
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-03_03:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, June 20, 2019 7:08 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>; davem@davemloft.net;
> netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>; Ariel
> Elior <aelior@marvell.com>
> Subject: Re: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> configuration attributes.
>=20
> Thu, Jun 20, 2019 at 02:09:29PM CEST, skalluru@marvell.com wrote:
> >> -----Original Message-----
> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Sent: Tuesday, June 18, 2019 4:24 AM
> >> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> >> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> >> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> >> <jiri@resnulli.us>
> >> Subject: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> >> configuration attributes.
> >>
> >> External Email
> >>
> >> ---------------------------------------------------------------------
> >> - On Mon, 17 Jun 2019 04:45:28 -0700, Sudarsana Reddy Kalluru wrote:
> >> > This patch adds implementation for devlink callbacks for reading/
> >> > configuring the device attributes.
> >> >
> >> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> >> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> >>
> >> You need to provide documentation for your parameters, plus some of
> >> them look like they should potentially be port params, not device para=
ms.
> >
> >Thanks a lot for your review. Will add the required documentation. In ca=
se
> of Marvell adapter, any of the device/adapter/port parameters can be
> read/configurable via any PF (ethdev) on the port. Hence adding the
> commands at device level. Hope this is fine.
>=20
> No it is not. Port param should be port param.
>=20
> Also please be careful not to add any generic param as driver specific.
>=20
> Thanks!
Apologies for bringing this topic again. From the driver(s) code paths/'dev=
link man pages', I understood that devlink-port object is an entity on top =
of the PCI bus device.
Some drivers say NFP represents vnics (on pci-dev) as a devlink-ports and, =
some represents (virtual?) ports on the PF/device as devlink-ports.
In the case of Marvell NIC driver, we don't have [port] partitioning of the=
 PCI device. And the config attributes are specific to PCI-device (not the =
vports/vnics of PF).
Hence I didn't see a need for creating devlink-port objects in the system f=
or Marvell NICs. And planning to add the config attributes to 'devlink-dev'=
 object.
Please let me know if my understanding and the proposal is ok?

Code paths which use devlink-port:
   mlx4_load_one(struct pci_dev *pdev):  mlx4_init_port_info(1 .. dev->caps=
.num_ports) -> devlink_port_register()
   nfp_net_pf_init_vnics (1 .. pf->vnics) -> nfp_net_pf_init_vnic() -> nfp_=
devlink_port_register()
   nsim_dev_probe (1 .. nsim_bus_dev->port_count) -> __nsim_dev_port_add() =
-> devlink_port_register ()

man page for 'devlink-port':
   devlink port set - change devlink port attributes
       DEV/PORT_INDEX - specifies the devlink port to operate on.

       devlink port show pci/0000:01:00.0/1
           Shows the state of specified devlink port.
