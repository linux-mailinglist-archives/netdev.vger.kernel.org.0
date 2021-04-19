Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1219364111
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbhDSLxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 07:53:19 -0400
Received: from mail-eopbgr110095.outbound.protection.outlook.com ([40.107.11.95]:8472
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233990AbhDSLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 07:53:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=elVNSfUpFrR8hT+pKeS5H3Lc9Ug5VYrkojgogOlqPwyQ46ia7iVu6rctvyAKwpj1F0JDpMvmtSaHOUUO2D++RTdW0lW0kpHdBuUbjre7c4CUewoF4fbhsLRMvw5xFDAmON1WgVn/GikW45ObUEMThHtoGzSFW+QubZt2PLI5w6x9DR2990p8H7XMScEY6cXjZ4jWujmcyA8vEYlHhT2yO/qwWVvcoU9mG8nBC1etvz24XzLOHz8HODr8pnNFWy6wrHdE+2oxHvEiStdFBZRuTQzrYY3GS7IiD+qtoK6G/UDuaxko1tNWPj525ZOXdw1QAMj7WwglfYAuvZmI99sKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7NYwEyrThm4laGKy9WOxQIhgdXMM/y2xtTjN15/dZA=;
 b=PTA8+WQ/sEN6EBNBYG7HWK6FH8Fvalj+enY4LWOHIpbMyL5/acSMBs/tlSePhwY8wvORePbZD1aJMyKWXDMFpEIFBR2VRDrsHzkGUn74xl06Yr5Fhigcry9NfI55sMityzJW1z6SXj+g7L27HCGM1x7zfmG3qXOQ/apZYQk1edq9QLnu3tWkcc7C+lcJbUB8NLO+RoGtf7oDB5LF4jSFXaUc7nsbXAd4es6pu0PyV4pWo+nerSbCTR7jTTnSv0emjMGMmPXQ29cgfuptCWTbOF099jB+AEHcR6p3ch5I0iH/rM8zwm6qYJu9Js6kGeX/incNwnV6T7zmaKWqcDx8ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f7NYwEyrThm4laGKy9WOxQIhgdXMM/y2xtTjN15/dZA=;
 b=wYcQcT57P/Sc5u4+3hw9ONfuHl3yzsIYotLc0RScO67MDpwJaeDDevd5/8HWH0x0hoxkaI/HEM4rdNH0/2P5LmBnBIC923lGlMUMYfvile9QFi5dRGYikVClTb2vKNWTb3el6B5VpD0CXvzWzxjQphfD4/kwfRCMEhWvrqX4T7I=
Received: from CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:5b::8) by
 CWXP265MB2232.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:85::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.23; Mon, 19 Apr 2021 11:52:46 +0000
Received: from CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM
 ([fe80::fc7f:716:28ee:ee85]) by CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM
 ([fe80::fc7f:716:28ee:ee85%8]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 11:52:46 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: RE: [PATCH] [v14] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v14] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXDECYN+cbMaQkH0qr/5BknxpUK6q8C0kQ
