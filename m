Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EA0164412
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 13:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBSMTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 07:19:33 -0500
Received: from mail-eopbgr40077.outbound.protection.outlook.com ([40.107.4.77]:60043
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbgBSMTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 07:19:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pbjaev3Qz+T6KdjVw5jGqhhsKqu5KwS5fx4YftHGAg+GSbhs4++GkoOaWL0m3dxzOgjStMz/GE0I43/QF9s3h9VXxSyfOxvaS5tSyxTZfFOCdPmaIA4NfYTwuohqv/4Yw6GHwWIxV/HfZXhaj/gP6U3AXJgL0N2LtaOehv9N0zUFc0Kk0z+CmbtfA4j48Kvy6l+xrPV1gp9NOHVeOiAY/awsUwVASipndhq/nuKE6gxpSUup0GPwcEUVEHvCVE/pOZuxUtZj7WpIHvp5hiGyaY0zHbQzTEvZ8w+5TPhunkj/agwpy19oX5DZfCjwHW/U8iMyDyq8Fic8tH6NDub4Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh9EXSUV0Mv5fFBCu6MQH/FrCxVzaX+YgWzsKtxXb1Y=;
 b=kS4g6/WuKR8JohVku2a2+k/SMDZ0mi6KkrbprVhF74EwZkAR2Q0jB4S1gm1sTIqt3hB48s7Ix0/SZs/u7UDpRS+PBntqVbdvwTtLSgN5l+SCa78crz2AUQpGCkuhueVRdxQoqJWSzFIit80IAqZ95yMsDbR3pAshMWqxkkdH5azanxTZYohbhtoaBYjtH6JB1AMs6ZQrg5so8ryF4cYqlTST4yKGWDoZ9qZ1u2kdUCteQXBn59I1buRIGqdM8Gpd/MLSywCJhcvKKb5da9so6fIF+sdmIx+pwPqLCc+UfWh3Hk1J/mwQpEQUDtS27kyX8rvPlQdyaAChBmpAeyQrHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gh9EXSUV0Mv5fFBCu6MQH/FrCxVzaX+YgWzsKtxXb1Y=;
 b=AlMxq+/7Qt9QNEKi+xYy2aL/dxHmX5NFrRBfOkrr594RMqxLhtRPx1DL7XMvu5bGpqUl5dVCHirAgZVtiVWUYo4vg5zMC49z+Y6xvCSwNEy39Ybjx8QJiC/69uhY1GzXoSh/KmbhM1WUPk/xiP3MzRXZH29QD3ElsZnfSECW744=
Received: from AM6PR05MB5253.eurprd05.prod.outlook.com (20.177.191.222) by
 AM6PR05MB5126.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 12:19:30 +0000
Received: from AM6PR05MB5253.eurprd05.prod.outlook.com
 ([fe80::accf:9b04:db2b:bdeb]) by AM6PR05MB5253.eurprd05.prod.outlook.com
 ([fe80::accf:9b04:db2b:bdeb%2]) with mapi id 15.20.2729.032; Wed, 19 Feb 2020
 12:19:30 +0000
From:   Raed Salem <raeds@mellanox.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>
Subject: RE: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Thread-Topic: [PATCH net-next] ESP: Export esp_output_fill_trailer function
Thread-Index: AQHV5xxq0z3D+VXQMU61/5L3FqQtRqgibm2AgAAAy4A=
Date:   Wed, 19 Feb 2020 12:19:30 +0000
Message-ID: <AM6PR05MB5253244D6DA767DF06C0A65EC4100@AM6PR05MB5253.eurprd05.prod.outlook.com>
References: <1582113718-16712-1-git-send-email-raeds@mellanox.com>
 <20200219121551.GT8274@gauss3.secunet.de>
In-Reply-To: <20200219121551.GT8274@gauss3.secunet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=raeds@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8098551-9df7-4dee-59e7-08d7b535f8b3
x-ms-traffictypediagnostic: AM6PR05MB5126:
x-microsoft-antispam-prvs: <AM6PR05MB51263DB0EB7CA31A0714CE22C4100@AM6PR05MB5126.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(199004)(189003)(9686003)(55016002)(8936002)(66946007)(66556008)(76116006)(66446008)(81166006)(8676002)(2906002)(4744005)(316002)(81156014)(64756008)(66476007)(54906003)(52536014)(5660300002)(6506007)(26005)(186003)(53546011)(7696005)(71200400001)(4326008)(33656002)(86362001)(478600001)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5126;H:AM6PR05MB5253.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a24VXmegL22HHfkBM5//H70hF+kb5NuTqe1nMjgorWOJIg98CJpIsBzy32vMki5aqM2dQwgF9Cs1xZ9OsV63LmY9udaeuMJyuCSgD7UlSkHAd2R5PXUS8DJDPpQqIrRPN7IP8/m+rsF2kFOtU5xwtG8p7gYTNQWl6R/6TqNiYzlyXWCdUoVBPJA16iMYHUsC9HW7sBX5oVDxkG91hQ3X/p9pJcF1r2qg6ajfgvfOkRvQYo+odB2yBDGGqhL+Htn5hp/gIXjkjzop5ZMO/38KTZLZIG38dagwDbyuBD2qribXcTWMCRIq6DPC4P+2YXhnfuK8MNRFfiDsh+1M+4PY0uyM7+eDccH0mLhfBamdX9d0EhBz0n2d8sBp12eIBsFtrxgmIcGSn8cAoYIvHNEt7XW2G/Emol4pqdsRNTavn9rKqr7KK6DtjEG+wHVzhps8
x-ms-exchange-antispam-messagedata: 9Gwb+8B5cv6UYEq2/yrcqkvHWicNs3G3BfuPPWZa1d1LBwkdhyKS5PSv06eIRPvlte6CEm8LePgmIKKyRsI2cRjIiTGRTboKoW/L8FxtQzHGrR8iX/icwNOKZVHakRJ/E1ksLBqMY5bf3ExwX767eA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8098551-9df7-4dee-59e7-08d7b535f8b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 12:19:30.5792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UBHdo+hOOnbG696F06JuO8fjMRsr7dJph+uz5WqsMkUlNpXInJz29BSBpRIAVW6r8RYxjP+KGiZifN8IY8bVnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


 Thanks for the input
> -----Original Message-----
> From: Steffen Klassert [mailto:steffen.klassert@secunet.com]
> Sent: Wednesday, February 19, 2020 2:16 PM
> To: Raed Salem <raeds@mellanox.com>
> Cc: herbert@gondor.apana.org.au; netdev@vger.kernel.org;
> kuznet@ms2.inr.ac.ru; davem@davemloft.net; yoshfuji@linux-ipv6.org
> Subject: Re: [PATCH net-next] ESP: Export esp_output_fill_trailer functio=
n
>=20
> On Wed, Feb 19, 2020 at 02:01:58PM +0200, Raed Salem wrote:
> > The esp fill trailer method is identical for both
> > IPv6 and IPv4.
> >
> > Share the implementation for esp6 and esp to avoid code duplication in
> > addition it could be also used at various drivers code.
> >
> > Change-Id: Iebb4325fe12ef655a5cd6cb896cf9eed68033979
>=20
> For what do you need the above line?
  Will be removed

> > Signed-off-by: Raed Salem <raeds@mellanox.com>
> > Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> > Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
>=20
> Your patch does not apply to ipsec-next, please rebase on this tree and
> resend.
  Will do soon=20
> Thanks!
