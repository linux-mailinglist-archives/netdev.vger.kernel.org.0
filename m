Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DE940354D
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348373AbhIHH2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:28:16 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:18950 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345425AbhIHH2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 03:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631086028; x=1662622028;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=GU+Bdjk2JqBCCD2T323mlJe9iezax5njlkyI0TZBHt8=;
  b=MZR7QpS0buSkFxpFiajnZM8oR8gEvSLOUG0eL/SDonhulkb6Rv8GgQPd
   3Dqihot5Rvt+UBZcN2Z++CCcnHYZgwT+yioucJHVxUCJ4+GB+ir5Uu9WH
   k/NoE3xFQhAEsphgySjWEUKqfUKSbCysIC8HPmC79UiAEhGOJcMXc6rTR
   Wjg2T5Jy8xjHu6NNNeoFYRbeiD5+TJLoE7h417EZbUyIeBNV7yj3e7EKu
   G1TkLt4f4Jdd2OPCP/ZWHx7qUfnLCQnh13gZ4PMSQpf4RVUxTrAQ0W7ke
   ke8z1CQi8apGoOyVFLXIkAasY3ovHHUutN59QWF3UkJqQqoblKQM2EZ05
   A==;
IronPort-SDR: F5gVHx1uQLYM5iULYzdS1nbe7X4nhsqhq/72iixL0lqhMz5EQhvRv/iCj91By1IAGDjeqyEoTE
 YXa69cyi0efwogH7z6g9/VB4+6EOz6fgMEJ6SqE5mCrHbD0OqxNjzcGx3/3F5jdD9eaHKrCXL2
 0k825X7BeyhBaCNiZbh77sIEmGVsdxKqmg9VHtLJOe/wcx0bolC3Ad+D5AHrqIxNgBgvpk6+aY
 7mL7K5qUg1l8USKrd076jaomxQ5UhOJwrUitnYkPHCXUi9oU63DeWtNipISPQPpBKqjNJOhX3o
 KdH69NC1nLn2Pta33j/iLZBb
X-IronPort-AV: E=Sophos;i="5.85,277,1624345200"; 
   d="scan'208";a="135762823"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2021 00:27:07 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 8 Sep 2021 00:27:06 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 8 Sep 2021 00:27:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YB8PNLnyuZuqucvMw9cS+PutGQNn6DmbdVE/dWTHNezjaHct5tYZndiC3wRMt+LOCD7oAON6WUA+7+vmjvP9I2Nv3f/9KEe/uI7zT1+q7Bf/TEoFUUP52kva2gZ9xg4DB1SMJ/5bcNLuP6UCgVGrQblOuuYVEJHa5CI8SV7P5QRVOgdIAoEriPOsVbPQvSc6JcGv9g6Vm+gQynQf5pXv+izeWEBrCKipFJxuRrENDQuyUdNlHGbiuuvSHOr/skWZ6f49seNd5oJ/OzUBNxDcnfEMvKL7L/UHT8o775x/HxdzJGqekqRe68177QqSXQhi4syUZDfxRaP2stj/XizVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=yOd2Pl5XxJ338sx3oJqw1geuhysoz8AEM0qM1ckeHtI=;
 b=YhUHv80v67l5PEqk9KJXklZaiRPE9WihtP3YpweAozwhdzS8k6znZ6G1diHOj7H+T2GAYld2YKS4ywJH8F0DiiRNCSn8XPN2PlMpolEfL4opIzM4tfkCLBgLz4flOoHOKpfguSWtTHoteZGFc+5uolTTYVDcJhyNdyXYiYjiNkmK/WM+tMbobO8zAhGGzTX9PViP1jxvG3Ye++/eI2pq1NRpzoAkaATp3Un3LB287vaKj/PgAbWx8uO+OXMXh7VQ9FlDhB4/w8fTxPxixe/krqJGvwS24xSJ36eSVfEUhAkKCJ6lEe9A+nrh9Gt3FQoX0HMU8ruCnaTq4mZCVTMnCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yOd2Pl5XxJ338sx3oJqw1geuhysoz8AEM0qM1ckeHtI=;
 b=fswOhQ7TFRgHi/te8qaGp8HyUDki7FWhnp0GK1wBDBEU29X6mGIGC7Z/QQxzAnNo3tPP8VB361z7ombqKxNIXSdVMBOi3heDU0rTVhU1htTyI7Cvz3Dw+hGpq6nXCEgFguq7eqcI1go5dUF2lQSIOcs5Ib7hkHWfBDjA6+z+SmE=
Received: from DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15)
 by DM6PR11MB4106.namprd11.prod.outlook.com (2603:10b6:5:19f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 07:27:03 +0000
Received: from DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c]) by DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c%9]) with mapi id 15.20.4478.025; Wed, 8 Sep 2021
 07:27:03 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <ztong0001@gmail.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] net: macb: fix use after free on rmmod
