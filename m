Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0C72D1A62
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgLGUQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:16:53 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:61800 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgLGUQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 15:16:51 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fce8d8a0000>; Tue, 08 Dec 2020 04:16:10 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 7 Dec
 2020 20:16:07 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.55) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 7 Dec 2020 20:16:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBp1hlV3gvpYkWGQzQWwmI/pNgH/KQPG3DcV91gr0gnE5pfq6rZvck6EovAQEDZfdBa+SE2t1M0ZFa6BqM219/U2f8poRdNtHTv6u4CO5d+rlkYmgZ1G0aOWS1NFaA43iPozH64lQo3eT1Si5Jjse0RYytBnHDqW6azCBunmBgyDnJcLhltyULSYbRJqvwID1d1xSmr8IVuB/4NXlxNkCvHmJ5VDZjpV3hLblwDL6N5bo6PMkixisPnpomYIVXEEjQ/ZAGs1LA7y4OAaqSypWIu7oUVlwCNLhp9i0Fq1RlB+q2VnDFh8N/cqxZdw4ZD/yAZ0rjAU+m9gjqqDHcuDcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oo/j7YInXDi3MyJiHMe1sTOkhKshCSLw+Qr6U3z454E=;
 b=CesFhb3m1xp/c/ksxq6UwR1Dq55tYone0duIa8795Dq21thoPCYfcx6pySLE3CH05GKJbSJ36x63Wx+SwUHynq+pfWzUFmesLu18MFJecfpVC50bke+lwlTkilZMsLSqrQGh857rpEROoekE64QIXRoLvRm43wwLqyOT9kT08+HIj6nrnnZXkP/m+psjIWWjpOx9XDm97I6MSoWExdfTmH7CeCoHIL/GLaGIANd9mqPHtpoF1WZK7i6w4KzRnkzsdn355ORxABn9QSkGPXNChqpmhXKWUFi0ePnZdXdjdrxHlM8x8EKW+c0IzNCZevG/AgJaVg03qd2Oe1zUrDI+SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3030.namprd12.prod.outlook.com (2603:10b6:a03:ae::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 20:16:03 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3632.017; Mon, 7 Dec 2020
 20:16:03 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next v4] devlink: Add devlink port documentation
Thread-Index: AQHWyZ6W5Pc9bv0Emk6Xe437ZGSmIqno9s+AgAIatfCAANtGAIAAJWSwgAAFMgCAAADQoA==
Date:   Mon, 7 Dec 2020 20:16:03 +0000
Message-ID: <BY5PR12MB4322B5678B9CADFAE5788904DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
        <20201203180255.5253-1-parav@nvidia.com>
        <20201205122717.76d193a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB43227128D9DEDC9E41744017DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201207094012.5853ff07@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <BY5PR12MB4322D2D98913DE805F8B8CE5DCCE0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201207121238.76dd1304@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207121238.76dd1304@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e904436a-c834-497d-77e5-08d89aecec17
