Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D10B59CB19
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 09:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfHZH5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 03:57:23 -0400
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:21998
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730103AbfHZH5X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 03:57:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1aWaUOMRof0Tnd/dArVVyer3pH72vXJ5IgvemqksZyVHLbQlUa2FH8rWvcx1q+9A371PMSx1awK57EI4OVl1ttK8U2gfOqXmej3lNXF8xxDIvigV2xuO0qDEwVwKV+UBfvAE3bIvVUogiKTAHR27KC6pjSxdrwhMwTnh+1BQv8K+c6hZEvGUg+ZCMNA0n9+03k1GIxdmfLH8bU7oMP1UyrdT4DPbwYeT5avgDsu9E9owEBkbLqgrkoSSs2vfBgHGdi/eeL0ca/5oEZ9LU5669DAdqRkmw8r0N3/DtP24jtjr/ZS8A88+M12db02w88kasQWXbMjISHKw65NPZdRUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDszGu9e8JvU+fu+sqqaZLdzKLyjNQ3H6BR/DZOdGEg=;
 b=hxxmh/dXtZy7icBo4FYYpMt3wObxMj5PsUELql6qCdm/z3vUs9K4QgIdq9X1VLC1Um/9LFDX+LNV0YLW75HBVMTCJ96RBYb+k5Seg7sbnBW011UgQSdALNZRqQvqcvTAvedYJdARTHuHf3wOroz+s15Q6wmOinq0iNFhfnOahlCT6Dj8FJ/6K0tSU1jJgL7NzEzpTSH7XLKIEl5yoE/r4Br3PFyq+2CCAsPjOftfo+FobTBM6loPQ11RIfiHdhXKGL9Yi89s0N4FUhmZ1yinnKhu+Im6UwMrT8tw9Kz8bhxbdX65hjnhZNrUWsiZkP+/zEGT88/Hj/yEkXgkbffuDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDszGu9e8JvU+fu+sqqaZLdzKLyjNQ3H6BR/DZOdGEg=;
 b=SCxLvtks1zIa8UpZNsO4PICd9lFLqWMfGmoWwekasBmK5LMHsqQPgPBasN+HZAXiVsYUVTi5lcjQnoBUpGQUDXEhUrUspXb9cgbqJ/XaXgGIhHOvaz6zyxoJKFInjecr1ByF7Ie3JeApKVkWwnmgrelYmR/hVTg/ZekjdG0FYpQ=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3879.eurprd04.prod.outlook.com (52.133.28.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Mon, 26 Aug 2019 07:57:18 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 07:57:18 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVW+Pim15gTjy7Q0WTl1tRdYHg9g==
Date:   Mon, 26 Aug 2019 07:57:18 +0000
Message-ID: <AM6PR0402MB37981FC4BC33F61940E5C23D86A10@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <8c15b855-6947-9930-c3df-71a64fbff33b@gmail.com>
 <AM6PR0402MB379864B810F08D3698618B5F86A80@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <13e65051-fe4f-5964-30b3-75285e6d2eee@gmail.com>
 <AM6PR0402MB3798FCBF1EE592687B13A3C386AB0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <5c920846-b8f5-d087-cea4-a8ca3f816127@gmail.com>
 <20190821185715.GA16401@lunn.ch>
 <AM6PR0402MB3798C702793071E34A5659ED86A50@AM6PR0402MB3798.eurprd04.prod.outlook.com>
 <1f50cdcf-200d-7c25-35ae-aee011a6a520@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f62af5d7-e080-4b30-2342-08d729fb049e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3879;
x-ms-traffictypediagnostic: AM6PR0402MB3879:
x-microsoft-antispam-prvs: <AM6PR0402MB3879FB779FF0AF54024AD77E86A10@AM6PR0402MB3879.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(136003)(366004)(376002)(189003)(199004)(256004)(14444005)(26005)(186003)(14454004)(478600001)(6436002)(66476007)(7696005)(71190400001)(71200400001)(476003)(66946007)(6246003)(25786009)(486006)(66556008)(55016002)(6506007)(53546011)(99286004)(33656002)(54906003)(110136005)(9686003)(53936002)(44832011)(316002)(55236004)(102836004)(446003)(5660300002)(4326008)(305945005)(2906002)(6116002)(76176011)(3846002)(81156014)(81166006)(8676002)(8936002)(7736002)(74316002)(52536014)(91956017)(76116006)(66066001)(229853002)(66446008)(86362001)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3879;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TwpIlj+YLNIO4roBsL0oKHhwajEIqIEnBoXW/h6JJxgIqR69z9Z1vKmLoufYYrKtsyf95nXpJ4Ry0/UHA4XK2i3aWOmh6y5fVOxF4Y9wJoaaN6+dTKgdOkv/CgIe0H81cf8OTUrr9dUOrAbEQlDp0k1LG0kmjPZluRzZU/1qoNaZOk9vPOZQ3OVZfKIDKfA8DOdtsw0+9Tq8Yzax8ijnHqeRcAp9WGA+bLfyt7uxtZPoH5t7Oq5Z52nTsjJwV/lDbEcO1r1Uub0st4r6Lft/aVfpjDSh1iER8geQzBGr7z0ZuvJZfsiMjYrPulVLZ6O2iER/2ADJR+vi/C4T7oGK25QmOzddqGcPENYXoV4mcqAMVP7rgHh+o9JoNSRbVhDLhD21AvGKBH13vsOprG61F2HGZT+voqt1hYwDKngSrbY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f62af5d7-e080-4b30-2342-08d729fb049e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 07:57:18.6957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mp+QfU+8quO+W5whHhql95fyuQgSYC5S8ijDvDopsvjMrxKyiHcfi0NpbX8rtA/MRVCzreXt29jfvS4ui2Ug2+PO5dnlk2MIlJoTE50vo48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2019 17:03, Heiner Kallweit wrote:=0A=
> =0A=
> On 22.08.2019 09:18, Christian Herber wrote:=0A=
>> On 21.08.2019 20:57, Andrew Lunn wrote:=0A=
>>>=0A=
>>>> The current patch set IMO is a little bit hacky. I'm not 100% happy=0A=
>>>> with the implicit assumption that there can't be devices supporting=0A=
>>>> T1 and classic BaseT modes or fiber modes.=0A=
>>>=0A=
>>>> Andrew: Do you have an opinion on that?=0A=
>>>=0A=
>>> Hi Heiner=0A=
>>>=0A=
>>> I would also like cleaner integration. I doubt here is anything in the=
=0A=
>>> standard which says you cannot combine these modes. It is more a=0A=
>>> marketing question if anybody would build such a device. Maybe not=0A=
>>> directly into a vehicle, but you could imaging a mobile test device=0A=
>>> which uses T1 to talk to the car and T4 to connect to the garage=0A=
>>> network?=0A=
>>>=0A=
>>> So i don't think we should limit ourselves. phylib should provide a=0A=
>>> clean, simple set of helpers to perform standard operations for=0A=
>>> various modes. Drivers can make use of those helpers. That much should=
=0A=
>>> be clear. If we try to make genphy support them all simultaneously, is=
=0A=
>>> less clear.=0A=
>>>=0A=
>>>        Andrew=0A=
>>>=0A=
>>=0A=
>> If you want to go down this path, then i think we have to ask some more=
=0A=
>> questions. Clause 45 is a very scalable register scheme, it is not a=0A=
>> specific class of devices and will be extended and extended.=0A=
>>=0A=
>> Currently, the phy-c45.c supports 10/100/1000/2500/5000/10000 Mbps=0A=
>> consumer/enterprise PHYs. This is also an implicit assumption. The=0A=
>> register set (e.g. on auto-neg) used for this will also only support=0A=
>> these modes and nothing more, as it is done scaling.=0A=
>>=0A=
>> Currently not supported, but already present in IEEE 802.3:=0A=
>> - MultiGBASE-T (25/40 Gbps) (see e.g. MultiGBASE-T AN control 1 register=
)=0A=
>> - BASE-T1=0A=
>> - 10BASE-T1=0A=
>> - NGBASE-T1=0A=
>>=0A=
>> And surely there are some on the way or already there that I am not=0A=
>> aware of.=0A=
>>=0A=
>> To me, one architectural decision point is if you want to have generic=
=0A=
>> support for all C45 PHYs in one file, or if you want to split it by=0A=
>> device class. I went down the first path with my patch, as this is the=
=0A=
>> road gone also with the existing code.=0A=
>>=0A=
>> If you want to split BASE-T1, i think you will need one basic C45=0A=
>> library (genphy_c45_pma_read_abilities() is a good example of a function=
=0A=
>> that is not specific to a device class). On the other hand,=0A=
>> genphy_c45_pma_setup_forced() is not a generic function at this point as=
=0A=
>> it supports only a subset of devices managed in C45.=0A=
>>=0A=
>> I tend to agree with you that splitting is the best way to go in the=0A=
>> long run, but that also requires a split of the existing phy-c45.c into=
=0A=
>> two IMHO.=0A=
>>=0A=
> BASE-T1 seems to be based on Clause 45 (at least Clause 45 MDIO),=0A=
> but it's not fully compliant with Clause 45. Taking AN link status=0A=
> as an example: 45.2.7.2.7 states that link-up is signaled in bit 7.1.2.=
=0A=
> If BASE-T1 uses a different register, then it's not fully Clause 45=0A=
> compatible.=0A=
=0A=
Clause 45 defines e.g. bit 7.1.2 just like it defines the BASE-T1 =0A=
auto-neg registers. Any bit that i have used in my patch is 100% =0A=
standardized in IEEE 802.3-2018, Clause 45. By definition, BASE-T1 PHYs =0A=
have to use the Clause 45 BASE-T1 registers, otherwise they are not IEEE =
=0A=
compliant.=0A=
=0A=
> Therefore also my question for the datasheet of an actual BASE-T1 PHY,=0A=
> as I would be curious whether it shadows the link-up bit from 7.513.2=0A=
> to 7.1.2 to be Clause 45 compliant. Definitely reading bit 7.513.2=0A=
> is nothing that belongs into a genphy_c45_ function.=0A=
=0A=
For now, there is no such public data sheet. However, IEEE 802.3-2018 is =
=0A=
public. This should be the basis for a generic driver. Datasheets are =0A=
needed for the device specific drivers. If Linux cares to support =0A=
BASE-T1, it should implement a driver that works with a standard =0A=
compliant PHY and that can be done on the basis of IEEE.=0A=
=0A=
> The extension to genphy_c45_pma_read_abilities() looks good to me,=0A=
> for the other parts I'd like to see first how real world BASE-T1 PHYs=0A=
> handle it. If they shadow the T1-specific bits to the Clause 45=0A=
> standard ones, we should be fine. Otherwise IMO we have to add=0A=
> separate T1 functions to phylib.=0A=
> =0A=
> Heiner=0A=
> =0A=
=0A=
There is not requirement in IEEE to shadow the BASE-T1 registers into =0A=
the "standard" ones. Thus, such an assumption should not be done for a =0A=
generic driver, as it will quite certainly not work with all devices. =0A=
Fyi, both registers are standard, just that the historically first ones =0A=
are for classic 10/100/1000/10000 PHYs and BASE-T1 registers are for the =
=0A=
single twisted pair PHYs.=0A=
