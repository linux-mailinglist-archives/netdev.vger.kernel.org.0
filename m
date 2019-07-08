Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C39661950
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 04:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfGHCb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 22:31:27 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:11910 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726105AbfGHCb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 22:31:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x682TeJ7005120;
        Sun, 7 Jul 2019 19:31:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=MMX4V0CEsK+NkXyla3EYyl6CwyfJ9yvKHH8wLSkZx2o=;
 b=DR73xYwZAEKSnFyoN3sVwlgR1qH2n39wOFQn6IXPkPQeer7LPoVfpUPlrSaBaqUV2Jr4
 Jx12pV6dKuoooTtyOCYhx3KPWmEwqC3ZduiwoMxbKL6jPSFq+d+5ezMI1MF0ABZZQ0SD
 /f2OxKWVGwl/1iisCGQQ1GRR9BKxQGOELBlaW9E1PSwZVp2iEiqkDeYxWFiyYCmn1sYF
 tgUqfLV2xcYBER6SD3X5R4KbVEvRTiA6/E4XK0QEgFjdsFDyOR4J8O7K+BtBZpGDnu4A
 fuaihW1IMhI9j2FQp9bTHugatpknuMdiyXi3oPe4M+AETrgqX8XFC5p6GQn7bPYAoyoe Lw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2tju5j58nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 07 Jul 2019 19:31:19 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 7 Jul
 2019 19:31:17 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (104.47.34.58) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 7 Jul 2019 19:31:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMX4V0CEsK+NkXyla3EYyl6CwyfJ9yvKHH8wLSkZx2o=;
 b=Mvw9B00g9FF/G5lgnavxfdqBfesGF6oGhSyGPoIjl1SEWw0FTdbcnK5CWuUQfHkgukustWaVBr7SBTrVTL3IiTKJrLqdYLQ0MiWvuwoI8+cTMHTdOtxKqcFW4miUwtlpsMBl50Omj1DThnuCEUZEXxMdveaZ4Sldjk0FUYJlBLo=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2909.namprd18.prod.outlook.com (20.179.20.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 02:31:16 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::a8ef:cea:5dba:ddb1%4]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 02:31:15 +0000
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
Thread-Index: AQHVMmtwhWoVnFWq60mWQbIco+QP4qa7BPyAgACQbqCAANhdgIADliGQ
Date:   Mon, 8 Jul 2019 02:31:15 +0000
Message-ID: <MN2PR18MB25280224F5DDDFE8D86B234CD3F60@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190704132011.13600-1-skalluru@marvell.com>
        <20190704132011.13600-5-skalluru@marvell.com>
        <20190704150747.05fd63f4@cakuba.netronome.com>
        <DM6PR18MB25242BC08136A2C528C1A695D3F50@DM6PR18MB2524.namprd18.prod.outlook.com>
 <20190705123907.1918581f@cakuba.netronome.com>
