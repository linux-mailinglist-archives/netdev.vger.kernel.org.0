Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C17796033
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfHTNgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:36:18 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:19009
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728682AbfHTNgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 09:36:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oJo1ePUWe03p8rFGi8AwOM8qX2nPMZl5B+CoUF1fQZzzEzYRhz6ayy/mz9fZzrxkcggjPovnGg2kx+Nh9rvO7jttO+C2qYVowQs1OKkAu+1Ts71A+67w+6qkM8BUy3VOM0IUDK+6MWQVXWzLWAE8TYCWCxIstBjRCbHeEGt3Gg9720HDLhPi5CnslBAZG1iMvCDks6DRq/sBQyD0XMhzhkGx99bg897TPkxW6ivtNrBfeelfegQ6Mlp6aSGw1Vur9H6Vjl0nGQjldVOpsTE9nXfqHbQNr+BIGvyjSQiMXWYtmmj+OUuOPbD91VLU76lXwIzLzPeKnZx7ySYiw73gww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbfvC7Gy6a5jMJm5qHD1Ktdcx8lzMmE5vVOtmdYjkVY=;
 b=JEspPKfnZtY/mBBzf1IwHl1GUDg4NuNMfZch2TbP0Z3oYAVujttBRYqdkDH1fCZLRDR4LfrNofohX+7UWWR2tMEMlnDGtttguRJuvXzGMoPeqgV2z1YnQVDhygR+Y1+fnQnaTba5Z+JfgGK/M3Fs/A8x/SHe6JVrajJwRT5KY71ImPhzqBrZRAjHitotBzv1avslfxQttoEt4i5gF757oscSyDDHfVSDZ1+vHIsBQV/05F4iLMjVgvzjTyZxJzqLAYgn79Mu45d9i8B7bv1nlFC3XmYinLEt01SvzNu0zTL2NFaDXSiyfW25k7EAoN4LGCq2v3hvvXPARAPC3yhiGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IbfvC7Gy6a5jMJm5qHD1Ktdcx8lzMmE5vVOtmdYjkVY=;
 b=R2/YxrBi0PFZKsltJfxo6WNmHeEHoYXefcmtgkEQN4hjE1RV5tMpssdo6f5BGLy/ovOIcOyZS9wmxAObRaHyHxoxP21z85wKcfEuUz7yJ7SQElJf8dQcVgNsA3JZjwTwoSFvhBLfGAZQzO+5rR+MfGaLFqyeeN4hgh33LbhtJ2Q=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3591.eurprd04.prod.outlook.com (52.133.20.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 13:36:09 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 13:36:09 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: [EXT] Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVVlfh9z1APBIvVEOf3Cz5T4N+yg==
Date:   Tue, 20 Aug 2019 13:36:09 +0000
Message-ID: <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9cd241c-3f18-461a-ad84-08d725735c69
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3591;
x-ms-traffictypediagnostic: AM6PR0402MB3591:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR0402MB3591C26642F178ED28287F5B86AB0@AM6PR0402MB3591.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(199004)(189003)(446003)(486006)(54906003)(8676002)(476003)(33656002)(91956017)(229853002)(76176011)(76116006)(186003)(14444005)(256004)(102836004)(6506007)(53546011)(55236004)(26005)(25786009)(7736002)(110136005)(6246003)(81156014)(81166006)(9686003)(305945005)(5660300002)(6436002)(4326008)(7696005)(74316002)(86362001)(53936002)(966005)(14454004)(99286004)(2501003)(316002)(71200400001)(71190400001)(66066001)(3846002)(6116002)(2906002)(66556008)(6306002)(478600001)(44832011)(66476007)(64756008)(66446008)(55016002)(66946007)(8936002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3591;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: D7bzG4ERQ2PjDXIxnPa89dsZbHkUOitpeon6mE9Fj/q/rwl5Ve35KlWBvfJSPSwXBuovX8L8B68wpZ5fzMnMoH1y+zDMkBgEzU1Hs+B5kz8aCIH8IZO6sbKaJLCVijkcSQp/hlInm4NUt6MDTseRqDAAcOWfs/2C4ZnJ31knQzKrHYCl3Ww/bBAO+S+dEGEc4VayKPQk7beh2QIBJHPi4zJUzzzHUuaaftJxz9qq/1OQZj+1vrkomat4Z6NiFIYz/2xhPL+8vw0AFdNIjMS1F+N1849/IWDdrUMZrs07CXPJoFOPdevVdd3A2uEWy/KIjOvHgR3qhkc7bZ/6OW0UbPg1gk3Xs02A+UhbkrcoxqpGYnENuSqm+quZnHApsiSZCJrx3mgqMGRYQTr7S2+kmwkYGw8dsCefJ4bB/6FYkrI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cd241c-3f18-461a-ad84-08d725735c69
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 13:36:09.6501
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HX7RQ/4M1KGF9+oO0KgaDpQkjJaaF6qPE2evR8/5d4oZvOgOWF9ib8OqWxnH4rkQ258STZi1To6GkGEQelVA1m/zNORyFu3rbC1xUrDPDnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3591
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2019 21:07, Heiner Kallweit wrote:=0A=
> Caution: EXT Email=0A=
> =0A=
> On 19.08.2019 08:32, Christian Herber wrote:=0A=
>> On 16.08.2019 22:59, Heiner Kallweit wrote:=0A=
>>> On 15.08.2019 17:32, Christian Herber wrote:=0A=
>>>> This patch adds basic support for BASE-T1 PHYs in the framework.=0A=
>>>> BASE-T1 PHYs main area of application are automotive and industrial.=
=0A=
>>>> BASE-T1 is standardized in IEEE 802.3, namely=0A=
>>>> - IEEE 802.3bw: 100BASE-T1=0A=
>>>> - IEEE 802.3bp 1000BASE-T1=0A=
>>>> - IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S=0A=
>>>>=0A=
>>>> There are no products which contain BASE-T1 and consumer type PHYs lik=
e=0A=
>>>> 1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BA=
SE-T1=0A=
>>>> PHYs with auto-negotiation.=0A=
>>>=0A=
>>> Is this meant in a way that *currently* there are no PHY's combining Ba=
se-T1=0A=
>>> with normal Base-T modes? Or are there reasons why this isn't possible =
in=0A=
>>> general? I'm asking because we have PHY's combining copper and fiber, a=
nd e.g.=0A=
>>> the mentioned Aquantia PHY that combines NBase-T with 1000Base-T2.=0A=
>>>=0A=
>>>>=0A=
>>>> The intention of this patch is to make use of the existing Clause 45 f=
unctions.=0A=
>>>> BASE-T1 adds some additional registers e.g. for aneg control, which fo=
llow a=0A=
>>>> similiar register layout as the existing devices. The bits which are u=
sed in=0A=
>>>> BASE-T1 specific registers are the same as in basic registers, thus th=
e=0A=
>>>> existing functions can be resued, with get_aneg_ctrl() selecting the c=
orrect=0A=
>>>> register address.=0A=
>>>>=0A=
>>> If Base-T1 can't be combined with other modes then at a first glance I =
see no=0A=
>>> benefit in defining new registers e.g. for aneg control, and the standa=
rd ones=0A=
>>> are unused. Why not using the standard registers? Can you shed some lig=
ht on that?=0A=
>>>=0A=
>>> Are the new registers internally shadowed to the standard location?=0A=
>>> That's something I've seen on other PHY's: one register appears in diff=
erent=0A=
>>> places in different devices.=0A=
>>>=0A=
>>>> The current version of ethtool has been prepared for 100/1000BASE-T1 a=
nd works=0A=
>>>> with this patch. 10BASE-T1 needs to be added to ethtool.=0A=
>>>>=0A=
>>>> Christian Herber (1):=0A=
>>>>     Added BASE-T1 PHY support to PHY Subsystem=0A=
>>>>=0A=
>>>>    drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++-=
---=0A=
>>>>    drivers/net/phy/phy-core.c   |   4 +-=0A=
>>>>    include/uapi/linux/ethtool.h |   2 +=0A=
>>>>    include/uapi/linux/mdio.h    |  21 +++++++=0A=
>>>>    4 files changed, 129 insertions(+), 11 deletions(-)=0A=
>>>>=0A=
>>>=0A=
>>> Heiner=0A=
>>>=0A=
>>=0A=
>> Hi Heiner,=0A=
>>=0A=
>> I do not think the Aquantia part you are describing is publicly=0A=
>> documented, so i cannot comment on that part.=0A=
> Right, datasheet isn't publicly available. All I wanted to say with=0A=
> mentioning this PHY: It's not a rare exception that a PHY combines=0A=
> standard BaseT modes with "non-consumer" modes for special purposes.=0A=
> One practical use case of this proprietary 1000Base-T2 mode is=0A=
> re-using existing 2-pair cabling in aircrafts.=0A=
> =0A=
>> There are multiple reasons why e.g. xBASE-T1 plus 1000BASE-T is=0A=
>> unlikely. First, the is no use-case known to me, where this would be=0A=
>> required. Second, there is no way that you can do an auto-negotiation=0A=
>> between the two, as these both have their own auto-neg defined (Clause=
=0A=
>> 28/73 vs. Clause 98). Thirdly, if you would ever have a product with=0A=
>> both, I believe it would just include two full PHYs and a way to select=
=0A=
>> which flavor you want. Of course, this is the theory until proven=0A=
>> otherwise, but to me it is sufficient to use a single driver.=0A=
>>=0A=
> I'm with you if you say it's unlikely. However your statement in the=0A=
> commit message leaves the impression that there can't be such a device.=
=0A=
> And that's a difference.=0A=
> =0A=
> Regarding "including two full PHYs":=0A=
> This case we have already, there are PHYs combining different IP blocks,=
=0A=
> each one supporting a specific mode (e.g. copper and fiber). There you=0A=
> also have the case of different autoneg methods, clause 28 vs. clause 37.=
=0A=
> =0A=
>> The registers are different in the fields they include. It is just that=
=0A=
>> the flags which are used by the Linux driver, like restarting auto-neg,=
=0A=
>> are at the same position.=0A=
>>=0A=
> Good to know. Your commit description doesn't mention any specific PHY.=
=0A=
> I suppose you have PHYs you'd like to operate with the genphy_c45 driver.=
=0A=
> Could you give an example? And ideally, is a public datasheet available?=
=0A=
> =0A=
>> Christian=0A=
>>=0A=
>>=0A=
> Heiner=0A=
> =0A=
=0A=
There are no public BASE-T1 devices on the market right now that use =0A=
Clause 45 standard registers. The first such products were developed =0A=
before the IEEE standard (BroadR-Reach) and used Clause 22 access (see =0A=
e.g. the support in the Kernel for TJA110x).=0A=
=0A=
The most convenient way to test with a BASE-T1 device would be to use an =
=0A=
SFP (e.g. =0A=
https://technica-engineering.de/produkt/1000base-t1-sfp-module/). =0A=
Alternative source could be Goepel.=0A=
=0A=
There are also a number of media-converters around where one could break =
=0A=
out the MDIO and connect to a processor. Of course, in all cases it =0A=
should be made sure that this is a Clause-45 device.=0A=
=0A=
As all relevant parts are NDA-restricted, this is pretty much all the =0A=
information I can share.=0A=
=0A=
Christian=0A=
=0A=