x-ms-traffictypediagnostic: BYAPR12MB3030:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3030F955EABB2073DA8568DFDCCE0@BYAPR12MB3030.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2mCQW96xAJFRqZgchM7ugOAlti8fOg2Fgrb6ESe4o61kUH6j5mIk2t52d5rqTZppz3RsIboY5clKBEHokuVNjOT+SGk0A9lWva2qvc41NGFMW4Xe4aXBhgT1QQDFxmUfybq/1oBOmNXskdOvjJHrZDgCi7kwKxx1Vr9EEJf0wKH+XcGfhQNft5+pst/y7uE6jErRK4FlXyUbVWxkX85vX3XeZzRgBVaKlZw0xYOrKvFaD0WEOxK5/wGY4LpjsIGef/OSql6RskA5niBsYnNFF1DaKBl+PwMURz9uHP3UTNluUDMp+5FBrkQ6QBTd9UWLfeTiGdEhyM353wyjC6VErA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(346002)(396003)(376002)(6916009)(66446008)(76116006)(66946007)(9686003)(66476007)(33656002)(86362001)(26005)(66556008)(55236004)(64756008)(2906002)(55016002)(6506007)(8936002)(478600001)(186003)(4744005)(8676002)(4326008)(7696005)(71200400001)(54906003)(316002)(52536014)(5660300002)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/rTwalBQjXC3zQeDOFSVxQ3G2oTzAjCz72/HTqLgzizCKK6LZrPBSYfWC3l8?=
 =?us-ascii?Q?7Xf3aWs9zlJ5J60XePOw2Ux2iIVhR4OBhPt8FNUaT599V7/V4xhioZt2qQXV?=
 =?us-ascii?Q?KrRtf2hkr/A7zdH1CEdswhdOAkTr6f1j+eN7B7nceyuHt10GT+VFU8ziWRCP?=
 =?us-ascii?Q?gvleuXp9yShm8Glm8SM0Q8Len9rCiVd/JeCCFgRCHulX7dwbDzDKF4fKMrt3?=
 =?us-ascii?Q?XyInN3d/inwnK2Tcr+UFSBJF1oOjT6iJJmHmx/zUFuiJMptfb8g77B5hxV4o?=
 =?us-ascii?Q?JYark0EnO3CfHRGKPLLVhyV9Pycn10lds4XBeexOTuZArxYJLzSnXuYVjiXP?=
 =?us-ascii?Q?9EuZrLXJD3zJZa7P8JCmSwBGtJjVbiRoEtwQtsJPhSXoLOlGJCxlEHDqjpkm?=
 =?us-ascii?Q?PUVRUvG1JIg2L0ZTPDGCzqutFxBVB7hC2fSHIiQmlbyrvpDapk4WFdFo1ywT?=
 =?us-ascii?Q?To7oDp80fM5c8r0oiWLUqyMLVg22phcupAukRubs+T1q+lR5jAIBEjwF4Izf?=
 =?us-ascii?Q?BpQ/Ca4HWwNF0+g6715hxs68zlmS7A1vkxdWndm9vDTua3T9rDbVXZflMKGP?=
 =?us-ascii?Q?Q0coJVpmEMJLG0bxFgxE5Pqq8qovSUWqMKwqb3yc7UiRvG3GyX0TfLNQzRKL?=
 =?us-ascii?Q?u4hcztqCJHcFY89JWKg3V6ATKDnU0NxXoaCpxS8h+EtVL6POpd8wraKOBMAe?=
 =?us-ascii?Q?Nr2MMuc//T+Cj+THBor7bhaex4SVoi9FG7MTQ0xsTLfjcZi9pMGv+nzKm+gm?=
 =?us-ascii?Q?G1kWfDUqeNNiLR59G6NQ7oHGBCC2fe/snIRzPFSfUZfKrpv9i6FFvj+Exr06?=
 =?us-ascii?Q?erKPfzZzXs87ZhvXDrruN8ogZeYi/wSTqzK49kT2C++l/vT6iJVC2LpFPjeT?=
 =?us-ascii?Q?0XGAt8UryTymfJ0yIn1KYv764CEstn8VoMEjHQnFcyXNSBUURZHi52j1nMRX?=
 =?us-ascii?Q?ZUMk5Ake8wkP4eWy+drCE9uWdMtZ0R2j7/+Lkei3+Ug=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e904436a-c834-497d-77e5-08d89aecec17
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 20:16:03.6108
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeglPt6mMJ8LGcSSUyKfmUB+sECAoVli4Lq796baKu22X/EEaNyN9sCXzyxdnqHvxw+8WbOskVG17K/1ZW+vKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3030
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607372170; bh=Oo/j7YInXDi3MyJiHMe1sTOkhKshCSLw+Qr6U3z454E=;
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
        b=IEamhSCWFOTCBGiF73N+z9U6OTyg+GQJ256PD7USRi8hFLUnzYiXlBRyo381F2wNn
         89Ioeztl2/dzeO76e0O1O62r0/usvCyZ9Zk2aEh87icrVwWRP9OaHxjljj68DBOJey
         LuCoxltnSxzfkKlRhwbXbcWj1F8nlXRA/oEXxvme5kDKuIg0P4dzWlUAZgQKrXXZhg
         OfqnFXXZ3opmsRENwDRgThDSiLB6PIHz4RcKrwvoOJNdD0YBScv3M8AfF7+M+veHlT
         wyr0gpjojEagtXcXmGvmavDV/SHT0SJtyh59udr6w50DH80Zm9JT67VM7EiKdLJEGR
         hIMrbnS7nw8lQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, December 8, 2020 1:43 AM
>=20
> On Mon, 7 Dec 2020 20:00:53 +0000 Parav Pandit wrote:
> > > > > Each port is a logically separate ingress/egress point of the dev=
ice.
> > > > >
> > > > > ?
> > > > This may not be true when both physical ports are under bond.
> > >
> > > Bonding changes forwarding logic, not what points of egress ASIC has.
> > Ok. Do CPU and DSA port also follow same?
>=20
> Yes, DSA/CPU port types are points of egress to the devlink instance.
Ok. got it. Thanks.
