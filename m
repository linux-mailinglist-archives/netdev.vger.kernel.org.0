Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C49B14283D
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 11:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgATKbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 05:31:25 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:58838 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbgATKbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 05:31:25 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 76F9E405BC;
        Mon, 20 Jan 2020 10:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1579516284; bh=ycG69vqqJf2SJdOjvAt79klZQl/ducuFe87qeuhzCRc=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ia6R52oGXQPWhOCuKAXHcfQlPVq8gK5WUOJ4qkYkSu3tIAw2ci+4ruYNSGhPKy9jv
         5suQbBDi8EAQCwCKEEjTY72S7nRIA3Ml5uWvB50qoQ5P7w2otJn2j4ZxyHe5PNbboH
         nV1JCV7P5jIYELtQFUI3KR+R4gtQfI5zpQrinAFqLlL7MOTy7hyHfIRGBRUlUxg7at
         N6M9h61qZ/I0KvFHIbUA7u1nz5p4pu8wDmnB1cLHu7Zt/bBRNOGU/87qGrX6EYbcYu
         bNHXFehxQ8ZBknFlXL8V2FoNt05Vl59fqJQGCTHqAAdUnemVEiogod15lhayvnc7vj
         5NL9jsDn3JuvQ==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C9708A007F;
        Mon, 20 Jan 2020 10:31:19 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 20 Jan 2020 02:31:19 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 20 Jan 2020 02:31:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVsLcwNVOaEClIw+9HI7BTCLVmEhWyuK/unr3fwnkecLXIIVTUT4QRNK5b9eI5a57IgL06ye2dVkwsTA9S07QrLraWh8QbjqMSKg6+ufZ0yIURquMXuxl8pP39m5Xne7zkmnV4UuEGbeOqhwyWxHna1Oi/efHocBIXZ9HN4tXBYXzhNJk97eCQYn40fisvMYhx7tRuNg+1gE8tdrODPqI4fDSGay7ZYxs23N5pg8CJOG1M/wJ4hjHtPK0eO4Q2zZ+WvB46lNc0ZS2YdpPx5EiLMwJZ+98DPmFU/uVgSL8yaRKWXK9GnBRwqdeZzidTeNEp2PqgGvgzwZfz7NdAPadA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofeJndvIVzjG/7Pzj+0op2T2CbnWAPw3H1fJmLnoGDc=;
 b=ed6jT+WiTFnKCpr2ApbrU3bwUmeGqsqZEfTZT2+8Qwrf6FjbuG8XNEr8CPmsyyLeagD2I/BVBiwzOFsgqgdt+/ZemJ68co6iZcmHqPgOiufEYCBK+ie8HPkJQCV2EMuN3qubMOdcc18y6q1qiM0qm+dlf2Dcd5FAvpYUOVb8tUUD+JjTIsG7u5DlnxsaMK92FNwB/VMEKHhj1muN47o1CiWyvlz0wrHThrANT/DhLLLr9NldYaapdNyqHK1noufWiI6hz+0QoBHxDQk1Vhzqv9YQQHXT2ijQiabN84F725f2NZL7MNXmR5u8qMBdEcXvmeza7+dEYDVtDqrfST4Q4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ofeJndvIVzjG/7Pzj+0op2T2CbnWAPw3H1fJmLnoGDc=;
 b=HbGyQnL4vu3h7mG33wohgM6btxLwJU8WcyTwL7yWq/GOluwXWaVDNJevAO2O4DYK/GBj+B9YQRzQVgKg+KYe+qoV4KJw0nxSwFWfBwZlywjwXG6c1lI82RTpChVynztmLv86Ol3w9YeOWP1qVDrCiW8jjRs0MjVxsCeOOd+VDFg=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2994.namprd12.prod.outlook.com (20.178.210.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Mon, 20 Jan 2020 10:31:17 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::c62:b247:6963:9da2%6]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 10:31:17 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Topic: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Thread-Index: AQHVyhMHPh1TkUf6pU+JUVzLFdFzk6fomWeAgAAAjSCAAAp/gIAKvyCA
Date:   Mon, 20 Jan 2020 10:31:17 +0000
Message-ID: <BN8PR12MB3266EC7870338BA4A65E8A6CD3320@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
In-Reply-To: <20200113141817.GN25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f2bacdf-4ee2-4cc0-5d08-08d79d93e1f8
x-ms-traffictypediagnostic: BN8PR12MB2994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB2994DCB432725B968DA7963ED3320@BN8PR12MB2994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(136003)(366004)(199004)(189003)(6506007)(4744005)(81166006)(6916009)(81156014)(54906003)(8676002)(5660300002)(52536014)(71200400001)(316002)(86362001)(7696005)(478600001)(2906002)(186003)(33656002)(66556008)(66476007)(66446008)(55016002)(64756008)(76116006)(9686003)(26005)(4326008)(8936002)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2994;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E27O1xTYa5GY+FelrI6rv7iBctfL+eFmaDBT10tX8QrHFgHKjkcaY2gwLzsoI3qwhmVLswuoProTQPex4JulUDzJOSQxG9IYWKM1ehI3LCmB82J3jWCRvLNBXvZAgSw5syEAFW+/aHpw1H2NHJLuB4jSKpz/1C5I973sleU2IwzKULWJqiR1sdrNQHlcHnAdWPP+XKOaOHB8YEpIIexbRv6d9SIug1sGKTOkqF2wyPcKNA+7BdOGIo+5VNzm5qZOi0X+frqkTnSwKc6CPmSi0T+KOTPEiBKEwUMl822NkKF591Jd+Ue+EdzYGgEHWfECxbK9aAxeW5D2U3BhKqL5whB/7uVZCaK1Oye2A6GgjsYtjVe2wSNOpfpTd3iknr2Gb7U+9dq7bfB/jGy0KTd1zuEX2e5tv6Fzh1dP+CgTLA5NGhu7GR+QPFoYbK1jFg5l
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2bacdf-4ee2-4cc0-5d08-08d79d93e1f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 10:31:17.1299
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rcyH5Cf2tvH6hh3GpMjeQD0iPd793c3o9S7d3pWK7vG8VNRDHe+fFd4nB6wB0QDTC2Dh9mRw96/IkFiRB8geaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Jan/13/2020, 14:18:17 (UTC+00:00)

> I've recently suggested a patch to phylink to add a generic helper to
> read the state from a generic 802.3 clause 37 PCS, but I guess that
> won't be sufficient for an XPCS.  However, it should give some clues
> if you're intending to use phylink.

So, I think for my particular setup (that has no "real" PHY) we can have=20
something like this in SW PoV:

stmmac -> xpcs -> SW-PHY / Fixed PHY

- stmmac + xpcs state would be handled by phylink (MAC side)
- SW-PHY / Fixed PHY state would be handled by phylink (PHY side)

This would need updates for Fixed PHY to support >1G speeds.

---
Thanks,
Jose Miguel Abreu
