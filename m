Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7FC3E5A9E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240830AbhHJNDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:03:12 -0400
Received: from mail-eopbgr110129.outbound.protection.outlook.com ([40.107.11.129]:28991
        "EHLO GBR01-CWL-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237619AbhHJNDK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:03:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEM1ImzeMOgDCU9DqsJ7BsGv5Z6DGDQEKybftX6CybEHHgR7vUBrcWNyjmYHnRCUvZL1tH0Z7Gfmr0fDaYKUySqbI/m9Fzjc+h6mVN/0ryQsXSK/0JeHTpHUhQK499pCKYPznAvwGGpHYePAI6KoVzo1HALLRyeZnL4pYNg50FATlyamaPEhWOxFu1pqU45AAHQ6J8wgADXWqEmz97Ph5abiTloAMA4xz1p6EEJH4aF/zIcw6mTQyr2iWXUPTM5A+TjiCjb3NbN3oZ7O17d1norMbw41U7J3D/YKaqolRZNV/LIrvApKIxmD0zaW28CtVGtoedLC/dRQXJ4ra3xiNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeBV0AVLwJbLtHf5fcTXSWEAK4znScxJFLKElGUOMLI=;
 b=b7lagZeeEjw9JJet8Jp+zkoIcNML69o2BREdK/xK6uDMdh3R1vpXlIMHc51kSU8KHdP8PmTVhcsy+h6HOHPkiX9jKva6s9+6hcb/ZW119t/QAVoikJA6E6iKEiXqa5gPqLW1owim4K1V/btQvqCHU+iNzZowJZFitUgOOTbUU5TaCueDvfows51oauHhl9VSG4Tk1Nim07EbdGyt4nQlZAO7Uqof11hp4AVP7mtv65ij8/3cJ3P49gIuXr0+ZyTtc0A3eFkDrJc9pwxsSr3VknJk5PTp7HC4sm3suTcfb2QPjS+60gziEVmp67E7oiiEH4ZuM/fpy8Mm0D1KvjQWwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CeBV0AVLwJbLtHf5fcTXSWEAK4znScxJFLKElGUOMLI=;
 b=elRv8b0VYex9cWZK3392ilbDpp4RKoJf5iYK1XJZHUUIk2a9sGmAvZuzoj35L4pWeQSaWAj7mBQsfzK9oPhzv+EuSGri4nNiF49VffCW33Jncmy9NXdaXEPKbs6j7QEnvYlUgqfkd4iCrioLhcSJqYbo+R6ItAQGNh8Dy/yjYmg=
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:bb::9) by
 CWLP265MB2482.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:95::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.21; Tue, 10 Aug 2021 13:02:46 +0000
Received: from CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b867:2f6b:483e:62e3]) by CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
 ([fe80::b867:2f6b:483e:62e3%9]) with mapi id 15.20.4415.014; Tue, 10 Aug 2021
 13:02:46 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
CC:     Mostafa Afgani <mostafa.afgani@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING DRIVERS (WIRELESS)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: Re: [PATCH] [v14] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Topic: [PATCH] [v14] wireless: Initial driver submission for pureLiFi
 STA devices
Thread-Index: AQHXDECYN+cbMaQkH0qr/5BknxpUK6q8C0kQgLGrifM=
Date:   Tue, 10 Aug 2021 13:02:46 +0000
Message-ID: <CWLP265MB321782CCA0CC2130A2D59A53E0F79@CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20210226130810.119216-1-srini.raju@purelifi.com>
 <CWLP265MB17945FD418D1D242756B2AC4E0499@CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM>
In-Reply-To: <CWLP265MB17945FD418D1D242756B2AC4E0499@CWLP265MB1794.GBRP265.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: purelifi.com; dkim=none (message not signed)
 header.d=none;purelifi.com; dmarc=none action=none header.from=purelifi.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9735bf62-b6c4-4d25-3cb3-08d95bff264a
