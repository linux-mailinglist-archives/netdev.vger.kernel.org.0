Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2AA40C0B6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhIOHqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:46:39 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36575 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhIOHqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:46:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631691917; x=1663227917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EP6vpDtRUmp8lCg54QOCCii69KdIlbuTbVMPZnQBcSk=;
  b=aTYFoAgMnT4P9UD6fy4MKTGgmQmAKDxM3CZy/XhnPZ+QofthA/eVcUyr
   TNvgD6JxIWCgeb5Iss2oP1QmMvT0JOOdULu5AxLpS42NQA51Z0tfYyrUw
   q55kmN8Ke+EEPq04T2qnmKfghMg/SPe9KAPNPudp10rVbWVKQM7E5+dek
   +6aFNBsHIUI3x4ze4N0tAbmqgd+F6IG/nz/uzKkeZ6TU7PotNGis8WnWd
   vv8XJB3XVBM2hDwtjqunUjVIg289hFEPaQ2/Lgv5tyOb+x/pzm6zvx/yF
   9TpcEc3RYEz+s+0xurxjq+YkYBHWohD7Vrsqd2bfu3ed7T3mA+KGDdWX6
   w==;
IronPort-SDR: RoRVeh1D2H2sht4YQ8HX7RpGKXyt0Wls3S6BNnk8ydGequFmi/S93HPrwFka7IqGiQb8LkXRnx
 ZMBofMESOw+nQS6M3gshKMo0UM0c5sQa4jBgHTfSPVSkNxCBagJW3kZeU7TdvZMadgWROF2BmI
 UpDH33iUEKMzSdQSRmsIqoA2ydTN3rCS2H6mtc/BCN5XcvR04H5ZalQLYaY+2dh1Ys1syBm3CC
 KHt1gYm2QDWEYoMjUnEt4p21GB4YFIOPZ8nhitL/TO8BiHNgjagiTdsdFtr8ENNmd0b2AMT2Ua
 wxCsIXsKXfkeTQWaYEOrX8vy
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="69363584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2021 00:45:16 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 15 Sep 2021 00:45:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Wed, 15 Sep 2021 00:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3avtYCgLuWwN6s3ZN45Bo4kQQqgrb9qHThJGeplU/MVPfugdUj/KyyD875YU3L+FcKNFOMAAeEnKaUorqcyXXJ3aWGfFVsYHLQUpx9c4U9zfd+5Y1Ss+qeMVy1aRUOamRUJsLAmts9eEoGg3Ztqx0oaHVHoKbx+dy/2R0g1mkVK0rnElzLFl2LO/71K/Fu/jqVCLK9oPt35hEpGIJRv1v0J3tad8v0KBNs+yx9qZlUrr4aUPEgEwaJ/btEwNFMJJOdLCqmnaZ2/NPR1UdbQe/qmvg1Psxrha02YXhfn9lNS1RREAjeZcPm9poJTxKT3jY4dKeFqNeufDjcUPcBgAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=CjR1rgEaY9TbtHxkc3MiD4Qa9U5eb/21BEh4HSrVjn4=;
 b=as/gFlPJ040KR8Bf32Qj9QAU3nRaptewqZkKzYUWJOnJbe4ouP/B2DhV1F+jdKdjpGlr4qf0BTpvhpedn4JtH0NuHsrbt8t6v1RKQxmuZ/jvGPLkuKtDDI6Cxj0aSvllSbnEyzg42MfU0FXrfXAbDmMF60icUrGBztLNhsOToZF0wnApcGa79zucNStu5TXpAzZYEAVZJZWg1i8SQzabNjr+FcqQ8hXx1+3OaouVQrCVy9pi1uXWM5apjnrVgzh2P482V28zzimA4TH/Ws6+GZzsrJNyxAUM9OLk1S+8bEKMO0FD6uqws2WQSwrZ5sXF3bYhVP1gGY67juz5UwczDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjR1rgEaY9TbtHxkc3MiD4Qa9U5eb/21BEh4HSrVjn4=;
 b=swVOMJNANOOK04+1oHkKCdjcfPd8HAkRvGQ+4+VfONzeEuV3XpgEDKMNr58QQGAzc48+AP4TBv5a9ozZdPg2ENZ4dPqT6O/bOkga1730t5QWzsB7j6+F7k1m4ktqnReCJGNpG88cRGRT3yB/l6RzG0sPoWvtD1XB3G7RaunO3qY=