Thread-Topic: [PATCH v1] net: macb: fix use after free on rmmod
Thread-Index: AQHXpILrg944TDc8eEOxLjHp95xqtQ==
Date:   Wed, 8 Sep 2021 07:27:03 +0000
Message-ID: <48b53487-a708-ec79-a993-3448f4ca6e6d@microchip.com>
References: <20210907202958.692166-1-ztong0001@gmail.com>
In-Reply-To: <20210907202958.692166-1-ztong0001@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fe35875-456b-4466-07d4-08d9729a0e19
x-ms-traffictypediagnostic: DM6PR11MB4106:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB410618E7A47A5D87242575B8E0D49@DM6PR11MB4106.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wz1EX9syotrUeJPfxYmOPmXdSwY6zXqvDcNn05uDlJbi7i9AT/cb+egHt2xkhPQzD0MJYpoTX4OzD5t+QBRwwPN+0clFNXdXA3tih6MSqmZFfJk4XWQSaNIxJoUoHPt2dmkFJU3NwJxuGexQayrV/10ZoGL8prhc1iXkOY/r3H/OUc6HWsZefw3/rMDeoG95+yUFqmp+xn+P6GPWg1rQefBsGLdOIsqGoY2/OxP7R/96Ms4nZyB5DmUXxLoKE6tQEvWepYOBbQ7XIRj9NKofQe2w84VKCdRwA+QdLSpreo+MWua+oiFVoW9Ti/eM1wM+CZ7Amr25aDCtGz5fN1ESWXAVFstFZpcsJiX1sBd6C2bGAN0QXrar7RQJv5o77Mck1e3M6X4jlXZ5qrmTh8HYSAlqKMluQBo7s3RlTdWApM0w2VZ/fggOuP4tBaICcjUAsuBJiqUxtX6Ke23P6SUMC0iscBAQ/FuLoGNNJ7SdhhFZWyxRvXPgglhPChjIWr2Wv/0mpRQLlj7OoakAbnkpJ+ji8UDx25rZeGaEibr1Jkq8DWzHdqj7I/x+VzPnVRiFT4L3gcNCZOGlglb9AcmxTrKCOE5tuZK69SdJppTi6DWyZXu37lSbqIegxRaCQqN4eHZ3uQfZmVRIlGJxFRu6BGHzAHl7Xs26xXsGozuhTqENrnSfI2e1fOCrhTNweP3JJdk5HdZ6T7kK8UZ1wTKyYK9gG0ywwf6mNs5LaLVn/Q1OzLPZzsaU/CtCipiGQz5T6dQpwgJ+0Wa6T+QsmprZng==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5536.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(110136005)(31696002)(76116006)(38100700002)(186003)(86362001)(31686004)(36756003)(8936002)(8676002)(316002)(2616005)(6512007)(91956017)(66946007)(66556008)(64756008)(2906002)(122000001)(66476007)(508600001)(6506007)(66446008)(38070700005)(53546011)(6486002)(83380400001)(5660300002)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?I8S1ZYN5Endj5UukaFubjyo6me86oQ0hmeX+nmpm71UVnp+Gk1LHUQCs?=
 =?Windows-1252?Q?DhBY0WFgqi95FNSPWxB+zV5dJOLjZWS4GQTJUbvw3229MILA4AXJH16w?=
 =?Windows-1252?Q?S4ZnwINyz8pQ5hbDehEE3ww4HjqlOskEvXeS5LIv/HWguNX3TbOj/MNz?=
 =?Windows-1252?Q?/Qd6849xx5iSmwl8x2xKs/9TS9DC47NNmAmZAdy850tFlOti0pjVE7zZ?=
 =?Windows-1252?Q?4zpZPpl5Kwqk/mS1mApbqEU4FOoF6JjeDz4HnN4zh8DzdCiaQCYbM6pM?=
 =?Windows-1252?Q?rl/i1bdF86qIza07gNga1QJ8sV09VikazB3nsQhtSfcqmQGTd8zQFXN6?=
 =?Windows-1252?Q?kjmJ2cjcENApIvvqVNy4tifZU3Glp3369Zk1aGp40ZqJZHO6HlNA9umP?=
 =?Windows-1252?Q?bFfnaIddAnXf/FSfFQ7aZTbRo238gmrlWUSCtgAE2QiRI3FpLhfOIITh?=
 =?Windows-1252?Q?30knp/RG3SH1Pb4f5iggpItK+LdhQMcHgAnMKs8cU0UKrQt+mnd2owq/?=
 =?Windows-1252?Q?+XNxJv7ERC0LqV2u/eFEVfAgjktmbDZwB8KzCT1zg1FFVh2e4jme6xe9?=
 =?Windows-1252?Q?oGYrWlo0WtFRjbT4CB9PJD1PBzlJyXzFuJIURL26np18bsXudxA7wHG5?=
 =?Windows-1252?Q?KDvakhWC0J7WFI3ViANO+CEaz56Rnve6Pzvn1dPpd7xWXj0TIqlFNWeN?=
 =?Windows-1252?Q?3tpuqANx/hugSP9t2nHaIuJR/DhD2Pd20CZxCNjrGh1ypS0lKDj6PIJE?=
 =?Windows-1252?Q?VAxX+ipqrx4TODXQLpVvpo3pLQpGyXNA3wm09SYoTY3KWOXAaT2HqpxF?=
 =?Windows-1252?Q?TTc6iebbW/bU4tt0Ex1wtkY/Iy0GGAnnVXY87b7KRkjfuVX26EWtvohO?=
 =?Windows-1252?Q?Eb0gWZpX0A42UWJcOXvksdFlXwW/OVMzni8gp0/DfLpdqPe0UuR5+E2x?=
 =?Windows-1252?Q?I1tKbMMJRq6Ngvd1Ti36I/q/Mjevz3BpmtlBwpdQGQNBTXF3Y8wf871D?=
 =?Windows-1252?Q?7imO9K1cMiIFSyH2FSgG7nyboO2G9D7l8akoe40PoQXk2XCfAJ8qoZFy?=
 =?Windows-1252?Q?8LlFVxBvQ7peXZQobfnKNe/1UkCZUxW128tYinJKv3b4i9QHaKVG0v53?=
 =?Windows-1252?Q?sgrFA4EBNn+hJHGsTFh100etQIcF6QZZ9APTbvNAIZ2AwerxSS9RSsTC?=
 =?Windows-1252?Q?7Tmiv9x0MQGhzowcY55FC/GMv/+V9AkPzACgretOVCP/jfqlew9aMwu+?=
 =?Windows-1252?Q?u3eUB7DLXpZgvy5mBTtgY4ZnEsINx90lM+IBC1woqEBZSP5EefnF2lJV?=
 =?Windows-1252?Q?iVOxR11Eey/rL6n4JaWULimkPBb8M2bSojc9W35xO1svZQr/8SvfYSxf?=
 =?Windows-1252?Q?HWkZHtijuEiG1HDDXeC1Tp1Z7424gsdXtKWPfKSaSWH628dA1ehC2YgZ?=
 =?Windows-1252?Q?VMinyKFyWcR7Vm8Gii07bgvEj/zDWQvlvOm5KqoQ52o/geHfA3TjYKid?=
 =?Windows-1252?Q?sjyjIe5h?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4C89508D9048B04EBDDCDB4D728CF081@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5536.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fe35875-456b-4466-07d4-08d9729a0e19
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 07:27:03.6119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NEqsAJfq/Iv2xoPvCLRyd3JInxFv4CK5l403Ab/dA8C7s2NK4nVdIiDP/Es1DOoddvpiLqE6OZvYbofI/ognowauUqZMHP5u6W5+nTkaXgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09/2021 at 22:29, Tong Zhang wrote:
> plat_dev->dev->platform_data is released by platform_device_unregister(),
> use of pclk and hclk is use after free. This patch keeps a copy to fix
> the issue.
>=20
> [   31.261225] BUG: KASAN: use-after-free in macb_remove+0x77/0xc6 [macb_=
pci]
> [   31.275563] Freed by task 306:
> [   30.276782]  platform_device_release+0x25/0x80
>=20
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> ---
>   drivers/net/ethernet/cadence/macb_pci.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethern=
et/cadence/macb_pci.c
> index 8b7b59908a1a..4dd0cec2e542 100644
> --- a/drivers/net/ethernet/cadence/macb_pci.c
> +++ b/drivers/net/ethernet/cadence/macb_pci.c
> @@ -110,10 +110,12 @@ static void macb_remove(struct pci_dev *pdev)
>   {
>          struct platform_device *plat_dev =3D pci_get_drvdata(pdev);
>          struct macb_platform_data *plat_data =3D dev_get_platdata(&plat_=
dev->dev);
> +       struct clk *pclk =3D plat_data->pclk;
> +       struct clk *hclk =3D plat_data->hclk;
>=20
>          platform_device_unregister(plat_dev);
> -       clk_unregister(plat_data->pclk);
> -       clk_unregister(plat_data->hclk);
> +       clk_unregister(pclk);
> +       clk_unregister(hclk);

NACK, I  would prefer that you switch lines and do clock clk unregister=20
before: this way we avoid the problem and I think that you don't need=20
clocks for unregistering the platform device anyway.

Please change accordingly or tell me what could go bad.

Regards,
   Nicolas


>   }
>=20
>   static const struct pci_device_id dev_id_table[] =3D {
> --
> 2.25.1
>=20


--=20
Nicolas Ferre
