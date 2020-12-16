Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146CE2DC711
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388287AbgLPTZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:25:26 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:54689
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388280AbgLPTZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:25:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nfLmTTv3R0csdclhooFM/3S9YrJNF9shJjH675KsJvte0ndOeZ0E3svVCl5dbBqoD/LXbzs6hr1pjYEPA/7IhjxBBSj2dnTvwm9Lm/4ZMbdXxaA3eijPPv5jXI7UCLSQktLA5MXOqFlu95wbhYOWQs9yMUQSaiz+LsVaWdNWfOVjf1qIWeOBUn69qmnKgD9Cgm4L5eOWwLIwA4yYLDd0X6ynDDOuugwbxHmrR+IkOzF/34ktKAoR9Way+cW4YxICWibv+c+RcU137wpKo1g4jFxL9hZk5IIhijXrGoHJn+PzmnDKozSsZqnOG68HisKGduOoqtIhxJXg4myade+gag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maergDhpmwHoQcz/oaJIWyj6Fsr0qsnLJ8qtjeqGYjI=;
 b=ED5EGfPO7uOZL6MvVHCU6TDIb8Sr/jfVXmX0c0W/f5KYpILqpElOUDxCbL2YzwEBR1DjFy5DKSw00Tp6qt40WI6rLn4OM4jHi4d7OOLPzDt+IPSYw8pGf4WLSpTd8EZh5eAJPBPK/U7ZeurIUobMGTI1AbPfQoZktelKezdOAfSHttOlXnDLd4K4QGeoXdy2lb1cBcqoIG19h8KymBAsptcTosQaSMjYsWmyiepXZf1b7jbw1m7it0sgmgUwMvUrRtoeDUdnrgqnFbQAhvXwZI8cB980H0TtbM1XbeNLnusUkZ6sOveD4PFDJQEniqBWY/xepVQwTmst59ZxALObRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=maergDhpmwHoQcz/oaJIWyj6Fsr0qsnLJ8qtjeqGYjI=;
 b=SXqQX9OONkoMr/SM5ofg1iCHZgI+/qUjse7DLyxr3waPqYO1vEIDNunWh+z41M/DdRfyK0G952sqqhFL7o+2PpMRfdlIPu2vPyn6g/+oS+PTq9YOBEA2GkmFNrfMfwJKA2QxOL2DeQCTD3BXF0Jkyy6w2tJAPS0SiI/Yz1PG6AI=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 16 Dec
 2020 19:24:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Wed, 16 Dec 2020
 19:24:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Michael Walle <michael@walle.cc>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net-next 4/4] enetc: reorder macros and functions
Thread-Topic: [PATCH net-next 4/4] enetc: reorder macros and functions
Thread-Index: AQHW0yhbDtCya7eYLkCOnFPrvaAGAqn6G/cA
Date:   Wed, 16 Dec 2020 19:24:59 +0000
Message-ID: <20201216192458.6a4j67jsxyfjdfyc@skbuf>
References: <20201215212200.30915-1-michael@walle.cc>
 <20201215212200.30915-5-michael@walle.cc>
