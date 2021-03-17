Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8541C33EA7B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 08:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbhCQHZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 03:25:16 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:35718
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229707AbhCQHZQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 03:25:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVmwYaLnwqDZ0XzlKmMGxIkhxlM/d8XtQH+XrX7aSsPxHKp6/DIF9AxnzD5CGVEoUAWvF7Fn1MwfSLIdJHtj5FM6/XOGk/K4jhL0l8xyQXZRh0n1cU3EdbgzUawRnqGaVPKAg9IezO+VfMEvySNmr3REHjM50CZH6yug/8xD6EHusDNU4gdW30g16mKsCcbd7HaVdDaVJLRH0qLYi2ntajjVNQ/h2SMGdPIIcSlbh08oSqRJ/wHmgd1YYt55CcnVwGaPn6VL4RN6r4OIRYOXcZOZzo2IZsDTVOGF/RiU3UcvpjM5Pa0coakXYPANQ2qtUxXKk4n/TBJzjSXiId41tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjWikZz4yrpE7nc8R73X6PHX79F3A/v5LKLdnwEo8zE=;
 b=iys2EmOD0xpiXmJE9p3fjmrDpbluorL2cwz93zMP22p96EFgh03nMMpa1QKmpP1tJCFtLpzrSkkTt0SXRnLIqQlACSpg7MUOlXQhYRyLBFrlAP7ENH88kCiSUl0VAd1tyodbJKRp9nJfBuCW2DVz+6gtseIlj1NdeCwWVsL66N2iYdYTX28xkyWAT8L6cSfcaZlYAVWSLmhm11+oWwlt1xWudIo3Zjq47iss3ppnuYj4WfrX8x+EdV4JMSDQeryloba5szX3vyNmW5Za7JMz7tXnWgAGTUvvIrYyR2nJOPiKtfPfeKke4B5D3Z207GxVwvoy5nRKULV5OWmR5/X8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BjWikZz4yrpE7nc8R73X6PHX79F3A/v5LKLdnwEo8zE=;
 b=VqLfPEEzY+Tz+j0kxUDflQBZGZiWIkhujuXm5hhq7dKpfa3pq13OA/Vn6H4WPBts477PtEh04240k1KlMPKITtMRuHHW34iP/yOozK8YtGX5qPx4DFmemPtqAIyRxf89/ThDieAAHAkuUZwbskmJdINUdoArOYiXSwsKZZeGcuc=
