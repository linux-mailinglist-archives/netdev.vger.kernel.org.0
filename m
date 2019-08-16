Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB890105
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfHPL6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 07:58:10 -0400
Received: from mail-eopbgr10060.outbound.protection.outlook.com ([40.107.1.60]:34018
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727014AbfHPL6K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 07:58:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Isi2BP0rBOpfR17+rmrO2/3yV2eR8qHax5N0pmQygJN480gLn8JiqUsEllD3FZ1knQfWw2fwzE0yZIy3Y1BCHQKIDIrTta9wtSMrhZIatQ2XTvaM7NRJBYgnxxuVYBuKFudXZCnlROq0YuYX8OdjClmvC4gM9PBKXLNHxVSJihQ6n4p6LfPxMmW2lYA5ZQxJRYsTKIdDDxL/wLnjezvgWgdESZrAyGA3lJ8IT+pCEzRML3N3HcnAa6WEDyY+CiJTZYfUEvMbxUhqd6ggdYXdYQa66e6B8XbYetMn9LI5qVc/FE9yDHMs01Go1R5HAKe/XQMPCmyOVLrMOc61MxDgtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oveiBEOk0w6H4nmm3j0baLV2+PdbJdvjHM4KrlLuIcs=;
 b=n90WNOiGN5K4FiqxlkhSnArJ2QgnTSsncSLMcNHxYAQ4T0iidkz3eklf8V91yJCs/wnOP9+mknwb20R55zpLo1G2z8HjEhSOQZpJU8MBbf3f31mJZcOmzo18ABIJIKZXuqasgnjdSHow692yEe2yXhbnyD94wF9rqGshohcvn6qJxBF8lEqNQWJ8npeCAL2hO0+2vLJXOhi926sAuNhiUBJygLzh6ETpdo5PtLFohnw74X0BAfhGlC/Sb8ZpsUmawOKVFV5unMm2IeKGcqpqRgwn9QHmWyldjD8GdeEFkG0/ypiySZzLwM8bv/OcVTEVZ20UAeMQQJjVKZ+Al54L1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oveiBEOk0w6H4nmm3j0baLV2+PdbJdvjHM4KrlLuIcs=;
 b=NI5FWUiB+sXnsk5SytH+vKh3pCoY+Qn+q5S98pfCnUc2L/r91hCOCzQ1XpSWjuDunNDzGvzBhqHu5HtrHd22u9SEgVt4rwjC9sPTooBiRzynVd+4HnbA14FPOrWn2lE1XJUFtysincqUtMKOFNy8F7pWsQIEZaB8oOYyuXmSRSw=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3848.eurprd04.prod.outlook.com (52.133.31.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Fri, 16 Aug 2019 11:56:38 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2157.022; Fri, 16 Aug 2019
 11:56:38 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Topic: [EXT] Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY
 Subsystem
Thread-Index: AQHVU36mdpwX4yyX/0O62UH8/z+9iA==
Date:   Fri, 16 Aug 2019 11:56:38 +0000
Message-ID: <AM6PR0402MB3798CD854B37F430980E204F86AF0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
 <20190815155613.GE15291@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11062640-a5eb-4d9b-d2df-08d72240cb65
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3848;
x-ms-traffictypediagnostic: AM6PR0402MB3848:
x-microsoft-antispam-prvs: <AM6PR0402MB3848ADBBB6E54909D7CB1B4686AF0@AM6PR0402MB3848.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(136003)(346002)(366004)(396003)(199004)(189003)(64756008)(66446008)(6916009)(71200400001)(71190400001)(6116002)(14454004)(476003)(446003)(66476007)(76116006)(66556008)(66066001)(8936002)(486006)(44832011)(3846002)(229853002)(91956017)(66946007)(74316002)(7696005)(52536014)(53546011)(2906002)(256004)(316002)(55236004)(14444005)(25786009)(86362001)(305945005)(54906003)(9686003)(26005)(6436002)(6246003)(55016002)(33656002)(7736002)(186003)(99286004)(81156014)(8676002)(4326008)(81166006)(5660300002)(6506007)(76176011)(53936002)(561944003)(478600001)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3848;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zVcOp1AwEnfV0/9BcVKQgjp/hD9/w9A8MaDhSgbCKSzi7kENHbvlypXTBsgpx/hWYbuLFY/79g6/D8SX3l4BmMuuIJ3kYhyQNGxoDMgkdgiK7Rv41vp5eLnkVyILAdk41/giQC9fTtSjC+Ec5nlxOVuLulWp/gi23x7vl1hG60481813Rt66SkMsgFGAAugCaoJutmPmIxdt5934eqfR4dtH2RDDcRQAZGQ20LngFbh/+ysJSrr/G/3wsyi7EDxD+b/8L+J3bK8XO9Fst4FyTzfAQvjLTyru+45Ox98ta8+bTkLxyPQTvNSrVFOr3JAI9OIFEz772y6ahC6m+tpKqiS9z9i+JaBlfleqdzXr6ey8rLVqRF16JY3rmDsG1fCUWSSFnKm6th4fFBN5l8kIDzep8alowKNl00Efcz92euo=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11062640-a5eb-4d9b-d2df-08d72240cb65
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 11:56:38.0984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22kuiPBddI4e5UPyHVuhsndWKpedZNzcP0HTGiNUWwqQCbR2+Q3YLkStiwGZdtJnCAkjmnNNc+V3E56XLasoZiKGK2YTiWpjTJmV6668yfc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3848
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 17:56, Andrew Lunn wrote:=0A=
> Caution: EXT Email=0A=
> =0A=
> On Thu, Aug 15, 2019 at 03:32:29PM +0000, Christian Herber wrote:=0A=
>> BASE-T1 is a category of Ethernet PHYs.=0A=
>> They use a single copper pair for transmission.=0A=
>> This patch add basic support for this category of PHYs.=0A=
>> It coveres the discovery of abilities and basic configuration.=0A=
>> It includes setting fixed speed and enabling auto-negotiation.=0A=
>> BASE-T1 devices should always Clause-45 managed.=0A=
>> Therefore, this patch extends phy-c45.c.=0A=
>> While for some functions like auto-neogtiation different registers are=
=0A=
>> used, the layout of these registers is the same for the used fields.=0A=
>> Thus, much of the logic of basic Clause-45 devices can be reused.=0A=
>>=0A=
>> Signed-off-by: Christian Herber <christian.herber@nxp.com>=0A=
>> ---=0A=
>>   drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----=
=0A=
>>   drivers/net/phy/phy-core.c   |   4 +-=0A=
>>   include/uapi/linux/ethtool.h |   2 +=0A=
>>   include/uapi/linux/mdio.h    |  21 +++++++=0A=
>>   4 files changed, 129 insertions(+), 11 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c=0A=
>> index b9d4145781ca..9ff0b8c785de 100644=0A=
>> --- a/drivers/net/phy/phy-c45.c=0A=
>> +++ b/drivers/net/phy/phy-c45.c=0A=
>> @@ -8,13 +8,23 @@=0A=
>>   #include <linux/mii.h>=0A=
>>   #include <linux/phy.h>=0A=
>>=0A=
>> +#define IS_100BASET1(phy) (linkmode_test_bit( \=0A=
>> +                        ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \=0A=
>> +                        (phy)->supported))=0A=
>> +#define IS_1000BASET1(phy) (linkmode_test_bit( \=0A=
>> +                         ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \=0A=
>> +                         (phy)->supported))=0A=
> =0A=
> Hi Christian=0A=
> =0A=
> We already have the flag phydev->is_gigabit_capable. Maybe add a flag=0A=
> phydev->is_t1_capable=0A=
> =0A=
>> +=0A=
>> +static u32 get_aneg_ctrl(struct phy_device *phydev);=0A=
>> +static u32 get_aneg_stat(struct phy_device *phydev);=0A=
> =0A=
> No forward declarations please. Put the code in the right order so=0A=
> they are not needed.=0A=
> =0A=
> Thanks=0A=
> =0A=
>       Andrew=0A=
> =0A=
=0A=
Hi Andrew,=0A=
=0A=
thanks for feedback. The use of an additional flag is a good proposal.=0A=
I was hesitant to touch the phydev structure.=0A=
I will add this along with removing the forward declaration in v2.=0A=
=0A=
Regards,=0A=
=0A=
Christian=0A=
