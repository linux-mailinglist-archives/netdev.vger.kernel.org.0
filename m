Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868FF2A30EF
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbgKBRIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:08:32 -0500
Received: from mail-eopbgr60068.outbound.protection.outlook.com ([40.107.6.68]:28638
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727185AbgKBRIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 12:08:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDtI6Qc8/j+P65ML+RcEvM9ALsyjcHLVXDrcqchn49RTKSjHd8hS+wS71+KWsR5tFsC0AEnuda+0RNZjD2N7YUSAAZTNTxVR75DcZVdox27RFupWCb/NbF3X/P4r4RTl25Ft3xje9Ll9R3WDu4QgjfDSrxkZ5sDiRGZA3LboJqgcVl7Yy1wMjgtspWuGcYMD3sYB8PlDmz+8zwy2YDKLI4kIk1JiDdh8t7VMYDMN21EauK7riu6FjmpOhuXxchZuWcnhOCq+FTpu+NmGwgvnODxnWOHBSzMLA/F8PfBaJkw9v0Xge4SZ9KYxFas3RPsKj5pl0ZEYDrTXUYSJR3TFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZD3kIirfox+35Diuqv/9hC7hst5F7779Hbi6pZh9kBE=;
 b=O+LQzzek1laCVxd/mSviyJoaQeNTIALygzUShTiA6VlurcK8crg9H2wLbqyjPcbDz7TbfDOoxXA69bCG3kyMg2zYR+RK4Prrp0mNR2G/lPAZlXVA1de3r1MUaqXorYmOt47k3x62vd5OOWUip7l+QCtM7PhCEHEQBFLjTlq0uAOZNb/hve710imHstmzceecnl1uuMtEfAtiF6RLlXzNDCEqBcF3xoTT9+xRzrNYYyhIS3mn8F6gKOtCARRYw6tywECJiLVsa0Azxp/nBaSRFY+agz78+auAWjdBFyKOS+26ADs4FBcHiYsGgx2VsW7d62zRr4S4aaoueNZX9n8rIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZD3kIirfox+35Diuqv/9hC7hst5F7779Hbi6pZh9kBE=;
 b=NMhgob0SsdNAc0ljq/8hoYpokWqT/RO4VidatMLp9XSLAuTFxAxY8WnQkErwnhxwokBBHx6F/vfdxGngJw2RIZe7SFSMKxuCoDIbgBQv9VHkD9eJieK5XbD/TDEVJhEuKtVm+iunyXD/+dKmzarBsMADDVoVnegKp6czyTo1Zxo=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB5965.eurprd04.prod.outlook.com (2603:10a6:803:da::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.28; Mon, 2 Nov
 2020 17:08:27 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::41c8:65df:efe8:1f51%6]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 17:08:27 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v2 1/2] dpaa_eth: update the buffer layout for
 non-A050385 erratum scenarios
Thread-Topic: [PATCH net v2 1/2] dpaa_eth: update the buffer layout for
 non-A050385 erratum scenarios
Thread-Index: AQHWrUkk9m6/M+ViF0qTCPWkbWkCo6mw8zaAgAQk6xA=
Date:   Mon, 2 Nov 2020 17:08:26 +0000
Message-ID: <VI1PR04MB58078B0BEA735CBB2C9E1F32F2100@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1603899392.git.camelia.groza@nxp.com>
        <505ebfdd659456e04eba067839eccf14e485005d.1603899392.git.camelia.groza@nxp.com>
 <20201030184103.59b09d16@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030184103.59b09d16@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8c20e84-2379-4ff2-0f1b-08d87f51ea33
