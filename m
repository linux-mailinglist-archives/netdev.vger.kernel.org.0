Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8F839BF87
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFDS0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:26:43 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:37842 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhFDS0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622831095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HkBDQPxmsCg6FQBruP9/WKuC7iJbnlxUv7HSYrJffqY=;
        b=AkdK1AWxvjoG5w+fl3aGEIYnIVHRaTPABtTBaeuLfZ5qqHDYjOVYNLnHMS75u32wA02vf7
        YvJTwiv4Ml1t9UuUmgTp9dtiJcZffrb2Qn+q6p7hJrwVURNVJCVsm3jbUFdZSwRHIfvRbO
        duKOi4J1tMYDwlXJsFxJM05CejOF0Ko=
Received: from NAM11-CO1-obe.outbound.protection.outlook.com
 (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-sKH56QrXPUihfrWVC6lZQQ-1; Fri, 04 Jun 2021 14:24:53 -0400
X-MC-Unique: sKH56QrXPUihfrWVC6lZQQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB4888.namprd19.prod.outlook.com (2603:10b6:303:f7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Fri, 4 Jun
 2021 18:24:48 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 18:24:47 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoAA=
Date:   Fri, 4 Jun 2021 18:24:47 +0000
Message-ID: <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
In-Reply-To: <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [27.104.184.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdd4865d-0bdc-4eea-e687-08d9278608ce
x-ms-traffictypediagnostic: CO1PR19MB4888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB4888ECBD4673CDC247699BD7BD3B9@CO1PR19MB4888.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: SpY2DCFnRUW8ebuis0BoarB9+MzfYMtHFrXMpfGHwH2UxQsqcoMSPzKqexsK66wt63LciRF06z985VsofiJyRPaMGQby+fUHRMCB2g98NZ06l9aCrlaBjiSE8Y4CdYyOBKxosVuDdyZnvA71uEO1/ZFD7x/ukR90VaELaiJGqzbNu8kZL+ETVemVUCEITewZ8j/qn+JadDuOHlqfOZhW6PKF+YRGQBjYvRtEfVpasrLjP5hXlTMo7nPuqgR82MjX9hU+G2S0ZTZrWKnSZpOLXLbH8NluvsaEsQzfNydfjv4NdslTKRtrL2Bu7vweF1yqaMhJJQJN5LDOGcF7y9KA5ppCEK/LmVcdKqqMLOgJVFacA8UFfM4kJPrzhTpgomJQFQxnPsuD98tyUX8y4Dw0X+j2v7fZK+IQUqVqpRUpzBByesE0+U6bn7lgMYr38FcGco5xXcR3SWLgLe+hj8d0Fit8L/kjuq81WdQdXPwheh0lrV2x27KyORbrW+EEj/bhrwt+yD3qA1k8nFZimQK66TDWw1kyna+L8FNTy3FXx4/dhV7L38IkBUnuU7xzCAlfZZ4u/AnDgNHIk5qOhVt0BWjO6SzbZB/HJu7u3gfslhrAaMQA+aJNSCSlM7dp3JXxf+KAnwzKC71RsCRb7qhZrDnxPaUVoR0gyTi3h3oKG58WcKrwsYlYf/78RJVXLWcv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39840400004)(8676002)(66556008)(66446008)(64756008)(53546011)(6506007)(66476007)(76116006)(91956017)(83380400001)(54906003)(478600001)(66946007)(8936002)(4326008)(316002)(107886003)(6512007)(110136005)(6486002)(2906002)(5660300002)(71200400001)(26005)(186003)(122000001)(38100700002)(31696002)(2616005)(86362001)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?KRFx9JjdYoLBXOrBu2jK3Orz0o8DAyB4NJlrWiqtYiMHLGw1lIYdT6A8?=
 =?Windows-1252?Q?zpQCVOMMwjz66CV6TBAGJojsEIdN508apRh3yc8COOzcZ9HRnnUMNKkC?=
 =?Windows-1252?Q?M8k3PmI3N4Uzl8nySE1wppB0nJrRqauNlxAvPXpDsjpln599Fo9TjXF6?=
 =?Windows-1252?Q?boukdEFRb6ed15KrqlRkXXqC5RphHhik+UtGLfTUHrn3k5MJWVWMk4ZF?=
 =?Windows-1252?Q?Zr/N3LWrxDh8LIym1BE8OWR5fBLxvI21UxDlhp0LNLHplNS9sKLJ5xl+?=
 =?Windows-1252?Q?ROVGuftjLXJlaiE6xCSt4uHXtNDbjc7qUsu9RGmfG0NXe6fBjWxrYGhN?=
 =?Windows-1252?Q?zg85+y8NgFZ7IYZfjfoeuw+bNF1kccZgFxki3jo6xC/SEzoDSOZfGrQ1?=
 =?Windows-1252?Q?0DrpE984aVwLvCkTCmquOWNoMyw2Eao4Tbq5qIntC6qGjsGILXXNQlod?=
 =?Windows-1252?Q?0e2S6ePVdLya528D7eXw+9llzVhldAZmESWtMaX3JZ8fjnbPouwe+it8?=
 =?Windows-1252?Q?9xBUz0aEPxv7RqcI58zrr3aRwpmlM/iYX/bWkU7wgp6KavrISjgPnDY1?=
 =?Windows-1252?Q?+XPD1nB1vmFIVDdbhFHh7n7JoeFQuumMPFa2Y6lEaYt4LRPjovR34Q/x?=
 =?Windows-1252?Q?KXpO7quOpMPstghYSYSraa3U5cvr0YOvz4bIl5M/0RqghbCTGogMUVpi?=
 =?Windows-1252?Q?EHIMqGq57lqNiKbmGnI7GF8TDHRj5oj4g7MWeZxEJKGDE2V8+iDQQjRB?=
 =?Windows-1252?Q?JVXow7Xpqb08iK0HuBbDNS2sjo8sSjPTERLdLoNlbFIP//sTh6YxKgn4?=
 =?Windows-1252?Q?8h8t6mcSyEescf5rHMCIwFZyrgJ56452bjLEFvqBmQ86Ms4CnWjkzcMJ?=
 =?Windows-1252?Q?yA///EBxblrZQ90na7s3QNwI7tyymRJChL32wdRb+M4jmuKM9PPBn2ze?=
 =?Windows-1252?Q?4+b5m9YPsmZRLLRH9TUbU7UubpM1TVnIy8Yq/ib+jTjmCVIGH+yf6ZOT?=
 =?Windows-1252?Q?7wm9s8rvMBiIcbozpDd2dkha23CAZVy3wCVJRgWRw1E5GRCW3YF6l4UW?=
 =?Windows-1252?Q?k6wBw9OfTSAkTglf6718BwPXKz/iIsi9R0L5G6CPdY1fjfQUlFIUal8x?=
 =?Windows-1252?Q?IqJhGqIR4fS/LW9DtvXQk3UKN1fyv/IHEx5sR28tgTXzNuK9AnTG3NXF?=
 =?Windows-1252?Q?MBrqPgraBuLSSEZNCgoJsLRlAjAJ9cc6/tqtg22DV+BEnWZOJWroXsoL?=
 =?Windows-1252?Q?gSKsAqBntMpz841JbJggQyQOG6Y46cujoDVHA4dOTjGuvIPfsOo2jSv/?=
 =?Windows-1252?Q?2J9qV0FD4Jrcv2DdzDIqJgpCBBhJ1HdnJcBF80u0YdFf/RqUiJzGeSF3?=
 =?Windows-1252?Q?guUHWICCu1bgeZHQmc/Vy1P7fpw1F8N0W5HAkSxKQg9s3ptAd+mDhK6k?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdd4865d-0bdc-4eea-e687-08d9278608ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 18:24:47.2596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PSJe+eLMaMrMXsiwqyUeoYcP5Un+8tr056nyK01KlqCyfhUr6t3VAmkXcQEw6ied71T5pSkzaLH7kYEVZOheJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB4888
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-ID: <BE231D462ED27A4B8E29DF41FCC05BB9@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/2021 12:24 am, Florian Fainelli wrote:
>
> > +/* PHY ID */
> > +#define PHY_ID_GPY 0x67C9DC00
> > +#define PHY_ID_MASK GENMASK(31, 4)
>
> Consider initializing your phy_driver with PHY_ID_MATCH_MODEL() which
> would take care of populating the mask accordingly.
>
Thanks, I will update.
> > +
> > +static int gpy_read_abilities(struct phy_device *phydev)
> > +{
> > + int ret;
> > +
> > + ret =3D genphy_read_abilities(phydev);
> > + if (ret < 0)
> > + return ret;
> > +
> > + /* Detect 2.5G/5G support. */
> > + ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_STAT2);
> > + if (ret < 0)
> > + return ret;
> > + if (!(ret & MDIO_PMA_STAT2_EXTABLE))
> > + return 0;
> > +
> > + ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_EXTABLE);
> > + if (ret < 0)
> > + return ret;
> > + if (!(ret & MDIO_PMA_EXTABLE_NBT))
> > + return 0;
> > +
> > + ret =3D phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE);
> > + if (ret < 0)
> > + return ret;
> > +
> > + linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
> > + phydev->supported,
> > + ret & MDIO_PMA_NG_EXTABLE_2_5GBT);
> > +
> > + linkmode_mod_bit(ETHTOOL_LINK_MODE_5000baseT_Full_BIT,
> > + phydev->supported,
> > + ret & MDIO_PMA_NG_EXTABLE_5GBT);
>
> This does not access vendor specific registers, should not this be part
> of the standard genphy_read_abilities() or moved to a helper?
>
genphy_read_abilities does not cover 2.5G.

genphy_c45_pma_read_abilities checks C45 ids and this check fail if=20
is_c45 is not set.

Mix of C22 and C45 is handled here, as our device support C22 with=20
extension of C45.

> > +
> > + return 0;
> > +}
> > +
> > +static int gpy_config_init(struct phy_device *phydev)
> > +{
> > + int ret;
> > +
> > + /* Mask all interrupts */
> > + ret =3D phy_write(phydev, PHY_IMASK, 0);
> > + if (ret)
> > + return ret;
> > +
> > + /* Clear all pending interrupts */
> > + ret =3D phy_read(phydev, PHY_ISTAT);
> > + return ret < 0 ? ret : 0;
>
> You can certainly simplify this to:
>
> return phy_read(phydev, PHY_ISTAT);
>
I'm thinking to clearly differentiate negative, 0, and positive.

I had experience that a positive value is treated as error sometimes.


> [snip]
>
> > +
> > +MODULE_DESCRIPTION("Maxlinear Ethernet GPY Driver");
> > +MODULE_AUTHOR("Maxlinear Corporation");
>
> The author is not usually a company but an individual working on behalf
> of that company.
> --=20
> Florian

Ok, I will update.

