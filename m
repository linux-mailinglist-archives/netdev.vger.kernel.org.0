Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F839A5452
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730994AbfIBKtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:49:07 -0400
Received: from mail-eopbgr1410094.outbound.protection.outlook.com ([40.107.141.94]:15314
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730013AbfIBKtG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:49:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN+zkQ6IT7efDZQLOOksoRjQ0je9B6+y38WYfWmPY/+1qlPaI5F8d6Y61EVnnSoA2cIaaVpPW8qfPbIo273MjGbrCgESq3X4DQ3gaqy4tlKWnrGVwwVXUHX7dPLnipycdLZHn24l+fjKRKtLCRhvlPXngVR36v0JQLhizcWn28xON7GFPN+hBOZWSxR9l1JI8L0VHBUlxah8f+A9dpwQAE6QuTjUjRJl2om7+sZaJUHjr2w/U0rvY50o9Oqmp5QUKtvPDtyL/sXlRBbvAW1dg1I+A6/x+TSC1U/PDSl1gTo8nI5AbB1bGR3Hh68ax3KDHEHZYS5rKq/HTAJdwLZ/DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4dje/sZgNS7/Roh/7Rol/oOXQB7n98fuv+gu2tKVkg=;
 b=BbY4ZA79jinuXwDIoATGVKWCEg8Lp4ZX+kxJrn31jGGRy12CyF0fY+nv7XondDMhzfU+cqX2TYLQY8aYLF3XqEV6gQsCuelV8QHPKjppP4phHUP6VW4tIoTNifTy2OCxchUDLYXeRiH5dMljpv4e8tkV60FUoPObsdgwPdgqW99Z3NsUcHzeiXdgDcyJWbhbgZ2T1lLrCdlxap1v48E7XJObS2NY8e2J3nrUJ2ZNX/ivBLgaYzgt1fDDNdz6btZ5oaoT1zss/ocYOwTh0d5lXT32qJqkjI3IAeZoWv8FX3oNnivMJ5nCYv4+aDtHxysMJZUiXGkuqa3Y1kmsZoWZ/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4dje/sZgNS7/Roh/7Rol/oOXQB7n98fuv+gu2tKVkg=;
 b=ZiZX9XpF9bD6Qhv42D2EGJdEOLKqTOqLFwewcx1EdnvzSCFPWntB2E3EQjKbCZjoriovco/lBF/MrZhVbeYCb3VRr8Wig1CSidUb329Rfzsj2KXOGBZX+wwv3hwVpC6alDKwFDcP3jOd1hZTMfuoh/2B4jsLyTEraq7DRQ4kdMI=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3792.jpnprd01.prod.outlook.com (20.178.136.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Mon, 2 Sep 2019 10:49:04 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf%5]) with mapi id 15.20.2220.022; Mon, 2 Sep 2019
 10:49:04 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Simon Horman <horms+renesas@verge.net.au>,
        David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     Magnus Damm <magnus.damm@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Subject: RE: [net-next 2/3] ravb: Remove undocumented processing
Thread-Topic: [net-next 2/3] ravb: Remove undocumented processing
Thread-Index: AQHVYWVcjqr52OSdJ0mAJO6oKTjcracYNQYA
Date:   Mon, 2 Sep 2019 10:49:04 +0000
Message-ID: <TYAPR01MB454423D6A03D095C4EF282F0D8BE0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-3-horms+renesas@verge.net.au>
In-Reply-To: <20190902080603.5636-3-horms+renesas@verge.net.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f39e5b8-4a96-4512-6631-08d72f932c3e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TYAPR01MB3792;
x-ms-traffictypediagnostic: TYAPR01MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB3792B5D46254C4A1D0CD4E1AD8BE0@TYAPR01MB3792.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(446003)(2906002)(486006)(11346002)(476003)(256004)(66946007)(316002)(7696005)(71200400001)(86362001)(66476007)(76176011)(33656002)(66446008)(64756008)(76116006)(26005)(102836004)(99286004)(7736002)(6116002)(186003)(3846002)(6506007)(81166006)(4744005)(25786009)(6246003)(8676002)(52536014)(8936002)(305945005)(5660300002)(9686003)(55016002)(4326008)(66066001)(71190400001)(53936002)(110136005)(54906003)(107886003)(229853002)(6436002)(74316002)(478600001)(81156014)(66556008)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3792;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RikvzioKVJyFC/5mEv/3IziTBMjLuImcK0AM1SIfZUIVvY0s3zTRXQdRc6ILSD6lRfWmUpCI/kjetHLr3MAel8eD2OelFGFB1Dvld90ywqYKBZaPv8pP4A4DInTIKESuLpT9+EXXxJ8zv+O6W248oYkgFcg6kLECK3FDhG9qS4skvmO0f6LyxADjmk0pLdzDme1xEBMrV1QRGr+udzFXJ8oWDWkbf6nmKWpEp0U0cVKG6ngVrNiNoYZC2hyox4DZdFEyMFlkxVL2motYNUWrJLVzVE1U3PJ2gBardCMhOAhx5bb7ssdSmRqp2BwfSTwchcTPA1eACEhHLbddfpiBYSbTJU9Ff/eBEaPsOZo0Bf6OQcvgzu0okClSxyah0+kyqQ79vbpWlPQwmXwFJ7n5DQyzf713h2KAJQzYRyDhwPU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f39e5b8-4a96-4512-6631-08d72f932c3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 10:49:04.3340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OnnSEsAkSCjjK480PdC46nRmMM3HySWQDr5HjPTzgm/p+doUsGoDoqDgBtiSk2Qj5wRrbh1k1n+Xx3UJd0BIzW1vPJ4keTHsvEFgHj3LrjIjWdPeVTEcomrsXzTSZk2n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon-san,

> From: Simon Horman, Sent: Monday, September 2, 2019 5:06 PM
>=20
> From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
>=20
> This patch removes the use of the undocumented registers
> CDCR, LCCR, CERCR, CEECR and the undocumented BOC bit of the CCC register=
.
>=20
> Current documentation for EtherAVB (ravb) describes the offset of
> what the driver uses as the BOC bit as reserved and that only a value of
> 0 should be written. Furthermore, the offsets used for the undocumented
> registers are also considered reserved nd should not be written to.
>=20
> After some internal investigation with Renesas it remains unclear
> why this driver accesses these fields but regardless of what the historic=
al
> reasons are the current code is considered incorrect.
>=20
> Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Thank you for the patch!

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda

