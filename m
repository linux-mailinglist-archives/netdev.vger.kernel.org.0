Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D34399F0B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhFCKhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:37:54 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:37866 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229641AbhFCKhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622716569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkQ0b+aO1AC5RLgNLwBgXkJFnANTW05f0ULD7tN127E=;
        b=nAWqRjBCLSPqK4L8RKHUs0NlQf1e21mqMm+Uydu7XtEvkMjIxLKSNPRRWgEquj6vNS8OSr
        sTycChxI/qEYvDK2m5w/orC35lJ+AIdujKvYdwJRAAB4AEU+ndE1QT4BPGEng2cHYFDUen
        NfmipTetVK+TioEPtVNZpLIS8/VCyz0=
Received: from NAM11-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-hSfT-NDnN26lWYG00ZKwkA-1; Thu, 03 Jun 2021 06:36:07 -0400
X-MC-Unique: hSfT-NDnN26lWYG00ZKwkA-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MW2PR1901MB2153.namprd19.prod.outlook.com (2603:10b6:302:f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 3 Jun
 2021 10:36:04 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 10:36:04 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWEr5aRzQQmYLZUuI1qUONcx6wKsCAhAAgAAV2oA=
Date:   Thu, 3 Jun 2021 10:36:04 +0000
Message-ID: <2fd2afea-ab43-14bf-f787-dc159a9cae50@maxlinear.com>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
In-Reply-To: <20210603091750.GQ30436@shell.armlinux.org.uk>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
x-originating-ip: [27.104.174.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a91df864-451d-426f-c119-08d9267b639e
x-ms-traffictypediagnostic: MW2PR1901MB2153:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1901MB21537E88A11A62930D2B5A87BD3C9@MW2PR1901MB2153.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wRS2l6h0FSNLIi/xAXRasQiLVEMfC1pyASB+3U3sGIwYiw5sqa8fWqlaEU6wPI9iv45lm2OBEH4E8tFm0p9gJWNVvQbMXRi8uTtAlJgcXFfX/ljSKP3EX9C7Qlu1Nbtzj0irwU7mU+2PKVjWZEEVUKdUZgnuHeDYhiAmuxvJQlGpY7+23ayJRRywoQ4pyeM1aD82Zj7tXlmHRsoZ4mXqmC1+YAKdOek8tFUkxcndXJHR6RsuCOQxZhvADkcvb1lQw2XottuHPGpFtDkLj86ls8x3OM/gWdFBLY7oFl6M047nq05WSicYnytEihAsPJ3U1oE/N/2GPtY7cWKjwulSQTysJ3kUOCS/MCkEw5s/kBhip1AxMdkOv3lW0pluGVHpmC9Zijfh3wrchmqGwYY1Lb0BOWZgg/7rnCp0UxjZJYpxAcW67P4/e65QvQp8DPkPNt9mpK25KJEgCGYqzlg1j0NDoZOYk2eUhf3sMpPP27lLI3LQRcx+j1WTGukv0v/bDoPZhu73WMbBK2LWJ4GjP0Piv4ILTpGNfFuLXBbVX5qTSDwGiVvHUqXxLsIAzIo9lAmZTmg0xMYCDLyv2pnyWeKZazh+ng9DkxZHR1oX7ZmAwqkpewMgU7DBDqvIR/FaR8fAIexTkW32nhBfFb3NrshWDEqzpXnl5sul+JgRLLfIn3ZUMkInmczJJwV9gBcn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39850400004)(396003)(376002)(86362001)(26005)(31686004)(316002)(2906002)(6506007)(38100700002)(186003)(71200400001)(6486002)(4326008)(478600001)(66946007)(66446008)(64756008)(66556008)(66476007)(5660300002)(6916009)(91956017)(8676002)(76116006)(36756003)(4744005)(54906003)(2616005)(31696002)(6512007)(107886003)(8936002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?g4pI0XXyLgnvdVzt6c2t0lZ6GSMSZVrO/G6h/lhC1CrhPdk0SQdki9T5?=
 =?Windows-1252?Q?54Cq1L5JKTlClOiQ25heia/q8zk2MpNTr2m3Earrv1es/c3es05nVrY5?=
 =?Windows-1252?Q?rJQe/bAeVQPyGJLwte4LA8SVojP1X2jHcYgZIjgQcZGFtKK6cKp7NNdh?=
 =?Windows-1252?Q?9TtaEP5DCq+Qg09nt1jalclYz+ZR0kcJXcm1acXlJifetF21bbeCekZj?=
 =?Windows-1252?Q?w7iOaClfyXODvF3xgFazTehPvdqeemSBJAlj/FXXZLevTV1ZTV6PGAkQ?=
 =?Windows-1252?Q?u/9wqSPqW1l7NrweL480sKfeJltYmc+9LVTKK4R2rXknbl6F0oiT9aZC?=
 =?Windows-1252?Q?LVrOFsN6Cs/NnJVhf0pqwVp2LalXAKEF/S2fa6VKRSBrsz7l3XAoHUrJ?=
 =?Windows-1252?Q?RB/xZcuQ8njeg0QvQPI3DdzXU3Dfm0knV7nyJDWjlLyG0Ysfst0Zpd13?=
 =?Windows-1252?Q?X3blR6P8VNBn0FEyCmLtj1dDtiK2maSIHdG6uvzb6Wf/RmxWlxJ6lhaD?=
 =?Windows-1252?Q?Sg9mVbij6IFDt2HiPTCRWiKaX4IwqrLCuUfHEGWD/k4kkKaITpexG/cm?=
 =?Windows-1252?Q?BWbYXPLIQ9/tblHHYk5Z5fIUYQ4I5fdrIHH0q9Cs4Kq/0HTD5tYu3Af2?=
 =?Windows-1252?Q?PHyMBt4/+nYynjVL0IvGNc38Dvc1c768RmLFlgy/dgLQ1oiVgLGWAc1e?=
 =?Windows-1252?Q?D07U5ymEnwYTCA1Kg7vqCi8EasPOTObf1x7bTFEAy3huKo3RLskSwRqs?=
 =?Windows-1252?Q?u07Rx606+WjWFlwqoYHPH+1L1XJYnO4ZqbeSams8aeLyxOJlpj5S2YQ0?=
 =?Windows-1252?Q?s6XA5MkmoV4ThedwteDwxcIsCTW/XHT8/9Q6Feexo9nTuR/+MKsj6qYP?=
 =?Windows-1252?Q?fU24iw2yM1RMKGk+ek1I9v0MAJhusdrOg2UzCwub+nHeLHA8aO5Y/Z43?=
 =?Windows-1252?Q?cfsqmydoHoyq8VpUEfQ9EvczuiFqkTwxUq9RHP/TSvsnISuoRh0QUyuj?=
 =?Windows-1252?Q?0U3aGoh68bLSdWSzcIMRANObeLu9JtnaGQSg4BC1DxOsLO5d8WnBCZdf?=
 =?Windows-1252?Q?MERKkwXf9sdlmRzm5HW0JjTk1YiWTl9nIp9FAaE+3qMdkXlNKS7HQMPD?=
 =?Windows-1252?Q?seWrfl+lU5feaGZK22a6c3n9/a044OTkrfL1ZNKq3kpe5/Y+LCM3SYmT?=
 =?Windows-1252?Q?9SkDm4r+OZCfJjHOI2SINRDzM2efwPkZRxKiunkB7SUySwUkN1Pf3UUr?=
 =?Windows-1252?Q?0uXsAi2tngO/rwN0RxSjlhItwOiOo+I/f1xbahl/JUsCmW6HbhBF+m1z?=
 =?Windows-1252?Q?sQKALjnZYl09FtLUiFwrsq8oJNjmXUmqX86Ih5VB39KqoyhZMMYMITQI?=
 =?Windows-1252?Q?sRj0YkE8aoTdJkbKFq1bgriC88148y2bmVswX3ELAw5xd6ZlMjPNxHLL?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a91df864-451d-426f-c119-08d9267b639e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 10:36:04.2178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rZLrczDxkGCAk+oMeO3FSQrl5/Wqy8+/1nWLK4t4hfQ8bIqSyR8Oeq5hnu8bg9MYxkojOI3v801qpqFKjYPtPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1901MB2153
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-ID: <A2A605977C24444DB4DDA7C331B171B9@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> > +static int gpy_config_aneg(struct phy_device *phydev)
> > +{
> > + bool changed =3D false;
> > + u32 adv;
> > + int ret;
> > +
> > + if (phydev->autoneg =3D=3D AUTONEG_DISABLE) {
> > + return phydev->duplex !=3D DUPLEX_FULL
> > + ? genphy_setup_forced(phydev)
> > + : genphy_c45_pma_setup_forced(phydev);
>
> I think this needs a comment to describe what is going on here to
> explain why the duplex setting influences whether we program the PHY
> via C22 or C45.
>
Thank you for review.

We support half/full duplex for 10/100/1000 and full duplex only for 2500.

genphy_c45_pma_setup_forced supports full duplex only.

So in half duplex, I use genphy_setup_forced.

Is there recommended way to handle this situation?

Or I should keep this code and put a comment.

