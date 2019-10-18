Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81EE2DC9DC
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 17:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406327AbfJRPxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 11:53:40 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:3186 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbfJRPxk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 11:53:40 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: OYZmKHXyVFsnnMlBBZrFBE7my3sxnd5YNJBQz6t9fD41YzvZQi1q2zQAzpbDvfInGMNskRdiF8
 vKfGVOOaho2tL4thQrf2DfCxI6Ddq71QZQWHP5fauh1GG5fgS8jPY1H4oYKXygacnAcBPCvH3x
 Lf41oacr84Y55wJfWrYBc4ooH2DCZBWNNo0gzeRNhpkhMfa1hJ/ruBfOsSZ8DYn3Z6lFei/Dsa
 +cJ2ejkB8sP2yiad2/eW9O/Ry4WsFAx1IlRgBE/Ygyy02OPaYYAbIHhnHT9sghpkSAeQQMtSVD
 558=
X-IronPort-AV: E=Sophos;i="5.67,312,1566889200"; 
   d="scan'208";a="50658316"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2019 08:53:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 18 Oct 2019 08:53:38 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 08:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CUeKWtJGfcD+l8QoUMeNu6H87MRHjMOLvHylCvWIS6+NCvRVn91CyUfk+umH4Lntvxv6D3b1Y1K1eCp8+Bih5Q0pvl4KKHlGDaYzDWPMFBY/DHg7e6PNv/dDJejYkN6QDN5fJHb9szK8ODmtbcaJ2lXnCze2yIOfIJWM6XuMC+wTESiqm8L7ETF96CjPt/inrwBhZBVVoIkdv5mlYwkqqkO8UDXDwEkH05/+81pwFz1PKFekhZeRpJcoYHOOfFPKQjj/I0ZnQcuf4jmfP23ctfrwBdW9GIH3Uws7seAW1M25mlasizwJ6LEjv1cmefe9aKOwnzdUGlbB7M2Ap7kBdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3KzmAOj1IGT7tRaCapm81TGgxk1+c4a/XgVZqrdLf0=;
 b=IroUVpNl9o9lNZqMvGP7DaBDpISZJPMT0ztq1wLnrucwsCXOVsUHLkt13q4M2+/TsCftzm8b/I+ppGYgAMm7zJydtMEHPps/EP640kjWgOME4N6CSt3PK3yE4BPDJh6Gr5LAGO50FNpPh2hPmQUJbxH0QBhBkb3StEKNGFwQo0YOcvR6x5R7VgoSRLpiNNP1pugIE41Nv/G21DCWhkja/a7pNEWdR81kN2HZTJWG+TBR4yYY3+yGPNdcaZS93buy8ZBhUSvVrRNRodYHXzEIOL+cYmrmDEeUb8kYdjNGJTxDetaHOdZovFyBHsY5lttn6UJ/yPPHp1gRFZ56eCDlww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S3KzmAOj1IGT7tRaCapm81TGgxk1+c4a/XgVZqrdLf0=;
 b=DX9Ux0XDWZ6U616FL7ay4aDSQnx8gJPg/R06/jX3pTDjCEzuWQ2iV0fVqUXO+rTltWzLZoTf/dKW/kRYEh2CwBRD3VShBscWdkCt96Gz5TOYomZSrWaTOPiSe1P4LOy8neuthatneqLqybnepjPDUsbHvsxc2/hVCfBF33MXvFo=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB2029.namprd11.prod.outlook.com (10.169.235.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 18 Oct 2019 15:53:37 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::5d81:aef1:f63:3735]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::5d81:aef1:f63:3735%3]) with mapi id 15.20.2347.023; Fri, 18 Oct 2019
 15:53:37 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <m.tretter@pengutronix.de>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH] macb: propagate errors when getting optional clocks
