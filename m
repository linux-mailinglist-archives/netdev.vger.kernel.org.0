Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD7A40C10D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 09:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhIOH4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 03:56:51 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36098 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbhIOH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 03:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1631692531; x=1663228531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eBiEaZJKurPXPHEDdL7ZuQPe0wdcp8tDWT9tuEHkfxU=;
  b=uaU2LTiyrMu/O8xxEu22aSFhg3F/k2sOdIZpxjP0e5L/CrN/EZScM7ji
   caOyltDQjgQE8XnbYpemAuOIJD3yvTKeEN0Vt1wfyc0Tt0m/4ked/F8L7
   uboAj0KUCluh9uYvLxJTVdJTfoorIbXZ3/oABp2bJG4Y/BrQEkMPIZlK0
   31gqZutdR8BXk70ad4jSVgGv0zWIy4qIFWZ0+YXXedbaKNm43DVU1KG6T
   ZmCHOhFA8R0qgOxxzQeLV0KSfoVfKY0ZghfRMhXXUrmMVxTwRWtEMGxLC
   C3Vxh3uAkYj9HWn58tT+7vbI++4KrGDTtbzu7SyCooP7Z3dDx7WAxDF9f
   Q==;
IronPort-SDR: LNKcgbHwijBB5cH5NX1SPmdfeUwIINnmQ76bB9fCisrkN3fzzwP3RWk11vg6Cnl2pYVOXEsPxW
 hXr5rzrUFv5CmxHtQxspjZpa5tVLcO8Y/+pF0z9+rT0GRlcnGkCu/NUWI4NkRx5WOIVADds7XE
 hsfPbRvRqYrD3TlIKhBcPScHhbmOsaQ9lMAZoIYN7Vq9W3aQimiFNWXj2IBYtg+TX2FezslMaa
 bqW0bMe7xeMKnd+ptIQywJs7zIl/JNCgy1kceOOvVf2/XGNeTnWSNGFH4OtR5mmj/oTj407hGk
 DjhJAls6QUx9zI+dw+n+V7+3
X-IronPort-AV: E=Sophos;i="5.85,294,1624345200"; 
   d="scan'208";a="136600736"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2021 00:55:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 15 Sep 2021 00:55:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Wed, 15 Sep 2021 00:55:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4dq2FM53By+/4g5C7zm2y2djSE3Hukbk5V7yRlag/3mh6DQ+yh5pPogloZElsqYm8QgrWy46dxZ0r0yOfqOnAl2uayvSU/pbOVlbWum0Ckb3kwQQsprijeEqfI4LPe4OrUezyp80GpVFO9FXiYBR8qGvsXCEfzthpRwIxAU2gOa2/Xb5rS5XhCsvlrD5tSRGm0aJnSlzi+C5N9Z3amDg9UGoN8Bsg5CZdFaf/Z9Xt+OtjY2iaaZrYo3XdP4hBnx67Fcdvj1wG5u3JpkO38ccAV5Mvu9H84+0cgq6CRIjfx8H02e4nRLqNr3oIpqa3YrTnZqjXQfovkbvNVQVBQSkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ppvjlYOrVcU2ax6+A1YKu7AvliLpZZ0DOTnr3LDczUs=;
 b=FQeanHpCYoxzQ9ccTjpqpF8tSGRiZNN7LngrMPhMTY2piHZDpU28KjR1LU/glpt4DBRSwvzFGE6PjIEllRO4nICu0BKWOoWBDGErrBtdGKleh8S0h5fxjA7oDBwfrJBRfuJXf6coJof1sLJcfJPyNG+lck77Y9G6E0x1ny4pCAz8CeP9MvJ0dMHdnr/VqmMHZ74BA09Z/6gHpwuhlYm0onJdkIkZtXvD7hbW7cT4n0SWD3ksjnmP0NwXzMqCWa21s+x+KhTUdnY/y3OrfJ/mEWhlBUpebV79Gssaw8+fp9ZClQX+9O90qFTUxw3Nto+QX2uOydIKY9c3FGPNsfuDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppvjlYOrVcU2ax6+A1YKu7AvliLpZZ0DOTnr3LDczUs=;
 b=Yh1mNH9z+xrPWb8cSeSwWI5ciC5ccrN7gFB/w9JEIH6HKhGmoj4nitN47UNCg83QoXOsuNMEdMlmwm3ulrDarCxYNsx2vjSPyZncVQ3qrNT9Svz/BY4wHLK/HNuznaoj6kF63h53ly5QcpvSWjG/CxK1K7BATxZ4aBhUSHz+arY=
