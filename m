Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF180177868
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbgCCOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:10:14 -0500
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:22944
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729625AbgCCOKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 09:10:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDf+ECBQCr/ErbZWgSSc4fIu74Y+v9HgDjJ181T0XdoEfu0aJUTGY3ZM0f3o5LeInPITKec3L1I6BwL9cy5KP1mc2oti1VUUWS5NXhVxYuGujiGQ1U9/8RtNyVg8aFwZB9jWYkEqDH416IZfAtrS4r61El1a4V/MlCHMoqK6a9VUOdfmDoHRFPxM48qiHQeAgo8C2jLLoSYWDqyCAGXTjWEAdpwDkLnEQjjYKbVy200p0/iCTYIPvst+9IuvZQLzzaq+wEBqKKntJZvXdrZa0JYK65M2ulWBSWJYtdlzNpWy92iAcxx5L3c6Narvtyt/NjhzbY+AoxgmuacSTa8VIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUHcI1szg2AAohrPDdCjqWS+oHH2uaufjO8Bp5FWQtg=;
 b=NE/pd0TNdfl5PJcBJtumkh0cHvpFsQLXhum9AY7wT2qi2HiVbkCGRDqeyjMauduzqOGZdzS35AWMpsR4l/MLHR7alVNlanXyarx4xmlv7Xa6by49ZKImupsSESDbXwEZpDszyNwK70qbvUR7sM1FmPANpoO4NtYPAB4iUspG3rz+A0Mpq3rd58boyzRRXm0eiru2KZ6PKZQX2pNWnP4ORiyGBpb7826dc5FX37IQmp8GOacFZicUl1irUMQKltLNQCwf255cOx90NgeT+tmZLeA1S49jtcnIvcDqbZ5ETouBPWbcJeAGbbQ9SoSqXkPPNR0aHXZJXGqioR0JqnbqeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vUHcI1szg2AAohrPDdCjqWS+oHH2uaufjO8Bp5FWQtg=;
 b=b13OlheVYlANRZKvaVQtSFkX6oGkEXQuzssDvspQcarcUrEk/5PsuSYNVAJOBhvfFmha3FvEg6mRWbpCx2xD7JtQddqGJd83if+lOrq2wYWpig30ZBVwhaTCU+EwpCwqTUigYCoAeD5y4TEwp5Sxe4jvaOGEPhe2ECqh1uwK9IE=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6147.eurprd05.prod.outlook.com (20.178.112.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 14:10:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::8c4:e45b:ecdc:e02b%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 14:10:06 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: RE: [PATCH] IB/mlx5: Add np_min_time_between_cnps and rp_max_rate
 debug params
Thread-Topic: [PATCH] IB/mlx5: Add np_min_time_between_cnps and rp_max_rate
 debug params
Thread-Index: AQHV8WVC2i2QNQ2hvE2QTjS8cq3lR6g25+kA
Date:   Tue, 3 Mar 2020 14:10:06 +0000
Message-ID: <AM0PR05MB4866E1CE9A5DEC5AD677E09BD1E40@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20200303140834.7501-1-parav@mellanox.com>
In-Reply-To: <20200303140834.7501-1-parav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:5121:27a4:7e98:56ad]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e94e7140-53ae-4ec3-28bc-08d7bf7c934e
x-ms-traffictypediagnostic: AM0PR05MB6147:|AM0PR05MB6147:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB614728247FC329824358B5D9D1E40@AM0PR05MB6147.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-forefront-prvs: 03319F6FEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(199004)(189003)(7696005)(66556008)(66946007)(66476007)(2906002)(64756008)(8676002)(81166006)(81156014)(53546011)(4326008)(66446008)(6506007)(110136005)(54906003)(76116006)(55016002)(498600001)(9686003)(5660300002)(33656002)(71200400001)(86362001)(186003)(8936002)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6147;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: reF9zRW46t9IpRh2kiZZGw8XrMFhU0M7wYT1FpX4GRqDv7plBEk+fZqlapqI8sBNKk8Y9rxrZ5HGmB1eicX1l+/qo4djKPGkG92p+QeAYlf2BG0FCvtuqrXXpDsMm5coxs3T5lHTx4do71ldeIwaR6y6bg+XXOVG14V0OGUWdx0nwZuqWcgfO/mQlMZ66UPk/S/9rIc8aCFJkgfGvqyIH5MigCf6nhXkjwqhzF26aP/tuJbNyOFGlBERhK/BteFrR+70nE4mqDZ2qknAXk4GWdpz4FUcPr4t6tDOcZRoFrhKFcCb61fG4X2Zgo8DXXlnxsGlGwdEHit2Sw/6eIzsBtM4jGv1z5LA7nKcLtSCfOhcDT79IxXi3CemJQlUf9Pu0YH2LphEIbsiOvsnZANd8wpHPfdxqkW+bV8YFRX6IAS62McM1qUwYJWJ/wTOifZj
x-ms-exchange-antispam-messagedata: 3pMMMevgg5b1QBrX6XUfBIPmhbBe9cFZzCCkQuhvol492Bw6KNp1aZVAzzs8W0tdL8MOj2ifHGWC13BnozgJYvCjeSv0TY+CpoxqUbio2Rb78UE1wSHyl9xY+2+VFkVQcreeZgT5rlUl6CupDnY63qJyAXE0rfUlmaUq0rJ3VSGZJ7GcYtIvqRorkvkUAJt+DqSV+M9lShreNXxOQkETxg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e94e7140-53ae-4ec3-28bc-08d7bf7c934e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 14:10:06.3208
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2yKZe9W5x+y1N2Bzc8HhfSoiM/HIh2vQ3IV1jFmMagoZWPzgDe4I3xXeYg2B9edQPcfjZBseojqrlSBNroyh3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sorry for sending unrelated patches here.
Sent from wrong directory.


