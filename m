Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24280193A0A
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 08:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCZH70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 03:59:26 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:39331
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726279AbgCZH7Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 03:59:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ml67QrSnU37goX368yB0z8lf7c83Oq+cKe+RVfnDDnPtijvxLXA5GThT3FRX6A9xHzTNoZ0Vv6nCwO7DCWMdQk0Fa/QsgnP29vlAzqxokj7xlMwmkGQ0BHlH/kTcONBL2LBEjnJG3KDNxFUMJjXge46ESOm+SR/psPnVFUHLMX17JHTnBTSzd3PBBosswJa9uuRKcdJW09vsJwlHsWnWaGSOodooRoIEhj3HriOrt4i7w8Fk/4wCYEaj9BRuPAM+vLrUy5REgXArRMHR4SybFa4pqeEeElBNFq4BWV82hScdNC5ljhYUIlSVIJMWtpSKezLlXcRIAnCprCql1qoqbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvbKp2cMV93dwUhpQEDEeK+kZ/BA9Rl5QGw3EG6S6hw=;
 b=C4cZ1H8S75h2h/Ok0jZwmc4zE0U40PwB7mjJ8XuGwj/lGtV+a3RuS8My95+eiSBwQn0QbNzKqxhWNgg77o1Ka5lD0/b4MltJ/Blm0ph0RsvdPuBuEWAIgYInxt9h00CHEOtvj/GS9MYWGHQ4Nbd45nzNy2qTOt6v9vFbPY7OnKwl0aaKGfRW6LT+JZRB48QgNTINyXnf2XujbHQ+SGcgyF/drHtlew9roCJDM9fLha0fwUJ0BQs136opKv71iuyKam9sdtzki8b/7U0NbRCS2mq8zJ5RjOoVPfvnuUO1Wzr+5x6o500Gs1TOiXhX6dGQLi9E945usZYz86fzGR6BFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvbKp2cMV93dwUhpQEDEeK+kZ/BA9Rl5QGw3EG6S6hw=;
 b=j0oT7vFfy99Ie1lc00ToY7R4BM2yXr5uI1xxwuJgZCd6ZodV3+uPAbUmIlBgXHxl/XVYkYloMcjmBFWYZ3rF3mwwBVzBX2FOALUTs4hIml0NPulywi8XVSvOIiftgu7v+cKIMPKe/ScJU8LUZF0XBEa/Ry7KIGcanBWof14unZQ=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB2941.eurprd04.prod.outlook.com (10.175.24.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Thu, 26 Mar 2020 07:58:49 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 07:58:49 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] [PATCH v2 3/4] dt-bindings: fec: document the new gpr
 property.
Thread-Topic: [EXT] [PATCH v2 3/4] dt-bindings: fec: document the new gpr
 property.
Thread-Index: AQHWAtDigL59/vfUi0SjmWgPNOv2tqhagtYA
Date:   Thu, 26 Mar 2020 07:58:49 +0000
Message-ID: <VI1PR0402MB360011C8A7A66BCDBC0D0D50FFCF0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1585159919-11491-1-git-send-email-martin.fuzzey@flowbird.group>
 <1585159919-11491-4-git-send-email-martin.fuzzey@flowbird.group>
In-Reply-To: <1585159919-11491-4-git-send-email-martin.fuzzey@flowbird.group>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ad93ba77-d124-401c-2a93-08d7d15b84d1
x-ms-traffictypediagnostic: VI1PR0402MB2941:|VI1PR0402MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB2941C401614EC4F9BC557932FFCF0@VI1PR0402MB2941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(66946007)(81166006)(9686003)(66556008)(7416002)(66446008)(186003)(64756008)(110136005)(76116006)(55016002)(8676002)(6506007)(66476007)(7696005)(81156014)(26005)(71200400001)(4326008)(5660300002)(2906002)(316002)(86362001)(8936002)(33656002)(54906003)(52536014)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2941;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KD/DcNhj3K4Oj7DXkWHxw4d7A8wKduznEjag9842qgrPk/4FfSlwKcM8C1fTbkU/pUqzs7uLw0IXc++/XvR02tyzXDxQkA6SZ7rMuFpdoE5uXSLAH7Oxr2YQ7BEHtwVXJt/DRZSLvAEYy6YPtqwShWqWimKabu2qCyxytYIfFra89p4+oeydHgQg4qgor55yHh+JpixV8ZxD44VEhuLMO3lySS4TLPwNbh/QwxoM7ojgcr++0SnKrEaXYzNFXofrpWaCwUpT9tPd2alvAAh1qq47iZbzYBPOsaCtBKztgVOJax6OweYKMIytPKk/MMna8C8dNYr2BLoNtWN5WSORhLPM8roMho1zFY28FbedQzMu6qxs48aagE0IgoWwRcx3m3gkl8SnoHjnWTZxiH2bu6exWUhTc09h7KTAqlSrgzyl79THXLR2AFd8GR3Qi8R/
x-ms-exchange-antispam-messagedata: xHhEpUEx0O1JIdXVeLjEfbNCbw+BMNPjrb27WvkQRAR/5kzrYVDkAunlc9N9J7YuumH0jiqT8x4ZmP+WsoMcRI097cfkEXn8WS+1cD3TJsWYy8aB7r/Riu+fCvRM+WtbqONNPYdUXfL9AjGmYNTbXA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad93ba77-d124-401c-2a93-08d7d15b84d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 07:58:49.5654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGewhVNNGLrpWjn8PlLVuVLTeSYgJlhb92T6hDQ0bvkWKkeRPMa5gXwBTG/88Dci+FRw/lyiMUxKOD3y4ADsMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2941
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Fuzzey <martin.fuzzey@flowbird.group> Sent: Thursday, March 26=
, 2020 2:12 AM
> This property allows the gpr register bit to be defined for wake on lan s=
upport.
>=20
> Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>

Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/fsl-fec.txt | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt
> b/Documentation/devicetree/bindings/net/fsl-fec.txt
> index 5b88fae0..ff8b0f2 100644
> --- a/Documentation/devicetree/bindings/net/fsl-fec.txt
> +++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
> @@ -22,6 +22,8 @@ Optional properties:
>  - fsl,err006687-workaround-present: If present indicates that the system=
 has
>    the hardware workaround for ERR006687 applied and does not need a
> software
>    workaround.
> +- gpr: phandle of SoC general purpose register mode. Required for wake
> +on LAN
> +  on some SoCs
>   -interrupt-names:  names of the interrupts listed in interrupts propert=
y in
>    the same order. The defaults if not specified are
>    __Number of interrupts__   __Default__
> --
> 1.9.1

