Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B622A44ED
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgKCMRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 07:17:24 -0500
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:35969
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729039AbgKCMRU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 07:17:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9lihtzlc/3RWov7rlrOP4WteXvgzBS3Pi+oKt++b5t3o5aVKasj39EAqMgy9zKce042QxtlPzYviG3kpri8hj6Gozy7FPLBbJd5SceVc4b5HLJwPFomlaLrW5iS+vObFq7rYr/UmUFVP9eizjeBGumVjnwyNeCJO6p3VJtm6TSBCsENfq3l3dNkBRKadjSAuk0OTIccfhS38Rc5331BqPG6MqdZxMkIWB22+WLmc8ahutz1RkB72gF8fYJBTaXzgu1DBU7s0OJkBpO6IH4qSP77XBJ3rcuOHH2cBnar/oIx3vajV2AHJsNKINgn1u2IbpAZpOnqFOgLKfXQLT2IBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsOL6MZAFaZ2AHfCB6Lcs3szH3u45WGwdxuypV9fa5U=;
 b=TUAswjfTCQh6q5/U0Gb4ix1/n+8kUPzj0lTnP8mHqfBpVr1y1TWa+ekQqRxOd2BaSMg3umyVihcUCNaIyU/+SEv6Fr3O6/Q8oalbmKO5GaTKu4U4APO0WThuH7cTMjGJMtWBnESVMg0eYLHXjLpJN/eO788/PklMFs0Rvto7VJHz8hNuFuq4iaCRJlNcyyFpPoK6tycLh7wacGwkBA79yb4kK5jPjfdZcaVddmyq7Ibh4OkbMVHGrWIPgbqevBgLcXnCEHabHSWb0jShoYwB6pKWJGTvd0o7zKG3rZSQ/Y2gjmE/eHyfsCoVbqulXc3AMOkHugC64aWAlOWCvyPQiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsOL6MZAFaZ2AHfCB6Lcs3szH3u45WGwdxuypV9fa5U=;
 b=gkXIp6lQO/rw6f+3S2Psq8QZb8/9KSC3hkck+X/tcXHJwuqmNFq/uHssPOdpxCGxvv6uhJf4yFKZYju8d95MPNVygAcjKkgcMyDYAoWPtzKKvopv7TJLt29OkOcAG2+lqfkIGO5nl934rUwJarHqUf4W0c5H1Tc6K7v6x/W8NAs=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM5PR04MB3043.eurprd04.prod.outlook.com (2603:10a6:206:b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Tue, 3 Nov
 2020 12:17:17 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 12:17:17 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Subject: RE: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
Thread-Topic: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
Thread-Index: AQHWsUbWtTXtW26ph0aJMJHkduCMrKm2U77Q
Date:   Tue, 3 Nov 2020 12:17:17 +0000
Message-ID: <AM6PR04MB397664A5EAFF0596DA36E691EC110@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <cover.1604339942.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1604339942.git.camelia.groza@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [82.76.227.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 19fc7d3e-3f61-47f1-1a8a-08d87ff267e5
x-ms-traffictypediagnostic: AM5PR04MB3043:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM5PR04MB30435609A3AB387F7B5C4A0AAD110@AM5PR04MB3043.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q3SGAW2sVnAVTf11MpWHRRH9RRRmlgk8RIS6IOEIlobszwszjqvp9VdnHNPnVcACalLFeJjP5U3vwzIZMm+wEcwvw0/DORTsb/d3CMPT+YK55lp5UWd74etV8lcVDYPWZqbXKRLVgftqtnBXEgdbU43cWXJ8W+2UMI+a8YXzVmI42j7JYRfKsK5YZ+X3/nTpOQN9DMbW1L3NeoCoWsxmRaR8IpeK97NhQY9lXtWFafsTalo1rpsUsoL/iUSO1gPJkTw2Kpho0SPfDUxoJzH21VgMIQz9CXbIzX0aPvpSI3vntc8XW4+toExrcYCZxbtSlLVDM3lQoanKQAqbjHcvag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(316002)(186003)(83380400001)(33656002)(8676002)(8936002)(7696005)(6506007)(66946007)(2906002)(76116006)(52536014)(53546011)(66476007)(66556008)(66446008)(64756008)(54906003)(26005)(55016002)(86362001)(5660300002)(478600001)(4326008)(9686003)(110136005)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: e5B6jPLFF6FghZwY2W5hukP0QDEUBYcmL3tXTANwRPQFwWER+uAciVkjkt53MtoGAF6JZq9GxeqMmiioOzwbL6SHrOHualEU2NcjN0dfAVkRC64EGsUQYlAk5iad9eLnM4V0skeRFVY4LJgkoQIFaFmpnJepBxSUtWRV85OriGYKEAy3iDyM2hVvgT85OPoGY1lTOfAHTiMMn3imNuBiOYy91Nn8/XkZIpApsbR4ZqOs0sj3JIl9w3+UoQDuCXx+M4eNSCvKpGTa7n5aD8b/Ln6l1d1SHN37mUBQmLjMmhCBI3+tG0ZzxCk+gOYjreLy1LLoHvmQR/QvT8z6hKKH7K7N5ufJaQ+bB45ZcMLw4zia4k1u59nmw1jYOv2KhxAbBEHfsjdzM9PQ23QTZxQYpnKnAUeWYkJ6zSeabk3v2UXgB5Grs/oGKZbXaG1vPzafC1k2Ac1xOe5Gtz8tAqx1Uv4etBZKhxqPg/uresd+ATVDvZEg/HOHZBFIZvA8/LB9jAQf7nICdihVSaWKoH+tHHCvsqfgePHKDga1xREHho2md8HLTpkvKxgBZype07EoONY5YhoSi0wdjYLWaN29/jZ87/Te7IHk2VX/7Y+83DOsdBfc5hIBHZdJ4eEXewfclX/XYcVvzFoSyd8a8wCoJA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19fc7d3e-3f61-47f1-1a8a-08d87ff267e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 12:17:17.3516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpyYVX6LSPDtQYJOJvm0HbZfKtsOdW78QnLY5npdYqQ8/sS9cc7164m9sXTgUcSbMbYmJfk+SM0fLovMASN80w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3043
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Camelia Groza <camelia.groza@nxp.com>
> Sent: 02 November 2020 20:35
> To: willemdebruijn.kernel@gmail.com; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; davem@davemloft.net; kuba@kernel.org
> Cc: netdev@vger.kernel.org; Camelia Alexandra Groza <camelia.groza@nxp.co=
m>
> Subject: [PATCH net v3 0/2] dpaa_eth: buffer layout fixes
>=20
> The patches are related to the software workaround for the A050385 erratu=
m.
> The first patch ensures optimal buffer usage for non-erratum scenarios.
> The
> second patch fixes a currently inconsequential discrepancy between the
> FMan and Ethernet drivers.
>=20
> Changes in v3:
> - refactor defines for clarity in 1/2
> - add more details on the user impact in 1/2
> - remove unnecessary inline identifier in 2/2
>=20
> Changes in v2:
> - make the returned value for TX ports explicit in 2/2
> - simplify the buf_layout reference in 2/2
>=20
> Camelia Groza (2):
>   dpaa_eth: update the buffer layout for non-A050385 erratum scenarios
>   dpaa_eth: fix the RX headroom size alignment
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 28 +++++++++++++++++---=
-
> -----
>  1 file changed, 18 insertions(+), 10 deletions(-)
>=20
> --
> 1.9.1

For the series,

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