Received: from DB7PR04MB4538.eurprd04.prod.outlook.com (2603:10a6:5:2e::18) by
 DBAPR04MB7368.eurprd04.prod.outlook.com (2603:10a6:10:1ad::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 07:25:12 +0000
Received: from DB7PR04MB4538.eurprd04.prod.outlook.com
 ([fe80::11d3:a9e:6ccc:4bdc]) by DB7PR04MB4538.eurprd04.prod.outlook.com
 ([fe80::11d3:a9e:6ccc:4bdc%6]) with mapi id 15.20.3955.018; Wed, 17 Mar 2021
 07:25:12 +0000
From:   Sharvari Harisangam <sharvari.harisangam@nxp.com>
To:     "zuoqilin1@163.com" <zuoqilin1@163.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "ganapathi017@gmail.com" <ganapathi017@gmail.com>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zuoqilin <zuoqilin@yulong.com>
Subject: RE: [EXT] [PATCH] mwifiex: Remove redundant assignment
Thread-Topic: [EXT] [PATCH] mwifiex: Remove redundant assignment
Thread-Index: AQHXGvRBtUeRxvmxwkG0ilsZK0DEnKqHxwdw
Date:   Wed, 17 Mar 2021 07:25:11 +0000
Message-ID: <DB7PR04MB4538A2B9B59010BBD3261FB3FC6A9@DB7PR04MB4538.eurprd04.prod.outlook.com>
References: <20210317060956.1009-1-zuoqilin1@163.com>
In-Reply-To: <20210317060956.1009-1-zuoqilin1@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [116.75.140.0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bef3bf7a-262a-462a-8aeb-08d8e915cd46
x-ms-traffictypediagnostic: DBAPR04MB7368:
x-microsoft-antispam-prvs: <DBAPR04MB7368794DC3B848536EF573C1FC6A9@DBAPR04MB7368.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yRLf4I17okMM9WqPaA3wxJ1nuN09wfb2ddyCuxkgF/jh9JD4xvdp5sw9YdR/5RXkBVfOnz1VpX5x4hDajwTdvAWjk/ekM8B7+9fSRY3p1U2OgQr03PtwYPdDQvpIf9HvtJzUw/j5P2Po9fZK8sVTSzIYRjkSEaD+f/sZ80Z2IG7G2B9cby6Fq4ZTCjJxRo6gaHV+Vw2N1IQb1hTwA+2Irpc3VuwiagCSAFVNtHNa/ZPoFFPUxX5a1Yqto84HzCt736hwOlIg+RiV+YQ2z9ztUxfr+6fdNPN255LkccQEEcU10PKzXVhuBS64GKLh9F/nqdTb685+4xZ1JXQsD8lEunTFqORsvZBUI5luCZawhl0P9HPQfdI37amDzLBHYTCxew/JAuttbjgxkvHcOZxwjqyuJJR8ebeuPUwkdWajMJNCBu4PBWo1pxewvxFVgo0o+r84GB6bBEDfnvgVLvtKWAKsXdijMGClAeQh2uhuLOHrWnK93TeVwCuQ4ma+SfBy57J4wYruRc6NxqcTYqx8c+NzEXF/hhRoPsf2dCl9CAxv1mgPebRlScci/odRAvpW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4538.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(366004)(396003)(478600001)(71200400001)(7696005)(86362001)(55016002)(7416002)(26005)(55236004)(66476007)(66556008)(6506007)(53546011)(66946007)(64756008)(66446008)(44832011)(110136005)(9686003)(54906003)(8936002)(186003)(33656002)(316002)(8676002)(76116006)(5660300002)(2906002)(4326008)(83380400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YdxklHUonbzycmtJgB976qYSQlT4rSO60Vp9UBNe8gVKkVW5yFFNHZC4HRKZ?=
 =?us-ascii?Q?Lq2YrFdrCATRFYSM6M/fu3o/r6PytQdrEyWiJYxDNu2XJdQBsaHngU88YRFj?=
 =?us-ascii?Q?/ZesKfBnR+HIjuJBWbaLeZ146alX6v11XTAKlX9kS+8m9QyKC9/NDC+XGCYB?=
 =?us-ascii?Q?5AhDd8v0HTQLkggFHDP0AfckGEVdGywghxdJYsVbGcGA1+T9KdXz2xeSY4C1?=
 =?us-ascii?Q?7KxhDjScvtwvxMcrHPTX4q8hrQ4pzftGalztfFVA5HsliGCTKeF4I3P2kECy?=
 =?us-ascii?Q?N3YAdnh2XAwVooKBclwjoOjNv0Ip3JfzZLsQiowRlzE/Au5+4Gon0ERvfrFn?=
 =?us-ascii?Q?ZFBxQs+eykbK+jlRQMrw1uSNd9XaZM2jX0swWZ4p/6rf3kecqHqCeNeezgnO?=
 =?us-ascii?Q?HJ3bU9U51Y2mdmvxLD7qa2F4Pqcoa//gYJUB3pR1aCMmxb2YVNVuz+6W5Xn+?=
 =?us-ascii?Q?HAt5hzR0fvvKcY9hIX806fohmtaeH9SXUT1ezS2vJQVI1tUms/zraEGMURUE?=
 =?us-ascii?Q?wvflxkjGZv8fZ+z7n5RpJeFqbO1GUtERVpCcvqOAAZ0M+d7FE/rSV3iBaGAG?=
 =?us-ascii?Q?ZW9myx+88YVUFvU1SV7nafPQj+EQu7NmZbUbaHos2Pb6YcWVVS2Y40ayxD3W?=
 =?us-ascii?Q?oF7AEtGTXwEOHVgrfVUC7ouAURGEirxchhAFbKRzZ3y0ZkDUXAHRcIguc87/?=
 =?us-ascii?Q?WKvwWR5fMGvbW6W94ULD3RFlQ9TFc0SSjvuM3t2hVDDMGxl7lNGVkvEY7QfN?=
 =?us-ascii?Q?NVtwnxwp2PtP1AAKNTLr/I3C6+cTj27eMpfB4BJyhdr2Y2BBrk+Hh+pB4foP?=
 =?us-ascii?Q?/HDJrpyESC9S+KJE4JMK1M3a3r71KgDr5yPmVKUFpp7Lb9g9C8IjYCsBBaBi?=
 =?us-ascii?Q?cbnY4k5J/ziA8b7fmzbwkUdpOIkwKu9kfB93ahElD038Jl/BgLx8F4SlKmnN?=
 =?us-ascii?Q?bKv7Y/1k0MbwcHhJEMsMznXdk4cGYfehmAVSfSKLZ7nl3nNx/jqkDIniXrbO?=
 =?us-ascii?Q?eF/5C+g9xRpIQ+NaM8vhyVnIGHqsF4ZC3NgfAFom7Ur+j3qPtS34HVnChq4c?=
 =?us-ascii?Q?XO8VUQfhok1MLs18SctZ3DzZQl5DGLJ3KxiE/m0aCWlrc10VzuTL39QaY1G2?=
 =?us-ascii?Q?eOfDECQrzVkGp8nPsrA6UvSaus7secYBmKgpgIMAodzX9raj2xkFELgJjf2C?=
 =?us-ascii?Q?/pRzcM/sw2SpKZGH+Csw6NN4l0FVUKBZVak0T1GFm6mOqFF5SPqq2TbRB8x+?=
 =?us-ascii?Q?JKONsYjH4DHf8hvDQqpYqaj+Txpan15DSiDLAVjQICdUZSzvPjUFvfEfaIOk?=
 =?us-ascii?Q?w5M=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4538.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef3bf7a-262a-462a-8aeb-08d8e915cd46
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 07:25:11.9463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WvlBDhIwwPw1ClboFtnlFnsgOBDyIcZtuY8DG/9WtAIjVqh2VqhOaLRWWFPrd9LqFfh+G/iRfnpf74+G1FsE1J4+7bsbdQoR6+5RftExO1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7368
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to return 0 in success case. So this can't be removed.

> -----Original Message-----
> From: zuoqilin1@163.com <zuoqilin1@163.com>
> Sent: Wednesday, March 17, 2021 11:40 AM
> To: amitkarwar@gmail.com; ganapathi017@gmail.com; Sharvari Harisangam
> <sharvari.harisangam@nxp.com>; huxinming820@gmail.com;
> kvalo@codeaurora.org; davem@davemloft.net; kuba@kernel.org
> Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; zuoqilin <zuoqilin@yulong.com>
> Subject: [EXT] [PATCH] mwifiex: Remove redundant assignment
>=20
> Caution: EXT Email
>=20
> From: zuoqilin <zuoqilin@yulong.com>
>=20
> There is no need to define the err variable, and then assign -EINVAL, we =
can
> directly return -EINVAL.
>=20
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/ie.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c
> b/drivers/net/wireless/marvell/mwifiex/ie.c
> index 40e99ea..c88213c 100644
> --- a/drivers/net/wireless/marvell/mwifiex/ie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/ie.c
> @@ -333,7 +333,6 @@ static int mwifiex_uap_parse_tail_ies(struct
> mwifiex_private *priv,
>         u16 gen_idx =3D MWIFIEX_AUTO_IDX_MASK, ie_len =3D 0;
>         int left_len, parsed_len =3D 0;
>         unsigned int token_len;
> -       int err =3D 0;
>=20
>         if (!info->tail || !info->tail_len)
>                 return 0;
> @@ -351,7 +350,6 @@ static int mwifiex_uap_parse_tail_ies(struct
> mwifiex_private *priv,
>                 hdr =3D (void *)(info->tail + parsed_len);
>                 token_len =3D hdr->len + sizeof(struct ieee_types_header)=
;
>                 if (token_len > left_len) {
> -                       err =3D -EINVAL;
>                         goto out;
>                 }
>=20
> @@ -377,7 +375,6 @@ static int mwifiex_uap_parse_tail_ies(struct
> mwifiex_private *priv,
>                         fallthrough;
>                 default:
>                         if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
> -                               err =3D -EINVAL;
>                                 goto out;
>                         }
>                         memcpy(gen_ie->ie_buffer + ie_len, hdr, token_len=
); @@ -397,7
> +394,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *p=
riv,
>         if (vendorhdr) {
>                 token_len =3D vendorhdr->len + sizeof(struct ieee_types_h=
eader);
>                 if (ie_len + token_len > IEEE_MAX_IE_SIZE) {
> -                       err =3D -EINVAL;
>                         goto out;
>                 }
>                 memcpy(gen_ie->ie_buffer + ie_len, vendorhdr, token_len);=
 @@ -415,7
> +411,6 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *p=
riv,
>=20
>         if (mwifiex_update_uap_custom_ie(priv, gen_ie, &gen_idx, NULL, NU=
LL,
>                                          NULL, NULL)) {
> -               err =3D -EINVAL;
>                 goto out;
>         }
>=20
> @@ -423,7 +418,7 @@ static int mwifiex_uap_parse_tail_ies(struct
> mwifiex_private *priv,
>=20
>   out:
>         kfree(gen_ie);
> -       return err;
> +       return -EINVAL;
>  }
>=20
>  /* This function parses different IEs-head & tail IEs, beacon IEs,
> --
> 1.9.1

