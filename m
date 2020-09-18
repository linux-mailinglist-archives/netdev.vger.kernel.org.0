Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E1D2702E9
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgIRRIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:08:17 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16044 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgIRRIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 13:08:16 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64e9730004>; Fri, 18 Sep 2020 10:08:03 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 17:08:16 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 17:08:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=luXeKAq6v0jxLlNYznVJsi2qZKQVn1AVEDPC5ghd4r87MvRgI7WHjRiAnNvy0F4dEGVKKJoSN2hmsCGuiTiB87T6zkB11PAHXGtzV4SLmTNhB+gfoZ5zKP7DZ/cj6OkivDtE+iNpJN3oTamgAekJbXFMampwSwJ0gBv+x/qMHsYEQ8Vx5KcEf6iF0eTuyIEvFMPnncHkJz6868OJZubRMhKSN1lnRVBbO03g0U5h9P5CjmDvG0JHWYtMjl/mAgP0rt+hfjlsCDmQtxpEphdRrAyS5f/6Rk8fRIfIy6SNK+YrbGx4L5yiNODHZp0WUxfmUKZ1mbTw3dGSKI84ZSkhpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQsDbSKeqXwwA8VS8Qs/wpwP8y2sCD/noX7hNYVTYxM=;
 b=REvz6snQ1nbqkXymHUKdBJAC/85OOhU//wi19b2iHFwjLG9QM6S8t7Tx3zQCBsM2Yq6tRhb/UoF7klrm2IgrgyjEvhbo+PkpA3LMY5HLFRds4tcC1GMFXUvrF+p9FaXa1aBRN8K1OrwjGlqgyA+ppj/SvGLi6bbXNoHkzs9zs24crXo33fJUq8sgV5nlO0QS8Lr6eeXGI3FISR/KMj7bhstMb0a0YaJIb4ZYhdS7M7MIm9ThX9g9Z5ylJIlqazFdA8KRvlG+rGCLjx3fxycjvZ33vEbhH/HVKgp59zvbTcuOtaOc93/6cbaxebnFs7JfZg0XrES6ejxs+FkfGi64wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3112.namprd12.prod.outlook.com (2603:10b6:a03:ae::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 17:08:15 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.027; Fri, 18 Sep 2020
 17:08:15 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Topic: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Index: AQHWjRbejAHFYrcRiUC40XmVyPqlcqlune4AgAABw7A=
Date:   Fri, 18 Sep 2020 17:08:15 +0000
Message-ID: <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
 <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eff7ff73-ae25-4be6-877a-08d85bf56e90
