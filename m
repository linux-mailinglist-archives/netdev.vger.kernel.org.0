Return-Path: <netdev+bounces-12226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BCD07736D3D
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEBD41C20C3F
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6454156EC;
	Tue, 20 Jun 2023 13:25:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA57B2F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:25:19 +0000 (UTC)
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE0B1716
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 06:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1687267518; x=1718803518;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=nsHlYqGQkXyg946M7x8w2z8QUg2iysH5AcRdlwEMmwY=;
  b=nKt4Ec9h/W1bwG/PkMzhv9XSdy4zOoK5tiiJV3IpFLlUBxcskq0kwOCC
   xrGPCOnBQ8Qdgg4BKtKdJTKsIBqrCp1C0xIhEfeEyPSeEqOhLkRMcW5W4
   El5HfGo3Gbz+b0R2T3dj3oztmPGqmYsZpvLsRsmKoEVEhAIXbz61tYA63
   Q=;
X-IronPort-AV: E=Sophos;i="6.00,257,1681171200"; 
   d="scan'208";a="221716606"
Subject: RE: [PATCH v1 net-next] net: ena: Add missing newline after markup
Thread-Topic: [PATCH v1 net-next] net: ena: Add missing newline after markup
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 13:25:16 +0000
Received: from EX19D001EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-f253a3a3.us-west-2.amazon.com (Postfix) with ESMTPS id EB61880794;
	Tue, 20 Jun 2023 13:25:15 +0000 (UTC)
Received: from EX19D028EUB002.ant.amazon.com (10.252.61.43) by
 EX19D001EUA001.ant.amazon.com (10.252.50.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 13:25:14 +0000
Received: from EX19D047EUB004.ant.amazon.com (10.252.61.5) by
 EX19D028EUB002.ant.amazon.com (10.252.61.43) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 20 Jun 2023 13:25:14 +0000
Received: from EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20]) by
 EX19D047EUB004.ant.amazon.com ([fe80::e4ef:7b7e:20b2:9c20%3]) with mapi id
 15.02.1118.026; Tue, 20 Jun 2023 13:25:14 +0000
From: "Arinzon, David" <darinzon@amazon.com>
To: Simon Horman <simon.horman@corigine.com>
CC: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Woodhouse, David"
	<dwmw@amazon.co.uk>, "Machulsky, Zorik" <zorik@amazon.com>, "Matushevsky,
 Alexander" <matua@amazon.com>, "Bshara, Saeed" <saeedb@amazon.com>, "Wilson,
 Matt" <msw@amazon.com>, "Liguori, Anthony" <aliguori@amazon.com>, "Bshara,
 Nafea" <nafea@amazon.com>, "Saidi, Ali" <alisaidi@amazon.com>,
	"Herrenschmidt, Benjamin" <benh@amazon.com>, "Kiyanovski, Arthur"
	<akiyano@amazon.com>, "Dagan, Noam" <ndagan@amazon.com>, "Agroskin, Shay"
	<shayagr@amazon.com>, "Itzko, Shahar" <itzko@amazon.com>, "Abboud, Osama"
	<osamaabb@amazon.com>, kernel test robot <lkp@intel.com>
Thread-Index: AQHZo0UviR2aYZp2QE65jWhVuHE3Sa+TpC4AgAAKGvA=
Date: Tue, 20 Jun 2023 13:25:14 +0000
Message-ID: <ac10789c93aa40b5b3f601ad968630c3@amazon.com>
References: <20230620070206.1320-1-darinzon@amazon.com>
 <ZJGf3K+oZ1x6wVYz@corigine.com>
In-Reply-To: <ZJGf3K+oZ1x6wVYz@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.85.143.179]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Precedence: Bulk
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> On Tue, Jun 20, 2023 at 07:02:06AM +0000, darinzon@amazon.com wrote:
> > From: David Arinzon <darinzon@amazon.com>
> >
> > This patch fixes a warning in the ena documentation file identified by
> > the kernel automatic tools.
> >
> > Signed-off-by: David Arinzon <darinzon@amazon.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes:
> > https://lore.kernel.org/oe-kbuild-all/202306171804.U7E92zoE-lkp@intel.
> > com/
> > ---
> >  Documentation/networking/device_drivers/ethernet/amazon/ena.rst | 1
> +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git
> > a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > index 491492677632..00851ec7b4ec 100644
> > ---
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > +++
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> > @@ -206,6 +206,7 @@ More information about Adaptive Interrupt
> > Moderation (DIM) can be found in
> Documentation/networking/net_dim.rst
> >
> >  .. _`RX copybreak`:
> > +
> >  RX copybreak
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  The rx_copybreak is initialized by default to
> > ENA_DEFAULT_RX_COPYBREAK
>=20
> Thanks David,
>=20
> this looks good to me.
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>=20
> Although it doesn't trigger a warning, the formatting of the text updated
> below doesn't seem right (I used make htmldocs).
> Feel free to take this if it is useful, or say the word and I'll submit i=
t formally.
>=20
> diff --git
> a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> index 00851ec7b4ec..5eaa3ab6c73e 100644
> --- a/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> +++
> b/Documentation/networking/device_drivers/ethernet/amazon/ena.rst
> @@ -38,6 +38,7 @@ debug logs.
>=20
>  Some of the ENA devices support a working mode called Low-latency
> Queue (LLQ), which saves several more microseconds.
> +
>  ENA Source Code Directory Structure
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20

Hi Simon,

Thank you for reviewing and identifying this formatting issue, I'll submit =
a v2 today.