> -----Original Message-----
> From: Parav Pandit <parav@mellanox.com>
> Sent: Tuesday, March 3, 2020 8:09 AM
> To: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> Moshe Shemesh <moshe@mellanox.com>; Vladyslav Tarasiuk
> <vladyslavt@mellanox.com>; Saeed Mahameed <saeedm@mellanox.com>;
> leon@kernel.org
> Subject: [PATCH] IB/mlx5: Add np_min_time_between_cnps and
> rp_max_rate debug params
>=20
> Add two debugfs parameters described below.
>=20
> np_min_time_between_cnps - Minimum time between sending CNPs from
> the
>                            port.
>                            Unit =3D microseconds.
>                            Default =3D 0.
>=20
> rp_max_rate - Maximum rate at which reaction point node can transmit.
>               Once this limit is reached, RP is no longer rate limited.
>               Unit =3D Mbits/sec
>               Default =3D 0 (full speed)
>=20
> issue: 961226
> Change-Id: I14544168ed115acaeb8ff900ac092fad2f1bb68f
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/cong.c    | 20 ++++++++++++++++++++
>  drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
>  2 files changed, 22 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx5/cong.c
> b/drivers/infiniband/hw/mlx5/cong.c
> index 8ba439fabf7f..de4da92b81a6 100644
> --- a/drivers/infiniband/hw/mlx5/cong.c
> +++ b/drivers/infiniband/hw/mlx5/cong.c
> @@ -47,6 +47,7 @@ static const char * const mlx5_ib_dbg_cc_name[] =3D {
>  	"rp_byte_reset",
>  	"rp_threshold",
>  	"rp_ai_rate",
> +	"rp_max_rate",
>  	"rp_hai_rate",
>  	"rp_min_dec_fac",
>  	"rp_min_rate",
> @@ -56,6 +57,7 @@ static const char * const mlx5_ib_dbg_cc_name[] =3D {
>  	"rp_rate_reduce_monitor_period",
>  	"rp_initial_alpha_value",
>  	"rp_gd",
> +	"np_min_time_between_cnps",
>  	"np_cnp_dscp",
>  	"np_cnp_prio_mode",
>  	"np_cnp_prio",
> @@ -66,6 +68,7 @@ static const char * const mlx5_ib_dbg_cc_name[] =3D {
>  #define MLX5_IB_RP_TIME_RESET_ATTR			BIT(3)
>  #define MLX5_IB_RP_BYTE_RESET_ATTR			BIT(4)
>  #define MLX5_IB_RP_THRESHOLD_ATTR			BIT(5)
> +#define MLX5_IB_RP_MAX_RATE_ATTR			BIT(6)
>  #define MLX5_IB_RP_AI_RATE_ATTR				BIT(7)
>  #define MLX5_IB_RP_HAI_RATE_ATTR			BIT(8)
>  #define MLX5_IB_RP_MIN_DEC_FAC_ATTR			BIT(9)
> @@ -77,6 +80,7 @@ static const char * const mlx5_ib_dbg_cc_name[] =3D {
>  #define MLX5_IB_RP_INITIAL_ALPHA_VALUE_ATTR		BIT(15)
>  #define MLX5_IB_RP_GD_ATTR				BIT(16)
>=20
> +#define MLX5_IB_NP_MIN_TIME_BETWEEN_CNPS_ATTR		BIT(2)
>  #define MLX5_IB_NP_CNP_DSCP_ATTR			BIT(3)
>  #define MLX5_IB_NP_CNP_PRIO_MODE_ATTR			BIT(4)
>=20
> @@ -111,6 +115,9 @@ static u32 mlx5_get_cc_param_val(void *field, int
> offset)
>  	case MLX5_IB_DBG_CC_RP_AI_RATE:
>  		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
>  				rpg_ai_rate);
> +	case MLX5_IB_DBG_CC_RP_MAX_RATE:
> +		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
> +				rpg_max_rate);
>  	case MLX5_IB_DBG_CC_RP_HAI_RATE:
>  		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
>  				rpg_hai_rate);
> @@ -138,6 +145,9 @@ static u32 mlx5_get_cc_param_val(void *field, int
> offset)
>  	case MLX5_IB_DBG_CC_RP_GD:
>  		return MLX5_GET(cong_control_r_roce_ecn_rp, field,
>  				rpg_gd);
> +	case MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS:
> +		return MLX5_GET(cong_control_r_roce_ecn_np, field,
> +				min_time_between_cnps);
>  	case MLX5_IB_DBG_CC_NP_CNP_DSCP:
>  		return MLX5_GET(cong_control_r_roce_ecn_np, field,
>  				cnp_dscp);
> @@ -186,6 +196,11 @@ static void mlx5_ib_set_cc_param_mask_val(void
> *field, int offset,
>  		MLX5_SET(cong_control_r_roce_ecn_rp, field,
>  			 rpg_ai_rate, var);
>  		break;
> +	case MLX5_IB_DBG_CC_RP_MAX_RATE:
> +		*attr_mask |=3D MLX5_IB_RP_MAX_RATE_ATTR;
> +		MLX5_SET(cong_control_r_roce_ecn_rp, field,
> +			 rpg_max_rate, var);
> +		break;
>  	case MLX5_IB_DBG_CC_RP_HAI_RATE:
>  		*attr_mask |=3D MLX5_IB_RP_HAI_RATE_ATTR;
>  		MLX5_SET(cong_control_r_roce_ecn_rp, field, @@ -231,6
> +246,11 @@ static void mlx5_ib_set_cc_param_mask_val(void *field, int
> offset,
>  		MLX5_SET(cong_control_r_roce_ecn_rp, field,
>  			 rpg_gd, var);
>  		break;
> +	case MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS:
> +		*attr_mask |=3D
> MLX5_IB_NP_MIN_TIME_BETWEEN_CNPS_ATTR;
> +		MLX5_SET(cong_control_r_roce_ecn_np, field,
> +			 min_time_between_cnps, var);
> +		break;
>  	case MLX5_IB_DBG_CC_NP_CNP_DSCP:
>  		*attr_mask |=3D MLX5_IB_NP_CNP_DSCP_ATTR;
>  		MLX5_SET(cong_control_r_roce_ecn_np, field, cnp_dscp,
> var); diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> index d9bffcc93587..4cbc87c79951 100644
> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
> @@ -792,6 +792,7 @@ enum mlx5_ib_dbg_cc_types {
>  	MLX5_IB_DBG_CC_RP_BYTE_RESET,
>  	MLX5_IB_DBG_CC_RP_THRESHOLD,
>  	MLX5_IB_DBG_CC_RP_AI_RATE,
> +	MLX5_IB_DBG_CC_RP_MAX_RATE,
>  	MLX5_IB_DBG_CC_RP_HAI_RATE,
>  	MLX5_IB_DBG_CC_RP_MIN_DEC_FAC,
>  	MLX5_IB_DBG_CC_RP_MIN_RATE,
> @@ -801,6 +802,7 @@ enum mlx5_ib_dbg_cc_types {
>  	MLX5_IB_DBG_CC_RP_RATE_REDUCE_MONITOR_PERIOD,
>  	MLX5_IB_DBG_CC_RP_INITIAL_ALPHA_VALUE,
>  	MLX5_IB_DBG_CC_RP_GD,
> +	MLX5_IB_DBG_CC_NP_MIN_TIME_BETWEEN_CNPS,
>  	MLX5_IB_DBG_CC_NP_CNP_DSCP,
>  	MLX5_IB_DBG_CC_NP_CNP_PRIO_MODE,
>  	MLX5_IB_DBG_CC_NP_CNP_PRIO,
> --
> 2.19.2

