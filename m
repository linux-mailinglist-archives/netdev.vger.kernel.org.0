Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8674E2B6F56
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 20:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731331AbgKQTwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 14:52:04 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:1190 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730334AbgKQTwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 14:52:03 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb429e00004>; Wed, 18 Nov 2020 03:52:00 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 19:52:00 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 17 Nov 2020 19:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aTgUXyvHdqsZwf7rctyALw50iw00JTZl0Z6O48NoRLobbFRR9JmVO1/OJawF7XE+In3UuBXCQUPabThooo0V4Jgt1UD/w/kyF3z+vl6SSlWxSh+JxkXNmJ092z//Yeum6NZgrDG+4gPRDPtfrwT+HATj9thKY28xBg6y/xD2g7WNe87mIQEplzAPd5KBVhkbgrmuqdm1GMpAmDc9v8yZpcoIoc37+gYnrq1ocM+7iHKVON/DJfh9heV1MoyT8rap1HjKc7c5xKG/6qPdPYWMX6sbBxQH7mR+9b5bWTqrgxtfY7VdWjsfcgUP5dFLe1GaCx7+ZQdqE36izz6mhUSqyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHn1tZ1PM73wdaMsHuZzkAMr4deWcMkFxx1FBSerZz8=;
 b=hTTZTQo3pFeeB4RcuGOUvN+wcwpE37nDx2N4+WTbMmRa37v+fdmfl8de180ePI9iM5KhmM2dBJ4DIZwEId5CZFUbBuw9e0UZ6BeWwr4ygCcj5TVmdMipmm4q6qs4SvioSeR23GEaMeCPvBjPnxeVGlNwo7AouV82wrSgm/vksFZUWEE6kqi02VP6Ldh1GAZxLjWGJWA3ZGn5eQfDLW1ihMlUO1+6uITx3xgn2H1irrpjRiKrhTuTJD7etvwZuWxiq5dUu38OunIbhYOte93cj1394tyGmVhJmAp1RmwW4bBJjAVacfK1+VRhIX8hapAHvOqjYsx+XaKeP3UTYd7NLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4934.namprd12.prod.outlook.com (2603:10b6:a03:1db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Tue, 17 Nov
 2020 19:51:57 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::9493:cfdd:5a45:df53%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 19:51:57 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 0/7] Introduce vdpa management tool
Thread-Topic: [PATCH 0/7] Introduce vdpa management tool
Thread-Index: AQHWuL6/zQf/qaV5ZkSpuhr8mZ5CmKnLXKYAgAFlMcA=
Date:   Tue, 17 Nov 2020 19:51:56 +0000
Message-ID: <BY5PR12MB432205C97D1AAEC1E8731FD4DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201112064005.349268-1-parav@nvidia.com>
 <20201116142312.661786bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201116142312.661786bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.222.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d971bf0-e5ba-49a4-5987-08d88b323d97
x-ms-traffictypediagnostic: BY5PR12MB4934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB49343CD95D653A324DCAF9F1DCE20@BY5PR12MB4934.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VwW22KgW+8RKFQiNjf2r2gRAW1/zCXyb8Hcs7Igpu1kSVW96/evFc0m8JxvKqnYItP9Ig2kXhdp4+p9daLWogRlZqW9P/Qywua0t5VBjnAjzN5iGUEEKJHijwOHLe/A/zH4ixDmS6VHXyHCGRNBwBbPvwHdqmPfttIYa6Ez5ITB0Q1HD9LOUvsRrsIcM8QY2SN4wL3f0uNR6m7I9tQuecH0BbsOtRAkpCggbOGpr1STIg1Jjlb0XcmVfUbv/vHRiwkmMHq1HzRst9sLUXVoUy0vpWZJfSSGU755hPVDa9Sh0PQZZgxl/3UdPQZLeuUe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(186003)(2906002)(8936002)(86362001)(33656002)(6916009)(54906003)(26005)(478600001)(9686003)(55016002)(55236004)(71200400001)(6506007)(8676002)(7696005)(52536014)(4326008)(66476007)(66446008)(66556008)(64756008)(66946007)(83380400001)(76116006)(316002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AEbGBSIJ3WlJ2vZMqQIH9WpBn6FwAD0rWvCBirS7MQ7eB2coAH/oxVwQr13S/oDvvmEZceEPLTTuOBBu0q/Uw1+MIDVrzuwAhSdjBpFuJs+JTvJpxRUin0rakvozuI50u44Lnumx+T/vKNmshkI4KV+yazQTih7f32nU5J+Vdg3YsSEpBWhqGd9NvU5CZVU/D86ypYmrHFt8Du8XwFET/1qTK0yw8aKxL/8aDw8Y9JTo1P61I/jeDPJ1NlYx8lo59OemzsKz0R0A6ne41tqQ2ZGMa0r/06fjx797LNic9vRBeD84dLsxU18LvzkNgdypE0JsSEoip/khimA6YI2Y0lyp2Y3LY0TTxofYxdnzN0f9UIdkMPloWEtO0KS8qnk797ht1dhexKjia5nVjbnh9t6dB+5ARJFmd7TcLBsT4BLCTKttcP5N8NhTcix9zMQYftJONf0JjNamyT0f7BecijudHgYS+v1dzA9ZiGxHG67gJGoMuNf44S/f1Av3NaOIvjAvGREYD401em6oKOT9UjkNl2HXjx4xQjBfFWF7k/EBhpU07ZBZ1pomQVX6SOx1RZ/PyVOvb64P4ajBQZv2C5jKY0Bw3HXaYxQEWEyvxZRf0QTvM7Pnv6MpAgHKrTd/BGEay9KbzsGYVQe+YyZdhg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d971bf0-e5ba-49a4-5987-08d88b323d97
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 19:51:56.9217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypsYhrfOV3gb44W9lQVcRnHRVTeNUtNCHWMgWFiVn+FaV6hddzmcU4Jz2PoqRqZmiZW0b/r7vSRR1ys0d9wq+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4934
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605642720; bh=XHn1tZ1PM73wdaMsHuZzkAMr4deWcMkFxx1FBSerZz8=;
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
        b=BRItLEd0b9/wzfDu+cm0g79twrOCsPgt3L0sHyX2pewHxOdilsxdZoheLwgIPzc3L
         CYpcFUt6oHuxT1fCfii9k5S+CLDQA9GylTNlpzckoswrEcdhCnngBI1FBSYvvGCYzs
         vHR6LcXdU9B04FU7j4NP77ymvO1AbeOmvvDzRT+D7Oe7vsObEu9WUcPktufFtb1ej7
         0M4yplDdiP6pxUnr7Xkih1IqGXaX3C3onudX1SaH6t0rNRLSymkaJgtkpiQN/iFljQ
         V+yX3smcwSulN12RxFVQewP3gsf7VLoG/WyfzLFBUpKP7TH/GxVWbY8wBCJZSrW7dr
         pc9fM+pZ2pUxQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, November 17, 2020 3:53 AM
>=20
> On Thu, 12 Nov 2020 08:39:58 +0200 Parav Pandit wrote:
> > FAQs:
> > -----
> > 1. Where does userspace vdpa tool reside which users can use?
> > Ans: vdpa tool can possibly reside in iproute2 [1] as it enables user
> > to create vdpa net devices.
> >
> > 2. Why not create and delete vdpa device using sysfs/configfs?
> > Ans:
>=20
> > 3. Why not use ioctl() interface?
>=20
> Obviously I'm gonna ask you - why can't you use devlink?
>=20
This was considered.
However it seems that extending devlink for vdpa specific stats, devices, c=
onfig sounds overloading devlink beyond its defined scope.

> > Next steps:
> > -----------
> > (a) Post this patchset and iproute2/vdpa inclusion, remaining two
> > drivers will be coverted to support vdpa tool instead of creating
> > unmanaged default device on driver load.
> > (b) More net specific parameters such as mac, mtu will be added.
>=20
> How does MAC and MTU belong in this new VDPA thing?
MAC only make sense when user wants to run VF/SF Netdev and vdpa together w=
ith different mac address.
Otherwise existing devlink well defined API to have one MAC per function is=
 fine.
Same for MTU, if queues of vdpa vs VF/SF Netdev queues wants have different=
 MTU it make sense to add configure per vdpa device.
