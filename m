Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8168217F25
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729615AbgGHFej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:34:39 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:63041
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726206AbgGHFej (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 01:34:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irvzLmJU2cH1yNGOBepN4gUP3jch1gXXBoJIxDlp0/JstifeKp6gMdAeImRgHW6oLSQItUI/X4I+Yyv6oTGzLOvjF43qS79WSRrcb58ukfAHwneIBzltvY+KWBVDyJEUcgwaGUsyyOENjaR4UGgUJQoNGsfzsOPnrJXbwf//l11MaxCrOLZXPtKsz2JZFXl2hais3JUv/g2OsT6KeWObaTgV5lO4krb64ZDxqM8yhIX+of9aeSjx5XY8L3c7xeEKIlzfibyACMzM2Hle70xaV7O8jNs4hYcB09Ahc7NJcZOT6cMHCohgV3htEpJ5pqxvpD/xqPUHTZJ4bpLcCb96WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+zaVDVo6C7H1AiBbcp+wk/jgbUP9i7TCRQqh71gxSg=;
 b=jPnROmYgqVYoffRUCa6+14co7s7RG878tp99S1oO2I7btBr3uqjWZ/EAgMPZmEiawrkcV3uGijo3fN88uaQQF3IVd9ozvTx1PpW9KyukpIS6X8/jhcLXReJmD7IE/2OxjphZifWlq44ahIZUqiEd+m5t2XqwG7LtD8FZAQ/xufA8tXLPkU1pPuXH0Q+lQpawFYdIJ+RMkqft/HjgMObR38QHGA/FmAi4+mOcXhuZpkxJtn6SwmLs064xcPdUtb4h07VyRdeJzpbXHP6N3fvd9S5FQr1jHc7ub6qUETF/WLSuCVHz2ShCg4YjyTnRm1EITBz4d1h4AqJX7EKRpIKH6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+zaVDVo6C7H1AiBbcp+wk/jgbUP9i7TCRQqh71gxSg=;
 b=VIFynQZM8jXljKuA7gRulrhY0G6Nfh2HhpZHXOh00E7gcRXiCXVjJfwB45dQ+ClM+PArBDzzDYz982T47UeAUUXzcHRehbgb8r/IOACpi8Tgk5diRwKhEZvge2Ngn7uVFvKtrVM96l4cxMnsdf6qAiMs0M9EDtKP+Li+B4VHDns=
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM5PR04MB3074.eurprd04.prod.outlook.com
 (2603:10a6:206:4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 05:34:36 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::75d9:c8cb:c564:d17f%5]) with mapi id 15.20.3153.029; Wed, 8 Jul 2020
 05:34:36 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Sergey Organov <sorganov@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Topic: [EXT] [PATCH  4/5] net: fec: get rid of redundant code in
 fec_ptp_set()
Thread-Index: AQHWU6F5IyIEbIdp8UqiTSGJIl4IMaj7gQmwgACxpduAAPiYUA==
Date:   Wed, 8 Jul 2020 05:34:35 +0000
Message-ID: <AM6PR0402MB36074EB7107ACF728134FEB0FF670@AM6PR0402MB3607.eurprd04.prod.outlook.com>
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200706142616.25192-5-sorganov@gmail.com>
        <AM6PR0402MB3607DE03C3333B9E4C8D3309FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <87tuyj8jxx.fsf@osv.gnss.ru>
