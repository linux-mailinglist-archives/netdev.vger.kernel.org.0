Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE0926F9EB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgIRKIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:08:39 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:16591 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIRKIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:08:39 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6486fb0000>; Fri, 18 Sep 2020 03:07:55 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 10:08:38 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 10:08:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGeNNG/tCwerpQSd/AohAo9SWajfLOMQsOKwyS2G2s/CIZRYS59eiwYql1nBLkWxlkQ2cepEJzVyz4N7pyTv1KJ6YZjrDFL60ACCo8KtElBe/busaOUX/5VDybauAek7okLqTp5bD3DyK83C6M664b3BSdY7MjH/oyyB1UwtmUB+yLQndReCfP9vwwIWy9g6Eiw/o164aQJ3cyocUIX+e4HdW2DkshRNezANWixpFrSBtWILSiXYcJsEMoWFvEcrQnCrEzFF74dTzb7SILxCVel9Fo3qRNcOqIYlrP+TJjBaZoD73gTi6cNsxcQR1v/9uywEOoxY8L/T4zWUQ6g9cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v/XCQ66rIN7gJ4lrR37ev0GuiU4HtPgVbWNTS0mvI7U=;
 b=cWMQrZiv7+i+Yd80KTzs5qNYoyJqM7zzWPujXSJF8xtTwta5g9cM1R4se8wrqli0BPuwEdRJ1g07XGTAJW66piKWyWppPp+ehFzR3X72u/oEo3V8pnsGJPcj82Efj1FQGt82ber4Pvj0xOd2mv7tBYJIPWXhq5dbWKV8F/sh0eHgNiCzpL5+D9PZOMyV5qoVG/SGyS2S85hGI0fOmoDL/C/z0Po+oDCxcHgs470vebSzslLvFqmNhLHfn9qvTnHyrd9tXJ9D8ibpWja4ZNHHtbG5+ncPFbrH/JmpiRZ/G5bfXSDvCrRTnx1OBpug2fGfU8wN4+c9qk1SJx0C+Zu9hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4114.namprd12.prod.outlook.com (2603:10b6:a03:20c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 10:08:37 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 10:08:37 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>
Subject: RE: [PATCH net-next 0/3] devlink show controller and external info
Thread-Topic: [PATCH net-next 0/3] devlink show controller and external info
Thread-Index: AQHWjZIsv0o+Kzt2dkWGPjNMlxfdmKluK/pw
Date:   Fri, 18 Sep 2020 10:08:36 +0000
Message-ID: <BY5PR12MB43224558CA9A18A48E75DEACDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200918080300.35132-1-parav@nvidia.com>
In-Reply-To: <20200918080300.35132-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4051ce96-0e70-44ad-46a5-08d85bbacf28
x-ms-traffictypediagnostic: BY5PR12MB4114:
x-microsoft-antispam-prvs: <BY5PR12MB411443DB9B1B06540AFFDAD5DC3F0@BY5PR12MB4114.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rMuInPpAgcargyKZmo8WrCgKIoRo72Jw9R5B2FnQrc5WBnvgHe4Rw1kaFruA9yEEhGjNLQ462OXACtI5IxF6KccFSIstRm9PTNI8C1M+LcNAbfGgXKd+ZsbAz4KjVwJQBPtjwaj1O/ZiSRH6lSwgJxPYRfc1ycSOjQ3htM+dFHhQtnveN9HMA3vSPJcQDsFw3QM7xuJHidJdAi6C7dohCOuyStqd8+CdyUuN1aIUPTb+lsnp+LwCtPMp5f8zWGUGI4GCvPlg4c6bZP62xa5erHEIqTRvqy/3KEeUX0wrzxcCpDo/3fSVIYYW92oa9Tx2o3AnFhtV0gC6huXXjOnVQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(66556008)(186003)(66446008)(66476007)(9686003)(76116006)(64756008)(5660300002)(86362001)(7696005)(66946007)(55236004)(33656002)(71200400001)(2906002)(52536014)(55016002)(8676002)(6506007)(4744005)(26005)(478600001)(83380400001)(8936002)(316002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: P70cRzQ3ZdoyDKBZuMDTKIWwMorHIfr9LUzQrfJ6j0dpa44VQETImNsX7GX2eqXhnFOSRTWzMxistklpXSaDSgl/XSx21eFW5W/vIoECqczdrnPzWqd/NSAxGxlYjpl9sakt2oOFvQcMrJ5WoVCg5fc1ALj26rshdEFzCfMw6PhPI7GYd1DJnOR35pr/ApNkdVC66Pw7Y9wZbAUFXBqVk3LVY10a6pNdgDuku3e6VSEm8NVn4a9rLhZu/SA/FO1Q/jctIe9zydZs3sPgkkwXPiyz2lOjrPavlb+7TOD85Fp2iIlFH9djN6gPbwtogxCn6rT6cR7iQg2Enhk98IDQ9aZdBYeW08CPghpR8qlSv2+NXgNqHP3pcHW60iP33Y9pcoRfCsYfP6zAzGkQJpnYpTXUp6OZI8UyhsOVo55yHU1tSnIFrn4SvA3Qr4O8c65hU4Tox/bd2gNL63UvucAQyY3YMpbLKXfO9bEODshqqPXYehnNtwmoEi+Qno130U1+16dCkfM7xRDK2pjFUfz3dlNt/kMLJRkS2rcR3h5CARNO9CwLS3oHKExmiLKfTJUkyXGo+6G3IZ+PHEIPEXhtJp3D88qe4DE+r0cohB94cLrDp1uJq2Vqyhe5WR72okZ8+Jx2yaWKVd6joJcchiFjEg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4051ce96-0e70-44ad-46a5-08d85bbacf28
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 10:08:36.9577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oCVICFlYYRZFEEQ9DKAHR7OJFs/pdWpx01Xlwmcjcbl7CBKvHdGNxNl86NxTFZIW45Ao3IQWRtkpm964qkqRKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4114
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600423675; bh=v/XCQ66rIN7gJ4lrR37ev0GuiU4HtPgVbWNTS0mvI7U=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
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
        b=M4zPtlId3ZLoq6aqeGk/OWeGtbq2ZZH4W+2O2snbL3MqHuIBo7DqCwgUjTZxs4cEt
         lyzMUGT0LWYyy2yQEVRiEDpQSLElLokrRLBrwDPLaX4grVUH+T82nYvqwRfBqlJYA/
         QgBr3iMOsX2cyBoSS5vv1pWQcyZJBiYFK0r+Uo0TzRrm1HnfuFbGWNGENrKy6teaUe
         RPSz+n5LwKhR2x5OmRyaBSndBHzDTBGYifaa+J2HGNG4un2x4FREtfGXb8Co5SFhUV
         xqduwaMW7dPlaEXR4JotClCPnfWDjREPNQntzh4Z91AyQUbaeOxM/x8gbjhTXl2Rkh
         dOFJ3imAFP67g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Parav Pandit <parav@nvidia.com>
> Sent: Friday, September 18, 2020 1:33 PM
>=20
> For certain devlink port flavours controller number and optionally extern=
al
> attributes are reported by the kernel.
>=20
> (a) controller number indicates that a given port belong to which local o=
r
> external controller.
> (b) external port attribute indicates that if a given port is for externa=
l or local
> controller.
>=20
> This short series shows this attributes to user.
>=20
> Patch summary:
> Patch-1 updates the kernel header
> Patch-2 shows external attribute
> Patch-3 show controller number
>=20
> Parav Pandit (3):
>   devlink: Update kernel headers
>   devlink: Show external port attribute
>   devlink: Show controller number of a devlink port
>=20
My bad. Forgot to tag  this a iproute2 patches. Resending it.


>  devlink/devlink.c            | 9 +++++++++
>  include/uapi/linux/devlink.h | 4 ++++
>  2 files changed, 13 insertions(+)
>=20
> --
> 2.26.2

