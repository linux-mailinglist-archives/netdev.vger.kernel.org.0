Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3763A2B4997
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 16:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgKPPjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 10:39:45 -0500
Received: from mail-vi1eur05on2076.outbound.protection.outlook.com ([40.107.21.76]:43863
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726321AbgKPPjp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 10:39:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFGwYsgCmJM58nmICvn/6n7KMRxtMqr60iGqXQBCwIwAFZWdVoepEJrHlqbVaOE4G0KZNZ+5s6OUjaJVO2Rd9yuhEyMdslKaYRIQsEsz42awQklw3khdqrz5MeZkAmHJ9ASDZn3gwRimq/T7leOBxEkYdGbkSiXaMei0cXSSXIOYAuXXWqP5po0ncNwjSM5JpmMFfznKid3fcGLpMCtzPU5AI2X+Qhlgqe8eZ4SSvq9yPGbKV9mfP3tKfE2oXoCNH/5vLxkb+gYChThJXrFB4IRKOIJDTqlCsTT7ExUdtQj5FAzSO/nBl2QUkiyA27mbuSix7Pg9aqtLAZHn16vfXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1OvycwIIgz5/I1hOw1kBuGllq7YnSszTVz/Ds0RnBI=;
 b=JlvkKLP6o6HSGczwb9M9PQLNhp6JtctvJ225fjbvGJZth6hSRCOYPLnYIaRV/BWNIOLYJ398u0mFueAx74pJXFUmyxZZ9+ZsTOfb1gLhcs+b0n92iCuglCjpjmzw1mjoE2suyNvpQQm0bUK1vPi8Jjd9Caj/8PPwusM/LoSuPYF+ZMANbptY0STRvenluwu0btENr30mZ+J+p1dTFihIKwvTberFmUNAUPWDo1BhKEK6fsoTyvpmmbVoU9Flhv7fdYA595tsLDWYPjoe7hxHxCr5wXvHTy2bFOrk+uCmhxO1m7w3cZ6f6KLUfvDJa8jmynlfdeXCsD7VLSSExLpcDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b1OvycwIIgz5/I1hOw1kBuGllq7YnSszTVz/Ds0RnBI=;
 b=kmOej2Zqiuu2q/PGHJH5p5azrYuZZf0uRDqcsRa7p+EgB+sWV9MA8+NC5V9jqnTijqT0Twb9VbcYebEV/yqEjB9xbGfohcqoGeDR+Axj+6ubH3fiNav6ANdpOUJVLvm+ooARA2OVxIDgXLJDoblc+IKLjYD77YsXEEjr0gLRgZk=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB5512.eurprd04.prod.outlook.com (2603:10a6:20b:99::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 16 Nov
 2020 15:39:40 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::7824:9405:cb7:4f71%4]) with mapi id 15.20.3564.028; Mon, 16 Nov 2020
 15:39:40 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>
