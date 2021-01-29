Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646633085ED
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbhA2Gg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:36:29 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:17167 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhA2GgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 01:36:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6013acb70000>; Thu, 28 Jan 2021 22:35:35 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 06:35:34 +0000
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.48) by
 HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 29 Jan 2021 06:35:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1vwG/XtxlclnQwpxilsodjMQd/6OqgE+bIj5M39HVasP4qOJMCsa/f4JVvYzXAoEoZTpnqrMq2N6JH6iXT3svsEnptX54HzDpALDYg2NK7/PNkksrD0dnpll/BSYkn+i7C+2PxQogiXJzdNdnD3sWN691ak5p1yG+5QEpTa174Olt0EU/4f4/iXTUNAGBsFnrLvQ25l+GP0tMmf2ac+6l7DETaTV+Gv92Q+/yJyh7VqV4A1MkPTOX7qLKMi38YGqy4Qq30xlAa2V8H56UYrbWSvDwBTyHv4tUXbjao7OVsFUItjtKYlurQHtSCl0m8d9PHsDQmyT+E7P7dxbxF55g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkxcutkp6OKmStWpKVa0pZOtuzJJHwosPubS4Jz5jbk=;
 b=AAGa3UjMFzY3DrD3VE1EVB9BlkmCaWIKQFCJ/aCEyYB6W4NAC/KlHY+v1AMQpKR2doV7scfRNPCR51Hmj5DDkCIIuPfsv5Z/hZO0/G/XKxicfObUw8MTylxtHHe7VenpO8YuE+f4E7skhtl857Fn6eSQtjDSWWCgO1VQGKjHAgpDj5zC2wpP5K03EKU7te1p+aTeyLrQULBZgCYBd383GfcUCMg1uyj7seAaaRXvDbci+A4D3YZ2YbO9YzdUHLdlmH+iuB83Tma3olHhU3fFTN6fys4BPeWpP1oHoxMSxgQtkT48uWBAvT7Jm7eSXRHbk+zQQZDPbHo0rOQGL9EH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4323.namprd12.prod.outlook.com (2603:10b6:a03:211::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Fri, 29 Jan
 2021 06:35:33 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::f9f4:8fdd:8e2a:67a4%3]) with mapi id 15.20.3784.019; Fri, 29 Jan 2021
 06:35:33 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next RESEND] devlink: Extend man page for port
 function set command
Thread-Topic: [PATCH iproute2-next RESEND] devlink: Extend man page for port
 function set command
Thread-Index: AQHW8HvBtBaI3iJgI0SqHWpiDnoWGao567kwgARFAJA=
Date:   Fri, 29 Jan 2021 06:35:33 +0000
Message-ID: <BY5PR12MB4322C17C6963647C5E8AED05DCB99@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164712.571540-1-parav@nvidia.com>
 <20210122050200.207247-1-parav@nvidia.com>
 <BY5PR12MB4322F470143709A0294F1463DCBC9@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB4322F470143709A0294F1463DCBC9@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.167.131.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c6451173-8092-435f-e806-08d8c4201465
