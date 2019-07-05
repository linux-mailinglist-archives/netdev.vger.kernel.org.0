Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AAD6020A
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 10:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbfGEIWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 04:22:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44234 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbfGEIWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 04:22:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x658KY3p017116;
        Fri, 5 Jul 2019 01:22:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fzJ5grc19UQ5yenwce9FdWCRBawxGCozdCOBfC6mxmc=;
 b=XyDMvdyZSnBGqlR9lcYpqdAVfQZJCgmrfh20CqarnQEfXa08E7Ys1a5X0r4eu9KqyA0C
 tYbq/QKUiEPLNjeUocoe1bHI9tpFAoOIawJKBSTqcH5dsWabCh6+yVlYGhZWhsKuEZHi
 xn+gIN5B/dBDkANbIu9KV9uSLew7zwJ7tDPHtbkybRvjjFxe8La4TmYWo/SxcKOBXcdo
 kVE99rPrY0BjYV1R7AbgL8WJBK6U+m92+TSThrGBawq2ISJpHOe3z9q3DvPKf4XjU711
 4aEbXRkTCBz5Kf5jElvtoFWdYU3RVLkp2wDRn+WHzh/mxsFi79dUPM0XTKENP2omI5RB kQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2thv9p1b1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 05 Jul 2019 01:22:47 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 5 Jul
 2019 01:22:46 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 5 Jul 2019 01:22:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fzJ5grc19UQ5yenwce9FdWCRBawxGCozdCOBfC6mxmc=;
 b=xSVcD626+lfa7f996aj4bGnicJZ8iAYllVmZsGC7K6G/zFQr9m86D42rH7aNV3Z/bf3kjJnc43ygCqVUB+MncDETUL6w+MzqwjK2lc7wpFPAmztxON96+62ZghMqMg+yeifWZajFHSnZyz5gHORiv6XqA/Q5qPra7frUL5Fph3U=
