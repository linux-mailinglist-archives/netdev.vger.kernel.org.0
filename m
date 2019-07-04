Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF615F263
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 07:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfGDFuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 01:50:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:62686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725861AbfGDFuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 01:50:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x645nUmF012899;
        Wed, 3 Jul 2019 22:50:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=3NVX36WKS+5IPaGvIQjuMOhXK763UniIebg8AM2Cg2Q=;
 b=h9+eEEfrdZEYAnxsBJn4RYfUFtnoWPeCMfhRK+Uo2Do/x7xqKSSQAeygGBI2w0s4WF3j
 sG7iBBob85CmYkvsxhJ+dTYw6s96kn+syyJ3o6sguZX4yN5zNGcSFOgh7GeCBYhSZ38J
 A1drtTl32MuKNKEOb3qNsLwMkWlvjfC4bareCgKvdXzlppSXAY1vLtm5zWiS17oaiuUp
 HXH5EyXg91spShOnlLZkbgXciEaHjx8M0fL+e4slm7plWCGGe6sySA+A3+YAMG5gnI4B
 CFeLA0bYtaSJuxuuk6q7qNqG/4F9qu48wpcvUSRxzGaTGFgdLyLCuPLQ8vKbKQm9CBV1 3A== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2th9480gqk-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 03 Jul 2019 22:50:41 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 3 Jul
 2019 22:49:53 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 3 Jul 2019 22:49:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3NVX36WKS+5IPaGvIQjuMOhXK763UniIebg8AM2Cg2Q=;
 b=K6lFpBXgdBbY7KCvCBlM6c7/MeDE8M/Gxm668VhY2T5dq7skqRanixzwudFRjDEH4M36WOUgRwZJUqlmMclTkicBi1EkdYXdShwKdL/cIVA6pyf5vJH6d3bq535doJ2zU2pcLEL5h3ayWCXGrXXjb0Ncg+hcrTZkAtnAo10QZ6k=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2894.namprd18.prod.outlook.com (20.179.22.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 05:49:52 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 05:49:52 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Topic: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Thread-Index: AQHVJQJMBFYAJht0E0S8f7iw9+GZZqagdSOAgAPWPzCAAEVLAIAUUSeggABhlwCAAMl+UA==
Date:   Thu, 4 Jul 2019 05:49:52 +0000
Message-ID: <MN2PR18MB2528AED543AB7B8AA067FD60D3FA0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
        <20190617114528.17086-5-skalluru@marvell.com>
        <20190617155411.53cf07cf@cakuba.netronome.com>
        <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
        <20190620133748.GD2504@nanopsycho>
        <MN2PR18MB2528065BE3D46045F7EA1888D3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
 <20190703104244.7d26e734@cakuba.netronome.com>
In-Reply-To: <20190703104244.7d26e734@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 90372712-aad7-4a06-2a7e-08d700436f1e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2894;
x-ms-traffictypediagnostic: MN2PR18MB2894:
x-microsoft-antispam-prvs: <MN2PR18MB2894F64A0E27EA87D65C7DD1D3FA0@MN2PR18MB2894.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(13464003)(199004)(189003)(76176011)(55236004)(53546011)(6506007)(6246003)(2906002)(3846002)(6116002)(561944003)(33656002)(26005)(107886003)(102836004)(186003)(4326008)(25786009)(74316002)(305945005)(7736002)(53936002)(478600001)(8936002)(8676002)(81156014)(81166006)(66066001)(6436002)(54906003)(229853002)(99286004)(66476007)(66556008)(76116006)(7696005)(86362001)(55016002)(316002)(6916009)(68736007)(9686003)(5660300002)(52536014)(66446008)(64756008)(66946007)(73956011)(14454004)(256004)(11346002)(476003)(446003)(71200400001)(71190400001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2894;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4j7XLwB5mob7yV5gYawNZUh5YAPQGTyuf2D2pLeTnhiXwrvSBxLnX2Gm/EyQyDUB6pVw3uJEZyKWankKEZt3u9Cs7qh2mxgYyE+MGdEyLsnARV65yFnIuhGU14w+sxImshA8ETdL1sjzvS8ihhBz558Cg9cgYPX8OVLVCZwX4Dq4rNtSWFkm6I2H1R0IGdyr0F/RwhkPCIF/LiObX2wMonWCGTHGbXugSdc7FzNISWwEqH8LzCu1cRkYoArNrN56CIzPvioLLj8CIGHOEERxtwMbv1Tm5LAVjn4uHUreaQSBBQVMXQS42fntGnyTRNOGDf3ctnDo+z2o+Dntv5JpcmM7xC6qf4tbhpW7e2WOCIiJUQkZQ/HRQnmDihsLfEGBzBzqUhP+lRVzKYjTYhjpG4Unzv8twBQ5nd07dgNQPjo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 90372712-aad7-4a06-2a7e-08d700436f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 05:49:52.2681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2894
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-04_03:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, July 3, 2019 11:13 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; davem@davemloft.net;
> netdev@vger.kernel.org; Michal Kalderon <mkalderon@marvell.com>; Ariel
> Elior <aelior@marvell.com>
> Subject: Re: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
> configuration attributes.
>=20
> On Wed, 3 Jul 2019 12:56:39 +0000, Sudarsana Reddy Kalluru wrote:
> > Apologies for bringing this topic again. From the driver(s) code
> > paths/'devlink man pages', I understood that devlink-port object is an
> > entity on top of the PCI bus device. Some drivers say NFP represents
> > vnics (on pci-dev) as a devlink-ports and, some represents
> > (virtual?) ports on the PF/device as devlink-ports. In the case of
> > Marvell NIC driver, we don't have [port] partitioning of the PCI
> > device. And the config attributes are specific to PCI-device (not the
> > vports/vnics of PF). Hence I didn't see a need for creating
> > devlink-port objects in the system for Marvell NICs. And planning to
> > add the config attributes to 'devlink-dev' object. Please let me know
> > if my understanding and the proposal is ok?
>=20
> I understand where you're coming from.
>=20
> We want to make that judgement call on attribute-by-attribute basis.
> We want consistency across vendors (and, frankly, multiple drivers of the
> same vendor).  If attribute looks like it belongs to the port, rather tha=
n the
> entire device/ASIC operation, we should make it a port attribute.

Thanks for your mail. I'll go with creating PCI-dev/0 (i.e., port-id 0) for=
 port based attributes as there's no port partitioning for Marvell NICs.