x-ms-traffictypediagnostic: BY5PR12MB4323:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4323C831AA64BB64AD6DBF30DCB99@BY5PR12MB4323.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:741;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: emNdnFI5KoY/gNZB3fXC/BiVZNTLtwQhAmgqjZ1BFX9L5+pC4BswKgMbXmA9oWIxBLqhccs+cZaQXdrddV89BOAHQGPwHDHBXfOUwGT2m8kQYnHPvf3M/LOShHC/byZgKKc+N7dlIKLVkGbyR5b42v7sOS9zZxe+kQbUIGDWo371PnG/jKXYwUkyduOG8SuSElfGl4Psl6wpn1sCdOpAqslCnI2wVsc3naSQkKAYYLTuAU3v04Vhx4m4CiD2vZjJpjs6q3+GQJxXUJqdSIaKgownWrj0sYLn1XThAXlOAeSmTp5YiMsT0L+OiuVabu+4U8DZjeOF+RRIhb67elr7rR+dYd+dyB2yKREGuT3Sp3gq2Loo1kCLV+DhAr6eXDDK/ybot3KhMTtcfk5X0yaZ4DGUROd28CZxuD4YDsE/tt26ekskDsM/uKNqCqXi0ogY5yqogtJ0XOnLcGhDotXjd9m1I1iXnay5i3Ibd63zfbciGjY1nAbdvaRzoqeCKi0dnAYVnWxuyVXfuoyKcyb00Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(71200400001)(55016002)(4326008)(5660300002)(8936002)(478600001)(2906002)(83380400001)(4744005)(26005)(186003)(33656002)(9686003)(110136005)(8676002)(66946007)(76116006)(107886003)(316002)(6506007)(52536014)(7696005)(66556008)(64756008)(66476007)(86362001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?w3GzKVQ9/c0xnXfVkkhPybkJfWPl5cVnrhWH9DJ1G/gB43zyWWqS1iqmVpRL?=
 =?us-ascii?Q?9cOFAgGRl0mpTZz+7I4VQin/cc0CZQYiGPdy0F3jYUR3G9edwTqFuVy8ddJ9?=
 =?us-ascii?Q?lBVa1F1hLW/GnqwGfpNpqbUlBiFcxzJNphGS+QZ+Iaco3d0wjfBQcyR82mAs?=
 =?us-ascii?Q?Q1PXedd+AYLkw7b/HN6q8FTIfCdFU2848WXTVGeoI3OYCnCLUVC/f3rYrpbU?=
 =?us-ascii?Q?lLIM+V6d/ppTukI4PhxACNnXIh/ID9zkoUj/JxF5b/yrwADp26hm0MBw8HwC?=
 =?us-ascii?Q?IKnwMbHoEz5AGxDAeViY5LNPSx5r2TOppDRo7L81+ZX1wbSSJTlWqVzc4Lzz?=
 =?us-ascii?Q?645IpzNib0oQ0trTzra5ZAPclZVFCDvo4zxBVX+ZoTY1zvPtHvdJz/NVTxV4?=
 =?us-ascii?Q?+mk25nhGGHFQdnDoeUku5scSXRhaS6dKMP/eG7S/xOsFV1N+d4TjAVNuUTSv?=
 =?us-ascii?Q?FcH7Ah2aw5WbQBjAWZr/jpDqAz890XLD9HCEcZRvpK2Q3UTylQbZOTo3HpkW?=
 =?us-ascii?Q?KXyLj+eB0y/MwpRZLdDAf8GCRcxjr0GQ/5ThcI0OBtvLwE6wGGrvBlzu3UkY?=
 =?us-ascii?Q?B6+Atx1KWbGdDHBk4xzUyW575Ue/a6Snix9zw2z0wPIZhI7/h7SinE/7ZmCj?=
 =?us-ascii?Q?yN4J5683kqB43NQ9u/kIfnBusWloje9tlt9mFqjB1o8laA24OgcUF7PltVyR?=
 =?us-ascii?Q?OqgdxOLCAF7U8UDYhQc/ocvGYfXVd/sC2NOCRRjVkR2DcOa43gYfXZfBWyzi?=
 =?us-ascii?Q?OBR2eXtoaT0dcB0/xHIT2J2Nu5UnA5m2TmI8czn6doKeWVvMXEis3V4JCy6o?=
 =?us-ascii?Q?SWUXZO01VLiaq1EbPtgAaTrDrIpbvUvTSt2gKpUaDb2XJhsP7aqw6v6LL/Eo?=
 =?us-ascii?Q?suRZF+BKw/e4nZ2S4b7OQSgKCEnVDs/eMEaILjlQ9wWjY3ICuY5qcKrru3TN?=
 =?us-ascii?Q?aPE1dyZt38TBzg9sFU2aMvtaC7qsG/3G/siwd6PskeaoCT/Uuxzv3kn7ZxEu?=
 =?us-ascii?Q?Fn3fmuatD8uGov8wVKfXAE9LqBbscgMvBwDsXuUfo0uXO0IcDCIwowOXyOAr?=
 =?us-ascii?Q?SVpF+yyr?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6451173-8092-435f-e806-08d8c4201465
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 06:35:33.1831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e3Im/Nuc2VFIgkSHqgqhpC5mPSXWD7TB8ouc043WJnIFRAte9lnxfc0hdTpHcg+Dy5tWNXN1m/YipMc8N1gFUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4323
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611902135; bh=bkxcutkp6OKmStWpKVa0pZOtuzJJHwosPubS4Jz5jbk=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Ive33Cg307k9ynpADj/HlsbWj7PQHyvQem2GGkiHCNt1rlnARdVWlxWQxFbZ1dHSK
         0brG1xHbY1aoO8ZfODNxOYc7+LjoSWiOG06I4A1tWs4mXR5ipgKh6rf8BMP4/HMEF8
         K96SbKwBNKeQx0NFSAssb2ZxlTJ7whlmZjDQ0LKVGYjpD/7HqxlHYkDhQIwhlGM42m
         tW5kV1BMAIWwzFe38OdaP67IuOpcxjZuX+VwoVPBLDoWibz5PE3BbSjNcFRhXRS3ng
         fZWD1JiuNT/nX7G1LkNyBpQjJ22QMNik6Y13viwuH7keeCeLDsUD0OoIz5zJFIrsoT
         snjJiqI/s7xxQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, Stephen,

> From: Parav Pandit <parav@nvidia.com>
> Sent: Tuesday, January 26, 2021 6:54 PM
>=20
> Hi Stephen,
>=20
> > From: Parav Pandit <parav@nvidia.com>
> > Sent: Friday, January 22, 2021 10:32 AM
> >
> > Extended devlink-port man page for synopsis, description and example
> > for setting devlink port function attribute.
> >
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>=20
> Can you please review this short update?
Please discard this patch, I am sending the subfunction patches and this pi=
ece is covered in it now.