x-ms-traffictypediagnostic: VI1PR04MB5965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB596581124A6E0F3FB7E10CA0F2100@VI1PR04MB5965.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cytpz4eFz9G9EHgsijmaARqss79QQ3dyf/jN4z/PpY0pn6bxuOzVjE73pCkBoKzT616yTYANAuE+HiQ/azN18ybjNIb4f3ZTGl6AXQuvTh5Aoq4K2rut2ktnMe618xr6XB62mO6kqyO+YEz+QoCpMz2J5vyBqjD1d72ekL/5qNBxHrQQJ+4DccUyovmjMJVahYZx0sQpXioehaG/dTXfHrW2T7jYiJJL3VzW4bYAET5vMNhaSgrC7lBSAlBIUC1hubaachXxF0Um6NC9jHMZhnepTRfGgvVaqcMvndWsyKjeIsA6E5R0TjKwiZUBpAZ75jtbquieO4xERyxw9gT+4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39840400004)(396003)(8936002)(86362001)(6506007)(6916009)(66946007)(66556008)(53546011)(66446008)(64756008)(66476007)(7696005)(316002)(2906002)(15650500001)(54906003)(186003)(52536014)(55016002)(5660300002)(83380400001)(71200400001)(4326008)(8676002)(478600001)(26005)(76116006)(9686003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CC3+K4rBTZwIsyPQf6ciGSzt/KisvlQVQHizpixrDKpkTuussPXG61Zf9RsYVV4Qcx9cVrL9C5YIL40KuMctHwTlmoI9aAqfK/Iu7QiVC3hX+gPt+hnRUShJGxgt+iu3/0r5300xZtDKYjimnThifpaKcpHTg6mrqLL3FO7BqdeTG8pnLIliboyVou1CwDJbEhsCMEuJAouB5u7PdJXjgUScGuAWRl+pxv5cq5lTYJzXDMN5QzHKlc3LKUZD9xRAfv6gtD4FptEJ+Wc7Tyz8Q/r/7s6YtauDEba8MfjQcm1j+87K5CeoG8Ycks3jsTaOKAnNTmGw8MEBwJZp3tedOutRrFoFb/aRZh4d6SfdS3RKUbCoLgBIFYPDiacqQ1GUj8olbhWLcZyECHbFSh/4kkO0pr/hS3QOPD291OsJacVZ6AnTS6wdjKRCgXm0o1yKc1ZO/6WrnJBhn2sZpw9yDKu3gp8gfFQhDuOLHkXMz/bpMQnCV54zHoGH9/1YvrVby1GaYKdCn+jhuFZZCq+pKb3MUW0gUpMPDdnQyw1bbqfn58/xv1anKvDMyYZwvrGXoQokTtj6CXAI962Tsxd5x49LECGNA2ET4SWzH4Byya880SizbqE8TRiQ9bmnJgjQsRH0dXFZ9+5nvBaqcN6Bww==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c20e84-2379-4ff2-0f1b-08d87f51ea33
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2020 17:08:26.9949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uzdVMv1lr1f1LuWaX/1dhBfHrynOlDWhOQZIoSgoo8l79GQYUHmWlP7lwBPNfkmbr7tIP9oyPGW84yZNwdX/sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5965
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, October 31, 2020 03:41
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: willemdebruijn.kernel@gmail.com; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; davem@davemloft.net;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net v2 1/2] dpaa_eth: update the buffer layout for no=
n-
> A050385 erratum scenarios
>=20
> On Wed, 28 Oct 2020 18:40:59 +0200 Camelia Groza wrote:
> > Impose a large RX private data area only when the A050385 erratum is
> > present on the hardware. A smaller buffer size is sufficient in all
> > other scenarios. This enables a wider range of linear frame sizes
> > in non-erratum scenarios
>=20
> Any word on user impact? Measurable memory waste?

I'll add more details.

> > Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 06cc863..1aac0b6 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -175,8 +175,10 @@
> >  #define DPAA_TIME_STAMP_SIZE 8
> >  #define DPAA_HASH_RESULTS_SIZE 8
> >  #ifdef CONFIG_DPAA_ERRATUM_A050385
> > -#define DPAA_RX_PRIV_DATA_SIZE (DPAA_A050385_ALIGN -
> (DPAA_PARSE_RESULTS_SIZE\
> > -	 + DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE))
> > +#define DPAA_RX_PRIV_DATA_SIZE (fman_has_errata_a050385() ? \
> > +			(DPAA_A050385_ALIGN -
> (DPAA_PARSE_RESULTS_SIZE\
> > +			 + DPAA_TIME_STAMP_SIZE +
> DPAA_HASH_RESULTS_SIZE)) : \
> > +			(DPAA_TX_PRIV_DATA_SIZE +
> dpaa_rx_extra_headroom))
>=20
> This expressions is highly unreadable, please refactor. Maybe separate
> defines for errata and non-errata, and one for the ternary operator?

Will clean it up. Thanks.

> >  #else
> >  #define DPAA_RX_PRIV_DATA_SIZE	(u16)(DPAA_TX_PRIV_DATA_SIZE + \
> >  					dpaa_rx_extra_headroom)