x-ms-traffictypediagnostic: CWLP265MB2482:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CWLP265MB24829DE9C3537E26FF4069A2E0F79@CWLP265MB2482.GBRP265.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e5lTTHdYDp9i2BgIVaqJu4N6k6ctVrI3YnsIeuBFh++mAKXaGcsqxmnnoYl/CWl7qHGr1z281AEzZZeqgUN2vkuZhcqXEEjxknQuppao1h5O12B+rDs9ZWTpfpp6mJLRYj+3/hVoUcbNI0X3nOo+7ZBJVY4vFwpIjaqX4y77IjgW8yX1Ycb17u8bhaI2BU0pOtoPoWoYLdgp5HSUFLJ2ZVNnUWX4WiLe2ZHnfCZzuLT0hj7MaQI+IFzzYkcz3YfpM3NisxJoieC5hFpljSjDgK8zXB9SyJ8jR+M5L9UtryRVt5uXxzJH7agqPikQRWcNO8qBaMu0b0a5u0nUb7ec6K9sIrfxkiclt4gleKmm4T9chjICErxhTkC78QO6tIfXMi6kKrcnAkOU6XqJODbnY2ssdNsKIGbqjk9tifYbq+QHufPuNLHJ6TZ9Z9zDtYsBLSBj6aWACosweuUxRThYmBcZwb/ZTXyfjNZRum0vh9GgCpJU+WAMLjEDqKQ2Rfj27nQckmLIGr1el7lDybt6vutJn4wMSj5nmiGIuY5IY0XEtxmPienanZcqpIKRw9aLtlVby9uLeXa2Nal/f3d5cBuuiYzIUQttzibe1jmsPgyCRXkjmdycKHTv58yjZ5JlmCgBBGQIcaoiUoOm+p3PDPO88aEQRS2q1Q5ShFY3/iD3tC+ybe7R2fKJVZEL6rj2+/7rpPwP7sSqWIgzPpxyk4p69oW4fgFBeZZaWhptJAI83I2l1h18m3b2Ig2Nn4uuT/vp3HMUIxr8zZllQ+k6u0Ee8SyKj/mOGOqHZjmusX8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(6029001)(4636009)(136003)(376002)(39830400003)(366004)(346002)(396003)(64756008)(66446008)(86362001)(66946007)(91956017)(8936002)(66476007)(66556008)(52536014)(76116006)(316002)(38100700002)(4326008)(478600001)(83380400001)(122000001)(54906003)(2906002)(55016002)(7696005)(33656002)(8676002)(9686003)(109986005)(38070700005)(966005)(5660300002)(6506007)(186003)(26005)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?H9YV+ZgdwF/VdP56J1WGMnUmRKUluysZGa6agauhSkqhjteOKb3mxDdi9x?=
 =?iso-8859-1?Q?71U3U88lTJwECppLh/5X3CrCsqnOwi2i2g1fmc/lrOl8QuAM2n9ZJcmyFd?=
 =?iso-8859-1?Q?6loz18tvbKAzOJ866wqmexclcxnyoSRappt3b7OnG1ihJjnchxFv6SgQyn?=
 =?iso-8859-1?Q?atqZnBAByuDHiyvJWmPDOhsPjkNFtgSjU6L/CZUHXsgDVIhCmf9yz+2br0?=
 =?iso-8859-1?Q?/RJlofPgarwHoyRBhaehU8T8JJvQFAGwoGEUrkA2KZdNJS62I+I7GjZarm?=
 =?iso-8859-1?Q?yLg8a2Yvcfy6GZEnQ2VMtKFH53sbCFNzQ3gVUKvfnm7fXxmge040Smc5x7?=
 =?iso-8859-1?Q?W59jNLyeCbzH8K7mP0RJFAsjlJ/dtNR19kml1hbIxdGZ5o4thBppu9fUoq?=
 =?iso-8859-1?Q?1pFr/N8DC2NnTLrbdJ1KGozekV9bhYbVl6cin0gwuN4jhSmpwrRZjXhvyF?=
 =?iso-8859-1?Q?GHjJPDRrl29Qc3j8Wl2VFzR5dniatfA3eIbl7/raRkud9QsuoBsH3W8xMa?=
 =?iso-8859-1?Q?wtB8DQe1K6jm5wlbxodi9oFpv4b6Gdx8Kb2N5SdQ4p0gKBctb1BVsmX4CJ?=
 =?iso-8859-1?Q?ivSF8qZcXrxjlFj5u8n3uxUm6MvY15/g4kozLF45Buc5VPnmfbOYm8xQG9?=
 =?iso-8859-1?Q?/oIIxsAEXf362WrT49qil2aoK8G/pkpbCvef6qcy1qArs7YMDjEbrLGfAj?=
 =?iso-8859-1?Q?p7Qwg6jsvZG6LOEZSa8AyBG2150DYeJXDk4n9PG1MCK8pCcm9EX9bMoZnh?=
 =?iso-8859-1?Q?al0taxh/SyhpFOAe5JyvmzdHxwcc3XSRIAoDmynjT2MLlxWkjiEkIA/9mC?=
 =?iso-8859-1?Q?YDdBe2Dg88jF0Eg6zWKSxEcnK+0zEgPa7WDavqApWq52dRU4F1uvhfGZLW?=
 =?iso-8859-1?Q?tW/ZaB+IoQ3qlJN31glWg04uIQtyB2Gd0OWejB7ItxnHVW/Wo9PZmIEn1U?=
 =?iso-8859-1?Q?q/Kp9OuW/ko/IH2FnoecjnvodWaweOXsTzfhFeTGUuT9+y1a7RbecZSZes?=
 =?iso-8859-1?Q?nC9QuV3Yf2wLVLLcvxswDzvt/q09LGTo18vgkmZbpnzakvUJlr5vYtXIfR?=
 =?iso-8859-1?Q?MvCYI4z6KPNXI0otSz50CSEMs8OTqXTeHvy02cyjlIUyhJa9xJgUu2Lf3w?=
 =?iso-8859-1?Q?qucntay80CloDbHZRiP4DcBviVO/9NDefGHQ4PgFvOl0jAJfLwSvqbI1fV?=
 =?iso-8859-1?Q?lnqXi9C1IYmkE8m/0wwgtZ3lj3wglMxdodsQRJviKSjWlnWisSJkpWiqQY?=
 =?iso-8859-1?Q?xg0FWk2jhvTcY2B6tCTYMtj/kXOOPnoqS3qQgeJ64bMKkFo224nkk5vl0I?=
 =?iso-8859-1?Q?wtlbbqEJ3DypoQVLLw1pBD2FUY5+mq3gtHuJvak9d4sQTeQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWLP265MB3217.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9735bf62-b6c4-4d25-3cb3-08d95bff264a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 13:02:46.5937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iyakYH+l+ak2CiiGkZEz/LGOhCcnlNCWSa7QuLJ4UtY+n4s4QqBQmyqHHEbfvhBl1BSUs+51cKno6JD4g816Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWLP265MB2482
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
> From: Srinivasan Raju <srini.raju@purelifi.com> =0A=
> Sent: 26 February 2021 13:09=0A=
> This introduces the pureLiFi LiFi driver for LiFi-X, LiFi-XC=0A=
> and LiFi-XL USB devices.=0A=
> =0A=
> This driver implementation has been based on the zd1211rw driver.=0A=
> =0A=
> Driver is based on 802.11 softMAC Architecture and uses=0A=
> native 802.11 for configuration and management.=0A=
> =0A=
> The driver is compiled and tested in ARM, x86 architectures and=0A=
> compiled in powerpc architecture.=0A=
>=0A=
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>=0A=
>=0A=
> ---=0A=
> v14:=0A=
=A0> - Endianess comments addressed=0A=
=A0> - Sparse checked and fixed warnings=0A=
=A0> - Firmware files renamed to lowercase=0A=
=A0> - All other review comments in v13 addressed=0A=
=0A=
Could you please review this patch and let us know if there are any comment=
s.=0A=
And please let us know if any changes has to be made to the driver for gett=
ing into wireless-next. =0A=
We have already submitted the firmware for review as well. The patch is in =
"Awaiting Upstream" state for a long time. =0A=
Please let us know.=0A=
=0A=
https://patchwork.kernel.org/project/netdevbpf/patch/20210226130810.119216-=
1-srini.raju@purelifi.com/=0A=
=0A=
Thanks=0A=
Srini=
