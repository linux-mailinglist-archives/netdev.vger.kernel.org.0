Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB67A2E220
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfE2QS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:18:26 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:12771
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726396AbfE2QS0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 12:18:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwV86SBBcW84u2+kpv7JOJzYKFmWovxWgXU18Ndjtj4=;
 b=StGrMje0UFKOZNuddTsSNPHm59NgvMHwg8BFxNJTmzV86T/CFPA++QLJRJA+R9wZ6K0pR+snF1oTV0y9fIgYCUiK2EwfiKrVVIw6eJBPYIgPFe882seLFhvC4QKh0l62w5y7r9lUZMg2UaXzTTDx1R37oYiM1G5QdJ3n5ludsdw=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3437.eurprd04.prod.outlook.com (52.134.3.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Wed, 29 May 2019 16:18:22 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Wed, 29 May 2019
 16:18:22 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 06/11] net: phylink: Add struct phylink_config
 to PHYLINK API
Thread-Topic: [PATCH v2 net-next 06/11] net: phylink: Add struct
 phylink_config to PHYLINK API
Thread-Index: AQHVFXx+Jo7DTUV/skyQDJJUBAdOCaaBtVKAgACStqA=
Date:   Wed, 29 May 2019 16:18:21 +0000
Message-ID: <VI1PR0402MB280020D1730C4860CAE9F855E01F0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1559065097-31832-1-git-send-email-ioana.ciornei@nxp.com>
        <1559065097-31832-7-git-send-email-ioana.ciornei@nxp.com>
 <20190529092845.4bc7439f@bootlin.com>
In-Reply-To: <20190529092845.4bc7439f@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95a68158-50b2-4b63-ddc1-08d6e45144fe
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3437;
x-ms-traffictypediagnostic: VI1PR0402MB3437:
x-microsoft-antispam-prvs: <VI1PR0402MB3437B791157A300A2568CAC9E01F0@VI1PR0402MB3437.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(376002)(366004)(346002)(189003)(199004)(476003)(7416002)(6916009)(3846002)(478600001)(316002)(14454004)(26005)(11346002)(53936002)(6246003)(4326008)(9686003)(486006)(446003)(68736007)(55016002)(6436002)(52536014)(66066001)(186003)(229853002)(71200400001)(71190400001)(5660300002)(81156014)(8676002)(305945005)(7696005)(6116002)(73956011)(256004)(25786009)(66946007)(66476007)(64756008)(66556008)(66446008)(2906002)(8936002)(76116006)(74316002)(76176011)(6506007)(54906003)(44832011)(86362001)(102836004)(33656002)(81166006)(7736002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3437;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jCTgXeeURHxdrbGy8vzE9ztdytoQ22pgo/Xl462jm6Fvk+YiFYMOlHzpR2ZGyG0ro70OMLalr2GLkSpCoLIXO8qE+QkeOvA4za6loMxw7lkFGHf0SFI0ZAcJ/PuysUOs8OUxrHQWGFn4c+SHSQhNj9PUkBjI4o/hGRBiVgyJ4IBH04H1LU3/DPHNT4tHfudt5CR9IBGkZ+8z5cavPBZNgrCQYnZvL31fw9yOCimWrGI++UaH0Zm57xjQHdRCyBoDCVXmZrMgeEqmPewrnQfrI/PUD5NOE3w/qk2q8Ypzd3RY2Ge9OmHLDfaC3O4gjGTHWCxqlpF0vJqZH7s4UdUnJ2RkZtOBh9ajzeZMiCTcSdRkPG6S7F/T/1tZw/w+NexKQOEbJFdhc66w/nWA5sAgBgR4FISuOj4P+igbfBe1AGk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95a68158-50b2-4b63-ddc1-08d6e45144fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 16:18:21.9340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3437
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH v2 net-next 06/11] net: phylink: Add struct phylink_c=
onfig to
> PHYLINK API
>=20
> Hello Ioana,
>=20
> On Tue, 28 May 2019 20:38:12 +0300
> Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>=20
> >The phylink_config structure will encapsulate a pointer to a struct
> >device and the operation type requested for this instance of PHYLINK.
> >This patch does not make any functional changes, it just transitions
> >the PHYLINK internals and all its users to the new API.
> >
> >A pointer to a phylink_config structure will be passed to
> >phylink_create() instead of the net_device directly. Also, the same
> >phylink_config pointer will be passed back to all phylink_mac_ops
> >callbacks instead of the net_device. Using this mechanism, a PHYLINK
> >user can get the original net_device using a structure such as
> >'to_net_dev(config->dev)' or directly the structure containing the
> >phylink_config using a container_of call.
>=20
> I see that you mixed both to_net_dev and container_of uses in mvpp2, is t=
here a
> reason for that ?

When only the mvpp2_port was needed I chose to use a container_of directly =
rather than in 2 steps: to_net_dev and then netdev_priv.
On the other hand, when both the netdev and the mvpp2_port was used, adding=
 just a to_net_dev was the least disruptive.

>=20
> Other than that, for the mvpp2 part,
>=20
> Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> Tested-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
>=20

Thanks a lot for testing.

--
Ioana

> Thanks,
>=20
> Maxime
