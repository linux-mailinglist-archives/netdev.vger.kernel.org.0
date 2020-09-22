Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D9F2739E4
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 06:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgIVEhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 00:37:55 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10664 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgIVEhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 00:37:54 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f697f440000>; Mon, 21 Sep 2020 21:36:20 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 22 Sep
 2020 04:37:53 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 22 Sep 2020 04:37:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPCaFO9jPEV7GAwLfgAlX4akrIxUUAt9tMiYnjWt3KiWSbZFfrYwAnhoNLbz00jQcu2Kc+vNtyFE9fAsF6/x1A3gVkhcKUDSNt4+k4hIzOHaDRW+r6vvaldIZs7yy26D+WexClVQz30WXrK4hT+CQCu+dORPKiyX6mJ2OmpnQD4/prOgIl0DdePd/OWAK0TbGUnmhnijXn9JjX5IzDQ5X6fwVbch3Aql4nguHxjr/E+N23GXL63qVTfCx2xixEtK8zYqpn0FmTpw7g6LfIE1CkC5z5+q2lzwHZ4ci1s24cJlIHDnThdlakqHXKxvTX5rU0YVuIJxkzoV6yAgKGxlag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGKvDzDZAbpDqkeBwCLMAepzvUO7H8gd3J8UfVottp8=;
 b=arsLIRQ6UlGeEpPvOg+8JoJgz59U4I6VXozVUgHJm+gPJUZQUu7jSaWSwXD5aukjjB0rzbkAVrMQtDGTeONVetmtBUjA9rCybg7ftalvkwy4oIju/UKuhlZiAJnpX33gLFTcvYdDOSXgGz7/OQU7M6TPc6X1ipkUi2cVn3+/oOGVEGXa8V8EfvtwYLHogy9/qw7qgZIfgvH2+VC3Q/FtgEJtkW3Ql1DBwT7ZkXnKaLXXT8nR343Ey/vEMSxFGTVRvvN3ASBHs7LLnR0UEHzft8yMPj7m+ju1Uk3bcxTxRg+gg+8Ia6O9kKWZBtH3lu+uOryi5BsrF/YuVLeZaRU0KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3623.namprd12.prod.outlook.com (2603:10b6:a03:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Tue, 22 Sep
 2020 04:37:51 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%5]) with mapi id 15.20.3391.025; Tue, 22 Sep 2020
 04:37:51 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Topic: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Index: AQHWjRbejAHFYrcRiUC40XmVyPqlcqlune4AgAABw7CAAArcgIAAAWQggAAM1YCAABv/wIAE1roAgABsQZA=
