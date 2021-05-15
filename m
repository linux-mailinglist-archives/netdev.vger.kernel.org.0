Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37B53818DD
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 14:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhEOMsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 08:48:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:61041 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhEOMsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 08:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1621082810; x=1652618810;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yNlXDLdGgHSaOLoBZTYSTdbeGTcV8E4apz+CGjW4hvI=;
  b=XUmuSRNRlFTyYWRdKSPQWDMJlKuR+ByqK5FEMu2lvyS73NSRqlI+rI9D
   cDAWWFFCfKpo9B+cG7Cpl+t6SFTzccI1GQgMwf2PLmdIjWkjkoAAcYPCC
   Kk+xkgtbMLWduo8la53tgA7ALtrJTCpHZgi+JXDW4m2k9RB1hUmLUKx2x
   cX6rZkk8G1ZTCYIUykLVbvAwHHGlx+q2dxbRSv6oFQNhg/OQyrOi8w3dU
   K3xFpYPIe+E6RxB0FpHQRLBQeSBF8Zck+rGT2g4VSA9NpdZml7zSAtO/o
   dzu7/o4H1xSHH0eTNnFyHYN2fez3281fe2p9iSVy8bxK7G+Ssfny/YFb8
   A==;
IronPort-SDR: AjP9T3QgWO4O9KYeet0hyx/WgoTC2T6BAZSRvC6SuKtnkE4REsJ0J8RbOmhlbo5rAoMs1uUwfh
 ePYS1JX8NH9lzRWu3c1p1mPcAMXpRIKkh45h+T2/x3ZCZYPIR1ny/NhwBe5QCa+88bRluZJwAU
 fkw21x5m0psArqczqe9xkdY3NLlqM2ZaCOdlHgt8vGBeQcuvGPi8jVCMtgW0HmGuoJSdPRYc9f
 A/LHOQs/bC/niaOci9WwaWSSQ8nO/9SWuv/fXeoJzY5KHkC0Oy9fiPKAxyDPytHCXYYEuy+0Di
 iQQ=
X-IronPort-AV: E=Sophos;i="5.82,301,1613458800"; 
   d="scan'208";a="115419278"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 May 2021 05:46:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 15 May 2021 05:46:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2 via Frontend
 Transport; Sat, 15 May 2021 05:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVT5jqEc0IWkP25bXqiWAiMy8A/PwJ7gTpAgjWJD4OR1D/2lJ3a9Hg2F3/y9H/uX3/++7VE4+zFkX2iPsy7t83lmU9LkeKISOIPYBbzTDxk3Jp7t4zEwXxeI4rUjEcD+/8vxigdPKE/35SNCdjPIoIQSQfIaWC/8f02SfmocZ9XL7rn01DcT6uJoaRZh8glZB+HzNpConlV5xL+k1jmj4OYEEc9PiD7G/8kRh/y7gmNFt837Ype33t0Ks7i9Q2+M4brUp9rmXeP8PlP7HK/wmZwwv9KQDlXUm7j1RgsVZydFTow3u90xgQH30Eao+skvLGokDeJ3KIlh3WPjwODiUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxsQ21tkxGf2foZ/PsfTKtpfJSZI0O0R4gFPIOQHG4=;
 b=EJ4N9A/DvfnsVeuOmrMzNnHpplfPPuMaswXlzjGvn/UCh4Kutipoyyar2wSEr2TVcSJxoLQzaqa/EoZjWvdCn+jeRLZ8Je4KIRJHAH7BjY4RQRPwEapt7h6u87mp8SGaGjswQy/OX19JaulTpT+QIs6b/T0GtVk9V/xPtScboAJNu6bjn3bfVEc79nVwt2w2l1Aq6t0AxWe3w4oAeMk8abhOOkHXi7LghaJsu+jXavrQySPVvHY1vwdDvsDE/v2KyGwMxP6FW0B6K2JSQOXWDv+fik+qC8n1xBZtA+W+cfea/DaxeYzGsMfalMLka7GEhleMrWo1nD1SPKCXlPHLqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRxsQ21tkxGf2foZ/PsfTKtpfJSZI0O0R4gFPIOQHG4=;
 b=LygSGl+CfTHxoGWgkXNhBkTBj155+gj5Jl5p6E2oEh8d8RDVGMnayCpbA00Z+Iw+dNkZHGcxu4T5F4WwwWtKQvkjzsToVD8Fn3bQp/5ydhS2smYx+mXdaP79ifcpMFnSWh961PH4Qd3nzwTxmZfBvPSZ5QOb8mb8YE5BLov0y+0=