Subject: RE: [PATCH net-next v2 0/7] dpaa_eth: add XDP support
Thread-Topic: [PATCH net-next v2 0/7] dpaa_eth: add XDP support
Thread-Index: AQHWvCbvFl9htBVYk0aSby+JbvxErKnK5H6w
Date:   Mon, 16 Nov 2020 15:39:39 +0000
Message-ID: <AM6PR04MB39764B6CAEEA27863F52A419ECE30@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <cover.1605535745.git.camelia.groza@nxp.com>
In-Reply-To: <cover.1605535745.git.camelia.groza@nxp.com>
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
x-ms-office365-filtering-correlation-id: 36c4abe8-8892-4fc3-bdef-08d88a45d4dd
x-ms-traffictypediagnostic: AM6PR04MB5512:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5512991FA541B0F8774D218CADE30@AM6PR04MB5512.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2oyUndyE5UjII87gGxAngybWGj7lxQ3Z1yFi9j2vtsXQf6hGWSHMa9Pz2gGiFR0a7S61FmQWq/wefpxiwJCJhjGgwIItQFaac5QbnWAfMU+qyPit7sVd6pgAxWFY0vTE2Jfojl1G2n2yLlJ4dKT9RCu2vxbEARW7l0I9ClitlI2K8iYJsFnJbJqoTamlWdh5OS2Y9cj7mrzxLv41/tBvHXoSnmSqrDFSZl8MpF0plO1eyCQJ/YBjHJzk/Z8UPX8SFz8OtJZw3YO6pOA0IKMFJ/h81ocVn9TPbivwIF1Zh1b9oJs0KvKPDcstTEQsCppFjnH/XAveRTf03s0hRgb3kQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(83380400001)(316002)(110136005)(86362001)(8676002)(54906003)(8936002)(33656002)(7696005)(6506007)(26005)(55016002)(186003)(9686003)(478600001)(5660300002)(71200400001)(66556008)(66476007)(76116006)(4326008)(52536014)(2906002)(66946007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 5F+wFMEPAGyQymf7ftGrFnRExvw2Nf4mZQazSArDDrbp9cqivVJXPnmTQp9qD6agbA40yBvCYiFv9arMTZ2uUNuIwfHHU6dbBqZw4pwCfYLgipiwUpiyvgM5g4+hqHCSPGmCHHCWn4WB3cNOY/Ha7BCFmG9URUZgNnRoujZI3D5yrafeCMd5X9GdwbMOIPIwtecwyz2TmyVix/kwsUmvtTwn9YdhGxw53XLFFm0BVXM9np76CXfRlCoaHRdB7pZVPCcAKPnFaQs+ACZRuVtHSFFigDzjyNCPiA9fw8AaG+f3gNoaguiuANp5X5BHf5ntzCevkaThKpBexqD4a4utcvKu2T+inwP+OJo/0YWkin87Ulfn/nJ/N5ImBV7BCqItjdOZG314H/Q4fhjfUJrrpEFx3hdxYnxy01A+vz/D+tHzHI50s0zto8Iw1iyIcyxWUr2Y8xrdORDjUzMgu+wCLLUYUDK//ZscaLaBCH10mizvXaaJVzZCtR82H104F5J9nGsUj8IIdFGAXW3HHcBx+AEu921pW531YLqHkF90JGUxUrF3o3mSQFPO5sFFMp0lb+I5p5FeLMsm52O33aDJ/IlJkW6gL/RagwHkAzaqbEH/CvoJk9ZPzSbBbZmjjDNaKWCJC4ByWsOwByfEYBDx6w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c4abe8-8892-4fc3-bdef-08d88a45d4dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2020 15:39:40.0024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 64AEC84+QAzJV/oNvEJUUFKH8HqG/0o9j3OXz0t840HSCmUjsnwnZAHiZRGOF11joWTdYFjqzbepc5rZGmyZAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Camelia Groza <camelia.groza@nxp.com>
> To: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net
> Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; Ioana Ciornei
> <ioana.ciornei@nxp.com>; netdev@vger.kernel.org; Camelia Alexandra Groza
> <camelia.groza@nxp.com>
> Subject: [PATCH net-next v2 0/7] dpaa_eth: add XDP support
>=20
> Enable XDP support for the QorIQ DPAA1 platforms.
>=20
> Implement all the current actions (DROP, ABORTED, PASS, TX, REDIRECT). No
> Tx batching is added at this time.
>=20
> Additional XDP_PACKET_HEADROOM bytes are reserved in each frame's headroo=
m.
>=20
> After transmit, a reference to the xdp_frame is saved in the buffer for
> clean-up on confirmation in a newly created structure for software
> annotations.
>=20
> Changes in v2:
> - warn only once if extracting the timestamp from a received frame fails
>   in 2/7
>=20
> Camelia Groza (7):
>   dpaa_eth: add struct for software backpointers
>   dpaa_eth: add basic XDP support
>   dpaa_eth: limit the possible MTU range when XDP is enabled
>   dpaa_eth: add XDP_TX support
>   dpaa_eth: add XDP_REDIRECT support
>   dpaa_eth: rename current skb A050385 erratum workaround
>   dpaa_eth: implement the A050385 erratum workaround for XDP
>=20
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 447
> +++++++++++++++++++++++--
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |  13 +
>  2 files changed, 430 insertions(+), 30 deletions(-)
>=20
> --
> 1.9.1

For the series,

Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