Date:   Mon, 19 Apr 2021 11:52:46 +0000
Message-ID: <CWLP265MB17945FD418D1D242756B2AC4E0499@CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20210226130810.119216-1-srini.raju@purelifi.com>
In-Reply-To: <20210226130810.119216-1-srini.raju@purelifi.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
x-originating-ip: [103.213.193.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e025ddd-e42e-4911-870b-08d90329a61b
x-ms-traffictypediagnostic: CWXP265MB2232:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWXP265MB223209E96D6FBADB8A1B95BAE0499@CWXP265MB2232.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tTZyIc4FcCKEwwyHSlZ1J8iexO8yh/h7qotcG7/4RFDPTpgNOJNdaB0xomXQmghDpd+ScOtqTQzgpR8A+9oykB2e8d4d6fd+tN8FS4d449rZTEhuZVo7N1qO5lG/MWA+uVY7kTPoAVrpV8cUXz3OxORm5x2YCF5ychICKurqQZreDPOe1q+1KR1uvawqb14oxN5+4jFEyi79mxHe3YWNWcrYh3CbYKmQ6Dy7E9gGgb6jmAXNuJuWJBka3iUKcMLzQFrzf+xAc5gj12SVCsyBh349s/83BgwlRn7+EEGs8Nc4yVOYKddURaPosCpM8h+7ZemeVdFk5BoCnbqxaqzg9vIzw1S/Di+k14+pqzcvDolIC59zTqXiNs9MByzHwEoG+2eOVXVrSXujI1h7iw+RIO7YLTZQiNeNnZ0t11LzFS/74PDI7spE5oAM5zjYhLQfOeoDGWnaeypk+ONRIdvZRrg1F9cFO0lOfwGJpzjmvPaQFecrCmvaLf4zR3l3RAYQZ3WYArW36HAgAc5+XVlShrlGsI5g7XYZHR/Fheo/ZP9IJo7gvMntonJXC7GdajV+V1IMTCP5PPWZdSrP1IKtXwO36ULFfsmTKi/v4HjCvRc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(346002)(136003)(366004)(376002)(396003)(39830400003)(8676002)(5660300002)(52536014)(186003)(6506007)(6200100001)(54906003)(55016002)(6862004)(316002)(86362001)(83380400001)(26005)(33656002)(122000001)(38100700002)(2906002)(66476007)(9686003)(4326008)(76116006)(8936002)(71200400001)(478600001)(7696005)(66446008)(66946007)(66556008)(64756008)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MDARW2d2qIUMKcgq79/GXder1NKQfeoN6xg79BJIN55C8R9C4J8513SPHGaC?=
 =?us-ascii?Q?Kj7I02KYc7ABOauCdpCtBSjd9lDb2KZFZtKx924RlACN2sqtwX2TAIcduqHU?=
 =?us-ascii?Q?BcRj6DWs++G/AAhSYm/3QRyS/HCvXWwJjwsMJGvRB2a9LXOIx1ODbYD5QdLj?=
 =?us-ascii?Q?Cov3FYdSO9kGSgi2mx2Ro3c6w5EmjqG1W9C7Yrjx+yM98cSUg8d9X59QkrT5?=
 =?us-ascii?Q?CMcKVgpsgKGdf7IT2dfppyh4kM/S4Eo64AFHMjV73CAiBwJd+6F4un6zW3i+?=
 =?us-ascii?Q?hoIN2np7Fm2MgnJX8z22FhX1ORprKpm6U2bDTzjVnmOfvKu1lVrColG9aReX?=
 =?us-ascii?Q?xw+005xKIYaJOIFfuWC22ajrAHENs8RL4NGeHuAG3NtDOV+ZxZXtGXuJ4S3j?=
 =?us-ascii?Q?i8Xor8ucmicaM19Ltqsi1HnNiczR5u07l9jBeva3aTffXdDH0CH2k0BVKnqu?=
 =?us-ascii?Q?UkRrF7w+sGQEwrnMRnF3d4JnA08f19j+SUfApRHoEQZsVoY9XTGv5L0y88oD?=
 =?us-ascii?Q?phfMZeLDvVzpGFaF9jwuWokUQdTRU9iDxI0HyYcyg4ZpwjPfucE/31DaS09M?=
 =?us-ascii?Q?1MbED7RJ9M9yv4Y1Y+VWy8MYuFp/shYEYSDvRbulrO380euPKShFw3muKUqP?=
 =?us-ascii?Q?8M77k+/dnNdnKxyxSsCdCFGFwIbZ9iSh0dPBtAXk677hbnRG6y+3sEQ4ROna?=
 =?us-ascii?Q?+xnX3oNu/z/vD0/LdP6PWMrA1yavKUXxdHxpRqtaaIF6PIJ0Gsy78asSQU94?=
 =?us-ascii?Q?pGa2ARNqdzOCWrL0Zbh8hd9B4FNl/mPzl1xbJr42fQutsJZpk663YQ6fery7?=
 =?us-ascii?Q?9yGtbJqyOC+jb7ihU7fH6C92XBfi8zLFbNM44r94g8Qo5F5b+nFhnm2aTS7b?=
 =?us-ascii?Q?ULaO5sX5moSNRIXFtMMK0mItKL8s9R8TwJHdYV0hM86YzrLr3eLpwpnZ7ev6?=
 =?us-ascii?Q?IEhLtrsHIe+VkG4b0TD5hA7tUI5bqVH+Y+PrnCxvcnb157qidEOrcceUMYB6?=
 =?us-ascii?Q?TPAjcf1rxUEoNyT0ezgndNRItB1vOFl9JXAwsq5Szlw1QPV9IQOjj7T7b8zv?=
 =?us-ascii?Q?u8Mha6xMQbM3ixU8xYwslnLxig02F3Sm6RPjoz+E1K2Z1Q4KWmiLcj7iJHdy?=
 =?us-ascii?Q?cMhsWjw5S0/j9cZkKmBrnyHyPbWxVNYBFm5bVDtgoJIorPpdyVZYWz8rKUQD?=
 =?us-ascii?Q?DumU83OidGvYD0yREGqZz1t+yjG9y3T0bjFacbghSFB4IokGmH27UC/S6xp1?=
 =?us-ascii?Q?CpQJFF4871AlHn3MmBqX8eMpmi8xonCjRkWKcYQVwGjEwCci4f0LXe+QLYRY?=
 =?us-ascii?Q?jcNc4+aZFjbDF8rnUhwAxo5L?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e025ddd-e42e-4911-870b-08d90329a61b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 11:52:46.4392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pr5ucYjSe4CLX0qv6cbw3SrnzTjOPx7NNlSE6g7R1m5VcCCh2JJfUDu1NunBAv+aTcVPjH+pbntcl0OuFOY2Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP265MB2232
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Srinivasan Raju <srini.raju@purelifi.com>=20
> Sent: 26 February 2021 13:09
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC
> and LiFi-XL USB devices.
>=20
> This driver implementation has been based on the zd1211rw driver.
>=20
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management.
>=20
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture.
>
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
>
> ---
> v14:
 > - Endianess comments addressed
 > - Sparse checked and fixed warnings
 > - Firmware files renamed to lowercase
 > - All other review comments in v13 addressed

Hi,

Could you please review this patch and let us know if there are any comment=
s.
And please let us know if any changes has to be made to the driver for gett=
ing into wireless-next.=20

Thanks
Srini
