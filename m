Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A951810AB
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 07:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgCKG2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 02:28:32 -0400
Received: from mail-eopbgr40067.outbound.protection.outlook.com ([40.107.4.67]:22855
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKG2b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 02:28:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDcqTUDYKfIDciT+Qf1y262+pGzOuS9BgbTDcaLRHkBydq6c4bS8V8AVEaWRuTl41nR7qX4LAk+z31VWaytkxOZhIDQv92xAOEtXvRHiLb+eifMhRxGKda3LsOzZJMscPUYZeYgjOrPeGIB4mH0mx76KdW41b75RpszX5+AmMrbhrYVc5tFpoyQFVA9eK/i4K3B1bZiqLAwFUO1HuwJefUWLei9tjot1z/wguMwZGAHsp913neek49kWZEX0EY/YPa97PPBPR6uta2Hb4KFBgX1vsGPPql36mDVkwCH0xpTsNgJdV5tPIfOozFmRXNu7Y13CHrKLOKmBEWzP3Jpffw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrrzdlgW89qyudRrOhcZh+b5nFbUAFMIH/q6G+jBBpE=;
 b=YBgRlNR0tjdrhY1M5yxU11An2dllpSfiHPRcV3MgKR3Hhy4IlzvW914FjpsAhtjqbA8lba9EXyL+rThZTOA5lzgzaxo5YTMe8kiTY7NAPuWnPP1l6YnOVKtAivqXrHBDPDsnMm9URrgHzsH9AbVKK1d9NNYjHZwMrSpN02rHxGDETON+mNr2HQz9joGHGrItVn3MnPWeV7clAsP1z48WCG5VL0JgUNgJHJbpWgRpRQGAK9eHpIqJO2XbnScGrfcLA14tMynnUEBEUvX/hVnBnrWMd7XSR7ndK7rXCduuyK53tc53hEfruLLCfCclF1sU6fqmLD0mA62m8EpW3dP/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WrrzdlgW89qyudRrOhcZh+b5nFbUAFMIH/q6G+jBBpE=;
 b=SPbH7Gm/iVsbfVH3PHVc3se49kMfOSGK8R/Rn6VcENZ8oWOC7pZZswIiNcGyRFRBkNclHKGJHA+wbymk3/2YO7diDWmciUBKtooNcs+NJfft2EJecPrTDNdwvtp3yCbI+JGPxwGsNVzoY2Awkkq7sHo8h0tOqBqJ/wv4WJq7m8c=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6971.eurprd04.prod.outlook.com (52.133.240.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Wed, 11 Mar 2020 06:28:26 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:28:26 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: RE: [PATCH] dpaa_eth: Remove unnecessary boolean expression in
 dpaa_get_headroom
Thread-Topic: [PATCH] dpaa_eth: Remove unnecessary boolean expression in
 dpaa_get_headroom
Thread-Index: AQHV9yg9B58WfTtTEUGZdgGF+/fe+6hC7dsQ
Date:   Wed, 11 Mar 2020 06:28:26 +0000
Message-ID: <DB8PR04MB6985A192818CEB0F0D274677ECFC0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <20200310220654.1987-1-natechancellor@gmail.com>
In-Reply-To: <20200310220654.1987-1-natechancellor@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.126.9.20]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15530de9-c1c0-4bfb-13c3-08d7c585681b
x-ms-traffictypediagnostic: DB8PR04MB6971:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-microsoft-antispam-prvs: <DB8PR04MB69711396ADFD226F8416BAF2ADFC0@DB8PR04MB6971.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:155;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(110136005)(8936002)(316002)(54906003)(6506007)(5660300002)(64756008)(66446008)(66476007)(66556008)(53546011)(76116006)(66946007)(9686003)(55016002)(33656002)(4326008)(2906002)(7696005)(45080400002)(478600001)(71200400001)(52536014)(86362001)(186003)(8676002)(26005)(81166006)(81156014)(966005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6971;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R1uL8wTxG9AIF/q1QYTzEK877BnShzw65z5kog/6yRXdcM5i1fR23NQoUGHUqnp96SSlD6pysxfYofs1RZEZfZsTuJTnWT8GCWFYIQJSdXnu+GbuwMoj2jMmv3y0sLmA/XQdiNpxlIZyk5cAVdi6vJ06Z6Bwvq93E3j2FBaSFn1tpTl2mOo6JwZ/AkhFK3R6jlIa3I+X38JeR8pzB55gCWT5tNzFw/d7aLs57D9TRaf3dUIVIHf/HlMgSBrXLFCd4nNY6PRI/tLTy0J+BWmLFw9KU8xagYqEL8kHNqdSRhruJNebI1td+Z1qH1j9Jdb9sTdjYDOJclLeDaTWJzrjJtj1Mg0Qi+0NE4G4EIYo29yr4uTlmwylYhI77eSvlcI/ZaTKpokdgcbknfJ5Xp1w19A3gCvzMtWPrGw0pBgOwMZf7NF9RVfclpsPDOHzuFh5JFx7DDdWMmYtQMvd/BF7n3hjic3VRuHg0DUkcsKJEUgZFqdFxNq2if4WZBm4sVwwR45rPm279We/PTFtDmxGWA==
x-ms-exchange-antispam-messagedata: OQD3wOUzvHs+oZCJyi/KbYbiOQU/3Vey7a10YawTrz4nQEksfYsdt21CWf/VbrCXlfAfRIXzRr5BdDWbnTl4JOd1t7wTF8hrAH4c12vbOz8X4XrYbYL0SUgf+YA2Nel+ZkcRXVX2I1cseJJxbZJfaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15530de9-c1c0-4bfb-13c3-08d7c585681b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 06:28:26.3006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ReTbHtuZQi6IjDLqzN30561s5v8rZKTigIwIzqlt0z057ba0+pxWIfTkRWGNw17kZvGS4LBJzRPd2UriWCg2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6971
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Nathan Chancellor <natechancellor@gmail.com>
> Sent: Wednesday, March 11, 2020 12:07 AM
> To: David S. Miller <davem@davemloft.net>; Madalin Bucur
> <madalin.bucur@nxp.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; clang-built-
> linux@googlegroups.com; Nathan Chancellor <natechancellor@gmail.com>
> Subject: [PATCH] dpaa_eth: Remove unnecessary boolean expression in
> dpaa_get_headroom
>=20
> Clang warns:
>=20
> drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2860:9: warning:
> converting the result of '?:' with integer constants to a boolean always
> evaluates to 'true' [-Wtautological-constant-compare]
>         return DPAA_FD_DATA_ALIGNMENT ? ALIGN(headroom,
>                ^
> drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:131:34: note: expanded
> from macro 'DPAA_FD_DATA_ALIGNMENT'
> \#define DPAA_FD_DATA_ALIGNMENT  (fman_has_errata_a050385() ? 64 : 16)
>                                  ^
> 1 warning generated.
>=20
> This was exposed by commit 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385
> workaround") even though it appears to have been an issue since the
> introductory commit 9ad1a3749333 ("dpaa_eth: add support for DPAA
> Ethernet") since DPAA_FD_DATA_ALIGNMENT has never been able to be zero.
>=20
> Just replace the whole boolean expression with the true branch, as it is
> always been true.
>=20
> Link:
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithu=
b.c
> om%2FClangBuiltLinux%2Flinux%2Fissues%2F928&amp;data=3D02%7C01%7Cmadalin.=
buc
> ur%40nxp.com%7C53f37e7dbf584248844608d7c53f5f70%7C686ea1d3bc2b4c6fa92cd99=
c
> 5c301635%7C0%7C0%7C637194748277007260&amp;sdata=3DGshtiHYyjvTcp87StdMoQDP=
5L6
> %2BhYN6nnUi6vbyuqic%3D&amp;reserved=3D0
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index 190e4478128a..46039d80bb43 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -2857,9 +2857,7 @@ static inline u16 dpaa_get_headroom(struct
> dpaa_buffer_layout *bl)
>  	headroom =3D (u16)(bl->priv_data_size + DPAA_PARSE_RESULTS_SIZE +
>  		DPAA_TIME_STAMP_SIZE + DPAA_HASH_RESULTS_SIZE);
>=20
> -	return DPAA_FD_DATA_ALIGNMENT ? ALIGN(headroom,
> -					      DPAA_FD_DATA_ALIGNMENT) :
> -					headroom;
> +	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
>  }
>=20
>  static int dpaa_eth_probe(struct platform_device *pdev)
> --=09
> 2.26.0.rc1

Reviewed-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