Received: from BY5PR11MB4404.namprd11.prod.outlook.com (2603:10b6:a03:1c3::19)
 by BYAPR11MB2869.namprd11.prod.outlook.com (2603:10b6:a02:c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Sat, 15 May
 2021 12:46:46 +0000
Received: from BY5PR11MB4404.namprd11.prod.outlook.com
 ([fe80::ed45:4caf:ab04:86a]) by BY5PR11MB4404.namprd11.prod.outlook.com
 ([fe80::ed45:4caf:ab04:86a%6]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 12:46:45 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <shenyang39@huawei.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH 07/34] net: cadence: macb_ptp: Demote non-compliant
 kernel-doc headers
Thread-Topic: [PATCH 07/34] net: cadence: macb_ptp: Demote non-compliant
 kernel-doc headers
Thread-Index: AQHXSYhcfQ7X2PpkrEmud7cbBvaxSw==
Date:   Sat, 15 May 2021 12:46:45 +0000
Message-ID: <bbfb694c-5d48-137c-e394-4d718887f03d@microchip.com>
References: <1621076039-53986-1-git-send-email-shenyang39@huawei.com>
 <1621076039-53986-8-git-send-email-shenyang39@huawei.com>
In-Reply-To: <1621076039-53986-8-git-send-email-shenyang39@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [2a01:cb1c:aea:8c00:3352:c736:f35d:1682]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33b18e2b-4331-4747-be2b-08d9179f7f8a
x-ms-traffictypediagnostic: BYAPR11MB2869:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB28692978F3CECEEFC7FD549EE02F9@BYAPR11MB2869.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:227;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ONohtVvYTK++eXsFWDVYlEKDKcuvlFZFNMuRFd9LEtfpv4JVWS8oviq9zhcwu2JzqeX4IvHm4/AUGIemADS2Pp9+WNRvB89GDkVd5sCwL7lKnBkEbY9F3cPmH64xGOxjSckUUJIAXXGq2VpFA+mCblPCXJrgQKvyxcnsdIeS1RvkEMT3ufs6TqBZNzJCFbYK5LFIe96K2jZ3gGhJWGl9zjw/aCR63pS8hcRG/PNZo3CCTf83wBC8tuFHCerno82Kpos1G3ZUoS+zHjKmzzloiqxdkwQRjZVZnpqcOlnTmhTwdhCaMZSlmhucHMENpXBYQSHEbrrdFwyYkxdlsoVV5FdFHkKqX2JtdLopThhRXFxknmQcp1YZe7vbV2+4HXKsakW+KEYGINCaNCytv2+wvq8ij3CNuU5yzerIUvwlBbC5uC9IMRtmt0b39wIfSp6xlFLNd5+WKM2e6tCU9eKF64RbycX/AIrXCII/AHKhez3Ko8p/EkdnTyf80VKows7cOe14p5enmWfpnj9/a4tPWRZ5Co5+15/nUl397stXzCoRv8SyVs44Oqdq0HWe99geoCn20HpZhS1tZrOe/vsbO4T725eh5u+mtk/lhLMz2qkM0ePu0by2rwZwq/45XEcwNikZy/yhOdJdpS9cXQ+89tttPXtGIvK+g5lLf0SVXZNQiNXdK4jxd5bAqi9KNCFztseOdz1kvFZKlo52g3bRvk7E8s54JaLvtUWJ733a5Mp9CUcfAK9dFzuq72mKVbM9zQElZ/kl4ML7G14EyXYTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4404.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39850400004)(136003)(366004)(396003)(38100700002)(966005)(76116006)(53546011)(4326008)(6506007)(31686004)(91956017)(5660300002)(186003)(83380400001)(6486002)(2616005)(107886003)(122000001)(8936002)(66476007)(64756008)(66556008)(66446008)(8676002)(31696002)(478600001)(71200400001)(36756003)(6512007)(110136005)(54906003)(316002)(66946007)(86362001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?Windows-1252?Q?SVyW8duEnQxtmKUPG+oOMHs5NLHGhIcB1kV/pfhTs1is0Npa2GE3isLU?=
 =?Windows-1252?Q?aNg3xax43QL99c4iA05BTTg/duVsHaXPZDFB+KXV+jI42PQ19f1PqXyv?=
 =?Windows-1252?Q?mK8lVY3/Edb+sY3H5L+73Pw+dl5cZ41xiraZnFILj2FE+P8HvINKsiiC?=
 =?Windows-1252?Q?1xfQbM1hx50pRP7EgVU/R7UV5SBeifM/l8pGhksFzSyb52lpQZCGjX+H?=
 =?Windows-1252?Q?HIE/dXJt9voWhV9oTbZDxClv5YO1IObsEnhi8OCg6R6+9pxvtIN5aBXs?=
 =?Windows-1252?Q?90AisZ/ia+G9sWfzQrw4GjlT3l3qRXR6oiQ7gw4wj5NjtwFyatSw9R3D?=
 =?Windows-1252?Q?pT180GccN4kNE6b+K/sI23V86einv0wpa4nsEvQP2vXjUmquNt5X3BpF?=
 =?Windows-1252?Q?GaTx7Vyqpo/+DAGE/dpfm+RAUbDY0Wyuo1JEEN/1zu0C1uLWTpd08grS?=
 =?Windows-1252?Q?wRwMIEq8Fu/WX8HgdfpizMPWUmEnR+wzLkVjpcCST1v7mCXZcoKPh5ch?=
 =?Windows-1252?Q?wSqzbMme9rC5dVl8w/hcvXQR5lUI3PlUwTfNK0mT5RClJ+2Xp2qZuSrR?=
 =?Windows-1252?Q?gHaEghkcQOMs4ZUmUZhfdvdKkpvaXVI9ViowVZodxz5UATjS5DsIbKAL?=
 =?Windows-1252?Q?8fpAVDUqm0HG2UsNuikDDK04tWdFyVavWbHQ3WMYZTCdAW2CTBl4y31m?=
 =?Windows-1252?Q?eN4H5BlEUL74HMm0P77AaX8Dd7HViL+EQH5X8VIfpKqZnZeZUbB1Noln?=
 =?Windows-1252?Q?tjStWtOK7oQu6EWyIaafF+ixJtwXM7SFJDL2c0OoVbuFLLXeUiU39k25?=
 =?Windows-1252?Q?6QrJEejwQ9DIhKAfFhInRSut1/xRFO6JDNG9gILzWNUN9Juw11jiamhQ?=
 =?Windows-1252?Q?gwBuaIbEZOhIUDC9Qk/rVg5CJmi/B3tS1jJrsz7YS9KKCEc7e37MeqJ6?=
 =?Windows-1252?Q?waFwcNjVsX0rVYVinijbTpfxjaET0DvarHP2M9QKAfTIYWi3WEacZRLW?=
 =?Windows-1252?Q?pWMY45P2d2y7juxkvrY/tFM8eWE9LQ8vim0I/07Ho/7nrqCaKNCusZ81?=
 =?Windows-1252?Q?/6UaVyVE/HPsfcAbfB9W8yuXqZIlEHHu66ZiWTsiy6zBUvWMg/4hutPk?=
 =?Windows-1252?Q?mOvXxgdCs8jULCf1C70hJC68WrggE0Y9DXbzguwY/e59hw27881lqbPy?=
 =?Windows-1252?Q?iZepk0to+foB/Ea9DYm8lm50CAGiLv59bf+jH6X3m39c4+Q9GvOeO4ao?=
 =?Windows-1252?Q?J5uBt+GLzhtwKsb8zgOJRYcStt+e/mqwa1HpEXcBcwmb6UavmX/pPeSi?=
 =?Windows-1252?Q?WOr8vIxJHIQKnCbtwiedV3/82t2W1Lu37gB4wdn5JBltSyIbh0wtePD3?=
 =?Windows-1252?Q?HfU4YThLQDlaASJpZQ+j4aK+Xz9JJYWLjEqVXcxytzzdSb8hqioeNGTF?=
 =?Windows-1252?Q?H+hFBI30uNYS2FRNm+k/tyjuEETF76aXti0ppb6PBY3f1OErhWeq6k3p?=
 =?Windows-1252?Q?/bY0uTGY?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <1F93986D1338744F9A042CEAF862C7BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4404.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33b18e2b-4331-4747-be2b-08d9179f7f8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2021 12:46:45.5114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mLHNCijTuWk2YajUJ69aNMZIIDxTQ4s2kVkBwrEQMttk36ucSiH3QGNYDmh2lTaQmj8sHdfVs9pix///HgdhtHps0TTjhvwqJMHJgcNJxIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2869
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2021 at 12:53, Yang Shen wrote:
> Fixes the following W=3D1 kernel build warning(s):
>=20
>   drivers/net/ethernet/cadence/macb_ptp.c:3: warning: This comment starts=
 with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/=
kernel-doc.rst
>=20
> Cc: Nicolas Ferre <nicolas.ferre@microchip.com>

Ok, if it raises a warning.

But I would prefer that you add drivers/net/ethernet/cadence/macb_pci.c=20
with same change to a combined patch.

Regards,
   Nicolas


> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> ---
>   drivers/net/ethernet/cadence/macb_ptp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_ptp.c b/drivers/net/ethern=
et/cadence/macb_ptp.c
> index 283918a..5c368a9 100644
> --- a/drivers/net/ethernet/cadence/macb_ptp.c
> +++ b/drivers/net/ethernet/cadence/macb_ptp.c
> @@ -1,5 +1,5 @@
>   // SPDX-License-Identifier: GPL-2.0-only
> -/**
> +/*
>    * 1588 PTP support for Cadence GEM device.
>    *
>    * Copyright (C) 2017 Cadence Design Systems - https://www.cadence.com
> --
> 2.7.4
>=20


--=20
Nicolas Ferre
