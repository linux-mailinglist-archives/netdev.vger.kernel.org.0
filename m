Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C117E10B507
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfK0SCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:02:31 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:33379 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfK0SCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:02:31 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: dBPf9Z3hLRQ/5o2Ogdo8nvmSwsBWByyu+j4rzau10EdlLfacObmkgag5TSDjf5sdbYgeOKwBrk
 /Rc9eukyDgJ6Vt0FZSJOM3+1P06e3VMMN8R9mYM9IoNvQp++TnwFqvpvQtO4Edq2T+eu638O8f
 IV20Ra7IPpgSumPVTouG8UAiD1Kmj+JN2BJRR+tgJFvT0j7PFGU9jjsxg1k61Ii4oV8vtfNqTS
 J1HRKcQH8HcnKBOn690ULUPnNDxr4dpTtQvu+lkv6fGp2Gi54XfKwW/mrWC97RfFWmQpV89H/J
 qd0=
X-IronPort-AV: E=Sophos;i="5.69,250,1571727600"; 
   d="scan'208";a="56825286"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Nov 2019 11:02:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Nov 2019 11:02:28 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 27 Nov 2019 11:02:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=STmQD4E9nR//4ssqBqxCAHrtGSYUPXNIweQ6P+v2744dehJ+4PJqxSi1ETIi3eawt9eMGicGZlQ1XgzFZJPajNp9YL4ZcdJ4xw3ySYy5uFOjl8GrlbVd9PU0OplJWYG6tuX2QYHmqLai6mi9l2d+/Xcjcj6rxZ8MRe72WQsCSTGfyACXSBVuwXr6PwuweX6Tz4nr05OcBh8nZYnBHnLTgwkDLssLVTbofgVuKXrLONaoXMimdmRL/yTU+xhKOZbd+qMoDf6yiOX23GrOl+TsQuHu/3F0yOVePH+kesb0CSA3hEpvtgQpQfR8NDU6ow1lpwxyx67h9TDy24JxND9gtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElMu+TgclyK7NVSUDYq6tjpeESuag1RYjPsQeLoK6q8=;
 b=hamzffVS/pMsSdJ5thSQXIJA+AOVEuLHrZEKLFEs0q7ptrm/1Bc6YISt9nrScLvLs6/RXI08iyMshoI1ff9zw3L3BPDpyVUGZijMVyM7152VSW5PyzrVTZyxjorWDeloT65DuPaGbuMBTMftgb0T9PlcDRf7u0UY5aLeamthbdAIlD6ePhloHdbGl3cw9MNFfqnTBO4mDK8oOnuiV6+t0NybliQoVMrnMemfSRQVNNAVoav+OI8N0qiE3cP7lMl4G7eIRCuI7/mfsUyCuUsHuhGnBQk/bktMtEQ3hddq06K7itvvOEfInIJSynVh3x8HcWp5ND8BNebdOIqk8M7F8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElMu+TgclyK7NVSUDYq6tjpeESuag1RYjPsQeLoK6q8=;
 b=l88P7x2pWnKGWcNPWcmbwnWwvDEJBsG+5W3icmgNmfv9bUpR7uumzsvZgoZLYYDhVX4IrkfkI4aFcs7HliV7JmRHQB6f/8GS98Aze9fnglcp/mlb2+vL6KngS0bwK5T4fFv2w1tsRT0CMQG1Gsqke7hkrEFMG34HdtDWrkiPhUw=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (52.135.93.21) by
 SN6PR11MB2733.namprd11.prod.outlook.com (52.135.91.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.18; Wed, 27 Nov 2019 18:02:25 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::74c7:7e0e:5565:a0e5]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::74c7:7e0e:5565:a0e5%7]) with mapi id 15.20.2474.022; Wed, 27 Nov 2019
 18:02:25 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <mparab@cadence.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <dkangude@cadence.com>, <pthombar@cadence.com>,
        <a.fatoum@pengutronix.de>, <brad.mouring@ni.com>,
        <rmk+kernel@armlinux.org.uk>
Subject: Re: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Topic: [PATCH 1/3] net: macb: fix for fixed-link mode
Thread-Index: AQHVpUzTKncQ8nnm2k2VwVBoKRNCbQ==
Date:   Wed, 27 Nov 2019 18:02:25 +0000
Message-ID: <e53eb865-6886-e7b6-3f4e-1ec40d38c7de@microchip.com>
References: <1574759354-102696-1-git-send-email-mparab@cadence.com>
 <1574759380-102986-1-git-send-email-mparab@cadence.com>
In-Reply-To: <1574759380-102986-1-git-send-email-mparab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0235.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::31) To SN6PR11MB2830.namprd11.prod.outlook.com
 (2603:10b6:805:5b::21)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a01:cb1c:a97:7600:4101:ade1:25ee:c9ca]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 639b2406-1f1b-4752-e38b-08d77363f58a