In-Reply-To: <87tuyj8jxx.fsf@osv.gnss.ru>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7fbd8ee1-2211-4ab7-7f72-08d8230099fb
x-ms-traffictypediagnostic: AM5PR04MB3074:
x-microsoft-antispam-prvs: <AM5PR04MB3074D5573E29ACB43A8E0B78FF670@AM5PR04MB3074.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBLa6X6I8dZHEjjdH6NOoYYiawzG0bJFrTRUWsLcslS8rtgUDyCinl9ZRniZpAsUaLafra+NTNyvrXjfz5+Ij4EaV1LEQWsCVs+BdHr7ESGoHw36JGmeHjwWbynSNBQHQl3wcGwblwDWXJWfa7+zWHHp90yTiEWDUYlmbiuSEHps0L3cQ9zmQJyUImHru9PD+a+temd7H40DqrV93LXkYddjSElnbFh6Mr/VVQPix71/VZljauuBgS+aBz3qaInmtKREgif/IAFtBs+5/tzxOXjMpPIoj3dUq4JKPjSjH0Ph0+uDUZirMUt5cKWPXAVXBkhSfr+R7HR3PeY5MmayvnWxg7y8X0tvPPgfjEKRW8UCHoasIB/zkW9XDzpcngWx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(83380400001)(6916009)(478600001)(86362001)(8676002)(2906002)(6506007)(9686003)(54906003)(8936002)(5660300002)(71200400001)(316002)(55016002)(52536014)(76116006)(33656002)(186003)(66946007)(66556008)(64756008)(66476007)(66446008)(7696005)(26005)(4326008)(26583001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: l/DxhBgnVIRd+VBs1rpP+0I/LyGiTj3kEuo6uEU68EA5WeglPMZWqewytIZFMm33msNIXYyS0RVmIVIhuBmtjslEb4KYVZQrRvOoPiGaox6PcyGhRkfnhYJAiHjFi9kkE7qM09l7+OziC60ASUHpfA5hFHojtuf6xwJolAkatD0ETJtg5OT2MqyzbvA1w83oFdPTln5A5szSl4Kvbd2hGRXWsUYshJ6JT8oJXPfMh87Zw2mTIWdkmdbmd2HELUZdOkX3U9LtD/slpHL8WjhpyXPKcyRSg5q2oqbvwWzz77qOpNqoOZ9fItzchHSkg0ARMZO6ewrwb1p/pA0fh2lIm/RlzLlIDgGs88zibvFR08++aX5hxTZW5+UH5lZ9xEC1TA+8HsoXNk/lIZXTaSIYsDG0e+Yq3tbeTIF3q32oHhZ4dWFePT9AgOhgs+b8Y+0z3TA97TLYzdYFvuEgKk8999ucTI8M6rGwlHka3xf4UI4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0402MB3607.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fbd8ee1-2211-4ab7-7f72-08d8230099fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 05:34:36.0215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cUiPfsf0CTyxSFj7pevHQHbU9njo6/eA+9KUoQY6r+L7i8ib2CUCsy9jV9IDhEuLH7U+EIuuhO14WN9tYLaQdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Organov <sorganov@gmail.com> Sent: Tuesday, July 7, 2020 10:43=
 PM
> Andy Duan <fugang.duan@nxp.com> writes:
>=20
> > From: Sergey Organov <sorganov@gmail.com> Sent: Monday, July 6, 2020
> 10:26 PM
> >> Code of the form "if(x) x =3D 0" replaced with "x =3D 0".
> >>
> >> Code of the form "if(x =3D=3D a) x =3D a" removed.
> >>
> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
> >> ---
> >>  drivers/net/ethernet/freescale/fec_ptp.c | 4 +---
> >>  1 file changed, 1 insertion(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/freescale/fec_ptp.c
> >> b/drivers/net/ethernet/freescale/fec_ptp.c
> >> index e455343..4152cae 100644
> >> --- a/drivers/net/ethernet/freescale/fec_ptp.c
> >> +++ b/drivers/net/ethernet/freescale/fec_ptp.c
> >> @@ -485,9 +485,7 @@ int fec_ptp_set(struct net_device *ndev, struct
> ifreq
> >> *ifr)
> >>
> >>         switch (config.rx_filter) {
> >>         case HWTSTAMP_FILTER_NONE:
> >> -               if (fep->hwts_rx_en)
> >> -                       fep->hwts_rx_en =3D 0;
> >> -               config.rx_filter =3D HWTSTAMP_FILTER_NONE;
> > The line should keep according your commit log.
>=20
> You mean I should fix commit log like this:
>=20
> Code of the form "switch(x) case a: x =3D a; break" removed.
>=20
> ?
Like this:

case HWTSTAMP_FILTER_NONE:
	fep->hwts_rx_en =3D 0;
	config.rx_filter =3D HWTSTAMP_FILTER_NONE;
	break;
>=20
> I'll do if it's cleaner that way.
>=20
> Thanks,
> -- Sergey
>=20
>=20
> >
> >> +               fep->hwts_rx_en =3D 0;
> >>                 break;
> >>
> >>         default:
> >> --
> >> 2.10.0.1.g57b01a3
