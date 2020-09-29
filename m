Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6AC27CDEB
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387606AbgI2Mrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:47:42 -0400
Received: from mail-eopbgr30042.outbound.protection.outlook.com ([40.107.3.42]:3207
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbgI2LEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5MWHLx1qpoZH6zLR/rXyzKTF3fzB2RCqdo1kAuE2N5i47k/R1T71O0OMynl4lusyeZXFlFrABsVCcc8KUhTmY1RNkuqRtkY10QTl9h1M69gULHqy4z2t3J3Dqp//NSg9coiC6ZHhM207Atw3rUUy7sZHZfIbJuAsDmOA+z4wNfls6cD+0oK2BABlGtAbLcyUcxbZsO3s0vP+n9np9UXuzYFrN3wseRjN6WMWvLOm2W+d5RpQ/1dg5fPXR52CiV3Gip/afIsuVSsDU3qLKCxmKT9BLtXCnkvyNysoCFG5ClSj/fEntdXvPiaJPEnur+0HZ4CR9xRJ3XQCE+kbbMMHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T/mwWCiJVmEw5zcDd2Eg306APgDERO7eiEMGTMaN48=;
 b=QSwrnnRis43CACeV8GGohwk3YMdoNzNqZZuAGPoA+6LMmEGlte+09aKC6RM/w4PcJWXyV63o6j7MHbVbCdbaYDdPMN6djLI4834XWapwa1WEMtEt4ZSX3/k0foyMv2e+OumpMgyWZCbP3xvIv+vzxBybbTIscKGISqEzgynNsCCbKQ1jLoXM+UBV8kHUXU9i1Ouh/lkhPjLMvW5swMYFXOJkaNLGcV4ZJ5zINoI+p72FpuohfNjR91tyYWBHMtJzj3QHY4Z80TlRR+HpOz5bYDwnFg4ucgq5/cYN2isoc6lFMd8t5u0JQdaIIyEA5u+isoeTsy1Hd2HK+oDVrw3NdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6T/mwWCiJVmEw5zcDd2Eg306APgDERO7eiEMGTMaN48=;
 b=fEGa96oOa0RjHbKYpQH9NIeSPIZeIukMKsg0TwY4fKofhPcyWKNBqRGR/BGFTqj0iUykuEZG3DtpSIMTUijk4Ma1wBshwqIdSbcwWqBkJvv21LTxN/9MRyoZizEfGDPACxbO+QdOb7HGFw/5S7xrk5J27sZrJvPxByGwi0dq3k0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6941.eurprd04.prod.outlook.com (2603:10a6:803:12e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Tue, 29 Sep
 2020 11:03:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.032; Tue, 29 Sep 2020
 11:03:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Topic: [PATCH net-next v2 1/7] net: devlink: Add unused port flavour
Thread-Index: AQHWlEkF4CNV15jT2UqI85y8iY116Kl+lQCAgAAJR4CAAACrAIAAB7MAgAAAfwCAABGJAIAAI2IAgACb0QA=
Date:   Tue, 29 Sep 2020 11:03:56 +0000
Message-ID: <20200929110356.jnqoyy72bjer6psw@skbuf>
References: <20200926210632.3888886-1-andrew@lunn.ch>
 <20200926210632.3888886-2-andrew@lunn.ch>
 <20200928143155.4b12419d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200928220507.olh77t464bqsc4ll@skbuf> <20200928220730.GD3950513@lunn.ch>
 <20200928153504.1b39a65d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <61860d84-d0c6-c711-0674-774149a8d0af@gmail.com>
 <20200928163936.1bdacb89@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
In-Reply-To: <c877bda0-140c-dce1-49ff-61fac47a66bc@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a01d2e85-05c7-4cc9-f543-08d864675cab
x-ms-traffictypediagnostic: VI1PR04MB6941:
x-microsoft-antispam-prvs: <VI1PR04MB694187CB54E0F4A83CB6830BE0320@VI1PR04MB6941.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D/fxlEpsVNnAzNGUWDSCsj+OshD8WTu79zgvOeC7eQrS51ufUEOhvB9JQhIXQM0Wp53hfMzR7TlpEXe+iGNYoMASayX2CYvs6+++yXFaXx6ZtYiPfuImuqn5D+xXpEOsJ6Bq3p2oAimDLF78pm85wOJRfK4RvVuxYmhxo/ak6pW1v2Em1ODjxX/DgXUxQbXkJZCTHs6/2ZgoxuAOfnwpcd7wG9GDMM1+CYt3cJ/pyGyGfhQtYMDE68FqQxbgMT/mnBwNvwRU0AQShhcqNGQEn0VeDTp9Mcf8vufwxEfbhlDD5a09Wc/mUsOrnm3QB650YiZ/zo4UUdWFeC7FiHnqHPpzo4hWUtOPC0HWHNnqS2lPUq9VczismrOaUkSU9bh0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(1076003)(71200400001)(8676002)(26005)(4744005)(4326008)(54906003)(66446008)(6506007)(9686003)(8936002)(478600001)(316002)(66556008)(86362001)(64756008)(6916009)(33716001)(6512007)(66476007)(76116006)(44832011)(5660300002)(2906002)(186003)(66946007)(6486002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N5ffJa1QFjGEQxKo9hD4Tr04W/pSm3SEEkE2G5oz/jQonHxWowKPXqLvHF2/D5e6SpGTLnPOh1h8hhv4IWh95UuzJsy1Dyk5A9WgDrLnsIF8lzCOJjSOKKFmPcyarcU3iFFIRsaN66AtdRDpo8+Rl7NWwQlLlbaCllOhyKM5/g9kjhO0+xMFsQQ7s89PIXwH1hoPvSV3W/MklOkRWxKTW5YEAuTIcfx7I5Rh/kW8ZgPqB6BuBbvquDEdkh85NRwVf3cDhrlHMC/Lo6tVD+P7dTukO6ldBHQNGfyF2+5hQUi1RyKD5T13vLAfFCnBKVCcI4Iw9p5kUtE3TAFpcHPtSbvurUneXcsYGuL+JrdZEIt/sUyY7s5AgQCIc1qkLObax03Qas26FBfnywilyN9zKsDGqSipuMd1cp23ZKLtSRkaVpnUm34GV9HnERirJzzFNdNLKHy4T9iZ2bhd5A89QRCeX7GzpmdrdEWimXjwzJJHZAdfnYTPoEfL+SHt+U8mJ53tc3lnc2oOq28IbMwTtj6rRTh29hUymrNtwbvIpFbPIoSHitUoXU66ZtqBLpJ8LKZZo5TVFFKU1yg0zwaz+UBaaEzdlZpl1OFDTFfR2he9opqNPTrkHrZvHJvfoUYHTPo0BI9Sn/o3JFaUabtoJw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0959CE8ABB16A4D81D9A8C2FBF0A039@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a01d2e85-05c7-4cc9-f543-08d864675cab
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 11:03:57.1078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gtGwmWBXgfcm0oIDn6fOT2ZWNLxElSJC3CXZ9u0Ms0we75WoCYg/aevxc6M1TPka5uWnYMZBtCf8KHetDRr7VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6941
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 06:46:14PM -0700, Florian Fainelli wrote:
> That makes sense to me as it would be confusing to suddenly show unused p=
ort
> flavors after this patch series land. Andrew, Vladimir, does that work fo=
r
> you as well?

I have nothing to object against somebody adding a '--all' argument to
devlink port commands.=