Received: from DM6PR18MB2524.namprd18.prod.outlook.com (20.179.105.140) by
 DM6PR18MB2683.namprd18.prod.outlook.com (20.179.107.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.16; Fri, 5 Jul 2019 08:22:41 +0000
Received: from DM6PR18MB2524.namprd18.prod.outlook.com
 ([fe80::9812:207e:ae7:2e10]) by DM6PR18MB2524.namprd18.prod.outlook.com
 ([fe80::9812:207e:ae7:2e10%7]) with mapi id 15.20.2052.019; Fri, 5 Jul 2019
 08:22:41 +0000
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
Thread-Index: AQHVMmtwhWoVnFWq60mWQbIco+QP4qa7BPyAgACQbqA=
Date:   Fri, 5 Jul 2019 08:22:41 +0000
Message-ID: <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
 <20190704150747.05fd63f4@cakuba.netronome.com>
In-Reply-To: <20190704150747.05fd63f4@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4365fa15-4a5a-44af-226a-08d70121f2e0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR18MB2683;
x-ms-traffictypediagnostic: DM6PR18MB2683:
x-microsoft-antispam-prvs: <DM6PR18MB2683D7CAC789C13085F9E947D3F50@DM6PR18MB2683.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 008960E8EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(136003)(39850400004)(366004)(13464003)(189003)(199004)(54906003)(6246003)(53936002)(229853002)(33656002)(476003)(6436002)(9686003)(3846002)(6116002)(73956011)(55016002)(486006)(52536014)(186003)(66476007)(76116006)(478600001)(5660300002)(316002)(66946007)(446003)(64756008)(66556008)(11346002)(66446008)(14454004)(14444005)(4326008)(86362001)(74316002)(26005)(7736002)(102836004)(25786009)(305945005)(68736007)(256004)(66066001)(81156014)(8936002)(99286004)(71200400001)(2906002)(71190400001)(7696005)(6916009)(6506007)(76176011)(53546011)(8676002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR18MB2683;H:DM6PR18MB2524.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: imByzzGo73TD+cxyOOBz0E0+rNdyeFI3B4GjJ4263qlJL19uiVA17KgHbxT8yD/Hsoor99WX3NvggOM67OCRCPUqwS6Putt2Tp80YMd7Oh5xln34Y33MaTTFipSvmfZHoW4YGFs8xlUqTSouiQNOetVEPDlJ4MZmECkmk/96rTNNhiZlmDvexOtSOrYKJkWR90r2YAaKS689wdy9H5OLveRqLvsypR4jkFRxOfR5576AyT/WqvSvcsW/UTg3eGzMnOdfxobEjJFDk3RwpeAauOZ89PKVB2w5pIJaV1glnHRf6US1C/hD++KCuUbuACVVXW+xkciFayjESdx88ybGRnmNfVBiFMBff71WaLWGEUQB1LLsUs26bO/wJzKiyzFA6gXyp9z641yzxS/xI6b48nQtNX4Kecu6906U00YCTC4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4365fa15-4a5a-44af-226a-08d70121f2e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2019 08:22:41.5448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2683
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_03:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Friday, July 5, 2019 3:38 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> <jiri@resnulli.us>
> Subject: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support for
> configuration attributes.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 4 Jul 2019 06:20:11 -0700, Sudarsana Reddy Kalluru wrote:
> > This patch adds implementation for devlink callbacks for reading and
> > configuring the device attributes.
> >
> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >  Documentation/networking/devlink-params-qede.txt |  72 ++++++++
> >  drivers/net/ethernet/qlogic/qed/qed_main.c       |  38 +++++
> >  drivers/net/ethernet/qlogic/qede/qede.h          |   3 +
> >  drivers/net/ethernet/qlogic/qede/qede_devlink.c  | 202
> > ++++++++++++++++++++++-
> drivers/net/ethernet/qlogic/qede/qede_devlink.h  |  23 +++
> >  include/linux/qed/qed_if.h                       |  16 ++
> >  6 files changed, 353 insertions(+), 1 deletion(-)  create mode 100644
> > Documentation/networking/devlink-params-qede.txt
> >
> > diff --git a/Documentation/networking/devlink-params-qede.txt
> > b/Documentation/networking/devlink-params-qede.txt
> > new file mode 100644
> > index 0000000..f78a993
> > --- /dev/null
> > +++ b/Documentation/networking/devlink-params-qede.txt
> > @@ -0,0 +1,72 @@
> > +enable_sriov		[DEVICE, GENERIC]
> > +			Configuration mode: Permanent
> > +
> > +iwarp_cmt		[DEVICE, DRIVER-SPECIFIC]
> > +			Enable iWARP support over 100G device (CMT
> mode).
> > +			Type: Boolean
> > +			Configuration mode: runtime
> > +
> > +entity_id		[DEVICE, DRIVER-SPECIFIC]
> > +			Set the entity ID value to be used for this device
> > +			while reading/configuring the devlink attributes.
> > +			Type: u8
> > +			Configuration mode: runtime
>=20
> Can you explain what this is?
Hardware/mfw provides the option to modify/read the config of other PFs. A =
non-zero entity id represents a partition number (or simply a PF-id) for wh=
ich the config need to be read/updated.

>=20
> > +device_capabilities	[DEVICE, DRIVER-SPECIFIC]
> > +			Set the entity ID value to be used for this device
> > +			while reading/configuring the devlink attributes.
> > +			Type: u8
> > +			Configuration mode: runtime
>=20
> Looks like you copied the previous text here.
Will update it, thanks.

>=20
> > +mf_mode			[DEVICE, DRIVER-SPECIFIC]
> > +			Configure Multi Function mode for the device.
> > +			Supported MF modes and the assoicated values are,
> > +			    MF allowed(0), Default(1), SPIO4(2), NPAR1.0(3),
> > +			    NPAR1.5(4), NPAR2.0(5), BD(6) and UFP(7)
>=20
> NPAR should have a proper API in devlink port, what are the other modes?
>=20
These are the different modes supported by the Marvell NIC. In our case the=
 mf_mode is per adapter basis, e.g., it's not possible to configure one por=
t in NPAR mode and the other in Default mode.

> > +			Type: u8
> > +			Configuration mode: Permanent
> > +
> > +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> > +			Configure DCBX mode for the device.
> > +			Supported dcbx modes are,
> > +			    Disabled(0), IEEE(1), CEE(2) and Dynamic(3)
> > +			Type: u8
> > +			Configuration mode: Permanent
>=20
> Why is this a permanent parameter?
>=20
This specifies the dcbx_mode to be configured in non-volatile memory. The v=
alue is persistent and is used in the next load of OS or the mfw.

> > +preboot_oprom		[PORT, DRIVER-SPECIFIC]
> > +			Enable Preboot Option ROM.
> > +			Type: Boolean
> > +			Configuration mode: Permanent
>=20
> This should definitely not be a driver specific toggle.
>=20
> > +preboot_boot_protocol	[PORT, DRIVER-SPECIFIC]
> > +			Configure preboot Boot protocol.
> > +			Possible values are,
> > +			    PXE(0), iSCSI Boot(3), FCoE Boot(4) and NONE(7)
> > +			Type: u8
> > +			Configuration mode: Permanent
>=20
> Ditto.
>=20
> > +preboot_vlan		[PORT, DRIVER-SPECIFIC]
> > +			Preboot VLAN.
> > +			Type: u16
> > +			Configuration mode: Permanent
> > +
> > +preboot_vlan_value	[PORT, DRIVER-SPECIFIC]
> > +			Configure Preboot VLAN value.
> > +			Type: u16
> > +			Configuration mode: Permanent
>=20
> And these.
Sure, will add generic definitions for these.

>=20
> > +mba_delay_time		[PORT, DRIVER-SPECIFIC]
> > +			Configure MBA Delay Time. Supported range is [0-
> 15].
> > +			Type: u8
> > +			Configuration mode: Permanent
> > +
> > +mba_setup_hot_key	[PORT, DRIVER-SPECIFIC]
> > +			Configure MBA setup Hot Key. Possible values are,
> > +			Ctrl S(0) and Ctrl B(1).
> > +			Type: u8
> > +			Configuration mode: Permanent
> > +
> > +mba_hide_setup_prompt	[PORT, DRIVER-SPECIFIC]
> > +			Configure MBA hide setup prompt.
> > +			Type: Boolean
> > +			Configuration mode: Permanent