In-Reply-To: <20201215212200.30915-5-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.120]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1bc1a4e5-93ec-4140-1acf-08d8a1f84753
x-ms-traffictypediagnostic: VE1PR04MB6637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB6637D6BFF7C7BF5BB5ECA231E0C50@VE1PR04MB6637.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y1oWLX37L4/gU528yqQO8I3jm8os1TUaIdoWqfn2dZbUuUvl8gJOUm2R08FNjedkHr2sWQ2ejemm3ReJzPUr6pL4OI+MwEyFoI2fX5MEnpdR+lrzYctH5kXYeuQq0rU0NDDyfD44aCHWOj4wcn6uc3vS6Y7Zh7aQCgNDdfj0VtaAM2v6HNtOqwijo1dKpLR+YV32W3WIbiGJP0q75RYNYhi0Ej7MOkc5fqa1UgLLDBM/8980gw36lWcv1UjfjVeuqLCf43dR9dO7AqwI9OYVk8F/1m065GtHz61JZ9h4shfpJCeFmHY4Y3f5HBABXON4jt3MhPJ3KjjaABHTI7WoBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(91956017)(86362001)(1076003)(76116006)(558084003)(478600001)(54906003)(2906002)(186003)(71200400001)(26005)(4326008)(5660300002)(6506007)(6486002)(33716001)(6916009)(316002)(44832011)(6512007)(8936002)(9686003)(66476007)(64756008)(66446008)(66946007)(66556008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?avq1UA6dNLNmosYyF/Kpulbarz5ojZPro0pecrvUrGjon3tSO8RdX6FRrL8T?=
 =?us-ascii?Q?26rasAQhifGHFegzGCegTvlQMKDC16ESCx5hcZu74TqHtXdzONfi1lXAxU4w?=
 =?us-ascii?Q?dw7l4fH6xBnO0SKeS55r1/Rj8vcWFpTjjoVYQOxMmL6/9XPGgPKbSueaqpVN?=
 =?us-ascii?Q?f0Sy4wBPRxcQiDsbPAoZaen/LKXGaJgAt4j0OgDJrBL36a5rUEyRjD+LYGy5?=
 =?us-ascii?Q?rJcV/EzWtT9tECrqjarsq1aO8bVNzJFL+aUWb89WzKMlMUHdHkId/9o0it3k?=
 =?us-ascii?Q?8Mv3Zg/mrXTRTLIhV3kE3IWtuwoPjSZFSVKedd8TGYzqjR0gW0Fig2M7IjFQ?=
 =?us-ascii?Q?TUv4IgZNIY+dWigmkL1RvaqNGvKbCM6jDFyUmiVfR4ziYVEMAvsKxGvusm63?=
 =?us-ascii?Q?yeS8HqQTdOUOosoKTpxQCHZPVABaUE0XLp7Y4oHfecFzjs4eKKRIizNG/HYO?=
 =?us-ascii?Q?fYNlssdmm+nxGLDhm5o16L513QSdOlpzzpYIwH2YmO0/UCBrDZnejzpb7V6U?=
 =?us-ascii?Q?/F4LHAlqbfBDlvnj1UVF3/f151Ss3xzAg43WxrPBKBXFf8QcIeMnqJmkiFjo?=
 =?us-ascii?Q?0yLTbcLIg6I/6qttUDfg/X8hUHVwLzOY0B7M6BoRPX0ORGR67w2iDYnmiNY/?=
 =?us-ascii?Q?yVAjT20aVCK/M3Ox7Hf9KF2jWSL6DUiHdXe+36C+XblfTtdD+JVr6YBCfJF6?=
 =?us-ascii?Q?NbL+Rha+jgwwsZrqA0I8k+g/aQmP0pOTTy//c87e9j32Hl0H9pNuZdDCjHip?=
 =?us-ascii?Q?gnzRv4Ie4+uC7j9BB3ct8u30zXrPH3bjKCa94WnP6LysffiPoUx4qUWEhI1N?=
 =?us-ascii?Q?wt0D1GkKl9RO1HcskZP/NM+fDezW7fWYLmhFc/lD3L6vppjlnw41+WjNZ/HA?=
 =?us-ascii?Q?ForsxVs1UtEmvlBzzj0zmzL2jQwxQNuJqSRrH6zl2cYA3AZdicR80fu3pqO5?=
 =?us-ascii?Q?Kmw3JxTcA5Ddveyw/cA4zDhPjoLlG7vMY0+R4LPnlP9N8qtpOjDmzBzxuUaZ?=
 =?us-ascii?Q?YOCj?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AF7B2790E24D2B4EB76830C76AA59E8D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bc1a4e5-93ec-4140-1acf-08d8a1f84753
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 19:24:59.3115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b7tSZsjbXS3NAf5hRvjlo+jgPSbxgdx5f3CM/jDZikvoEtQgCAJlCuhzNYbnqeWOEudO1JyMuEVdU+AhHwN25A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:22:00PM +0100, Michael Walle wrote:
> Now that there aren't any more macros with parameters, move the macros
> above any functions.
>=20
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>=
