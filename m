Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F40EB1200D4
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 10:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfLPJSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 04:18:55 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38794 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726875AbfLPJSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 04:18:55 -0500
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 86FFF42650;
        Mon, 16 Dec 2019 09:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576487934; bh=TuUBvcwYnuYNXYYCOMVn2LlqQyoLV9WD3AmcOfygKks=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=V9+iyQwQAOugzLlIKzmwgZRUk+lUoIBvPA1tFCYUJolPY6eSth5BhQUMNdKqMG+kQ
         lWh9mtKTzWpsmg5eNieOo2RJqNDp18+hWOqVoA6XFxxw3hznCSPZX3O+pY40uTwrys
         g3x/oBnTb5/KNJQONO+venasY2Pdl3M9jLfzISUZTCPTbWcZLBe/oamoXGoLpgvB1U
         QyYesycoewAyMi64vPG07YBTsSBqT/HGqlasRMyX/Qiub7KPkhoow79NX9YEA+rsEl
         RD+WYhDgW260IiMjTFhe/+pSKuhZ7G832i1HWZEC8jisSIWRnBFdmwLAKJ4eN3vDPr
         szEtT4757+F8Q==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 5F3B1A0085;
        Mon, 16 Dec 2019 09:18:52 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 16 Dec 2019 01:18:52 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 16 Dec 2019 01:18:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mgPWS41eJ3D1bFWhqlWFBevxA8ktRIDqlQAYqMibL9E/glChgP7YLueMMV50VrINKjRYDzxP8cPrhkk43X1Mf0VfNHZmw7/3yM7wQ6tc+VrVWmSmhluER57IOatQ7hAN5YBaM/pS/hP4pUcJTjdAZ8HnxpYVPGdRWeBpZzN/+5HjDu6kmRAZBHVwQmDTvMdODE649jWz0s66hCE50z0tNNxqfbKjk9psmWUpQ0Ou0ilZl8cHhCGERm8g8WUf8Mm9B3/gdAFQpXIn51qwXcRv73ZlVwJHCTQYjaLcxQLDXroc7V5eQRctihmXKT3dMPx11W4uVACwQVlMiWvuOQBjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oC3dJqay3iflZmkvGKU8yuy9Yrqc7PvExl3sum/ScyE=;
 b=ja8FyP+NTCO1KFOTGwPG+lioWQ5kGZL4MPvwTYzbWICFt6AbXLrfT6oIf2dwRcAuFgs9upOxntIf6ogIFxDJtObar8LZGG0h7OoEZJfxkwtKOt+2Q811OolUaeA3WRAVHM5AqCB8DzYaoL8s3z6jK5L1CWkFGsYKnp1xk/fsFCZBlY5U2OyOLQ44op93N179X3qz4ameRTYqHfDF4uNyuwJAZx4/m8LsgBd4Wj0nptOJolM3HeibZ0Xk/PUIOb7s3cucwHv2S29w1bcYf2hKuboUPSe8rsYwrbuyZiwkTj51aoRcNB0UgOmN6RPpGJmc4UkGZrX0Nw0SRWhchcM8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oC3dJqay3iflZmkvGKU8yuy9Yrqc7PvExl3sum/ScyE=;
 b=BdhGb3QTiHU/mpzCaIKqBSm0M9G9io7+qgvf4VfmFzyr20Q5Te/WUruyLcHHOL9hiiA2EAO7o8TAay5UT5q5CTYiPSqXlSv+Hz72MHHIOOj5NGwWWg1hDmGxUiDA5b9UaakIQeiJFn9JxCwqyGRFWMd2wwYSXpom/hz406qvkZI=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.67.145) by
 BN8PR12MB2994.namprd12.prod.outlook.com (20.178.210.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Mon, 16 Dec 2019 09:18:50 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::3d20:3a36:3b64:4510%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 09:18:50 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] net: stmmac: Let TX and RX interrupts be
 independently enabled/disabled
Thread-Topic: [PATCH net-next 3/4] net: stmmac: Let TX and RX interrupts be
 independently enabled/disabled
Thread-Index: AQHVr5PIxrei2rB6dEKHZgwzBhKcYqe6HSSAgAJnE7A=
Date:   Mon, 16 Dec 2019 09:18:50 +0000
Message-ID: <BN8PR12MB3266288303A6CA6C3CAA5E6CD3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1576007149.git.Jose.Abreu@synopsys.com>
        <04c000a3e0356e8bfb63e07490d8de8e081a2afe.1576007149.git.Jose.Abreu@synopsys.com>
 <20191214123623.1aeb4966@cakuba.netronome.com>
