Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2381273320
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 21:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgIUTr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 15:47:59 -0400
Received: from mail-db8eur05on2088.outbound.protection.outlook.com ([40.107.20.88]:49024
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727197AbgIUTr7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 15:47:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3vPD4jLEcn7KSGLUFrHcwkZPgTCZ1fqSNJ4NRjNswPIhagQbMbj4zbil007Xyo0WmBIvFP3Ag2uLYm/AlFPXd8KExTDoXxkm2fbdHYPseBOuLAQPMxr449esK8EF1fghvFu3fvejA8zBRXU9WcRV7qG0W9yxRAZy1ihbVL/mCvHTdQqE84D4jBUpso5XTWfNZmWskIOGgseU1Ogn63Bs0GWLrWiWa5VG33PKO03SODFHK28HC09OVHXxpQCWSNAYqCmiP1J0oCVi596i3v2acssk03jUCf0MdXS5os/EujipRWw6A4eB9WJ4nR2shL8zHMPRQrnNVz0AIFrknZhpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haDzqRNZkDAKL5bULPFT79IH/OFxxYNZrOqJ0xD1fBc=;
 b=ZY+eKTFN+P//ifW/3ryIo+GcsVjhgCFex4Aa0Di+GmK+27zcPCoO1D0lbPK6ic/6Oco0XNgOhY7y3x/hImT+t3atb6wcC/4CeMMU5jEa1Pv0UESBOTvB8m7yckrEK+lRRwIoahswIEAkUH92YcHEwRZ/jow1KLFX52WVnEVibNsE7Y9ub1ox7O6T/H3VjcEMRSXBDk1+BgdZobkdCGMfGbO3aUXiN+XIafR4pXVLGaCV2LxWmhYBTM1ig6Fxh2IVfN5wZdvJaHdpOdpchlaqBv7iJQ+pp4sIEUQhdw7TVSJ877VQtpB9O8pM7XdWiKKML4kSecP80ekYRtfDB0q/Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haDzqRNZkDAKL5bULPFT79IH/OFxxYNZrOqJ0xD1fBc=;
 b=aCfiGQWc0x1l/TIx+2I5w4Rq6mnuShyYBfBid7dGcM6GT+ZSk6YTaAbP4Bl7QmzUvTy+qD10zTD1AA84rywp+VB7mQrPbIPijpL/B1CAsxye+rv44gNxdyVdrRQ+mujbd1Brq2J2s6HuWrJyFvZSGz17vKQjcul03Rn4/q4FDLE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 19:47:54 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.025; Mon, 21 Sep 2020
 19:47:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Topic: [PATCH net-next 0/2] Devlink regions for SJA1105 DSA driver
Thread-Index: AQHWkDQ9QATQ1ChqX0Swkc7eW6HAIqlzVGAAgAAQswCAAAkMgIAABT6AgAAB3gCAAAjzAIAAAZmA
Date:   Mon, 21 Sep 2020 19:47:54 +0000
Message-ID: <20200921194753.axrpneh3eugz757r@skbuf>
References: <20200921162741.4081710-1-vladimir.oltean@nxp.com>
 <20200921171232.GF3717417@lunn.ch> <20200921181218.7jui54ca3lywj4c2@skbuf>
 <df33c443-6a4c-537d-5c06-8e984ab3e0c7@gmail.com>
 <20200921190327.GG3717417@lunn.ch> <20200921191008.urnhrb4iuk5hmzer@skbuf>
 <20200921194210.GH3717417@lunn.ch>
In-Reply-To: <20200921194210.GH3717417@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 714d64c4-8a04-4c4e-b3e1-08d85e673b66
x-ms-traffictypediagnostic: VE1PR04MB7374:
x-microsoft-antispam-prvs: <VE1PR04MB73747319794CDCE0DD71712DE03A0@VE1PR04MB7374.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c4TCNWKkcajdCE5PBojaxi2v4HbFuj4s6STjYT3u/wbDhe83DuUDxsYxconFsVB//uJkaZcdYHpxxYkp2ZBeXRz9L0f8UYnlS7/GcIxRTeLzAxKgWMuO9RzpODmNOOV8j8KUReAJWxPtDWGDqb7J6ghbdKS1PPA9HyLf5C2nw9cZwfyEr2ApwePqcnOfdJ1O9CHX24qYTGacNVFN/7U3uBRvFqIMYZEt/UvxcsTS24isl515wco5HTSBJdgQ95kRDeUfNVG8cEF3Hj0dmde12T/yc6IFKS5Qw2Hy4YSkkJRraD2GX/QpmFp6XT1ezhi8kj9M8+GEwoCOZmHnnDpoKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(39850400004)(346002)(136003)(366004)(376002)(6506007)(83380400001)(6486002)(316002)(86362001)(5660300002)(33716001)(54906003)(26005)(186003)(44832011)(66476007)(9686003)(6512007)(66556008)(4326008)(2906002)(1076003)(64756008)(66946007)(66446008)(6916009)(478600001)(71200400001)(4744005)(76116006)(8676002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: lKDjT+kmdRK3g7A96gZGthRc8fnOeMHmb08zqSVnKQahgeYtLqDhGFoZeCmSH8AuP2+XivlIaMbw1OrJhtkwYtS+5CmpAFE70+eIANWIVHchfYHligWUzPRZ5ywv5YZZPt3LfvAEQayoJG81RzTDNwjeG3gnEMcNOkjOxWsAVJHtu0qnJAm5sMEPV1CvGuk/kW4HDqe8lehz3sWezdXUCG1k2RZrvnUK22H6mwDw6tmEAWc3RMev07cXODD9No04mw+EmHTayqZhL78IkmszxFvLX4Rs5h8YuiwQRDAD8O6ZzJxO76bLx5GnYhcO8B+kCHJJ8wSemS8WkFFWQekLp2c5oodgWRFPUX24X1yZooHB3FOjvD8ji1QyW6JEg9c9ooW3kUGZ6hWXGyPvAAHou4D9erWsZ2S6Y1S/Xb1EnE+Gi06VJqmG9NlUFXhk0S5PYD+EFpANFr36iUw/Id3G3N/++8vldaXd7J+wqzYtei1F2iP2cZF9myMjiicJZlpUR+xhvoJAjC/aHvLzFi/5YCxnysaYIuda6sFwQCeUi9j7IzXWhgEiLmMaKPkrdtsjDGcfBm0XDdwkTPZljB+NRM34NB73X6uqqo3/3tcKeB+QmWzyWQeNTQexX4DdOZUj/8I0HbiCrfqn+vqO00V7nQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C8E129B5E59B34E948C36C682099025@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 714d64c4-8a04-4c4e-b3e1-08d85e673b66
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 19:47:54.3064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sPLPzL5aWW0IlrtHuoARWvVkwt0JH7O1aVH592dsl9gylV+uHA5gqlpFz84eCw/vilDoprzy9dElSLlGErgiaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 09:42:10PM +0200, Andrew Lunn wrote:
> On Mon, Sep 21, 2020 at 07:10:09PM +0000, Vladimir Oltean wrote:
> > On Mon, Sep 21, 2020 at 09:03:27PM +0200, Andrew Lunn wrote:
> > > Vladimir, could you implement the devlink DEVLINK_CMD_INFO_GET reques=
t
> > > so we know what sort of device is exporting the regions, and hence
> > > which pretty printers are relevant.
> >=20
> > Should I do that in this series or separately?
>=20
> Up to you. I added it as part of the regions patchset.

I was planning to add that only if I need to resend this series,
otherwise I would go with a follow-on.

> I need to know which particular device it is in order to decode the
> registers correctly.

For sja1105, the device id is part of the static config, so the region
is self explanatory in that regard. But if we create a larger tool then
it makes sense to report the device in DEVLINK_CMD_INFO_GET.

Thanks,
-Vladimir=
