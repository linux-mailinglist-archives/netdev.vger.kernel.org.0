Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12E292BA4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 18:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730509AbgJSQkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 12:40:23 -0400
Received: from mail-eopbgr110100.outbound.protection.outlook.com ([40.107.11.100]:9687
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729879AbgJSQkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 12:40:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkCzrtby9ZKn/jmFxtoQplCC8Y0yz5aanwTde2bujErWtgESQj79IRg2aI6kRi7L6IgLe+0BiAgMGrXUqHwzEphCQkIqmkjSM1Sy9QOkaXB+Ir0XkZmMlLeCmh2lWVPiLLRPRCR8GpuCNLL/xYn9n8oJg3OonhjsJbDY5j+tqnPO2mgA3t0w0mUYHXzSsyJzEg/j4zP4vLPIF0nn4sZjk+4rRv8ChZcxLv6bB4HdYO0FYz6lFOBCMSJGDNW+dYymek9YuNWy/tdnUEvbepk1apSSVekMIUydcoCyd2GwhsGdzg9efnPdH3r7ABR3bEK7Dcn3c2ET6Oa1cn+2ALxFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt7VgHIx8NbG+Ds4qlxxYKfCHWmI55iZZzKpHh0ODJg=;
 b=T0ljcSv71N1Ez11i7legQFzei9dnglEH4MLaSnd+dhd/AqoRJZaswYinzRvbTEpKM9Wa59gM6G4rl07mLhNTT3V3jdot9suvFueACH1LLIOyahze543MEnN/wXARejh/zofJvsDrwkBGUbySRyuB6pS+0MCW6eO3aSIVRAycxtavm1Vb/+dp1sbGjf8AGWjHMet1h8HhGUqkYjprp/WEgZOyX1rxSxPmm8xwOFfVErfC0IGGuWGbNll0ZXQXBeVJgsF7F3MWxrAqFzb32gathwCfQf8tlhQMPKnTuCKZV8953sTr08gxA7mKopCeSTm5d6bDrgoGTNMXuF2mF86PCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jt7VgHIx8NbG+Ds4qlxxYKfCHWmI55iZZzKpHh0ODJg=;
 b=VRxkYGbbD5S7RfqiqG1s3OBputk3zVW63fwllubvjQszxUMlgwzk2LlS7TJStwEKeLxL01pfqMHO9xffprSc98/rqKesqyHJJdoHi9KkXajOrNzWb7WL94qJAGTeiG3RiOm2DPt+W0Q3u0wGTm8agADgA/xweLTw7oXftGEzu4k=
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:ef::9) by
 LO3P265MB2314.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:107::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3477.21; Mon, 19 Oct 2020 16:40:18 +0000
Received: from LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b]) by LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b8d7:c2a7:cbbd:6c2b%7]) with mapi id 15.20.3477.028; Mon, 19 Oct 2020
 16:40:18 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v6] wireless: Initial driver submission for pureLiFi STA
 devices
Thread-Topic: [PATCH] [v6] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHWpfNnC69OUf5kyEqGJu+7PrU+76mfGBIAgAAIROQ=
Date:   Mon, 19 Oct 2020 16:40:18 +0000
Message-ID: <LOYP265MB1918B212C618FF60333BFD85E01E0@LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM>
References: <20201019031744.17916-1-srini.raju@purelifi.com>
 <20201019083914.10932-1-srini.raju@purelifi.com>,<CABPxzYJaB5_zZshs3JCnPDgUZQZc+XRN+DuE3BjGjJKsiJh0uA@mail.gmail.com>
In-Reply-To: <CABPxzYJaB5_zZshs3JCnPDgUZQZc+XRN+DuE3BjGjJKsiJh0uA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.8.116.159]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d15a6967-27ea-40ee-9674-08d8744daa08
x-ms-traffictypediagnostic: LO3P265MB2314:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <LO3P265MB2314BDAB5CFD5502838C6AC5E01E0@LO3P265MB2314.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KMg6AFXO29vhVv6O6kaJ7up0Mntw1b7Q5XbD3eVAfiDUELMb2AaK8JCWedDodnBJJk2/bqMnhZmo4z+WFysxk9zd20w74UNmKGA6N4MnfaeN7PZkerqrQZVppkZiRNsKxbi8dqYLriZM2gKgl/ecPPL8cphzOuEWMbDxAAziRr0RncEbgCnX7FivSrecViUlpz4t/RBsjybb0V0+Ay/M+0ValUtoDXLa0OqMCB4/UkfvVBKq8F6TImwVJ+THuM5DB/Id+hzKinm6gZYowVatE9KHl21/hErkPKeDwDfJFOC/xdHUFjJcVFL6NzFT2902
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(366004)(396003)(376002)(346002)(39830400003)(136003)(9686003)(8936002)(52536014)(8676002)(478600001)(186003)(26005)(7696005)(6506007)(4326008)(66556008)(66476007)(76116006)(66946007)(64756008)(91956017)(66446008)(558084003)(33656002)(6916009)(71200400001)(54906003)(55016002)(7416002)(2906002)(86362001)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9CrjTJCpjzsUEDJgdrO/B2jbb+eD+KjkcWwp2gaBAuLlG84QawhFMtmjga4H42Mk0sEzUkl7etC3KgTh1qgKJlmEni64c+2AsXCLj7pFZnhEZNkjGBz9nCsT4yUZYOqAU5w+ogT16KuhzWaOMQ3KnNp8NbhKO0ERwwqCdebG3YPuOVe+ynI8hYvnPvLumOKOCsESgJDdXofOZRj+d2NFhLkXKkvYQpEa0xNl41rxV97+OmJziPJZT5R7D2AFm2EScwb9UVqQeRz3jql4WuXDglAFoK+rfaTjlf2hD8c0RVB5UrcP0ZvdxTm+TP/M3UwCm1t1yF4LDa6yVTCzmxxiQpW8RUnhI/Rd7Z9K1t4w6w34to65TiNad2/SrO82ly0HQQjQdBWDWYwm22LZXsgYGXTdEiorY3qWm59XQ8IH8Np7AuIH70QMUIxXrEsTMv2pYVugzPMqUG9IPi5ACeLCApzb3Y+PIFPY/Ym9qt8BDG2aXMKL7U7XjkR8S05rt4OQmqEwFqcLYvO26JYkEE1t2kUEUNvZX2iwPcMg8+zAkZWMIfI6h9XmGKTMwehtCO1YO+++XhFQvblJ5udz9eT/uAxkvEq7+qnU7Er9NAnJJHe8p4Gs/So7MAn2L2A0aUS8OtskTMpQ18OkdXvvIy1UDg==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOYP265MB1918.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d15a6967-27ea-40ee-9674-08d8744daa08
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2020 16:40:18.5703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QC3byEguPfVZkJrQ0SlFk1m90RXW8cUUGdCk+fX7b/jb7RuqqLnMuhRYzaVe/szQ8aCUjj6qrkGTTKeaoAU76A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P265MB2314
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Overall, there are many magic numbers without comments, this makes it har=
d to=0A=
> understand the code. Using defines with proper naming helps and for 802.1=
1 stuff=0A=
> can use ieee80211_*/IEEE80211_* should be used.=0A=
=0A=
Thanks for your comments Krishna, will work on them.=0A=
=0A=
Regards,=0A=
Srini=