In-Reply-To: <20190705123907.1918581f@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd833de3-394b-42c0-8dfc-08d7034c5a16
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2909;
x-ms-traffictypediagnostic: MN2PR18MB2909:
x-microsoft-antispam-prvs: <MN2PR18MB290910A388B39016FBEB1F71D3F60@MN2PR18MB2909.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(13464003)(52054003)(8676002)(305945005)(81166006)(5660300002)(256004)(9686003)(7736002)(14444005)(8936002)(74316002)(81156014)(478600001)(71190400001)(3846002)(54906003)(33656002)(6436002)(6116002)(71200400001)(66066001)(53936002)(76176011)(316002)(7696005)(66446008)(64756008)(76116006)(73956011)(102836004)(55236004)(53546011)(6506007)(68736007)(66476007)(66556008)(66946007)(486006)(99286004)(4326008)(186003)(229853002)(11346002)(6916009)(446003)(55016002)(26005)(6246003)(476003)(52536014)(25786009)(14454004)(86362001)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2909;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x8LQyOWV0ecZ24xwlrkmn2rfnO5n+3o/d41yO3QSoV/MFPu147l5TM1Kd5BxbIiiICKChX7bWdA6s7Z7LkcYp795Lv7EJoLICk8iJVJgVJ1shDaXYyicPMAadpo/6bkV0x2r1b6tCdFrbbCLYu47bxlnFKZLiKxBUZQRh5ekfftBjDOJ4Hwdp8RsdmZGAKtbFr9STnn3r0G/0iD2eR36esYQlZtcc67naOWxHHr+yBG+Qi/IYinymLZhO/txzc7mrC0w3xeEBUJ1mJao7qpo/6QpC4kDG3X+9bk+Pi0JFa8crCX6HD0TISZU86I5NZlNUEDM8wthMkjt2Z2kOD22lOkrtJqbTOij9eu+npsfLUx6UUzMDFdvfGVmCslw6uJYZBI1ssB21l3MpxRKlbR0lTycCXKFpXyJJHwIY8F6ULE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cd833de3-394b-42c0-8dfc-08d7034c5a16
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 02:31:15.6052
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skalluru@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2909
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_01:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Saturday, July 6, 2019 1:09 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Michal Kalderon
> <mkalderon@marvell.com>; Ariel Elior <aelior@marvell.com>; Jiri Pirko
> <jiri@resnulli.us>
> Subject: Re: [EXT] Re: [PATCH net-next v2 4/4] qed*: Add devlink support =
for
> configuration attributes.
>=20
> On Fri, 5 Jul 2019 08:22:41 +0000, Sudarsana Reddy Kalluru wrote:
> > > On Thu, 4 Jul 2019 06:20:11 -0700, Sudarsana Reddy Kalluru wrote:
> > > > This patch adds implementation for devlink callbacks for reading
> > > > and configuring the device attributes.
> > > >
> > > > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > > > Signed-off-by: Ariel Elior <aelior@marvell.com>
>=20
> > > > diff --git a/Documentation/networking/devlink-params-qede.txt
> > > > b/Documentation/networking/devlink-params-qede.txt
> > > > new file mode 100644
> > > > index 0000000..f78a993
> > > > --- /dev/null
> > > > +++ b/Documentation/networking/devlink-params-qede.txt
> > > > @@ -0,0 +1,72 @@
> > > > +enable_sriov		[DEVICE, GENERIC]
> > > > +			Configuration mode: Permanent
> > > > +
> > > > +iwarp_cmt		[DEVICE, DRIVER-SPECIFIC]
> > > > +			Enable iWARP support over 100G device (CMT
> mode).
> > > > +			Type: Boolean
> > > > +			Configuration mode: runtime
> > > > +
> > > > +entity_id		[DEVICE, DRIVER-SPECIFIC]
> > > > +			Set the entity ID value to be used for this device
> > > > +			while reading/configuring the devlink attributes.
> > > > +			Type: u8
> > > > +			Configuration mode: runtime
> > >
> > > Can you explain what this is?
> >
> > Hardware/mfw provides the option to modify/read the config of other
> > PFs. A non-zero entity id represents a partition number (or simply a
> > PF-id) for which the config need to be read/updated.
>=20
> Having a parameter which changes the interpretation of other parameters
> makes me quite uncomfortable :(  Could it be a better idea, perhaps, to u=
se
> PCI ports?  We have been discussing PCI ports for a while now, and they w=
ill
> probably become a reality soon.  You could then hang the per-PF parameter=
s
> off of the PF ports rather than the device instance?
>=20
Agree with you, thanks.

> > > > +device_capabilities	[DEVICE, DRIVER-SPECIFIC]
> > > > +			Set the entity ID value to be used for this device
> > > > +			while reading/configuring the devlink attributes.
> > > > +			Type: u8
> > > > +			Configuration mode: runtime
> > >
> > > Looks like you copied the previous text here.
> > Will update it, thanks.
> >
> > >
> > > > +mf_mode			[DEVICE, DRIVER-SPECIFIC]
> > > > +			Configure Multi Function mode for the device.
> > > > +			Supported MF modes and the assoicated values are,
> > > > +			    MF allowed(0), Default(1), SPIO4(2), NPAR1.0(3),
> > > > +			    NPAR1.5(4), NPAR2.0(5), BD(6) and UFP(7)
> > >
> > > NPAR should have a proper API in devlink port, what are the other
> modes?
> > >
> > These are the different modes supported by the Marvell NIC. In our
> > case the mf_mode is per adapter basis, e.g., it's not possible to
> > configure one port in NPAR mode and the other in Default mode.
>=20
> Jiri, what are your thoughts on the NPAR support?  It is effectively a PC=
I split.
> If we are going to support mdev split, should we perhaps have a "depth" o=
r
> "type" of split and allow for users to configure it using the same API?
>=20
> > > > +			Type: u8
> > > > +			Configuration mode: Permanent
> > > > +
> > > > +dcbx_mode		[PORT, DRIVER-SPECIFIC]
> > > > +			Configure DCBX mode for the device.
> > > > +			Supported dcbx modes are,
> > > > +			    Disabled(0), IEEE(1), CEE(2) and
> > > > Dynamic(3)
> > > > +			Type: u8
> > > > +			Configuration mode: Permanent
> > >
> > > Why is this a permanent parameter?
> > >
> > This specifies the dcbx_mode to be configured in non-volatile memory.
> > The value is persistent and is used in the next load of OS or the mfw.
>=20
> And it can't be changed at runtime?
Run time dcbx params are not affected via this interface, it only updates c=
onfig on permanent storage of the port.