In-Reply-To: <20191214123623.1aeb4966@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0c33801-ca34-4fff-9c1a-08d78208f695
x-ms-traffictypediagnostic: BN8PR12MB2994:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB29945FDF293216826AA45EA3D3510@BN8PR12MB2994.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(39860400002)(366004)(396003)(136003)(189003)(199004)(7416002)(186003)(316002)(66946007)(54906003)(6916009)(5660300002)(33656002)(66556008)(66446008)(66476007)(478600001)(76116006)(64756008)(7696005)(6506007)(26005)(2906002)(71200400001)(9686003)(4326008)(55016002)(8936002)(81166006)(52536014)(86362001)(81156014)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB2994;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jCrwCxBOCvWLkIEZAtLoBvcQw/9EOU9GzEynQnO+JcMiD24FbtNSCKzNU7vuDV+8DSi3oP2wU3c9JC9ViHYdRY4srgEnmZYfqZF/xt15W+Ko500tvsVDIJPd5RWIT/CrZ1HtX2FEccAR8JePuGfla2puPTlHabFqprLRzYhsJzXX8d3Ugwlqi+TW97qUyiuvucdhg2I6WbjOKy69KfHtyvk2i3f8aVK4BhvCCj+hLJlakcF7Dc0OLgV2u+KRYrnoy3QGoRshDWEx1jCWC4SqIUQp5wo2XRPEay49bP6G0G+l9ogt8X48q9RD4S7fEKlNbD/TqAJfUEvhk56Cmvq9r6bsy1X4bEv+CaOgzIBXHAtKnZQVeGoOI9pOoKMRaThkr2nZLq8/Y3j4abLzauTl4PuN1vWSe21/EYro+3LnOe6DhFX0vys1wWTnAnYPu+Of
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c33801-ca34-4fff-9c1a-08d78208f695
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 09:18:50.1745
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HyBSdc2fWqfuP1vsWi+qdphg3EOdN234Qg69/QBA5u7XpIeKbs23csbMWMcUMFpbTTYNNVlkdmzkVEthtFidWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2994
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Dec/14/2019, 20:36:23 (UTC+00:00)

> On Tue, 10 Dec 2019 20:54:43 +0100, Jose Abreu wrote:
> > @@ -2278,10 +2286,14 @@ static void stmmac_tx_timer(struct timer_list *=
t)
> >  	 * If NAPI is already running we can miss some events. Let's rearm
> >  	 * the timer and try again.
> >  	 */
> > -	if (likely(napi_schedule_prep(&ch->tx_napi)))
> > +	if (likely(napi_schedule_prep(&ch->tx_napi))) {
> > +		unsigned long flags;
> > +
> > +		spin_lock_irqsave(&ch->lock, flags);
> > +		stmmac_disable_dma_irq(priv, priv->ioaddr, ch->index, 0, 1);
> > +		spin_unlock_irqrestore(&ch->lock, flags);
> >  		__napi_schedule(&ch->tx_napi);
> > -	else
> > -		mod_timer(&tx_q->txtimer, STMMAC_COAL_TIMER(10));
>=20
> You should also remove the comment above the if statement if it's
> really okay to no longer re-arm the timer. No?

Yeah, agreed!

>=20
> > +	}
> >  }
> > =20
> >  /**
>=20
> > @@ -3759,24 +3777,18 @@ static int stmmac_napi_poll_tx(struct napi_stru=
ct *napi, int budget)
> >  	struct stmmac_channel *ch =3D
> >  		container_of(napi, struct stmmac_channel, tx_napi);
> >  	struct stmmac_priv *priv =3D ch->priv_data;
> > -	struct stmmac_tx_queue *tx_q;
> >  	u32 chan =3D ch->index;
> >  	int work_done;
> > =20
> >  	priv->xstats.napi_poll++;
> > =20
> > -	work_done =3D stmmac_tx_clean(priv, DMA_TX_SIZE, chan);
> > -	work_done =3D min(work_done, budget);
> > -
> > -	if (work_done < budget)
> > -		napi_complete_done(napi, work_done);
> > +	work_done =3D stmmac_tx_clean(priv, budget, chan);
> > +	if (work_done < budget && napi_complete_done(napi, work_done)) {
>=20
> Not really related to this patch, but this looks a little suspicious.=20
> I think the TX completions should all be processed regardless of the
> budget. The budget is for RX.

Well but this is a TX NAPI ... Shouldn't it be limited to prevent CPU=20
starvation ?

---
Thanks,
Jose Miguel Abreu