Received: from CH0PR11MB5523.namprd11.prod.outlook.com (2603:10b6:610:d6::15)
 by CH0PR11MB5459.namprd11.prod.outlook.com (2603:10b6:610:d2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 15 Sep
 2021 07:45:15 +0000
Received: from CH0PR11MB5523.namprd11.prod.outlook.com
 ([fe80::8857:c39a:75e0:43df]) by CH0PR11MB5523.namprd11.prod.outlook.com
 ([fe80::8857:c39a:75e0:43df%8]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 07:45:15 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] net: macb: add support for mii on rgmii
Thread-Topic: [PATCH 3/3] net: macb: add support for mii on rgmii
Thread-Index: AQHXqgWeV3owDn05pU+JVXAeYi7U2g==
Date:   Wed, 15 Sep 2021 07:45:14 +0000
Message-ID: <c17845bd-2b32-883a-4b59-a684ee8dd9b9@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
 <20210915064721.5530-4-claudiu.beznea@microchip.com>
In-Reply-To: <20210915064721.5530-4-claudiu.beznea@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none
 header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7efbf670-3ab7-4da1-9932-08d9781cc17c
x-ms-traffictypediagnostic: CH0PR11MB5459:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR11MB5459877665FE8BE8FEE9D11EE0DB9@CH0PR11MB5459.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AMAPwZOnh5qAlaBXMHhd/4XPrAIgFGS3UOgxs17Sq4c4+AU8Z1v+Pe809OXLf4faa2ny5dUf+43l02iQKirVhdqwFz95+XulKr24Ke5RyqTCacN5LYU7LL53jWH9aIIiO+5VwnUeIkR53xx3EOq+W6bf5M0n0frx1a3HUcKTekkU1cnHd3jG955d0vt5IapA3UZUEtvSvRULErv7yujnBFMs7I0T6umxicWZQ9n07lxet8Xfh0oWGnhkwjkMGqq0e0qeTZ3BugGmHVxHz662LfoJdvnvTcWDv8nSsM07gT/GoSpFii/ySjV8o33F7YHUNTYysLuSG6c9ahQc7JTtDbgUPaXwzu6wGi69eTwBLBsjlsp6o7fsCHMAuGwcwhWNhpBV0usHHb9frnabiqkYOUE3vy0GfJaxwz3ewdLjEhMPn7EE+puZwiE164ATrowA7RwYEdiY69DeGlsU5rKYEapWb85im4At3RND8ZBkuaokn5SLzWIiWiWI6V4aufdRLbc2yLEg80kD3UNknPy4ZHlvt9gzMXK0kaiKL38SbxTTQWXt1nlMuG80uizh0TJlJVY/iAIQ9nVGaGVLlpOc+IOlCEc2lRh5zZeTyXoPC96I/7RC7M8kcKdWxrdQM3WLXKkd77ItpsYQK5skmln7sKDGdfeL5k+VwfBMrgVuBMpVbGfCJvsHYkbMZvtVeQ7z+ggKMC/7Jc6WCVRDAHrVBE4QI1zIxg4lUFj8DS3FXQUMB+bV+9D/1afHRR3kjf01k2Nt7vU6kHzevMMClRwY6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5523.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(366004)(346002)(76116006)(66446008)(6512007)(66476007)(64756008)(66556008)(5660300002)(186003)(53546011)(6506007)(91956017)(66946007)(71200400001)(8936002)(8676002)(2906002)(38100700002)(478600001)(54906003)(316002)(31696002)(31686004)(86362001)(38070700005)(110136005)(2616005)(36756003)(6486002)(122000001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?NpXRnBVYzdlkpSXyWtmwTzOm101OFHzSGNN0EZpCaeE6D7aFRMMMBH+9?=
 =?Windows-1252?Q?vZjml2wjv/yImuqJlIOadg9Es76hPuVX6mEiyVvxneWU7xP2w2cy7w1A?=
 =?Windows-1252?Q?CR5JSmDqw+aMqbgEH/1WqcNZZ/jCoGK+Fy9/55rAUo1/WgAmun3gBufF?=
 =?Windows-1252?Q?ZElj70tK3+PgPa/DjT7bhEykWlPNTsEF5b1J6Up0Alm5/ADzSxAmqzLe?=
 =?Windows-1252?Q?mOmciGR+29sVsW7K3+Z1uVddnB9kRDr+pL6tkkCFkT3WnT2rP2qntWd8?=
 =?Windows-1252?Q?WtuMQ9NT5OEz3ai30CPs4q+7a9m/0nS47YufwkWhtkok8d7m4Mu056Jr?=
 =?Windows-1252?Q?yWO3sQOA4ChSQR2EaU3r3saIKz9IsTSUrmqn9sLO6sD042xbND3m/XVn?=
 =?Windows-1252?Q?fR1l3GSLUYoVLI3NVyGMqwGhD0s/lET12W2ijbgkpVVvYZ5qTYq5spQ7?=
 =?Windows-1252?Q?wdPN4xw99ty+445VV5gLbhl9CtOKaTiJ+j1k7dWc0vG+gd1oaUnZjral?=
 =?Windows-1252?Q?PM56s1x7V8oK0UqJmWMW/cMAAak78ZgBj9IWPymjNmlDAGq9DAAaqAQF?=
 =?Windows-1252?Q?A7/c6rdbYl+rlA/gIRoALJhGHunFhuExpAp+Y83L3imLC5hExifRYrc9?=
 =?Windows-1252?Q?P43au4cU5UKIDM19Rn1s7nMkSb1WHFdZhZly/iBc/wuRrAqHxzUaOz3P?=
 =?Windows-1252?Q?5XqDESifKUrD5yQABvzECkCaisjNW8uF8XMACuy/ruNpga3c6LdThePK?=
 =?Windows-1252?Q?nQGr38Pe+GLGUtqyQc8QqTmfSd0EWWVhu8yeZU9ZUjfl+Yn6OI6GIygp?=
 =?Windows-1252?Q?6uiU75RMtmtTw11oGzpzhgxPuZZAE07CGA8+XOVYG33budzJQJL+dgfC?=
 =?Windows-1252?Q?EINnKonb4BK7U1/VR46YXpoZrFoQi+p7+GtqKlArYzJ8+Gyu4OuTYkZ/?=
 =?Windows-1252?Q?Lp1fLQEVF1MnEKHUs0SDFaYZKBzGIT50pnZ7ENz2EqcWtb9sPPl+dC9r?=
 =?Windows-1252?Q?jJQJGK6cpBhie68Z9yxSF4ei0LbsTiqJZL+DS5LB8/Y2aLjSZgLOXR4v?=
 =?Windows-1252?Q?Ud4OMbLGCHx9i+FDvWR0lTAX5fkW/sPWaqtWmrE9gzMcW1WlJolLdrYQ?=
 =?Windows-1252?Q?AxLjray7fRsxZQammvTq1DwE/GQU93stLHNqsgJ0HQ9VRIXocoCy20Jf?=
 =?Windows-1252?Q?OJsvuWcupOI1sW0JmvZmIptSfWVvHom+dNeoSdQ/JO3/gxI+8AK59r0l?=
 =?Windows-1252?Q?P/v9vp1bfGk3OSTUMujpI+ek7D+dSckQAkVDtWsXF1cCVQRQiWYQkMMJ?=
 =?Windows-1252?Q?Mty0ouDBOyDv4fzDUl4XxtdZyI7JqXUqQqaS67mlS/4iWqlBF4+lGDBQ?=
 =?Windows-1252?Q?ZUt7nQs+vSfde4TJji+TDiGproF9VRxpxnIDWIb8N4qgtPTi3WYkwHy0?=
 =?Windows-1252?Q?jXi6fPURHW73DlGYrU2P+NLMVEdb1pvXg/UF5uGWJvhlHoNQ2WzH/2hY?=
 =?Windows-1252?Q?PjjGueuw?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B357219AE64CDC4DB1F2309838FF7EF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5523.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efbf670-3ab7-4da1-9932-08d9781cc17c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 07:45:14.9375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mB4+AnwiuJ+8DxIPGCtAzBD+IE4mrvvGA5XXBdXvr8Bd0Qrh2Shc4gq9B+QS0O4/iMzlcxIqMbn3roknGWoUJ8mBFj+3WOd9zj+vhYlSZTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5459
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2021 at 08:47, Claudiu Beznea wrote:
> Cadence IP has option to enable MII support on RGMII interface. This
> could be selected though bit 28 of network control register. This option
> is not enabled on all the IP versions thus add a software capability to
> be selected by the proper implementation of this IP.
>=20
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Fine:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Claudiu, best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb.h      | 3 +++
>   drivers/net/ethernet/cadence/macb_main.c | 3 +++
>   2 files changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/c=
adence/macb.h
> index c33e98bfa5e8..5620b97b3482 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -246,6 +246,8 @@
>   #define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
>   #define MACB_OSSMODE_OFFSET	24 /* Enable One Step Synchro Mode */
>   #define MACB_OSSMODE_SIZE	1
> +#define MACB_MIIONRGMII_OFFSET	28 /* MII Usage on RGMII Interface */
> +#define MACB_MIIONRGMII_SIZE	1
>  =20
>   /* Bitfields in NCFGR */
>   #define MACB_SPD_OFFSET		0 /* Speed */
> @@ -713,6 +715,7 @@
>   #define MACB_CAPS_GEM_HAS_PTP			0x00000040
>   #define MACB_CAPS_BD_RD_PREFETCH		0x00000080
>   #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
> +#define MACB_CAPS_MIIONRGMII			0x00000200
>   #define MACB_CAPS_CLK_HW_CHG			0x04000000
>   #define MACB_CAPS_MACB_IS_EMAC			0x08000000
>   #define MACB_CAPS_FIFO_MODE			0x10000000
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ether=
net/cadence/macb_main.c
> index d13fb1d31821..cdf3e35b5b33 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -684,6 +684,9 @@ static void macb_mac_config(struct phylink_config *co=
nfig, unsigned int mode,
>   		} else if (state->interface =3D=3D PHY_INTERFACE_MODE_10GBASER) {
>   			ctrl |=3D GEM_BIT(PCSSEL);
>   			ncr |=3D GEM_BIT(ENABLE_HS_MAC);
> +		} else if (bp->caps & MACB_CAPS_MIIONRGMII &&
> +			   bp->phy_interface =3D=3D PHY_INTERFACE_MODE_MII) {
> +			ncr |=3D MACB_BIT(MIIONRGMII);
>   		}
>   	}
>  =20
>=20


--=20
Nicolas Ferre
