Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCDA2D1A2B
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgLGUBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:01:44 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:36430 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgLGUBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:01:43 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce89fe0000>; Tue, 08 Dec 2020 04:01:02 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 20:00:58 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 7 Dec 2020 20:00:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVqLljF+47NGALSvMXttCyo963uTC6kIeAU0vV/FeF/THTz9rFfHtaurse4KUYp3NruLW+L9YqemAU92PRcYnJjmm8ujopCQP9Gv8VRRZRttrYDlKpGmEWuhcEWkMdYwDisQFdFAnRhdrJ2LY7o9DbVEnrMXhZDhK4Ps0nDEN1iXCfsWVp/I6KowSQOsFCwszDxShw1kkGLLrmUayjoiG72o2C6LDKpuHvpsFArMwe0zERY0TIfbrQzV5vVNOVn/F6LQMrhkKPFNuXtyew3xkx2sBvLpyVPpTbOJ/ykjwIhrvrnSpBIR2RePSk3oezaRL18v28QuHRv+7y4nbyIEtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K2ECl9wfx4qjq5GY7ALIEqrzvF2tu0wr3twnnKyko8c=;
 b=coLL6dSFd4k4svKaAf+Z8eOE21MMyuvGs2auap2jTMO0iSAthMHb3UhXiEGFCCwGdQcDNAJlKY/AVbi9m93rsI8FEDcBgUQ8p4Goqp+S1qwEkC3Hb5HY1ZJonj9kt4AJrQ1Z/buq7lWSaDnSzlpUtbAAYwj8+9yfsdnvthtN+1p9+0X2HV4EUmIC8OaleNK76uWtX9Ze90MtOg4KCp4vI96FKC3roEBOnk/33rnVeFxcHJPmS9ili1giPxQTOOd4BK2t/Ojmg0kbwoOBpUKLKHHi09YjuYIT6reVr7DXO+3dB/ozx8mAjVgYShXOjl7KJTZTwbPzz52iKjyMHuMf1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 20:00:54 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Mon, 7 Dec 2020
 20:00:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Index: AQHWyZ6W5Pc9bv0Emk6Xe437ZGSmIqno9s+AgAIatfCAANtGAIAAJWSw
Date:   Mon, 7 Dec 2020 20:00:53 +0000
Message-ID: <BY5PR12MB4322D2D98913DE805F8B8CE5DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
        <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201207094012.5853ff07@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207094012.5853ff07@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67b94874-1b60-4629-e316-08d89aeacde7
