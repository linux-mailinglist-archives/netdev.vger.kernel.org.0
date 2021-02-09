Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA131474B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 05:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhBIEFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 23:05:06 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2612 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhBIEAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 23:00:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B602208ab0000>; Mon, 08 Feb 2021 19:59:39 -0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 03:59:38 +0000
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 9 Feb
 2021 03:59:37 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 9 Feb 2021 03:59:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8/mcca+8Yk5iI2tExebOM2KVjwTmR1UUCUrvc9qAQu4hTXIK16wsF/zsQmdT8FsefKqhgtplaGnfMvqnnwKF1C9GNs1vHNHlSxFpY3wcp5qpCHYdvhNOpuc2l8Zkiqv9qfmTRizIQZnlJmY4jKnujrYQO8XgUYEgPqHlQuA3iskigzhFWwL0p07vKfkoc9O+AVSCvsUh4QPztzfUs+C94bJViSWqhXgJd6a5QyMYECYR8qVBWQKO/DbOPZsen9BrRcN7IyA4aZRBPWagR4UgNbMV933UQIf6jfbEnfOkmM24DTpGBijeN9m/uAXA8294BNYHlvw5uTFVm3PpHuSNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b4Lj9NIRCH0LY4r73wr+bYfEe3zZYTXTpbOhXMwfMQo=;
 b=AAggRBpw9K5M+tSLTAT/CjAz9nE28Y3owgbgGKqqaaBbhkpy/c3/xf5lTgcOBRjUaXN1+Jb/GlxfzcXdW/h5aYIHa6dsQgUwwDz8tOchdAfSCxrQue6Ysck8bNoXMdHvPNuF0IppI2DXaDZ85Ellq19OSGIywX27p5Oy8Af1Ls/oCMdNzps6vODcb7xfhYwQ+Cl4ZXWnNstJPB2coylYuUZ/PiatmBOJhngM2fDVjTrmSXbjTd/OmrPccJn1EmSzI58u4Une7ZfgegLIL2rGD63/KDt3CvdgpMng0oUEIAdkcLLKlOTJLG2E85aPK2T1yA1IlyfbTLn8RxJkKp9Q/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4934.namprd12.prod.outlook.com (2603:10b6:a03:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Tue, 9 Feb
 2021 03:59:34 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3805.038; Tue, 9 Feb 2021
 03:59:34 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next v2 7/7] netdevsim: Add netdevsim port add test
 cases
Thread-Topic: [PATCH net-next v2 7/7] netdevsim: Add netdevsim port add test
 cases
Thread-Index: AQHW/S18CGvkXnZ47kqostT6yp3gkapOxkyAgABujRA=
Date:   Tue, 9 Feb 2021 03:59:34 +0000
Message-ID: <BY5PR12MB4322F05EFBE23C2024058CD9DC8E9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210206125551.8616-1-parav@nvidia.com>
        <20210207084412.252259-1-parav@nvidia.com>
        <20210207084412.252259-8-parav@nvidia.com>
 <20210208132113.128b3116@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208132113.128b3116@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14d1dd31-27ba-45a8-5880-08d8ccaf1c8c
