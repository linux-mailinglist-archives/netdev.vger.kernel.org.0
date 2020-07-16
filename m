Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B081221A73
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgGPDBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:01:04 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:35168
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726998AbgGPDBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 23:01:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8pGgs+6Y4wmdb5EC/irfA1WkY2/8ZstTmZ8GJrvKNgk829xK5E4n4AaZt9LcKDtYbVeWtOXNPNtGL53OK5iQ5feu/Vc+uyP/NalU8D4RWv/fOzLo6N/xmY69PQIc/5djtnUYvZ686FqpwAm+c3If1yPtKESSklI7yvQbeTHSFP1tPaLXcZQn0+pyuG5LJR4F3iy/uXQXQCt39nNrfPAfSBDlDR4BfLoL7RiUHO0hvHERfUdY61KSUeJvYE1HGB5iaEumQFYt7yzizHdvckV5768YcjXJnDaND4zHwSyOr7EKlpiusXoblrbSbjzrGd+9lW0vJtaa+0dL3uqmwjiDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVpE3Ljz0RSpqiTT5D+/SImJVtTPFtinOCSnoOFyUSk=;
 b=XjK54thI84DSuCfInT3Avf/69prq9jnIQpgPN6sK4T3OabIugykun9ZAIugn4fD+EVwELlReJiTu+LpPsqLIfiMyXqMuzkij2zlAKegRy/uCOp2/idzKDhHgtpfzW6L9omqvRnJ9m/oYIDX1B6n8u1xoc0WWWREfp9YzIR5p7qzHxd7UEKx7iJYTxer8IzmqI6UZGSFauveQC5bsw70tCs0a80JLHR3cMBrcVlBUbBrdhfHQkam7DyuOAukR0iIzRnpB6KDNHrW0jQVJTGVBq1usfyvWPEtbyqC3U/52gpZtkeInVdVBGS7nq6tWGw/ZP0Bij0d2JpaFK/v8vwaIuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KVpE3Ljz0RSpqiTT5D+/SImJVtTPFtinOCSnoOFyUSk=;
 b=XQfAvT6Z3LK6fIkWAcvLI3wqnaVp1Fxl73jQUFAjPjq7/L5gC5hLM/qdoypmFNWiH90qLexM5MCHRzUygLEwlzsQGXktBI5udrPScRap7tZW1ZTwuJQ0BW1BKV55uUD/OQvH8I/ys81NF+VoHgdSb2X2NVK1STmU4Y4wSjq0d8g=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR04MB5688.eurprd04.prod.outlook.com
 (2603:10a6:20b:a5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Thu, 16 Jul
 2020 03:00:56 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 03:00:56 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sergey Organov <sorganov@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: RE: [EXT] [PATCH net-next v2 0/4]  net: fec: a few improvements
Thread-Topic: [EXT] [PATCH net-next v2 0/4]  net: fec: a few improvements
Thread-Index: AQHWWr6ibltQtnA9YECq6XGYxzCLvqkJhMYw
Date:   Thu, 16 Jul 2020 03:00:56 +0000
Message-ID: <AM6PR0402MB36071DED4EC0FAF0A02F5872FF7F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
 <20200715154300.13933-1-sorganov@gmail.com>
In-Reply-To: <20200715154300.13933-1-sorganov@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1b726b92-b0a0-4216-92c2-08d82934760b
x-ms-traffictypediagnostic: AM6PR04MB5688:
x-microsoft-antispam-prvs: <AM6PR04MB5688BF0EDD9384AEAB900012FF7F0@AM6PR04MB5688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n1jCQlIzm7VEPhAoC6YBAKdSrtXE9GvCw5s8VxUFmLdF4jblDWR7ALJq180by/Z12Eil5hysrFp8cRyYM20O+jbpM6iFgr9c12OJMLCof/0IQbCwSwCODRtjBee9Rc/TCib62BIN39lA0EidmEj0TQpsvG9A9kQx/to7YcYsGlSKOF+lNSTZQCt49VkI/4N0zrXwD9S8pHgXQvBveAsZqYr2TB5O2HIRB1KKWxjojAYyCWWBi96rP7JAnsultqdDykcD5+8W2chRytPfI8uZIt8CDYhyaCSvHR25yq68AxLBd++CEEouYzSssD8/m5qqa4mfru2svSVfLmJFS2IRXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(4326008)(7696005)(55016002)(9686003)(478600001)(26005)(8676002)(6506007)(8936002)(86362001)(83380400001)(5660300002)(71200400001)(52536014)(316002)(110136005)(76116006)(54906003)(33656002)(186003)(2906002)(66556008)(66476007)(66946007)(66446008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dBL7VW4eOmsRQ+oRa5KfWW8vUU9Pc51JOpcfdqCGvm/fBxkS6laxVRheAQtjvKeF0ZoRejOskXSp2OfiPW2MoHjCLc1zGTRcGfK4kO5kUsMqhgEg/D9oZBc0bWesobh8BR1xF2DWI7W0/wuZGhEoUj1WWosmqWDLPo2/cSQEtBw1E2NItDS/bFg4JvlNsFRkrVf6TVCNbIVFnKoom4J5oEqVj6eQ6RocYqVS05nzC+WGXaEEZmFvqJ2MaH1F1TuA5qSpuhYjhSlfDXP6xe8qFi1Ce2RcBggrnqMJ7n/BerbcTn+raGLd12WD2RTGGNfDLNltu7+swUvMfznSxg8ebByETuzq2FjfP6IT7oaxlUhzimlzC64j64EEcs8HPUGdX6h76wn2TCfyCMFjXLt7CbOpnZWzLRBQJxJm57VU7enOajJFyhSIUUX0q6Ev7OLTGvLv2F8dYCA2nka8ndLyUOPm/SbixZhdLzwRoWXH6fk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b726b92-b0a0-4216-92c2-08d82934760b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 03:00:56.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXvo+SsbjrmvfwXPEDhIHu5Hy87+7CT4ehgsFU7Rmc/04RsZPP8wU/YQwnK89XnthenGiQXOge041ws2Oymhvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5688
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com> Sent: Wednesday, July 15, 2020 11=
:43 PM
> This is a collection of simple improvements that reduce and/or simplify c=
ode.
> They got developed out of attempt to use DP83640 PTP PHY connected to
> built-in FEC (that has its own PTP support) of the iMX 6SX micro-controll=
er.
> The primary bug-fix was now submitted separately, and this is the rest of=
 the
> changes.
>=20
> NOTE: the patches are developed and tested on 4.9.146, and rebased on top
> of recent 'net-next/master', where, besides visual inspection, I only tes=
ted
> that they do compile.
>=20
> Sergey Organov (4):
>   net: fec: enable to use PPS feature without time stamping
>   net: fec: initialize clock with 0 rather than current kernel time
>   net: fec: get rid of redundant code in fec_ptp_set()
>   net: fec: replace snprintf() with strlcpy() in fec_ptp_init()
>=20
> v2:
>   - bug-fix patch from original series submitted separately
>   - added Acked-by: where applicable
>=20
>  drivers/net/ethernet/freescale/fec_ptp.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
>=20

For the version: Acked-by: Fugang Duan <fugang.duan@nxp.com>
Thanks!
