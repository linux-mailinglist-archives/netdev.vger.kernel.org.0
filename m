Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244DE1C2A15
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 07:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgECFWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 01:22:02 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:21022
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726762AbgECFWC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 May 2020 01:22:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MViWs+LSgoe5Hv/LWBeZtEgRS39aPf0S4fveFXcvD40oyUwPFijDolK+6i2WWH8rVVfrjE9ZhmyPeOpGJ2z9/J9CPtFVVVlfx5sq2qhKv5wAXqIrP0mKuBt1PV/iK6zcqvzuPX5ESoT99GWlA2rWkE8y6m7zejfW4UeB3nESugMbby5uiodUkcsCWv6KacGCh+ucdRJSHBZqlDe3otedQBBW0IfItEnn5CURD1fsoUMzYbqK6sCRHsfVCRnhm2Q+F6t9vxTDW9NubsXFZoHFPJolAXAy6R/B3vniflSLMUBqqPy0oTOaOLrV69bGSrMcTXtKNM4W9ADNNsB4VKsvow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZiFhyxlM2o5YsDl2IzX4wcvPHXQcTIv7sl3WvF4tmY=;
 b=lvM60HwR4q6WrEzFLZ6Ygha3duLxLWRGlRXuWM8JvVL+49zGip0jY6nS9ll2jagIZ4+8sFZbiFF+1QaP2wvV66SBXUATJke5gNFq/xn1L/nbI2i158bpV+YafbCWOjiKJ4J7yYoFaPJq2U1M12wiXg3CzoZ+OXa2cLFD9FBb3d7Eonb3mY9YKW5pdJqyOPRpQn/vIAFwycwW6r0r7WFTOthft7Yd5gXTQ+Yd+ASPQa0jJf40Y21jHENzQmYQckzWwR4lFYU5BL9ioW4x5lVzp+fGwnFtAqoAmTbfyde3A1F2b0exm3Z4/6PtSbNWuZ4BMuO9OsO8e3lUP5cq6HfTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZiFhyxlM2o5YsDl2IzX4wcvPHXQcTIv7sl3WvF4tmY=;
 b=j0L6myrWhbpNsJV5r5/xYxeM+MuiiCtvf2eS9dSv/+KqmNM3XZ8FbtEhglqqcKKxE0gg7m3m8HQUujzDrwRoLsdd6b0F/AO6KrlS3i3WTqW7iUPhfg1WNBTpCfnKhnjIjXJFhiGwsIArSoeTsmfmjv00HRsO0+qcQL/+yh8JRlo=
Authentication-Results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB4823.eurprd05.prod.outlook.com (2603:10a6:20b:5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Sun, 3 May
 2020 05:21:57 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2958.029; Sun, 3 May 2020
 05:21:57 +0000
Date:   Sun, 3 May 2020 08:21:54 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200503052154.GB111287@unreal>
References: <20200501124836.1b375eea@canb.auug.org.au>
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20200501124836.1b375eea@canb.auug.org.au>
X-ClientProxiedBy: FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23)
 To AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by FRYP281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Sun, 3 May 2020 05:21:56 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5971b901-ec5b-4248-d791-08d7ef21e61d
