Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C33BF1E04BA
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388448AbgEYCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:32:14 -0400
Received: from mail-eopbgr40059.outbound.protection.outlook.com ([40.107.4.59]:19687
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388110AbgEYCcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 22:32:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhNPMPdiJM8vZ6clcfVG53v6tVgmcLhsx4bSQXMI6foQa5Jp0ymn1U27mYAzOeATkjuOGGHzvqqKDcA+DcjAb2xCiXNwhYFEiDCkMhzklryRnRXjJHO01CIapvNNV/itWpWxRZl2cOnwGyIWbH0qjPABCAbT5guAxvSCjzmCMgkW1MQ1bbVm5lt0b2W+pIUsX3JMQnqRkgI9LZWS8wtqx3UP/tW2wFX+mjE5QnZtKw4pwDQ+6wbaWuKA74MdXjgEm5fYvBE0QTu48U0XpwvZatmIqO8asvI0Ybo+6q8V+/S1l7PSXJG3fM+yaVwrqXx8zRvL+Cf1guH8fL0ZQwWFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o7LRZ6yia6/1AmKyRMcSO8OOg3oQmu680vAdcPiozk=;
 b=gYOto2/8H+/DnnQdKR2aMBv+eu205SdAlxocE/IBCDYgMe+mJngNsaw9MbdT0DZuPQfeYbJJSUfpWUk6mWc3WrDv7bCZq0GuYfCHZafTkQeP9JXHOLX/TAcZ44wWmH7omkKJUrw2e1N5eyg5SaVSa7koNm8V6PuxLR8IXurlMra2TO9W2fv4gQVzT7JZzhqS5V0wV3TTJhJK+ptwynuiiKc1yWTZ8o8xNumQrWYpvJ4k7OmYKu8Abqr7rjKoPnjPkzmgI3Lbga3CJloF24LsCb8pNX92+EzIJh5XwxUgomuMpcN5o9AjV6ui27a4U2FRoL+vRfE26yenXkLab0I/zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/o7LRZ6yia6/1AmKyRMcSO8OOg3oQmu680vAdcPiozk=;
 b=jJgWKGf20UXolUqJs2Apt/WMbWpEstva8RN6mYOv0cHOrE1YBQf+b7wWYMBWx4BhICuJOMbUZf0NFh4DP+TdarvuIWLPqlljNdcYisHDdff1A3gplVHJgYzyq8nS3YtziVnnhFh9YaIaITvDOpPEXdGgJcFIuieNcfxant+B5vk=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3720.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 02:32:11 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 02:32:11 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr property
 to match new format
Thread-Topic: [EXT] Re: [PATCH net 3/4] ARM: dts: imx6: update fec gpr
 property to match new format
Thread-Index: AQHWLoHSZsTKfn2KY0W5vmilgDZ/AqixNB4AgACoEqCAAKg5AIAAxaRggAEfV4CAAGEUAIADURJA
Date:   Mon, 25 May 2020 02:32:10 +0000
Message-ID: <AM6PR0402MB3607C21533C208F5053BF167FFB30@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <1589963516-26703-1-git-send-email-fugang.duan@nxp.com>
 <1589963516-26703-4-git-send-email-fugang.duan@nxp.com>
 <20200520170322.GJ652285@lunn.ch>
 <AM6PR0402MB3607541D33B1C61476022D0AFFB70@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <20200521130700.GC657910@lunn.ch>
 <AM6PR0402MB360728F404F966B9EF404697FFB40@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CANh8QzwxfnQ1cACz=6dhYujEVtQoTCw8kTgkHi9BnxESptL=xQ@mail.gmail.com>
 <20200522235016.GB722786@lunn.ch>
In-Reply-To: <20200522235016.GB722786@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4d75629a-5f23-4aa8-e5ce-08d80053d3ea
x-ms-traffictypediagnostic: AM6PR0402MB3720:
x-microsoft-antispam-prvs: <AM6PR0402MB37206B682A53D334F2911817FFB30@AM6PR0402MB3720.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0414DF926F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DgjWH8XIiLtbBDGRCORw9NXbWNIJ0BEmmYJqxew4985o5h9Y7CKQg8GFwMySswEvK7lE3yDTs7wqdUx4etgyn7RtvvlxS4iyw90fzPFMiMb2JBWsSNk32qAcCbDChFiILi6mP9IN5BIykA9ITIvfugEXeC7Jq6dQaNw+sf+0/l3JMMHpYdc9WwKmsnOwTvPJA3BrULVpRG9L7/aOcyxGoSsfrhNBlTW7P4yFZnwXRqq+9CK4fsITUMUlkZxKamhuNHvbWkEAx1uXlCWH1wUGdzmf5122qWOqGyAJdVlmb4MevK56oeUcxzQXPL7Uym2gz+2b6UAbh/0D3NmCN6dvWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(396003)(39860400002)(366004)(136003)(2906002)(66446008)(26005)(64756008)(9686003)(66556008)(66476007)(6506007)(76116006)(66946007)(52536014)(7696005)(4326008)(478600001)(110136005)(316002)(186003)(54906003)(71200400001)(55016002)(86362001)(8936002)(33656002)(8676002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Q7pX2J4/m3fYlrtGiyPJ23C2sDRT897S7GuoE6eKDbUr1WS0UxuKnrd3ND0ChaMcp6tZxaw7hentftMRETPT2mdLxx1dADPt5/jDyngI4rc4v7yTFCuHlK9fQBEl/lGpTUoT8sxzrArxXC3u0RUJu3lAVl0SYVaCI7vxinPrvSwonrl0g9wBDTkF6T83FNuQxScJEYeRM1+TN3Jmd2M15cYSk/kkCUB6q9U7dNV+0vXCjclLh979QpPu/v97z6gvlqKurMLERSJK5SiXAkwpYAURWeS5bxzThb/dsnAezyR1D4jrGRMnmCbIHeCzu+EFzEhRr3gS4SIXcxBKsQCa+MA5gnnOYohPMKBkt9UMPGUdn3YY1prZdAp2yilpVO4uIYi3R8npk65ubqESJ4CHkbAEQjNbZiY+ny3ahGqqrEv+3oDAFkNy6WNlScptjSOSBEdDe6fPGFOvZOS9Bm7R76/BLdSzFJf2V6PxqXZ8ET4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d75629a-5f23-4aa8-e5ce-08d80053d3ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2020 02:32:10.9967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OeDNGB1S2NwGsedOjAAAFZDNbIwh5JVgx3FJzQKTva9hi6uNSOCED/A4d/d9Hq3o2BCeCTOAdi6Bgwc9dHao4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3720
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, May 23, 2020 7:50 AM
> > Yes, I don't think anyone is saying otherwise.
>=20
> Correct.
>=20
> >
> > The problem is just that there are already .dtsi files for i.MX chips
> > having multiple ethernet interfaces in the mainline kernel (at least
> > imx6ui.dtsi, imx6sx.dts, imx7d.dtsi)
>=20
> Vybrid is one i use a lot with two FECs.
>=20
> > but that this patch series does not
> > modify those files to use the new DT format.
> >
> > It currently only modifies the dts files that are already supported by
> > hardcoded values in the driver.
>=20
> Exactly. This patch set itself adds nothing we don't already support.
> So the patch set as is, is pointless.
>=20
> > As to not knowing which instance it shouldn't matter.
> > The base dtsi can declare both/all ethernet interfaces with the
> > appropriate GPR bits.
>=20
> I fully agree. All it needs for this patchset to be merged is another pat=
ch which
> adds GPR properties to all SoC .dtsi files where appropriate, and optiona=
lly to
> a couple of reference designs which support WoL on their ports.
>=20
>         Andrew

Okay, I will add imx6ul/imx6sx/imx7d/imx8mq/imx8mm/imx8mn dts change
into the patch set in v2 version. (before, I plan to submit another patch f=
or them
once the patch set is accepted).