x-ms-traffictypediagnostic: BY5PR12MB4148:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB41481F1310B66C982078A39CDCCE0@BY5PR12MB4148.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R41z0AN+hZcAlarbWfvOEa5QPTjtZH0ODMQaPNcmhydAdfa8toQPOrVzEKhbmMp/6DM2HfHo/4wChVq/8vOoVtucGiRDr295LCJTqkzVddTYHHiHn9/NTwAr1s/yp/aWHisUykHDZFeJKji2kTyBz6Ly/42TPbimwVZCtTrz9MJQagFOin0dLV/VqemigTe1jW/eKBQN8lvzBOZ2XFCZazDtzNUCfriAqtMcIYLs8qDZnDC+C+frd7QIHPxWvhuS9X69oeMWE1QYL8fXBe4AtOcO8/3GbQc0WHIvcvlct7scqyJ3GZLbQQiuUFdsuB3u9y3SdmCQvP5CWwABWFTuBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(346002)(396003)(8936002)(6506007)(7696005)(186003)(26005)(316002)(9686003)(8676002)(6916009)(54906003)(2906002)(5660300002)(33656002)(66556008)(478600001)(4326008)(107886003)(66476007)(55236004)(64756008)(86362001)(55016002)(66446008)(71200400001)(83380400001)(66946007)(52536014)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bBbxYc35ZytjvjjHP5QGX75P4HWCJDcY8SJ2LRC2bRWgSNKvb9ikpG9JY270?=
 =?us-ascii?Q?x9BcPZqzDRgmpzE2vB00ogvRge77aSKDM2HexCwSDPGYDl5Z7uh6GfzF2+kZ?=
 =?us-ascii?Q?7LEla+AvI8grH5GBJfy6cExHiUSDVnPHiOUU//8JT1x1qCyjT86+AFKDLL2f?=
 =?us-ascii?Q?YeaNItJxUh5gm/0AXslQS5onKNj+PiAgIMdxuV4kh5nwch3QOkU35X1Z5YMG?=
 =?us-ascii?Q?RRhZAFTLnTR64ICZl4zaspgsuSi6GTXlAgaT9NoJBj/lJq70SX7f3mLNBPJB?=
 =?us-ascii?Q?ZoqHSazvw2h0tR9SZrPfsbRDhDHOxgpn1F63jz+7blJzUJx41ppBId+PvAOv?=
 =?us-ascii?Q?4JuDEOulV2CKDib1Q/VPo8sVY0whgTkQpPwDFi75YmA4LiknvIhwfSsK9oe8?=
 =?us-ascii?Q?zz3QQY0bQ8n1anbf1/sqDEl5eQe2vVHT5YjyPz+rhy+g4pnhmVJZSPWMT1E1?=
 =?us-ascii?Q?gLGQ7D7VvZFN2lEKgfIXMElCYlKzvZoY0s+8hrYy1qDXYoaAx4Y8JsykkzKY?=
 =?us-ascii?Q?AxPXjVhWFBNS7ZGoPLCBiq6JAcBx11D/4FSr72F2CYBXkKwWQieacauqK5OW?=
 =?us-ascii?Q?WvhbUcBLhIsGa0R8hcV9pU9j1shSwVarMsTaicUpaj+r2+Di+kebGzPwGUV0?=
 =?us-ascii?Q?gPqrdzT31XGLUoEtNswRHdlBxwN8t3tVCuNA72m5UK+IwsYpcIiHlk0DSFHm?=
 =?us-ascii?Q?W8w5kRTr6O92/37lJFjrfpIO2mIG2WBwcsUM9bekcAKRSeMykqMqH7SHljGr?=
 =?us-ascii?Q?6Je4929X1aD8WcuDkubys9HCGjmxwlxYZkSzMLy6IjtwnRjpqtW/OPP0QBJj?=
 =?us-ascii?Q?FGdOK9Y4KiFqaWqH4fm5IklikvFf9BYlOuGnVBdv7i1ba7ZRG0FlcWG2n1mx?=
 =?us-ascii?Q?9TPHOLOk+VHGigi8ZeovaOvWOPg1ik8TNOI3MTa9UBPFk6EwL0XcZbE9w5Hb?=
 =?us-ascii?Q?JnQJQFCEz5J0cHkp4KQQ32CEOFXXymKQHSX5JZeDR2E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67b94874-1b60-4629-e316-08d89aeacde7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 20:00:53.9361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNwSLH7pLi2KoK6cZVJdt6kyLLDyx+wbqa7QMIP7R5ntCgjUBor7IG3Hyktozh4W9mccARSrszy86Jp7ao3N2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607371262; bh=K2ECl9wfx4qjq5GY7ALIEqrzvF2tu0wr3twnnKyko8c=;
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
        b=ZxqHg5KvYSQdjgJ2obFU2tctFg6NwfgHvSvNqT7KFtLS0JcpAn1xZzqnwRjQh3vJw
         hx9U6OFsNay5Eo6eEUDVoD2+RJxA7WzxixqrsO+e9i0x1udnVj9pyEdfuBUbbj+qxM
         5n6n04yeFyGtagOIGW/OiDxzxB4fIXbQWraFYAMx5D6Gl6T4FSQ+LHjUcvOz/oiLVI
         Q2xBnXL5E3YIbRga++blYBytf4z5DOktp9VIKOOxHuJoYPfpbLmEtK+64wOCHF8DyQ
         GBm5DBXITeF+6aqOC0KOFevJsBf1w2OK5PLcclVQhBSsPYk7ecWHUH/zY9Lc1VoGhg
         31m8b6lnPORKA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, December 7, 2020 11:10 PM
>=20
> On Mon, 7 Dec 2020 04:46:14 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Sunday, December 6, 2020 1:57 AM
> > >
> > > On Thu, 3 Dec 2020 20:02:55 +0200 Parav Pandit wrote:
> > > > Added documentation for devlink port and port function related
> commands.
> > > >
> > > > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > > > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > > > Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> > >
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +Devlink Port
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +``devlink-port`` is a port that exists on the device.
> > >
> > > Can we add something like:
> > >
> > > Each port is a logically separate ingress/egress point of the device.
> > >
> > > ?
> > This may not be true when both physical ports are under bond.
>=20
> Bonding changes forwarding logic, not what points of egress ASIC has.
Ok. Do CPU and DSA port also follow same?

>=20
> > > > Such PCI function consists
> > > > +of one or more networking ports.
> > >
> > > PCI function consists of networking ports? What do you mean by a
> > > networking port? All devlink ports are networking ports.
> > >
> > I am not sure this document should be a starting point to define such
> restriction.
>=20
> Well it's the reality today. Adding "networking" everywhere in this docum=
ent
> is pointless.
>=20
Ok. so I drop networking and just say PCI function port.

> > > > A networking port of such PCI function is
> > > > +represented by the eswitch devlink port.
> > >
> > > What's eswitch devlink port? It was never defined.
> > Eswitch devlink port is the port which sets eswitch attributes (id and
> length).
>=20
> You mean phys_port_id?
No. I mean phys_switch_id.

>=20
> > > > before
> > > > +enumerating the function.
> > >
> > > What does this mean? What does enumerate mean in this context?
> > >
> > Enumerate means before creating the device of the function.
> > However today due to SR-IOV limitation, it is before probing the functi=
on
> device.
>=20
> Can you rephrase to make the point clearer?
Sure. Will do.
>=20
> > > > For example user may set the hardware address of
> > > > +the function represented by the devlink port function.
> > >
> > > What's a hardware address? You mean MAC address?
> > Yes, MAC address.
> > Port function attribute is named as hardware address to be generic enou=
gh
> similar to other iproute2 tools.
>=20
> Right, but in iproute2 the context makes it clear. Here we could be talki=
ng
> about many things.
Kernel interface is not restricted to mac address, nor the iproute2.
So I will mention as hardware address to be precise what is does and additi=
onally mention that it is mac address for Ethernet ports.

Will send v5 addressing these comments.