x-ms-traffictypediagnostic: BYAPR12MB3112:
x-microsoft-antispam-prvs: <BYAPR12MB3112372CE7B911486FF6655DDC3F0@BYAPR12MB3112.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HapvO8O5mgagph/ZfNCYnzlISuZyaj76DawGWD7B8/VDEqyKbUNwI7eJmjZSWv8h/mGfnNrQTSB2vv85K0h/yDpL9CR1XLEzqFMVM8Se+LwNrWO67HvZtmPob3qKuLJykwzwDimZpcSiwuCBYN49riNQP9fwZGyyOVJ8rJ0BW9fiiAYcHOZdoFNMVpXljx5jt29p8b0C0ykRWBGjdpyyBcFCbuxaOqkrbvw9jIIfqOW8jqwm+H0PizJc+D8adEL3t07IrUeIBBvrxwXqhkq4Oc6UhVP1mMP8YLqDxI2axm5wUzhH/uZSFTUsRPCHE957KDKq/2XHgqgxUHCTqVXB4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66556008)(66476007)(52536014)(7696005)(66446008)(64756008)(83380400001)(5660300002)(4744005)(76116006)(4326008)(9686003)(55016002)(478600001)(8676002)(316002)(186003)(2906002)(26005)(6506007)(33656002)(8936002)(86362001)(66946007)(71200400001)(54906003)(55236004)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: qOr1552HhvSM7xyAh/xP4mdc2R5GyiPjwqPZ9fJ/ELD5H+DE5asVm29qkquk6Wm3OcJvJ9G9eQNXjFYq4Q4nMfDUYrrxD/4ZpkUbqb6xBFd44io2DPjTegH6fakuT1sV22XYrQ6YXWm2EWvJJK8EGVkRokTXg5phFQNrJe7KFx6/ArF/xQwYgAMTR0OjiUpQORN+GbaEu5fcu72slUJxXoDWvL1UQ0XrkXc32+rkwxNg9zMdEKXQJMKoGCogwCV6gZ4Ugn3f1RjXld8FQlkBaCfPX7N1BixPFqP1PYjiEjyVJvKkTcmYdH+irR8nFTBnZ4nCt4aREyoOGDHCQTVSvI+bDoqCCT+S0vrg31RDGX00SWBit90+v8Adgg4TysyKiIWzaPGr25IG6dXK+cdaYiJBo3eJfw2y0sUINIWCH3gLLGXWK4swthV6cg/f1NA1Lv66oMmdbubRv2UWbBBRnV/ftKum6e/vDQquOL2Kk3ahdGGpIcBp0HKEmjoFP0gdfVq0tv+DvqwxDFj/ieg/79fIVfy5vqF0JKuhrsGPDZ6OxOOy/BIGV41GtMm3kx+iAm3iKkm+KpFNNonSS939wxIkEYPDAs+MxkynxXeJiYazpLK8GC8yl0gDmEQCUx3RbDLskQAbgQBlWbDFJahthg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff7ff73-ae25-4be6-877a-08d85bf56e90
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 17:08:15.1064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NYoPhP/nm+ehM5i/oA/vjTKgP2+QF1qjeIM2CU9nO4Po1eDkh0LeQ2wERzjjBCtPiro9Usigfhsbz2XHM8J3DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3112
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600448883; bh=CQsDbSKeqXwwA8VS8Qs/wpwP8y2sCD/noX7hNYVTYxM=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
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
        b=gKm7KmceX+yIzZDdgbTHHlDDeaG+lofgRS37tHCxNLhNRjQND05xYQb8FHhN1hnjv
         tdxxGYW/31cr25+1yc09WYK7MQ+LBuMYODRQTo41wivPCaya8FbPr2QvLpJGSX9Q0w
         Ed/00wu427JcYAE8uxtXuWcE8HwcFU7MezT5+q1ZFzsPIFPLuBg4TSDi1B7nSKfB3V
         MCNawkhS87Jw7mWGN3ehtKDUCp/HGUZpf6nbSmrP6zbAcGailY9mjv8IcTob7IJ/sf
         vy463ftePuZNh7M47OHDMg7T+HTb3QRzaaTuF6FosbdwHeyTw0ef9S+jMXyp1KqzsF
         yvAL5K19NhEMQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 18, 2020 10:22 PM
>=20
> On Thu, 17 Sep 2020 20:20:12 +0300 Parav Pandit wrote:
> > Hi Dave, Jakub,
> >
> > Similar to PCI VF, PCI SF represents portion of the device.
> > PCI SF is represented using a new devlink port flavour.
> >
> > This short series implements small part of the RFC described in detail =
at [1]
> and [2].
> >
> > It extends
> > (a) devlink core to expose new devlink port flavour 'pcisf'.
> > (b) Expose new user interface to add/delete devlink port.
> > (c) Extends netdevsim driver to simulate PCI PF and SF ports
> > (d) Add port function state attribute
>=20
> Is this an RFC? It doesn't add any in-tree users.
It is not an RFC.
devlink + mlx5 + netdevsim is crossing 25+ patches on eswitch side.
So splitting it to logical piece as devlink + netdevsim.
After which mlx5 eswitch side come close to 15 + 4 patches which can run as=
 two separate patchset.

What do you suggest?
