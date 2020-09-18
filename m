Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE712705FA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgIRUJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:09:26 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15146 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:09:26 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6513e90000>; Fri, 18 Sep 2020 13:09:13 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 20:09:25 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 20:09:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5wmyC8s8ih9CYIqy6gDPTVeNj3RfJFodMLLX/cZkOUTUddHDeEQS2jptmlYdQ+a+YF7dZj53WOXynNFtJo68SCsYlcz8zgUO2cifHSbdjUOLqErbiBIGuqQtiaDUvShwbXwtKlN9E2WVDJOWq0EbHvP1FdSfBbDrlljKxtzWzPWbI12EvU/KOsbeEJPWiuvwRFuQKsOV110GowSvRfvrAOfyQI2gPLTAcpLrLmwCDrjXtasB1kRGiCFxfNQw7td1djmxQDQkRLaKGrSd2WBe44PREy0wRqkNnvYTTCf5Dd4vntntbvNYQbSd7XOGieHK5av1ALEHmqyZLyI2se+CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqgG4vTA03Uge2Q0JwU50ejXnLS87IlXz8llbGbHXDw=;
 b=YnOxh1hewf7S0NVdpvJL//V6CpYlvInrCN6u0uKhG4s250X4fpVfVIZcobCtcNpm5A0SnusWuW8L60kNnIQE9oErqtk8JaNQ5HCkoxfOElbOdWGlN0HEtWLNFLOxkjR+dNk8qJVmw3R0zorZevybKXhE4Qj1HbQzr9xdK5djKC/rlujUIFcbRmnY7WKrup9rf4Sh2c3I8iKCXm01HMmirzLDo65NBH7lz0wMBLXBfb1Is3L6leR7iqyfRVLSjb/Rw6xWwfRJDKpKQecJOqTwze3xvI8hBJY4/QKDxtS1ETks7HOiGYy1ofms4I8zjlOSjnZ1coDbNK5XiVZqzTBKCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4228.namprd12.prod.outlook.com (2603:10b6:a03:20b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 20:09:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.027; Fri, 18 Sep 2020
 20:09:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Topic: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Index: AQHWjRbejAHFYrcRiUC40XmVyPqlcqlune4AgAABw7CAAArcgIAAAWQggAAM1YCAABv/wA==
Date:   Fri, 18 Sep 2020 20:09:24 +0000
Message-ID: <BY5PR12MB4322C97E73753786B179ACE3DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200918112817.410ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918112817.410ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee9619dc-9a4e-4837-e69c-08d85c0ebd01
x-ms-traffictypediagnostic: BY5PR12MB4228:
x-microsoft-antispam-prvs: <BY5PR12MB4228C95FD6114C2193429453DC3F0@BY5PR12MB4228.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VhH+9h5CdyELbNpebBU2g53qe/MOHcnea7fkSd3vlIAPVzgrmY/q+g4FlVhbXsvEAIoMlO+EpI1ih+RA6lXPl0AjzArWEGDqYQsabeL4VMf2RQawU8lTYM/bOYPUEiiTclzIjemPbTpiW+uvVr968mT2il3TbCo3eAft4hNie3uAiowTu3BO9+bT6dAxNbFQG7oM9KgHgo5COkwVOYDydNtPgYc1+wD/S63o+hnP6V9vt5dsT3tlNlhEBLSNc0y5VnTd7SvnpCicfuGWhl889vBknpQ/8k40eZ330yL4kwpeNeucCSiA6V2+kjySJSJQl5/hXvhLMP5747z9nPgZ22VCqOsPwVyCVWq0ErhAnG5PHgKWN6veaphr+m1//okd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(4744005)(5660300002)(66946007)(86362001)(55016002)(52536014)(76116006)(54906003)(7696005)(71200400001)(8676002)(4326008)(66556008)(66446008)(66476007)(64756008)(478600001)(6916009)(316002)(9686003)(6506007)(55236004)(8936002)(26005)(2906002)(186003)(33656002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: H+cWLWY7+9X69Nd8bTqO+tXULS0w0UUoLNemJpdqPqidYlwdSe/d6/XI/l95KtiLiDTFHXNHakmmVr+8DOOAWwyLkvhwgDxaPH/jLmnaim9eb2UbXnudh5Z9vLFyVxwo//J7rrY+M6x2epEHGL6vBx5MV9sTO0uq3BdHpO/rte3PZpjyBtbJuGXaALvIHqU/YqlsNFcXuBczqdDosIkMF+w6zElgdy8T6XU+lXvPfyXbxyEz3/lBRE4myRdCQRDN8xgpgN7TqPYhJWBcbwr2CQWN4+K8rTcod2LYiTiqcivJOQyAssKVb0Vix2V/03W0J1By6MmCXNH9a/ejGLWJX35EouZA/5WaHXh5xqWkDVTTQOGSG/JUCZLz75+M6SHdM8y2EKnustAlyO8f6KqgyrcKEfvXaObrEHhVJh7U3adNB/KqzNc1uV8C8GKvqdA8Nyzc2LZ3ocKESW5DvKJ8jAhKx5F/5ZBFtxfSii4Amojvon4gY5gSpC2sHLcaWYFZWdBr5pgnUt2skakhDd73YiBNr5sqUSSC7Z/OgkVkouqAyBNbM3GvxNozg6t+/Z3cdEPZ9rIkrBKFtTE9RZi4nhEBozCDL5fS1gJffA7sz2hDQ/BqLgZhY7X7toalyVN+SWcgoIClBs/ZwRre9RuIFA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9619dc-9a4e-4837-e69c-08d85c0ebd01
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 20:09:24.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XUrzSrdgPb7s5jK9hir8BmFHh1+2qXuPPzCfkzRcJ6qvau5aKTe8ipZIJq07EIG4M+8kcjKalPKkk2qzlOJ2aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4228
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600459753; bh=CqgG4vTA03Uge2Q0JwU50ejXnLS87IlXz8llbGbHXDw=;
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
        b=kooR8aN+6I7HjA0xidPmAx/A75OujzWwy5+My2Ye7ZF8OvxPhsx6akSVbmHT661JQ
         nTdb2he15SXuFtkvVl4GjjAvMLfC8uoF8V/9mvxwBLYs3S22FkrZY/Ow7KKgcD6tH6
         hJObQg+Nx4PIzqRorrc0sWfR4LwG1/qQLuQ3KzentZkHlgU6oCMjilPYHtF5s+RPs/
         dSYQ33Y+NlZL8CB3jufKG9/xC8U0itW+Z22l/pKeigCrKaWBWu4r3ijMc/tCW2azeA
         01o/hdv5AvKfrp1P9Uyyr/sjohtN8XOAtwclZHpqJc0o+CHzydcRvGWOuaP9aG0nq9
         UxJgJexGcJ+NQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 18, 2020 11:58 PM
>=20
> On Fri, 18 Sep 2020 17:47:24 +0000 Parav Pandit wrote:
> > > > What do you suggest?
> > >
> > > Start with real patches, not netdevsim.
> >
> > Hmm. Shall I split the series below, would that be ok?
> >
> > First patchset,
> > (a) devlink piece to add/delete port
> > (b) mlx5 counter part
> >
> > Second patchset,
> > (a) devlink piece to set the state
> > (b) mlx5 counter part
> >
> > Follow on patchset to create/delete sf's netdev on virtbus in mlx5 + de=
vlink
> plumbing.
> > Netdevsim after that.
>=20
> I'd start from the virtbus part so we can see what's being created.

How do you reach there without a user interface?