Received: from DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15)
 by DM5PR11MB1449.namprd11.prod.outlook.com (2603:10b6:4:8::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.16; Wed, 15 Sep 2021 07:55:29 +0000
Received: from DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c]) by DM4PR11MB5536.namprd11.prod.outlook.com
 ([fe80::e016:4c8f:2234:fe1c%7]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 07:55:28 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <Claudiu.Beznea@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: macb: add description for SRTSM
Thread-Topic: [PATCH 1/3] net: macb: add description for SRTSM
Thread-Index: AQHXqgcMENe33T70e0CU6kEWsXu1UQ==
Date:   Wed, 15 Sep 2021 07:55:28 +0000
Message-ID: <63b34d23-4233-d9ac-439a-ba4e5d285a00@microchip.com>
References: <20210915064721.5530-1-claudiu.beznea@microchip.com>
 <20210915064721.5530-2-claudiu.beznea@microchip.com>
In-Reply-To: <20210915064721.5530-2-claudiu.beznea@microchip.com>
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
x-ms-office365-filtering-correlation-id: 3e303668-cb2e-4963-be53-08d9781e2f68
x-ms-traffictypediagnostic: DM5PR11MB1449:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB14498E28230B27C60370D27EE0DB9@DM5PR11MB1449.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bFspr6+fOeIilf/iyhmb1f7DyEZbOHa7pwTTWt47g+TalCjdon8BS/82Bs5GVg8ZNE+X2KRAMrqaRpjr8eoqrW1OHyxorw4q8+vguXUDNPNPU0nmh7/wK063XXFK6kgA1pJJqnMtpKFT9uIqBlzAJuxYQE0CT0rh+tKJp8RJYWr6a3VZ6aEPSbMrQ8QTpTJFRL89vPQH0xZeKcgLJl13RKrrYCijis261Ejx1bj0C0VV24JOP4V6dTF9fSyyWarYmnzG1cTebrA9J8KJf8mW/HTDzMxrC6QgGRejpZAWdVssfezzuTyGJNZTPcfkFS5c2haBhqXn7DudNeBgAtv143uGn87qQUiiZ6HkOo8SEDHYHiVNhU4bhLXUSyyY6CLpr8hT8rMF8xD8OeYGIfkhih8Bkp3S67KxMH+uzzVISgVBdVX3R0SVI5H1YV1AxdisaMVKsdxEi6t/AaxjJ/XPHgichrTnCx0FDX6kpRmsJQ2XYSiWb4rKw0r4el5yIPff/fw2JoaYW2IEby6oHT2ayRT3fxiy8zmtT4EF/Tsgj7MiB2mqtFL2CmtJbxxq87EG4g8CPh2MUhc611R0ob6m7kWly/rcAfnt+EzzWUXYGfJ7H09AJYMgLLXeLdOIdvPdSxZb/pYWxGOhmNrCcLSIlbhjibXgPBmEVp8lwYVMZUH1OWee9Uyp64L6Fxm9pWDH7nzy17t4BqwgOObW6w9rNhNDeWRJ0lEjJJEhngj5jFgES3bOhZ0M06YIOXWEhIj33JaXgitvOudhNBwtxP5bZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5536.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(136003)(39860400002)(346002)(86362001)(76116006)(5660300002)(83380400001)(36756003)(91956017)(54906003)(66476007)(64756008)(478600001)(66446008)(6486002)(66556008)(71200400001)(53546011)(316002)(66946007)(110136005)(4744005)(38100700002)(6506007)(6512007)(2906002)(122000001)(31686004)(31696002)(8676002)(186003)(8936002)(4326008)(2616005)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?wT//HVaX9jsYq3tBmUv+2G4vo7IDkm1eXGMlzmJzgKLBCf/K06PraLbc?=
 =?Windows-1252?Q?X+L9oWJL6n9XlZQVWG1tFewBw4wX7rTFSpN5O1Yqte4NkBHnS8ZrUjel?=
 =?Windows-1252?Q?6uZnUh0ulp9Aj6l1cTGXi7dmsRsO1rGnjlRq2GeIyp0fmQks8o/X5qHZ?=
 =?Windows-1252?Q?LmjH4tdrc9A/jWBfXl45YBwfcX8vbUigLdLPdnTIaohQJVQ42FAVESTq?=
 =?Windows-1252?Q?YzQ4sVWN+SibNxqiRwtLCltTNMGzUrfBtIdOKYVogUuISij/VNjRoxp+?=
 =?Windows-1252?Q?xX3qy5tRCygftqurBn4dPM27JONkBtH2XH0/8Nq18gMHpTEd4CDkazNn?=
 =?Windows-1252?Q?IVtkt9K00l+rjob5EmAdqOXtZOtlaZ5s9gkzGujIaph8PrtRUAooFx1P?=
 =?Windows-1252?Q?bTPEzw70oPX4/EMJlirKc5nmWNC4W4s4VicYfiK+eUx6CdBOS7ZINN6Q?=
 =?Windows-1252?Q?convmyCrRDR/Lgh+POVXAUR511KMKdHNK6TRkNIXSco1OeKUH+Z6Fwp+?=
 =?Windows-1252?Q?sE3GMrF4Lzty7Qo1N6R1uuOlN7AYreJQ5AsCX6YESnyQ7+rDPWjmCLK6?=
 =?Windows-1252?Q?iU2TELgh5iLyoEZRFOTRm4sWTj5fHEKCEgggpLblfIJR28y49X798uDv?=
 =?Windows-1252?Q?E/pFq29TXIcllGAst4E5sM5QrwWOu2cZMuYKgEXMNwkFwk4GGm15TdO5?=
 =?Windows-1252?Q?nCOwbKe4HByhDJxTAWJuEJIRjOuPVj7gqO4hXLaQj3NlRk3ogM/902ET?=
 =?Windows-1252?Q?XlkuOt49QBF/e4F1DvT7xTmCzh8C6YqsFbqMowzLBnQq+H9kTw0rpRU7?=
 =?Windows-1252?Q?0FC/KZEu/ekgJn5T6IOCdHNaDOlsCkc86QdSvJhzOQmM7fE08tGyKeib?=
 =?Windows-1252?Q?hM4wu4QtN3XSZloeJPnt8LE8U1OW2aO1bQWRFZ7g7H8nq5DzgodscbnA?=
 =?Windows-1252?Q?zZcMGni9PBQG39/qnm+tytOtHjpcm4lda4A2YYWbs2eoDftDDvmZHuba?=
 =?Windows-1252?Q?7pZXbcs6hcB9nWh9gVMDhyARKZdCaCxQMuanWr8pK/EZh5x2wR9zstyI?=
 =?Windows-1252?Q?5g14EIdtWgzuZOCT1hCUwCjBLH4/PCktYFigA/ogwboM/ntTZnS6mXOp?=
 =?Windows-1252?Q?4UNrtA48tqK9pznF+auP88968xY3KOm3+UzBmnI0X6CRiG9S3Nm6O+Xt?=
 =?Windows-1252?Q?n4y4/UCCclqGejzpja3KkZN9I32U3PBWVPVqpo2Fa9mYczuQCAAWJUGg?=
 =?Windows-1252?Q?oCrbMJ8TTuTTYeIk0G2bAT/5CHhkKyLrju7TK2urcRJXYfe4mDBTTtj5?=
 =?Windows-1252?Q?2FT5LgyOpzRMZiNoDqe/5xevv6EM3kRPbU6MwKGOf0bemXv3ek4XnUFI?=
 =?Windows-1252?Q?+i5mi8N5SDlr9ssZCRHZ9gg6FYzTWS2oev0s/GX7qJRfb6SHnYRq9ge4?=
 =?Windows-1252?Q?OuHNfk/voaFdUJgSx2enLAHLxMBN52nhvLrv/Ypf92L1neVuCjfKh5xG?=
 =?Windows-1252?Q?hBr3b1ay?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B369E9FCF62AA040BB11E7BC316E97E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5536.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e303668-cb2e-4963-be53-08d9781e2f68
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 07:55:28.8415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KUL0PU6fZ/tXYZGJG+HnOYEO821DLCQPjFsF2p1UsOTcLQA8ZRx2fj498I5FAAp5Y+Ct6df0VsmSDqRMm16FHw9odJAQlJ+9wpccRWdw1Z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1449
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/09/2021 at 08:47, Claudiu Beznea wrote:
> Add description for SRTSM bit.
>=20
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> ---
>   drivers/net/ethernet/cadence/macb.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/c=
adence/macb.h
> index d8d87213697c..d1e0e116b976 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -243,7 +243,7 @@
>   #define MACB_NCR_TPF_SIZE	1
>   #define MACB_TZQ_OFFSET		12 /* Transmit zero quantum pause frame */
>   #define MACB_TZQ_SIZE		1
> -#define MACB_SRTSM_OFFSET	15
> +#define MACB_SRTSM_OFFSET	15 /* Store Receive Timestamp to Memory */
>   #define MACB_OSSMODE_OFFSET 24 /* Enable One Step Synchro Mode */
>   #define MACB_OSSMODE_SIZE	1
>  =20
>=20


--=20
Nicolas Ferre