Thread-Topic: [PATCH] macb: propagate errors when getting optional clocks
Thread-Index: AQHVhb4QQinep2IHYEau77BgGFAPSqdgjOMA
Date:   Fri, 18 Oct 2019 15:53:36 +0000
Message-ID: <8e505dcc-c485-3413-af9a-2062c113d22f@microchip.com>
References: <20191018141143.24148-1-m.tretter@pengutronix.de>
In-Reply-To: <20191018141143.24148-1-m.tretter@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::31) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd4c8144-5f4b-4453-33eb-08d753e3562b
x-ms-traffictypediagnostic: MWHPR11MB2029:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB20293594D38534F3D027C8D3E06C0@MWHPR11MB2029.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(366004)(396003)(136003)(346002)(376002)(189003)(199004)(256004)(71190400001)(14454004)(446003)(107886003)(486006)(2616005)(186003)(2906002)(11346002)(4326008)(71200400001)(476003)(26005)(54906003)(110136005)(6246003)(3846002)(6116002)(2501003)(6512007)(229853002)(6486002)(6436002)(8936002)(64756008)(66446008)(66066001)(31686004)(66946007)(66556008)(66476007)(76176011)(316002)(81166006)(7736002)(53546011)(6506007)(5660300002)(99286004)(478600001)(52116002)(386003)(36756003)(31696002)(8676002)(102836004)(86362001)(81156014)(25786009)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB2029;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bPsO+6utOEv6TRVoNJ4sUzvuk6lr6Yala8YL5GSJmQVLbVFiTfNH1I2SJBG81OtkL0+5AC+xLKa9V6Z9Ojd5kHZxXBP4bt6meE1Jup28vguZ8yJEXcikFb24a5wwGojY/LpsGlecl5aNrmuNOWf+itKPkLrXTdeJ11PgfJDKqCKdD3xF2vixE1I/7BoIWpQox16LVyCkcOlzaiFlLNxyU+JbktLcIbEzRsxxyeDRWNJUTOj767YPxH2TCJzC2SMjUv7pjqDoEhxjXu/djcBs9EkkXqngqXkKKVJySr/nwNsW5RaAbt5izIEBUqOHg9ivKRljr+r3Wg+ZP6UVR7zP5c6Wa7RQwgoie/w9gXyH1HPyA1vboiqQPNRgFOldt46Wxu1kxQZ0EkNbU34bc4fl/5CtEPCyTeGm0Lh5tNrl15k=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <F03A60334DD12249A446D84FB3B62308@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dd4c8144-5f4b-4453-33eb-08d753e3562b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 15:53:36.8586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: No+e531N/9aOd39FCjYyatxx4VatlAIV/TD4xKprpVUJbfVuNB2qKTdOmPMYJp3pM4gj9NzuOubo1sEz10kS6IhxVsr3+jPMOW6Nn/VOAqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2029
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/10/2019 at 16:11, Michael Tretter wrote:
> The tx_clk, rx_clk, and tsu_clk are optional. Currently the macb driver
> marks clock as not available if it receives an error when trying to get
> a clock. This is wrong, because a clock controller might return
> -EPROBE_DEFER if a clock is not available, but will eventually become
> available.
>=20
> In these cases, the driver would probe successfully but will never be
> able to adjust the clocks, because the clocks were not available during
> probe, but became available later.
>=20
> For example, the clock controller for the ZynqMP is implemented in the
> PMU firmware and the clocks are only available after the firmware driver
> has been probed.
>=20
> Use devm_clk_get_optional() in instead of devm_clk_get() to get the
> optional clock and propagate all errors to the calling function.
>=20
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Tested-by: Nicolas Ferre <nicolas.ferre@microchip.com>
(for the record: on sama5d3 xplained GMAC and MACB interfaces)

Thank you Michael. Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index 8e8d557901a9..1e1b774e1953 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3405,17 +3405,17 @@ static int macb_clk_init(struct platform_device *=
pdev, struct clk **pclk,
>   		return err;
>   	}
>  =20
> -	*tx_clk =3D devm_clk_get(&pdev->dev, "tx_clk");
> +	*tx_clk =3D devm_clk_get_optional(&pdev->dev, "tx_clk");
>   	if (IS_ERR(*tx_clk))
> -		*tx_clk =3D NULL;
> +		return PTR_ERR(*tx_clk);
>  =20
> -	*rx_clk =3D devm_clk_get(&pdev->dev, "rx_clk");
> +	*rx_clk =3D devm_clk_get_optional(&pdev->dev, "rx_clk");
>   	if (IS_ERR(*rx_clk))
> -		*rx_clk =3D NULL;
> +		return PTR_ERR(*rx_clk);
>  =20
> -	*tsu_clk =3D devm_clk_get(&pdev->dev, "tsu_clk");
> +	*tsu_clk =3D devm_clk_get_optional(&pdev->dev, "tsu_clk");
>   	if (IS_ERR(*tsu_clk))
> -		*tsu_clk =3D NULL;
> +		return PTR_ERR(*tsu_clk);
>  =20
>   	err =3D clk_prepare_enable(*pclk);
>   	if (err) {
>=20


--=20
Nicolas Ferre