x-ms-traffictypediagnostic: SN6PR11MB2733:
x-microsoft-antispam-prvs: <SN6PR11MB2733C9583D4003FDF1B3CF6EE0440@SN6PR11MB2733.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 023495660C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(376002)(346002)(199004)(189003)(4326008)(5024004)(256004)(186003)(2616005)(11346002)(446003)(478600001)(71200400001)(71190400001)(46003)(31686004)(36756003)(2906002)(25786009)(66476007)(66946007)(81156014)(64756008)(66556008)(8676002)(66446008)(7736002)(5660300002)(305945005)(8936002)(7416002)(86362001)(316002)(81166006)(6512007)(53546011)(6506007)(386003)(102836004)(6246003)(229853002)(31696002)(6436002)(14454004)(54906003)(52116002)(6116002)(2501003)(6486002)(76176011)(2201001)(99286004)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB2733;H:SN6PR11MB2830.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dy16Q1PIUq9uF/VVtcp06vzv4ViaG/Vncns50k7htItTFEblpvTlinFRE2CAfqnRK7hOlVZ4sx7fgBaWV5aZj5TWO9/CDpfDYOcngDUV0WvTtINyOqPjMGuDb3MOIzb9EDGyYWPQMKfpOhNqNLWjDAjeWd8BGuMS31Mz0kfiG6JxNlDKZJRE+Q+6cx1nkMnZ7FSI88b3f2pJO06VjujnXNhC8hK/PEN7tEOGE0X+lZ6YHb1EBzA15CsVhCZKHVethWtYjQ+PHP0o0mjQyg7d1c1Cz+KsuxInG5LsygfhsmaY1UGIpkvE0kV9e6w8fiGYllcfd63r+jvfCqgdKvGUKMuoNAv8aAA1fbR9nB8cKSorUWCJBHZHAjpE8372MyibT0Hp50O1IDYLLFquKQE2JsqNGB1zF+Vj9h70v/q7Due6P4ChkU76GGrAkygcB3CU
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <8E2DF698B56F9D448AC6416B338765C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 639b2406-1f1b-4752-e38b-08d77363f58a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2019 18:02:25.6740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uVzKAXYRtH946RPYpEOwIr/IkYLOm8g08L643eg476PJjzgkvxPjTfjcBP7k6S6JqfCvFFmjRAUwDFebAnjGlWWBe0XQhaz2zDRmYpOJHUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/11/2019 at 10:09, Milind Parab wrote:
> This patch fix the issue with fixed link mode in macb.

I would need more context here. What needs to be fixed?

I think we had several attempts, at the phylib days, to have this part=20
of the driver behave correctly, so providing us more insight will help=20
understand what is going wrong now.
For instance, is it related to the patch that converts the driver to the=20
phylink interface done by this patch in net-next "net: macb: convert to=20
phylink"?


> Signed-off-by: Milind Parab <mparab@cadence.com>
> ---
>   drivers/net/ethernet/cadence/macb_main.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index d5ae2e1e0b0e..5e6d27d33d43 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -617,15 +617,11 @@ static int macb_phylink_connect(struct macb *bp)
>          struct phy_device *phydev;
>          int ret;
>=20
> -       if (bp->pdev->dev.of_node &&
> -           of_parse_phandle(bp->pdev->dev.of_node, "phy-handle", 0)) {

You mean we don't need to parse this phandle anymore because it's better=20
handled by phylink_of_phy_connect() below that takes care of the=20
fixed-link case?
If yes, then telling it in commit message is worth it...

> +       if (bp->pdev->dev.of_node)
>                  ret =3D phylink_of_phy_connect(bp->phylink, bp->pdev->de=
v.of_node,
>                                               0);
> -               if (ret) {
> -                       netdev_err(dev, "Could not attach PHY (%d)\n", re=
t);
> -                       return ret;
> -               }
> -       } else {
> +
> +       if ((!bp->pdev->dev.of_node || ret =3D=3D -ENODEV) && bp->mii_bus=
) {
>                  phydev =3D phy_find_first(bp->mii_bus);
>                  if (!phydev) {
>                          netdev_err(dev, "no PHY found\n");
> @@ -635,7 +631,7 @@ static int macb_phylink_connect(struct macb *bp)
>                  /* attach the mac to the phy */
>                  ret =3D phylink_connect_phy(bp->phylink, phydev);
>                  if (ret) {
> -                       netdev_err(dev, "Could not attach to PHY (%d)\n",=
 ret);
> +                       netdev_err(dev, "Could not attach to PHY\n");

Why modifying this?

>                          return ret;
>                  }
>          }
> --
> 2.17.1
>=20

Best regards,
   Nicolas

--=20
Nicolas Ferre
