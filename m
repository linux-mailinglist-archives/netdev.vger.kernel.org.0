Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59131A544A
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 12:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730862AbfIBKr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 06:47:59 -0400
Received: from mail-eopbgr1410139.outbound.protection.outlook.com ([40.107.141.139]:14912
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729741AbfIBKr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 06:47:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h3LT/PeZvVi1ghT1bnPhViivfF8w/yNENiFc7OntSOL4mmnVCFgVFMYHgn/AGeepkoCl/pcwsKV2LYXwp+V5nx/UGOp7rrT8vdDHFxiTEUrHB99lKeXe4TAEcNmEV4jyPkazpBmZNRMlY1KyLsSi9oz7JJ3ZN0wLRzBhMB9cwR7DqaK/kg86zd484UOVRQCEXGNdIHQUWYpaEilp9ydIy9MONfSa2JqRl8ylNVtIBX4skz86ZcQT0NclsnMtkFeAKAfGu3wtE2hyPbHQVQJu3Vsv65iNlri6ZGzYgPjzICXVqEUeiOMqYFDWxvJ9lzuiL6VKCL/llEiraz/AMwyRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/RAhyVUvKUd5tmWVjVwY+U3BSww1tk4fcJ2aGBJQTU=;
 b=DU4FUac/7aF04N7muwiEzdTbN8N0U+ClfyiDdQnRHS9q6Q7NdK9GK8ZA42ZCTav7igUSHHXl+fooPcDKC/x9U0dZbZ7ClCt3BAW+rh9KLWpKf9C7Pa+qOrV+Vo6yaPSsCMEHR1C3Xu46ePMJwgeyEtguHKKYxxVuxYPSg6yl2eFRAEMP9raFX7PBQ2AXhZjWa2QahbbJYWG3MYOIIhWR0sZnYBuf4xvJLViP9dA4FwSGKgUx9R66+x342OeY6uoL9PwX7OP5I7QQJ8xhXB9LKHyCUVtC6Tu0h0MYKnCoXYlqr1TeOiAA7kMUvdZ2eClz9H8jGPz+O9VK0l+JGcMfKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/RAhyVUvKUd5tmWVjVwY+U3BSww1tk4fcJ2aGBJQTU=;
 b=P9V9iWtLytyM4eB95v0pQ8HBITX4zO8S+sqgncYG2qXhOzlUjxpQCNY72BLC5ogFBe1lau6c6+mjBr4ZgLTm5FeFIjaZahXv70oVs0Sy73iWkZ1FyN7nn+JFwWkE78O1tC2KUedvAIxcrC/wwzT474Vp7A9nlAu1LybJzQTQElg=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3792.jpnprd01.prod.outlook.com (20.178.136.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Mon, 2 Sep 2019 10:47:55 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6564:f61f:f179:facf%5]) with mapi id 15.20.2220.022; Mon, 2 Sep 2019
 10:47:55 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Simon Horman <horms+renesas@verge.net.au>,
        David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     Magnus Damm <magnus.damm@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
Subject: RE: [net-next 1/3] ravb: correct typo in FBP field of SFO register
Thread-Topic: [net-next 1/3] ravb: correct typo in FBP field of SFO register
Thread-Index: AQHVYWVb3sZzkHkFj0mwXUnfqqrhT6cYM6EQ
Date:   Mon, 2 Sep 2019 10:47:55 +0000
Message-ID: <TYAPR01MB454408A21C77A3DEC47DDAFED8BE0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-2-horms+renesas@verge.net.au>
In-Reply-To: <20190902080603.5636-2-horms+renesas@verge.net.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4d2254c-4bf2-44dd-1389-08d72f93030d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:TYAPR01MB3792;
x-ms-traffictypediagnostic: TYAPR01MB3792:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB3792D2E45AB63C8F6D48ECEDD8BE0@TYAPR01MB3792.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(189003)(199004)(54534003)(446003)(2906002)(486006)(14444005)(11346002)(476003)(256004)(66946007)(316002)(7696005)(71200400001)(86362001)(66476007)(76176011)(33656002)(66446008)(64756008)(76116006)(26005)(102836004)(99286004)(7736002)(6116002)(186003)(3846002)(6506007)(81166006)(25786009)(6246003)(8676002)(52536014)(8936002)(305945005)(5660300002)(9686003)(55016002)(4326008)(66066001)(71190400001)(53936002)(110136005)(54906003)(107886003)(229853002)(6436002)(74316002)(478600001)(81156014)(66556008)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3792;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GYQ3y3pLDYrPXwd1qRW3zc7VN+gJ+TEcry83JE/wEpqu94JQc0rgUiSnLO3GZOIxjQag/B8HwBFM+dNkL3C1gC1XbO+ZA9/ZQu9LQ6uHwsgk6n85IxuennLJoyqFq3PKKsgAgDbvdh+2kZQJx7mQZhhkNYQgMgnGsrN/Jmt5Exo9PooWma3WynJlGb6rf4ia8zz+n5msf2n6KarKJA560M4eo9DYqVqphhuW42J5zfDFxxT1gXg8KwUaWPu/l559pfzOrbbzRgXHgmT/LN4szfGrqK1eZtO5Lc7e5gDWd5PyCrcTaMiZesmwmkCY1UbGYKWz3MkoZZ25jgvFgEgLtNOPKVZiNzrtitl5N88ldNoGYJrZyipBu+ssOAA4wDcNPXmOV7m5QwdYyKNBvaLE7RnbVwOcU+ohQa6YouIUdKE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d2254c-4bf2-44dd-1389-08d72f93030d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 10:47:55.2661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b4zoAL+QdZ71ABlTewIafisrDLXBRJH8b3WgYKbUHhbr8nOgDnsLOd3q8+YhAlreEZ30CX5QwCT/PYbfh2lTc+hMsZJxa3+rnIP97cdxLSmCgtYR+TWgKxu0zibk2aAK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3792
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon-san,

Thank you for the patch!

> From: Simon Horman, Sent: Monday, September 2, 2019 5:06 PM
>=20
> From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
>=20
> The field name is FBP rather than FPB.
>=20
> This field is unused and could equally be removed from the driver entirel=
y.
> But there seems no harm in leaving as documentation of the presence of th=
e
> field.
>=20
> Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
> ---
> v0 - Kazuya Mizuguchi
>=20
> v1 - Simon Horman
> * Extracted from larger patch
> * Wrote changelog
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/r=
enesas/ravb.h
> index ac9195add811..bdb051f04b0c 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -317,7 +312,7 @@ enum UFCD_BIT {
>=20
>  /* SFO */
>  enum SFO_BIT {
> -	SFO_FPB		=3D 0x0000003F,
> +	SFO_FBP		=3D 0x0000003F,
>  };
>=20
>  /* RTC */
> ---
>  drivers/net/ethernet/renesas/ravb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/r=
enesas/ravb.h

This patch has two same diff. After removed either one of them,

Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

Best regards,
Yoshihiro Shimoda


> index ac9195add811..2596a95a4300 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -317,7 +317,7 @@ enum UFCD_BIT {
>=20
>  /* SFO */
>  enum SFO_BIT {
> -	SFO_FPB		=3D 0x0000003F,
> +	SFO_FBP		=3D 0x0000003F,
>  };
>=20
>  /* RTC */
> --
> 2.11.0