Date:   Tue, 22 Sep 2020 04:37:51 +0000
Message-ID: <BY5PR12MB43229561A54E29AA880E329FDC3B0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918112817.410ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322C97E73753786B179ACE3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200921150204.11484b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921150204.11484b96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1219c481-f25e-49ed-0b47-08d85eb143e6
x-ms-traffictypediagnostic: BYAPR12MB3623:
x-microsoft-antispam-prvs: <BYAPR12MB36230E1462FE1EDA24AFADE5DC3B0@BYAPR12MB3623.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfycqjXPcrzUNZvyQaov51USni/lk7N/2NR6ZZAJTz1icpiqxk8BMqJNhO3Wd01zW9nHV5H7vk8fC56YICOF2trrvVe0HVFrCN6GJ5DAKC15b2IjeyWyjRw3TFjTGMt4she4OULMORDORzaeGnU1oUWVjk/vpGo/VPjbd9Jv1uXObihWeSrVG/JuFuu4XD4WUjuz/R3LZJT+ELcVPb+WFXBUD/qUCpvvfITU7hvm3IXAYKgQ08fEg7F7UORTnvXmeARFq3FT0hE60Fr+yJHn6gvYWM+WduiKqRe2j4cXsb1P6V9jrxdy+lUZokLv/hOMmIsGv4dh1WmjgTDc2tFPXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(83380400001)(54906003)(478600001)(7696005)(8936002)(5660300002)(71200400001)(33656002)(52536014)(26005)(6506007)(55016002)(8676002)(66946007)(66556008)(66476007)(4326008)(55236004)(76116006)(316002)(66446008)(186003)(2906002)(6916009)(9686003)(64756008)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ychGCxg+2QAx8AkDPmu9OIpsKNlPSVE3XzjuRqfTXnlI9bE8TWqcltPNj35snRKl+N0Nhn7VD+SWVNY2fTIr91PI+YUJr+8TXAfAJqwFajUHkCXVRJDWz4Q8YieJvdYc1XPd6LKTdVBls+8WVkr7zichqYwwgBfRbI9FS5R5+f9YMhOaHuhQstpNOsmT+KCCy3WQ2NdYhLhctwbKWegKt5px5tezEQ6myfakKAIg4GhBTpjjNWJf2pkbU/9t1YqEMcvc/LZtMtN1nTfa9YVX2EHZJnob6Hf6EJ6MpPEQnDgsyf1Wy8Jv042X5hhwSxPdirRCKqC85GCqxq1Gv2Je8NISK80Jnx5OWxvFhXUWy4O9keisg68Su6qp+pGEkywsnj8nZqwXR8WERfaXTOUPh2lTGdkjNShjqxqgYetWr0wCiHYyV1//B0RF/0C+2s9qG2TNxGXLV2jFQb/FuX2c7gpuuYgGJ5z7b1m+KldDg8Wkxh/4u4BPB+AjB8pA2CiLMbv1dzR5JbfEgpp/l16+LKP8GIQUk4ZnHNJZA2UPSuYloLgy4aF6x8C3HrraLD7IYSyfCmnxs2ADa8qgJ+ZOJTPK7COUF2oeaOSfPeoXA0vMPKCvJ3tCakb3uffl5hdZ6bhWjxILBOvrPZ6QjahGFw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1219c481-f25e-49ed-0b47-08d85eb143e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2020 04:37:51.2047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJDZH/nTPZ/NjC0ITsVIRwOVIRUIGsFsw20gV4w6yc3Zt4A3Qm7M6C8r+K0eOKosOhjqmCbrVN0gWfbCgqKbwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3623
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600749380; bh=nGKvDzDZAbpDqkeBwCLMAepzvUO7H8gd3J8UfVottp8=;
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
        b=nWo6d2mPbnPm4AN3BYD+jXVft1B2LsmbUzkQ6Qy4VBfDRs1jDhjKhbXYNzYHXxtQe
         tHYUjD4panMU7SEOnjk70x1kTexSkT0m/0Aq5ptMgipnxtXLkGiTQoGvqEeNhB7leU
         w6eu1u3WoN1p9Joi0aTUuyz44O6DiVL7pmPC64ZJTOTPmnjblWlPCp8Owj76so6+uy
         cYPq3eEJgb77LbULAt2nUoyfQnLPwXinLAbVtgX87zLqRtm9t2+PQFszLoNRm5sfcM
         6F+VwkcTxNjXskcTzwWG/g+l7KzEMNXhNjatQTKNeQ7wg8dN8chqmCgMeOkimeSuOu
         aTmIxRhHnnSWw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, September 22, 2020 3:32 AM
>=20
> On Fri, 18 Sep 2020 20:09:24 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Friday, September 18, 2020 11:58 PM
> > >
> > > On Fri, 18 Sep 2020 17:47:24 +0000 Parav Pandit wrote:
> > > > > > What do you suggest?
> > > > >
> > > > > Start with real patches, not netdevsim.
> > > >
> > > > Hmm. Shall I split the series below, would that be ok?
> > > >
> > > > First patchset,
> > > > (a) devlink piece to add/delete port
> > > > (b) mlx5 counter part
> > > >
> > > > Second patchset,
> > > > (a) devlink piece to set the state
> > > > (b) mlx5 counter part
> > > >
> > > > Follow on patchset to create/delete sf's netdev on virtbus in mlx5
> > > > + devlink
> > > plumbing.
> > > > Netdevsim after that.
> > >
> > > I'd start from the virtbus part so we can see what's being created.
> >
> > How do you reach there without a user interface?
>=20
> Well.. why do you have a user interface which doesn't cause anything to h=
appen
> (devices won't get created)? You're splitting the submission, it's obviou=
s the
> implementation won't be complete after the first one.
>=20
> My expectation is that your implementation of the devlink commands will j=
ust
> hand them off to FW, so there won't be anything interesting there to revi=
ew.
Correct. Since handing off to firmware and processing event from firmware i=
s creating fairly more patches,
In first series I will just go inline where devlink command would create/re=
move virtbus device on state active/inactive.

This way it should be possible to have minimal working series under 20 patc=
hes.
This way in one patchset, I prefer to cover
(a) devlink plumbing for port add/del, port state
(b) mlx5 eswitch refactor and devlink callback handling
(c) devlink plumbing around
(d) virtbus device and their netdev creation

This also gives complete view from user interface to netdev device creation=
.
Post this series, will improve the internals of mlx5 via events etc which d=
oesn't need multi-vendor, virtbus and devlink involvement.
Will differ netdevsim to later date.

>=20
> Start with the hard / risky parts - I consider the virtbus to be that, si=
nce the
> conversation there includes multiple vendors, use cases and subsystems.