X-MS-TrafficTypeDiagnostic: AM6PR05MB4823:|AM6PR05MB4823:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4823563084A34BFD6B3EC854B0A90@AM6PR05MB4823.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0392679D18
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnKgeiE0BnfE6hvo3Pw4Bw5bXzpmenm7TWBvCNnHQUzmisu/P82gAhzqNlnVS7DhJLaAyy9x8uB7dkWy/Kj7huv6UOpspvZ+R3ZC1htz2SQnZEI+/IAfhr9LG20PrEiYoz1Zj3wfYUmBTaLWsz0ypthdwKC4J72cDKo19Ei1sYQutIgVSM6b4+o6eMfkuOQCyMTGi+ifLpqXlLaUrR7nHJbyPKEFBibfgMgQv4zqjXM8T2l32h2uz3B/6CxPDrckodIn7kckn6yToOn1cGC663eveA3kjcK/s5p0wozw4e+mBlUrf+TToAE4ga5r3wCiKI2gq4rBXc9mUKlb7nGLIw3tkKFtoygXysGvQxENPF2gGI6iOeNJToQn5WJqN411b+1+rreTFrW44OtYSZ5XWuIIKLoO18Wl3CCgYEsWO+WlD9iEpvNYk8xizDcVqbYodetPWGRqqJ0eW3FCbKzOSZ3Qzas2pls3O2fZzrHcOg+CBVk+4IwRGmqNzJCk7xRt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(7916004)(4636009)(39850400004)(396003)(346002)(136003)(376002)(366004)(33656002)(21480400003)(4326008)(107886003)(33716001)(2906002)(66556008)(66476007)(478600001)(1076003)(54906003)(110136005)(66946007)(316002)(186003)(8676002)(6636002)(5660300002)(6486002)(44144004)(16526019)(52116002)(6496006)(9686003)(8936002)(86362001)(2700100001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rxa1sNtkCaXWevOL/ONZyml61cLPfT9ujtUitspp0un9JtVwis5n4GIJKe8uiA69Vmw1/XIm7zlbeZjojRqvDf2/4T0yaBmz4sfIDjIQ25TyWWbTP/YvHmM6LbPwkGnnzRqQ6Rj1mDYrGJrY/iZ1ii76pDBRARKQ9F1kB310g5XmUJZitiBEzkoRQBMwznhNfRDMyZs3H6sdq7hKN+p3dreFjvGZvk9nuERuj3rjfQfV/uRpjKeguvM6Bp/nueoOKPTiGsd9eR4h1OyCCcqMWsDsRjr+uHNC786/F/kOjU5JtIL8+06UEJq/U2A3gHq2r+Okk3iqqjXfJvaibD8l9SaM9kckmitOBkx2PJ9C6pFYOtw0xfJRYcz2LJH4TI1NL0gt4WZ8kHJKrUbX4hT9LkLtAfRiGJN22D5sLtQyW7bjO48OELn10HEzdGjnHin1eyd6/VCH9QRIsLVVC7Yw5TKGADo0tWG71Rs37OqNS7iWPpymUBqOtdmkS8mhM2zwNTlJXOQCJl/hDtxZ7EuF1xQ/XNb/kK+iDkyx+3pO6SBNJR6z0r2blJTm5GUefMdMALDya37F10bzMwSTE8ty+t8rKRxx2jJyUDUes5NS93C8dBAN7UT3Cic0jienME92weFr181a/kljG6ewtG8Zg5ICA9tHPq4XMrv+cvmDFg3zhU4Q3ZqD9UNWI1LWtWFFB1HxBytvtMKzetmcLqehW99//A+q/BYnaglBQJjFsSLTRI76R+yLiCBv/X9HKVrnHvRP6a9Fn6scM0KO1m2/CI1mZ2cHr1gpISOzlDR1V/WaYJx+EurwGovKlzcwlQqz
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5971b901-ec5b-4248-d791-08d7ef21e61d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2020 05:21:57.1738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D4YcQ6MuxqMjQbsWN8PRUDKqEi2pl/MicjvRtn+YKE2XQQeBvpAgGS7sKfFsbwkIAcW4hnWrG7B5WOrh1bRQuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4823
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 01, 2020 at 12:48:36PM +1000, Stephen Rothwell wrote:
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
>
> between commit:
>
>   8075411d93b6 ("net/mlx5: DR, On creation set CQ's arm_db member to right value")
>
> from the net tree and commit:
>
>   73a75b96fc9a ("net/mlx5: Remove empty QP and CQ events handlers")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell

Thanks for the resolution.

>
> diff --cc drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> index 18719acb7e54,c4ed25bb9ac8..000000000000
> --- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
> @@@ -689,18 -693,6 +693,12 @@@ static int dr_prepare_qp_to_rts(struct
>   	return 0;
>   }
>
> - static void dr_cq_event(struct mlx5_core_cq *mcq,
> - 			enum mlx5_event event)
> - {
> - 	pr_info("CQ event %u on CQ #%u\n", event, mcq->cqn);
> - }
> -
>  +static void dr_cq_complete(struct mlx5_core_cq *mcq,
>  +			   struct mlx5_eqe *eqe)
>  +{
>  +	pr_err("CQ completion CQ: #%u\n", mcq->cqn);
>  +}
>  +

Saeed,

Please pay attention that commit 8075411d93b6
("net/mlx5: DR, On creation set CQ's arm_db member to right value")
mentioned by Stephen is not accurate. ".comp" callback shouldn't be
called if it is NULL, so unclear what you get by adding such pr_err().

Thanks

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQT1m3YD37UfMCUQBNwp8NhrnBAZsQUCXq5U7gAKCRAp8NhrnBAZ
sbLBAP9rlWvupuKkkfnXxMs8yNBohkV0++69c9lJxGdTWaX3HgEA2tXoLwcHQKVJ
6oR4j23onIx7K0KilaPcAU+t8hT61wo=
=lMd3
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
