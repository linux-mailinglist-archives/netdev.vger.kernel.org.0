Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D82C494FFD
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345116AbiATOTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 09:19:08 -0500
Received: from mail-bn8nam11on2106.outbound.protection.outlook.com ([40.107.236.106]:37216
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235706AbiATOTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 09:19:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHPs8VnGifY3Duhqq9AJOd0T4fV3Kc6c47oDY4WGn2N1YnFD/8sJa2sUNx0GFQi2e6Uh0/RkdtO2E29nnHrxHRDXH9eiwFcO9wHhU0vaubfbPW29stiVRXkNL60ejhztLCGFCFoMgj/CvwrO4pBFSs8Gr1W+49dWgGM1DS8pXgepz4vnYIgUbc+F2jbBct2rMyxRHCr6Q9p73aNdb7FH1S2rfCiDWfq+RlURBCmyO/wZ+BUUyui781rF43+EVem+po9xz1O/lXq+CH9f7JMoZ2DWVMEO8wx0h/eNm2UBFoLo/o23JCka0CJDLEcQoX1OcNjQL/SiJwXHv7UqSSJ3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HbvhVLyOKfrLUbFXzumTiYDjdGa2e5CB92Vh+7cBoXk=;
 b=Olo270QkADg4Ucl9mvbuyAq0zJCvvVS7d+ul8u5YjXa4pQJ5yJi0Ad+On19hsoiADpdHLPru221GVWpFodwY/N4dSWwNq+C6mQJBKTCDUZoJf00JKqQBU4a2XBnskrheNYSPHtf1H4PGJEmq8yZIwm6QlLcBU6VvVew022RGsOKeSqmoOpqm4WApKz9T48NjEDjmuwz9kBMRU6O6DlkBwGZIAcV914379/5Y3LV1MEgi+guzcQGM6wcSzsKenhx4p+qMmEIGrMNFCPROh1kpdHSA63VyNFe2xoN0VAZ3VxqH7irIHmGaX7AGpYT2DJee4VI2lt19hEyLU7lrOTOm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HbvhVLyOKfrLUbFXzumTiYDjdGa2e5CB92Vh+7cBoXk=;
 b=HI6BIrQpPVJf1mR1x3uGdABwRfbXydFRfvQREeEyOE31clX7/s8YU5SvdwU8tUf4dXsHaBbEn0XTjtGK+CfgabXglLwPGtvWmmR1xJ7LLmLrQh8SM3bd/EjKYIEKJty3VOj0coHN5AgnekE4vf9APazSnRc0HQbYZbwkaGkG510=
Received: from CH2PR21MB1464.namprd21.prod.outlook.com (2603:10b6:610:89::16)
 by BN7PR21MB1684.namprd21.prod.outlook.com (2603:10b6:406:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.3; Thu, 20 Jan
 2022 14:19:05 +0000
Received: from CH2PR21MB1464.namprd21.prod.outlook.com
 ([fe80::3d37:d46c:5a39:166c]) by CH2PR21MB1464.namprd21.prod.outlook.com
 ([fe80::3d37:d46c:5a39:166c%7]) with mapi id 15.20.4930.006; Thu, 20 Jan 2022
 14:19:05 +0000
From:   Dave Thaler <dthaler@microsoft.com>
To:     Quentin Monnet <quentin@isovalent.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: RE: Bpftool mirror now available
Thread-Topic: Bpftool mirror now available
Thread-Index: AQHYDUOvChWv7WrZkUSyKloA1xiDRKxr9ViQ
Date:   Thu, 20 Jan 2022 14:19:05 +0000
Message-ID: <CH2PR21MB14640448106792E7197A042CA35A9@CH2PR21MB1464.namprd21.prod.outlook.com>
References: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
In-Reply-To: <267a35a6-a045-c025-c2d9-78afbf6fc325@isovalent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6e2b32c-5ede-490c-8af3-08d9dc1fd0bd
x-ms-traffictypediagnostic: BN7PR21MB1684:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BN7PR21MB1684790EFB67EA9000844DAEA35A9@BN7PR21MB1684.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SEt9xI/h0xW63rDLc5otUsW3vjBariftRBiDXklJ1ZyB19W+q68QU3T1u+l70KgAk1lQV4UDILJosDlAEwTW/I8lB9by9fLxKJhglIqvpX0kY3bmONJNLeh6CNQJpINSEzXIhpnIDSu80nZUDf510DxiFdgSXYl6xlAxxuCOaT8gCTqS+i7lqQqENsnPdX2cI315g3uXusDM6lqmQE4uVImOU5MnIgshge2sPiAUn0AZY6/sDbeX42rmPDljqHu2TAuIvIWQ7pNdTDw5kCEAFFKxmrC8QorHYoyyUbJT6orWgrxZdBNcouoKynmpvEqkqhyy5K/ltTbaBc0FeIXWJaf9jZds2oNAJCy+BG/lNy70dUerYFdkwqOrB/feTJbtywm9WEqyctV+ULCkxQwsP7DGyqwCdCuzZJMiroy2u8oFstK3F+Ezd1Ij6enoKpmSkpezcFTUHTdUKLuEMNp0x560P7CdEcCie+l2tl/1NesbX03EQpN/7GvmuoyZ4Ivq2wgmnHSFjjlSD3BAD9vIphxmzLL4aCZINAyyuXmZ0jX/8fqjir5Uq1GK3FNBqvc4L+AQsYc4NMrZ0NUtT/BpCQlx1MokocJFmQnXNa0kZ1OtiZbnPoMyXcTBQeo74U6BH1mQ+9F8RqFe0/jLZi6UV/aooJPXyjD1n9hNRLOLUXCeT/Ic287ovLB8bDf/iNZnc0Y5v/dyInTx/EmckZY5EJJCK3Z00grDruDUYKjejjSLWstqj8f0ZmBWNMZ/64JU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR21MB1464.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(71200400001)(3480700007)(9686003)(6506007)(8990500004)(83380400001)(186003)(55016003)(2906002)(54906003)(316002)(4326008)(38070700005)(5660300002)(76116006)(508600001)(66946007)(64756008)(66446008)(66556008)(66476007)(33656002)(10290500003)(8676002)(110136005)(52536014)(86362001)(82960400001)(122000001)(8936002)(38100700002)(82950400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qbU2JVnT3Nzx+nKTLUVxSXm0YZWCCX/EoCEwMF7cfOC0rMHE/TnEneQcKUtl?=
 =?us-ascii?Q?tVfhOmgZoYlaVZwMny+tBvjdYPc6K7mpmZLbLsHw1JWKhiPompPvTpacFz8k?=
 =?us-ascii?Q?cvnaz1w09AoHh7debRoaxmTp6zAbvjlcwA1xjrijqfOOpNo0mQib7ZEWmf6A?=
 =?us-ascii?Q?htnwawTjD8JMkoNB2kPPidJI2F6vJ30qofxvTncdkSfiSq4RUbqQGNQ/mBfA?=
 =?us-ascii?Q?fql9Dmp5ontp14EfuyIy6X47NF1Qqlos4cqz8YaP+7OkQvNJBC7BjI3CstgJ?=
 =?us-ascii?Q?/4KKqaISvQV9yHqno0jQB7e9bdCZ/4jnuV3Meqgqt1B3Y6oyX0BCAx7NQXCJ?=
 =?us-ascii?Q?AiNLFxTn7IgVhGV6PMhwy4+NPaZXUjML+fIGUUhJZfaStMRxvT1L8dsT3CMQ?=
 =?us-ascii?Q?uaHyQcQV6enwBpCbnDZfVYfuwJOGUWSr3flqOzLvlzukUhBoLsrKJfMFUGv2?=
 =?us-ascii?Q?AznKJj5r78A1iYXuM3rv2G0Qsr40ryhoC5vYPTkeURlAEMNtlmMnTxe/C8QU?=
 =?us-ascii?Q?ABNIC7Phd2uQKXsMnoLLO7SNgk4vlVGCCFZS7xlsIu4Pa+3xA/mofUCiaTic?=
 =?us-ascii?Q?J6eXTFLcNjHcXrou7jP8sK+lp6SCQeutICADsqt5avAW4mjWnlQ0+xSu/DT2?=
 =?us-ascii?Q?ru9ZlnS7xBMyBYVAMjGunmG4IpDKVp82dys9hV1xH3rvJ7oAPDVNiHDBPOAp?=
 =?us-ascii?Q?PxmJSUtch8Q/Syitx2tdEqNS1KoxX22M7AvsXpOGLzL/F85wunNYqlyc310Y?=
 =?us-ascii?Q?Ox4UY3EdxcLjcOQD9oi1niw70XndW6CO49oK2ivB6Zq5PNXcR7QAWa/JjEgn?=
 =?us-ascii?Q?yvUCeELzJKyE4xIUchbCi4ME+UZUN1jUvNj0WyIRY9t3zVl4mXmw/yyNhE8W?=
 =?us-ascii?Q?7L8s4ZM+JockbtR+nrUZHiEVNX7DJ2YiKl6xaC625r/zI2J83SFsTrPb8jjz?=
 =?us-ascii?Q?bf9wTFl3kWFTO+A+9Lj0R1qFP5OyZYtoFLF2L8CTOByIwFJvXdHEvjgv/8YE?=
 =?us-ascii?Q?XGJC4Dx0kcPBQ3twspmP15/BtWu+Y8RgLceIBMCIKOK0+euDwXS9fRsSsxHE?=
 =?us-ascii?Q?2h23nNJEaVoM9moPtxI2Pr+U1HkIMIAGEmxaYUVrqalSjZhbziA4+lVDq0l7?=
 =?us-ascii?Q?CdK8kx6zniZTR7uxuvvHsxsCHeLESRv1rTWGI1E2KimYWc3FLkSYN4r+Tb/E?=
 =?us-ascii?Q?efIXKf9mBcABQ+Ivmo1UxbyYI2nOY0wIARUKen+6JxZGYpzTxBWpVBoUUCyX?=
 =?us-ascii?Q?5EKM0CthcqmZK4CSRkrTYRqC4uBpRdzYDTwTXCA+C65udB2z6AHuFxkomZFV?=
 =?us-ascii?Q?T2tYwFnDUMIBYAoxTLliWdBZaL7ndm4IfO0f/8VDVv7Vm5IkYwq1ISPdJVku?=
 =?us-ascii?Q?074ajxiv6YQ9euLws2scdhendpC5Qxy2xXOLKHxX9HPuAb+LCQr3LrDXueMj?=
 =?us-ascii?Q?EkJPeUNMcpDh4m2FuY2UB1F/nLYbMadvzyef0lETpYuJG0UoHTgLSG8zBWW0?=
 =?us-ascii?Q?wI2yesO0aQtefXib1imWkXNoj9v1hV9zjUAhNLlJyCXM5S0yar8cCBEKMGRd?=
 =?us-ascii?Q?too9tRJKn8yey8GKdkO8LpT4ts6V4oUUDtOqE+3gAOYHzjlPNrmm2sHAaVej?=
 =?us-ascii?Q?fZOQwIqF/3bneJMKbHsPtbWkaj0YebxlmNIyNO6BnI7b7BheB0pV6rh/9YGf?=
 =?us-ascii?Q?52aQOvMItAF/Fhg5GYP6e4Di+xdsJPCCDaFPkQbEv87z+BrKCAz5Ew/vOcDZ?=
 =?us-ascii?Q?OoOvbnzHqg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR21MB1464.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e2b32c-5ede-490c-8af3-08d9dc1fd0bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 14:19:05.3115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IAMvtk7UTsitq8BagaLlzYPspJBQLxD7D3tOot5DAJcar0TEvXYXflEI5BAur7opDFeTxX8flatkFJnSZXo5NxLEHOIIkqYY5Oz/7tXViG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR21MB1684
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet <quentin@isovalent.com> wrote:
> Hi, I have the pleasure to announce the availability of a mirror for bpft=
ool on GitHub, at the following URL:
> [...]
> 3. Another objective was to help other projects build on top of the exist=
ing sources for bpftool. I'm thinking in
> particular of eBPF-for-Windows, which has been working on a proof-of-conc=
ept port of the tool for Windows [1].=20
> Bpftool's mirror keeps the minimal amount of necessary headers, and strip=
ped most of them from the definitions
> that are not required in our context, which should make it easier to unco=
uple bpftool from Linux.
> [...]
> Just to make it clear, bpftool's mirror does not change the fact that all=
 bpftool development happens on the
> kernel mailing-lists (in particular, the BPF mailing-list), and that the =
sources hosted in the kernel repository
> remain the reference for the tool. At this time the GitHub repository is =
just a mirror, and will not accept pull
> requests on bpftool's sources.

Thanks Quentin, this is a great first step!   I can update the ebpf-for-win=
dows project to use this as a submodule.

Longer term, is the goal to make the mirror be the authoritative reference,=
 or to make the Linux kernel repository
not be Linux-only but accept non-Linux patches to bpftool?

Dave
