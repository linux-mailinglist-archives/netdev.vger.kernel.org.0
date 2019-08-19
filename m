Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F127591D24
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 08:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbfHSGcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 02:32:35 -0400
Received: from mail-eopbgr70084.outbound.protection.outlook.com ([40.107.7.84]:1978
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725308AbfHSGcf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 02:32:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RYxJQEOyJ6HSILXAwx9Ib7YjA/TK6w30A1BGrE//LyWH7Qa7A4j8Z11a7gqzYwWsOyVYVxwPOvw7ZOWAHb/D3orITvo7wsf0nuzlNrmyMxzjdXvDVr9X59C5XEmKz8eNEK79tBWEkECBLTVC0pAZbfl9852GUqqFeFdVGxZmYpN/9OzuAloR8C62GrlcdPYb5vg2ZoiAydnqfm2nUDUWEGyZM8/VqMoB78sR3Bsz5TijtID3GX2kqgTIzEf2xyRqSpKK/29u5XUS/OXlKd/DVc591TbCTFMGc2uBxwuPQ6/H95MtpK5niNaURSoWj2MVhfGjzVzqfINUObkQ1E/Slw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWFLIuuGkf13ePRQ4yezHdXeetUjmt82N08eDvZHSfk=;
 b=IkPgE0VSn9in/EHQrwqdrgROeyRzGTLoSl83r2NheTYcZF/JwwVN5jP3Rb/nQH5OCb2+mZaHrAu9nSkA2XaIF5gnE2xfJnQ63iA8pdxDpAdw2f+nKK55evKUIa1ALW/JOx+9CYGcxl4hux0g1cgLTSIGhPrrC2t7VMNF8af3iKBQe+lqlAMMLt5hZrtcJih2JgsfQqQYT14v8Jq/6JYFJp7beylLba67hbG0XR6MRxxRdzoTzJ+1knUBqaTh4/4GZ8daj4eIbpJGd8rGJQK5UjBfW2vsPqXj3J6nvuuBwAZoFSC9s2fMdVGWta26gqShtziIoyHpDargMnnPySsepA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWFLIuuGkf13ePRQ4yezHdXeetUjmt82N08eDvZHSfk=;
 b=QKQr8Lzh+5CZmZOt1Btv+Ex3queoXOmKlaow7SprmwFu2U6XG+s0Dnh37tQPR26CNUErYE2XOWr5jFqxFa0G95uN8bQ/eLJM5Y4nULahklXOI1s+7R2ZP8sK9lh2MmJB+oDDnXbjQCjHP8NlzJ0uf3UMlFqh3EXU/FakkB7IbMQ=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3607.eurprd04.prod.outlook.com (52.133.25.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 06:32:31 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 06:32:31 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVVlfh9z1APBIvVEOf3Cz5T4N+yg==
Date:   Mon, 19 Aug 2019 06:32:31 +0000
Message-ID: <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 811b5873-2c79-43e0-202f-08d7246f03ac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3607;
x-ms-traffictypediagnostic: AM6PR0402MB3607:
x-microsoft-antispam-prvs: <AM6PR0402MB3607F2DC38403BD47A79E00D86A80@AM6PR0402MB3607.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(110136005)(33656002)(478600001)(9686003)(102836004)(3846002)(6116002)(54906003)(2501003)(64756008)(76116006)(5660300002)(66946007)(4326008)(52536014)(66556008)(66066001)(91956017)(66476007)(66446008)(25786009)(6246003)(316002)(53936002)(2906002)(14454004)(71190400001)(446003)(476003)(305945005)(99286004)(486006)(76176011)(8676002)(229853002)(8936002)(81156014)(81166006)(256004)(74316002)(44832011)(7696005)(26005)(7736002)(55016002)(186003)(6506007)(86362001)(53546011)(6436002)(55236004)(71200400001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3607;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: O796B9BTL/asU+mklje9iAcAEQ34bwZMhAhnY0ersl1SqnWPqZ72xt8PQOfAHUZfgA/Z7bkY8IdBJQo64NnJSNsJWCOE928CbQk12xz0Sa/E2AWgyQHxHmKaIlTEEQQjtD8Pd1eO2OH4x49/PFGo7OXOmIz/U+Y0g6f4KXiKtsUK3TpmiTU5l+K5Im5nhwgfByhgC0TaVth1DIr2YkxpZiIpkybOTcixk83/3wHEMCL937vOaIt+uwn08AQe2lZXvLtiG71rk+nDo3XHLSpX2Eo8rS0cayu6zq+YUlfCsnxyuA6QL51otOfnIagaz30w1B3wVaCHPVoJP33QApBlwBZ3r6s1OcHJ6wNKkB8DEhGTL6F84tBX0K0WXCtsYDHGijbBeVAseC7EqtVT/kE0uZHNXoRseuUvCfBIKi/Ltus=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 811b5873-2c79-43e0-202f-08d7246f03ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 06:32:31.7486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /Nnt0bHjLw7ayfcF52yeHImE1NPFdKWgS20i4b3TEFAecYIfAlcCyDqx7NJj8weQDmPwecEkZjwRUHPLkq4IGF8cCyess7cf7gQLo8BrFOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3607
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.08.2019 22:59, Heiner Kallweit wrote:=0A=
> On 15.08.2019 17:32, Christian Herber wrote:=0A=
>> This patch adds basic support for BASE-T1 PHYs in the framework.=0A=
>> BASE-T1 PHYs main area of application are automotive and industrial.=0A=
>> BASE-T1 is standardized in IEEE 802.3, namely=0A=
>> - IEEE 802.3bw: 100BASE-T1=0A=
>> - IEEE 802.3bp 1000BASE-T1=0A=
>> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S=0A=
>>=0A=
>> There are no products which contain BASE-T1 and consumer type PHYs like=
=0A=
>> 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE=
-T1=0A=
>> PHYs with auto-negotiation.=0A=
> =0A=
> Is this meant in a way that *currently* there are no PHY's combining Base=
-T1=0A=
> with normal Base-T modes? Or are there reasons why this isn't possible in=
=0A=
> general? I'm asking because we have PHY's combining copper and fiber, and=
 e.g.=0A=
> the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.=0A=
> =0A=
>>=0A=
>> The intention of this patch is to make use of the existing Clause 45 fun=
ctions.=0A=
>> BASE-T1 adds some additional registers e.g. for aneg control, which foll=
ow a=0A=
>> similiar register layout as the existing devices. The bits which are use=
d in=0A=
>> BASE-T1 specific registers are the same as in basic registers, thus the=
=0A=
>> existing functions can be resued, with get_aneg_ctrl() selecting the cor=
rect=0A=
>> register address.=0A=
>>=0A=
> If Base-T1 can't be combined with other modes then at a first glance I se=
e no=0A=
> benefit in defining new registers e.g. for aneg control, and the standard=
 ones=0A=
> are unused. Why not using the standard registers? Can you shed some light=
 on that?=0A=
> =0A=
> Are the new registers internally shadowed to the standard location?=0A=
> That's something I've seen on other PHY's: one register appears in differ=
ent=0A=
> places in different devices.=0A=
> =0A=
>> The current version of ethtool has been prepared for 100/1000BASE-T1 and=
 works=0A=
>> with this patch. 10BASE-T1 needs to be added to ethtool.=0A=
>>=0A=
>> Christian Herber (1):=0A=
>>    Added BASE-T1 PHY support to PHY Subsystem=0A=
>>=0A=
>>   drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----=
=0A=
>>   drivers/net/phy/phy-core.c   |   4 +-=0A=
>>   include/uapi/linux/ethtool.h |   2 +=0A=
>>   include/uapi/linux/mdio.h    |  21 +++++++=0A=
>>   4 files changed, 129 insertions(+), 11 deletions(-)=0A=
>>=0A=
> =0A=
> Heiner=0A=
> =0A=
=0A=
Hi Heiner,=0A=
=0A=
I do not think the Aquantia part you are describing is publicly =0A=
documented, so i cannot comment on that part.=0A=
There are multiple reasons why e.g. xBASE-T1 plus 1000BASE-T is =0A=
unlikely. First, the is no use-case known to me, where this would be =0A=
required. Second, there is no way that you can do an auto-negotiation =0A=
between the two, as these both have their own auto-neg defined (Clause =0A=
28/73 vs. Clause 98). Thirdly, if you would ever have a product with =0A=
both, I believe it would just include two full PHYs and a way to select =0A=
which flavor you want. Of course, this is the theory until proven =0A=
otherwise, but to me it is sufficient to use a single driver.=0A=
=0A=
The registers are different in the fields they include. It is just that =0A=
the flags which are used by the Linux driver, like restarting auto-neg, =0A=
are at the same position.=0A=
=0A=
Christian=0A=
=0A=
