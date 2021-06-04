Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8442F39BFC5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhFDSjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 14:39:18 -0400
Received: from us-smtp-delivery-115.mimecast.com ([170.10.133.115]:37314 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229769AbhFDSjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 14:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1622831851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9CMpEulTLiHh1PIW8pjAfk+w8gxyOqjZkW1uUL8zU2Q=;
        b=Wnbi+9NdKecVey+BlQOlwDgsI9nyqIPr1dlr5gzFmZOSSwvqOjxnChMnG9qa2HF0U9Ioy3
        Be2XYDKfz/85N3stxfMcyDtUM7ajEKO45L3XMW68JbKQWXyfAMN+kZ/FWF+8XUfz3V0NxW
        UljCeUEDFtKX6h26Oe/7nIh3zFUoRW4=
Received: from NAM10-DM6-obe.outbound.protection.outlook.com
 (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-108-KRp3zEcPMJaECjIaLx0eZw-1; Fri, 04 Jun 2021 14:37:29 -0400
X-MC-Unique: KRp3zEcPMJaECjIaLx0eZw-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by CO1PR19MB5192.namprd19.prod.outlook.com (2603:10b6:303:f8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Fri, 4 Jun
 2021 18:37:26 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 18:37:26 +0000
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
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAlKAA=
Date:   Fri, 4 Jun 2021 18:37:26 +0000
Message-ID: <3910bcb5-fbbd-50ad-50c6-59e60c050a28@maxlinear.com>
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
x-ms-office365-filtering-correlation-id: ae77bd8b-72f4-46c0-032b-08d92787cd32
x-ms-traffictypediagnostic: CO1PR19MB5192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR19MB519259AB0C3D538F1E71C508BD3B9@CO1PR19MB5192.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 27lGFzGAfx7Z1EE2yEPb6VGt44FcFVVNxdCqRzFaxq1iS79XKio5OBNbTHOpYNCEM+EOGhIgZYq2y3oK1umS9YPDjwqr0dLRTw9WZ2i0AVOvyzRCsrVlXRWnb6KIkktQwVIl3LvNyL8Rftu15khUpUO2sFbU9dY5qv4hTgaZfv+G1BPEWVdLghJuJ8DIQidki5lvSeSigjK0Vmv1bmxnaYIzDEjDWpqiRkA2F+XC29LgBMIVyOWBEJYJKL1Fqh4FRc78p6gPdqoyykeOynThsSjqDwwLNO9oWqLAfdQQLI262bGbJt+/euHLZFVAgdrfgtEQUAe0XmsAJaBdLsDo54dCS9X8NQjHMaR4T50dZniGHhTGkSG0JFUERIrXCxFfOG3ik3yOeDMAzTA7PzSm5u00OTAqXxO49G2amVessj+MTPmf88IFOYCP4IvUh4rLGnJERAG+Yx3CqMirmLA1KRNc/zf45d4MBejyyV/r1suBK82zJE4y+cYwQREFgagO8qKbnTxIlA2HViY6EvbOXXfaxsW6kgPvHYoGL7f0Su+rWZO+V7a3LZp9+hOcy4HTTvRYxqFeF4saGmSYnOPxhJWRqZ10hmUcPSlE3uzE06ydOQWUApjra6rvfKQ5tZbKSHKvUSBSwORodAo6Lhzj9T6OJCipSX+I3+ZBBLj2XRt3SnmZ6pbKMwiBWzdkBkkl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(122000001)(86362001)(26005)(38100700002)(316002)(478600001)(110136005)(54906003)(2616005)(2906002)(186003)(53546011)(4326008)(107886003)(31686004)(6506007)(6486002)(66446008)(64756008)(6512007)(66946007)(76116006)(66556008)(91956017)(66476007)(5660300002)(8676002)(31696002)(8936002)(36756003)(71200400001)(45980500001)(43740500002);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?ZHNjxeLA4y80NtBn3dZGdwWpgS+FPqH/6CXlVJFAybgP1EM/mo+uoG5i?=
 =?Windows-1252?Q?eytXeDavn1+3rjFEuvQ6C0P3V5PWNRX3XRZGyAq6LbZPKV7ylmuimiqh?=
 =?Windows-1252?Q?ND2D8fYickp6JPWloknXEygNooy7/To8/JY4Hg5oc326nFG0rG6G/Wv8?=
 =?Windows-1252?Q?fBO8nE0qtYqKn8axBQawr+lBgEKBGUnB6ns4Z06Bc09f+MZZTz+x4OHZ?=
 =?Windows-1252?Q?mrPw0aPZn00cVi5/WNQ8268Ixr1e78FZDh1enu4pKsx6cJj7ZsIelj7o?=
 =?Windows-1252?Q?TzBWT18LL+cuH/x3BJAbevAWa1nKOBIR4Jz8ECWlOoVK87UBn6N90yrr?=
 =?Windows-1252?Q?jiPJoBTAcreMdzuUdDNn7NDZBev48ykkCL+vGivLoBaW/PjuguNrWHNe?=
 =?Windows-1252?Q?KMgqdqxSh6dq/R/3369x7agNHw7PffdWuxXK8DepRVcftR2KS5ZPjzhg?=
 =?Windows-1252?Q?3YOpRFLnlIA2tHgQEog/p8QDwG8yJ+80v/UdC8wXrCHhRhBumTkKSLoS?=
 =?Windows-1252?Q?2NVi5zHTPO+WTRg+nFXHoR0yb2JgmUWdgCMFMLmjKn4C4sYKcU25NHhO?=
 =?Windows-1252?Q?5J16NS8MYNqEZtjX654qaj0q5fVtjy+Gc3d/4JVESSZugkgvyeHAhqj0?=
 =?Windows-1252?Q?Vx7QbavlR89x2A98SDTbIzukuydSAZJf0qF1X5RPwDJDTCjOhVAaEH60?=
 =?Windows-1252?Q?HK5kJH01oqotgHe4Fms3jEWi0A+hZnbI48L4TU5PXtUnxTt6hbcBQ11C?=
 =?Windows-1252?Q?ZHK8oYM/B0odtqcBhUI6D29Of+OYh/rhVQVTBggNphifYgq1aVFZqTRD?=
 =?Windows-1252?Q?i+tkABvwxwaIo0ZfUW0SdTvosooHU5qoasY7CREglfg605xF8aoBfb8n?=
 =?Windows-1252?Q?Tlx+ikIFJPqxuQkQDHkvUi4/h0mfAJFCsyC1lo+8lWYZEkvYmmnrdi2g?=
 =?Windows-1252?Q?+XOPVZggH7HNb0ZH6P2/7ufWIKTLsx6it23/byCQqW1nXaUiXLBNbqk2?=
 =?Windows-1252?Q?4WczcBeV7WLZyup5hIZI1yMEVpoydOg2/aRHe1Qwwxx4vvAmj5Bkx3J4?=
 =?Windows-1252?Q?9Y2epd/fstE7Ypl7nJGFb7zmEQXQivhUmLUBBTG+jGRO3vYYUyzqGNdD?=
 =?Windows-1252?Q?6mYrqWEiQgfYbCB9ss86Xl0qaT49SqQJ7UnjoHuJy++gpKbpMlhSoBF0?=
 =?Windows-1252?Q?eg5VTJmodQXqjcf5zzCOc0jr/4J3aJ4oskvH3jBsxd28urFUFnuTCEcp?=
 =?Windows-1252?Q?aLsLmxhXtOk19MNgBsgn0SZFQiCoHEK4hN9g5R6DJyI9Pwk8LZhImbbc?=
 =?Windows-1252?Q?j7XC+rCFjG0jkE03+sSpuEtejKK5JJSCaGsTKOA4UGCbqKOKVqgqIKAg?=
 =?Windows-1252?Q?J1yC9gcYNF2xlr40COJ3aPGnHegIjTb9zlNcEhbsyLSS6ZHuLoJ0xBS6?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae77bd8b-72f4-46c0-032b-08d92787cd32
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2021 18:37:26.4571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6muAOu5GtNJ6wEOu0ght+mn1WV1wR52mYjzdaKON5lf3vHoVhWgePzF9Kq0ncNDbkSe6wMmAPYceOrL4Q4L1ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR19MB5192
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-ID: <8DDB737AEA768043A9709159D3E3B150@namprd19.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/6/2021 12:24 am, Florian Fainelli wrote:
>
> > diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> > index 288bf405ebdb..d02098774d80 100644
> > --- a/drivers/net/phy/Kconfig
> > +++ b/drivers/net/phy/Kconfig
> > @@ -207,6 +207,12 @@ config MARVELL_88X2222_PHY
> > Support for the Marvell 88X2222 Dual-port Multi-speed Ethernet
> > Transceiver.
> >
> > +config MXL_GPHY
> > + tristate "Maxlinear PHYs"
> > + help
> > + Support for the Maxlinear GPY115, GPY211, GPY212, GPY215,
> > + GPY241, GPY245 PHYs.
> > +
> > config MICREL_PHY
> > tristate "Micrel PHYs"
> > help
> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index bcda7ed2455d..1055fb73ac17 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -70,6 +70,7 @@ obj-$(CONFIG_MICREL_PHY) +=3D micrel.o
> > obj-$(CONFIG_MICROCHIP_PHY) +=3D microchip.o
> > obj-$(CONFIG_MICROCHIP_T1_PHY) +=3D microchip_t1.o
> > obj-$(CONFIG_MICROSEMI_PHY) +=3D mscc/
> > +obj-$(CONFIG_MXL_GPHY) +=3D mxl-gpy.o
>
> Could you spell it out completely: CONFIG_MAXLINEAR_GPHY for consistency
> with the other vendor's and also to have some proper namespacing in case
> we see a non-Ethernet PHY being submitted for a Maxlinear product in the
> future?

I will fix in v4 patch.

Thank you.

