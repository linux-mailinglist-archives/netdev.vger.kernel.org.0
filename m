Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4D27B844
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbgI1XeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:34:04 -0400
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:8453
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726986AbgI1XeD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:34:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxY5GUbZKOx8HqZGoMSNTuMuIt2AColQdwQclU8eNstqzl3Dya5VWOq/R/05oG9/tenoJwYArleFrS/Fvmw9n9cJK+hFxy1qfJRYhtmhkJTxpCEcYhHVFTdzOxObrhavpdtgHltVCtTl8fkPBQj8eRom9D+ER4KmgSBwGNpIM4ZdWrJz+OjYuD8nw6D7b7vKlGS3vSl1RJHIIQq9D43+XeRy+8PnequjOr29L/ghHJW3ZxSqi4Y0mURR4QAX2/Wh5Hq86kdpMiqPO4cWAY7zt1D6MECPFpFvD9hvVrmPkf5kDtDoIy3FmqSd8vNrKZGYleaDqzahkyU3QWRtqEC1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qochAeEHBkGXJZVOVzIO48zCbNHp7tCwm0y+Q0ThHKo=;
 b=PkWLX7d6khp4u4ngvnfNj0h/kHY+qiJSdDZGsiFG1Z7YqxDpE86EqmY9u6e4Jg6vYwkmdlQ0W5OjYhV80JUFo4VIc9pcevMNvkAQNXwmz+LZHktXoskxhu3U4ECdRThuDSWB1nKns968g8ofMwb2keidL7hMQtApx5Dl9FSuwTB7gXJNz2PAU9mNQuOYt79HAgLtKNd/FrJZc3wOOqOGZCQsqwg/E5CskTmmGeSbg22tbYjMsVwRHHSLd7Nup0FfoM7Ye2tTL9Ou/bTaBNdfMBk3hpZShfPy+7VmdegtRBdKFTEJcNaYCwDOfCQ9SR7Awl+y4vwokxJQdiydONczHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qochAeEHBkGXJZVOVzIO48zCbNHp7tCwm0y+Q0ThHKo=;
 b=Gd40K3G9HqRmyz1BmAGhkaCiMRd9oNGqfjdZCzuQWHF47mR0gAsEFSHlpNz9iSAM2uZewuRmsX1OqNCV9AviQPTl8TK0UeqfUXl6cNbVVqHUtSmWpvHQgvDLJ1lNAfPyQ5pXFeF5k3tYnF+ux9I8f27DLhwiMc9O9eG5YjLQgPw=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Mon, 28 Sep
 2020 22:05:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.029; Mon, 28 Sep 2020
 22:05:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Topic: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Index: AQHWlEkF4CNV15jT2UqI85y8iY116Kl+lQCAgAAJR4A=
Date:   Mon, 28 Sep 2020 22:05:08 +0000
Message-ID: <20200928220507.olh77t464bqsc4ll@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ab1dd35-fc49-4672-7efe-08d863fa903d
x-ms-traffictypediagnostic: VI1PR04MB4910:
x-microsoft-antispam-prvs: <VI1PR04MB49101076ED63A5323AED0062E0350@VI1PR04MB4910.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CdMFvxf3O51DjhLcmf/NaDPEN93Hpg10OsTiCPRibgf05vJ/jrPoODIbemgzm5FT+4tCZx6rT50xDFKHtko+lQu/N28CrXQsmJnfqIB6W08jROcEQPqyj+MJZQluKiNuSAx8SZlbatnWElzHZX+YJ4es5QarGuOlutb3IVbx3s+0JBbtcCWL/dc/5sQeq3Sb8+U7IDfiHu11hPLTfY/E1EhYEbCEEuAl87s26b7UdAx/oasnliMRLAvLOdycGAUnCf1mwTyWfxNAZ8olfDmbV79eqSORc5UfM99nsDJzDe2okGwpD7bblHGk1XNE3WG+cBswK/fGXKEaMuqXsIydEYO2L+RVHBtP+zTxE5UTyknIW/Mm8LOXWtM+E8N0mDl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(39860400002)(136003)(396003)(376002)(346002)(66556008)(2906002)(71200400001)(8936002)(8676002)(33716001)(86362001)(478600001)(26005)(6486002)(66476007)(64756008)(66446008)(186003)(44832011)(4326008)(76116006)(66946007)(5660300002)(91956017)(6916009)(1076003)(9686003)(6512007)(316002)(54906003)(83380400001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: FheXtUIuuDF/7ZjmUb1cabuy3yItQlHKTwSGDPf9QN7qajFLgG0K4y4EYMqYqdfPB+pPqXHMGpq5GB0rHwLdpdMw5YvknHBtm9QsDY9juTZ7ROoWJGYoYL7/HdHsnUXDQfbazSwhLBJD2rOavHSGpjoH9uenh4pFms2r8aESwUIwmgHWskZJ+lUxwhTkzEj6pB7Q8MVi+dHly12zsRGe/GfPtY6OmVU3p6Pzg1UN4hbNJLeF5Bu5Xd7Tp4r46q+rBFIYuN3NgQjlEYB+iG9JR7KtnRg1bYHMFGwhbgNERIQr50jxOJ08Yl0k4PhXcaMMduK30nqQH6mlBsPs21iVbplT8PCNtQ2YtWoPhuJiuOxULsgxByb27MDCEmG6G545Ki6hxnvIi4HP+Et3etWxRSwYs/iKPlzShk/hU1yO3grz6AfeJdZYT1FYtak3fzL3duG7jzFksXaH2l4cpini8SEvuj7L/mfWcsfyIHYBHvaf07FliZCme/3iwvY8RJ7q2mTYamL1xgcYiOZvtWH5IRrwXpxdqKBZ86tUmvdd2GpTnbGLyfoWGfsG03gSAVBDsLq6FG8JfTUXvjPW6yadFEM5Cmo9UOeFpZe+TRBimFILDM2YmfrvOeo+kgBGwj8M398UCKOi/B0NcAYTerShuw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <442A18C2D422EC409A41B4E4BD56054B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ab1dd35-fc49-4672-7efe-08d863fa903d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2020 22:05:08.4818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z225vqYtrMY++thVOxNiLtTD23Vs8IF/aMhr+srpEcsH8fJcccw7HJKEnncW65L500SDd4PqLZB0yyzl+I3NOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
X-OriginatorOrg: nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 02:31:55PM -0700, Jakub Kicinski wrote:
> On Sat, 26 Sep 2020 23:06:26 +0200 Andrew Lunn wrote:
> > Not all ports of a switch need to be used, particularly in embedded
> > systems. Add a port flavour for ports which physically exist in the
> > switch, but are not connected to the front panel etc, and so are
> > unused.
>
> This is missing the explanation of why reporting such ports makes sense.

Because this is a core devlink patch, we're talking really generalistic
here. And since devlink regions are a debugging features, it makes sense
to tell a debugging story. Let's say there is a switch which had
configured all its ports to be part of the flooding replication lists,
but also configured other things incorrectly such that attempting to
flood a frame to a disabled port would leak a memory buffer. After
enough time, the system would lock up. So unused ports are not absent
from the system and they might even make a difference if the procedure
to disable a port is buggy (and there would be no debugging without
bugs, right?). I see no reason why we would hide them. Devlink ports are
not net devices, I thought that was the whole point, to have insight
into the hardware and not have to deal with an approximate abstraction.=