x-ms-traffictypediagnostic: BY5PR12MB4934:
x-microsoft-antispam-prvs: <BY5PR12MB4934BC8725359A64AC18A2E6DC8E9@BY5PR12MB4934.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CSDoEkEO3j2uPe6vkQZiWlrwHwMHL/upbwBKg8+gXxhatFLhf24xHFSp8gfJbRTMqznzqK/9r7ZFyfJQMW84saIGid7MpDL5wB0m5T5EoHHR1gKAi2Gua3nN/eW4T88ORfMOHp4yegoe8HJtzXZfA0pimcNpEXJ87mFcFSmxGJQe4SkV2p3aPNL5MjI2AOXmpPKIE263cd6wdrWHTjOVI9eYf1b2A/6jqB9HYYA/AFh5huMhNHOS26qSRP+dstYpeevr5Mr+lLeAF/oJa2vvxms3Bceg1WL5ROGtNuC6HCbMacdEINyi/KpfmOJC/H3zUQ785B5EnmVdgvlP/s18/G50BMXZWwNSJ+HfMGy4W/lDwylWKQFBQRwrvhn1a0y0xcMrDpiqtzbwETmbw0KHD/wij7KoihUcDYJdHTUi1ZUKei/tCz+7qOqz8BcBqFLrODQIxshOeBaq1jt2fZusMxCr2O7OLJU/+cADt+m+woK0qo9BEYridMDo2oVUgGDPvipQ5vAi3704DCJVf8XBEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(66446008)(2906002)(66556008)(64756008)(66476007)(66946007)(7696005)(54906003)(71200400001)(76116006)(55016002)(33656002)(9686003)(4326008)(8936002)(6506007)(478600001)(316002)(83380400001)(86362001)(6916009)(8676002)(26005)(186003)(5660300002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2rZ2CTt5nUHN4kJcbSlF1jOYBEf8es+9mYoBp12qZIftcUzyt2/iPK+cStru?=
 =?us-ascii?Q?a/5Yw7j53AtyQ/4H9XgBqLyNog0MNI7Jw5DEwJoKCBahRD4Enr1DOwyyJkM2?=
 =?us-ascii?Q?f/dCKLjKPP+lQsX2OIeyVMtR4vZvRCRPxLXkpEa+xRaPetwR9GRd9YQBjGqX?=
 =?us-ascii?Q?9xu2gchluKBPj7gZ1OhViC7TG79jLYuDvrJfEEB1sNSVAvKe7wm0QYXMwWQM?=
 =?us-ascii?Q?kT6kDXVagarjGyq69y1CVKuiFgCa6IEoKhpjzvjZN8pkQdorsg4LLSAXy90u?=
 =?us-ascii?Q?sa438F+UUlOXZhz9MxOf3vcAyNzTuk6p67ltQksG3aEHal2/EUZdzRnv7soh?=
 =?us-ascii?Q?jKKs7kpW/VBRgqZJvzJ4KmgkkOEBEF3Bc1EhSjLyxZrTcJetFCsk0GSueTI+?=
 =?us-ascii?Q?h9GGKVhtr2X+0yT1tLHpLC54kPuXn42vXyGXdbq9h6r5U8UR0eDuUp2KzR7w?=
 =?us-ascii?Q?mrUCHnRB+JB+gEofc0mQyp4qgkjQESxJ0nvYCVlzeAsjJSOoRc37123bNjwd?=
 =?us-ascii?Q?MzNSdm/Q3GkIHCddokg1bGITua7DgFBIeu4DapUAq8stF9DERtPdhm7FgaOT?=
 =?us-ascii?Q?UJygtlyJMnoXQFSZIV5yaTTEpAUHxtuUV+jxnN7oj/6RO2vT90BvE26mN/vh?=
 =?us-ascii?Q?gbkOulyu/+DCimYVBX8eDppUclmzZzN92eGv/85HpLbTSuqq7nFD82ZobdTE?=
 =?us-ascii?Q?A1/gWB29bK8jaK0V93eyHU8bDzrT10x0DOpYkPD5CVp7xzfgwZamIeHk4gTN?=
 =?us-ascii?Q?XliiCoHpl35x6W2LuxShlBnuzqeHdwCgswL4xrbIXDRJSDe7JOiGPKckcUBi?=
 =?us-ascii?Q?UjMYNRPPTXwM7qzOUKOGEjZMH2iAlG2N/0SLM+Ga+MehlVz7Zw1eZkWj+REk?=
 =?us-ascii?Q?yUw13MqltyJSVgwFLEhtDjVJvsvy1nsbYjdv2vEWfLXQZtA9xA3U6DdZRho2?=
 =?us-ascii?Q?xKNd7L1Bq1rai+YE9Us/MPYZljL7/WqUNJ4tgb0yBbxLV6RgjH9uepesZooJ?=
 =?us-ascii?Q?5WfyOpqbs4hbkhcYOG5N5bjBokrNCt4bS9jTJx6TobSoE7BPVVMsJN8erhM7?=
 =?us-ascii?Q?2dAoqfdNuLre5z5E4EobWajEfZET2cuo8I9W8uOwK0n1NyVcStKPCbihP3RE?=
 =?us-ascii?Q?wqnMvYTD3Te+eyCfTU4HOkW6emFxwbLSBvki+eu3szJqJEUwL3zFK8z8X9Yi?=
 =?us-ascii?Q?1H187jIQXRBGTjxQoZwgYpqYdSTCsKsJbv0piHRcD4MuRxiY8/ZkosHMJjtz?=
 =?us-ascii?Q?LqcfwrPQvUpkE4+Mw//amRG4YGfEwjdfleJiio4DLdnTaA8VVQruSWBa2zxU?=
 =?us-ascii?Q?VPvWhT8dLAMRJhiBnYb5CQtq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d1dd31-27ba-45a8-5880-08d8ccaf1c8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2021 03:59:34.2003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEFS8LifZ69LsTabbOOz7iX7fOGd3ngG5S6L1YNkDXqOHZ0/BG0qsQp0KQ3yzNHWNpvA+IVT5q7jgQISQmdERw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4934
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612843179; bh=b4Lj9NIRCH0LY4r73wr+bYfEe3zZYTXTpbOhXMwfMQo=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:x-header:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ESi1JmevJur++YpnDhWSFKR1VNzozzxhmEH8gVLRxxkf6mPvo0F2Wi8BGKSGydgES
         WdARm9cBf7bzGjDuVlbsJ1iusirrCsFhBYjq0QifB3LfQNDsLeilZ6ziRw4lyhyJYq
         I3Cga7IYbezZzhtmsKt2DEfdBczPo9OIMqygeaWHHt1z1JoyZV9BWzcGTXTL6BUvkK
         HnMu6p5HDZdEJ+JlJuS+o02/dTgOgA3pdyAk+3lflq/4OBUiW/t17k3XmMJgXp7Psr
         K9AeHJGk8C+9WElvbB1AcRXgaFm5Yz2LWqv/Ja+LCjajIW7ngDV9MFg1kYHZwKrmdJ
         zzavWjBk65hSg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, February 9, 2021 2:51 AM
>=20
> On Sun, 7 Feb 2021 10:44:12 +0200 Parav Pandit wrote:
> > +	RET=3D0
> > +	USR_PF_PORT_INDEX=3D600
> > +	USR_PFNUM_A=3D2
> > +	USR_PFNUM_B=3D3
> > +	USR_SF_PORT_INDEX=3D601
> > +	USR_SFNUM_A=3D44
> > +	USR_SFNUM_B=3D55
> > +
> > +	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_A
> > +	check_err $? "Failed PF port addition"
> > +
> > +	devlink port show
> > +	check_err $? "Failed PF port show"
> > +
> > +	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A
> > +	check_err $? "Failed SF port addition"
> > +
> > +	devlink port add $DL_HANDLE flavour pcisf pfnum $USR_PFNUM_A \
> > +			sfnum $USR_SFNUM_A
> > +	check_err $? "Failed SF port addition"
> > +
> > +	devlink port add $DL_HANDLE flavour pcipf pfnum $USR_PFNUM_B
> > +	check_err $? "Failed second PF port addition"
> > +
> > +	devlink port add $DL_HANDLE/$USR_SF_PORT_INDEX flavour pcisf \
> > +			pfnum $USR_PFNUM_B sfnum $USR_SFNUM_B
> > +	check_err $? "Failed SF port addition"
> > +
> > +	devlink port show
> > +	check_err $? "Failed PF port show"
> > +
> > +	state=3D$(function_state_get "state")
> > +	check_err $? "Failed to get function state"
> > +	[ "$state" =3D=3D "inactive" ]
> > +	check_err $? "Unexpected function state $state"
> > +
> > +	state=3D$(function_state_get "opstate")
> > +	check_err $? "Failed to get operational state"
> > +	[ "$state" =3D=3D "detached" ]
> > +	check_err $? "Unexpected function opstate $opstate"
> > +
> > +	devlink port function set $DL_HANDLE/$USR_SF_PORT_INDEX state
> active
> > +	check_err $? "Failed to set state"
> > +
> > +	state=3D$(function_state_get "state")
> > +	check_err $? "Failed to get function state"
> > +	[ "$state" =3D=3D "active" ]
> > +	check_err $? "Unexpected function state $state"
> > +
> > +	state=3D$(function_state_get "opstate")
> > +	check_err $? "Failed to get operational state"
> > +	[ "$state" =3D=3D "attached" ]
> > +	check_err $? "Unexpected function opstate $opstate"
> > +
> > +	devlink port del $DL_HANDLE/$USR_SF_PORT_INDEX
> > +	check_err $? "Failed SF port deletion"
> > +
> > +	log_test "port_add test"
>=20
> I don't think this very basic test is worth the 600 LoC of netdevsim code=
.
>=20
Do you mean I should improve the test to do more code coverage for 600 LoC?

> If you come up with something better please don't post v3 it in reply to
> previous threads.
Can you please explain? If only test case improves, wouldn't it be v3 for t=
he last patch?
I must be missing something here.
