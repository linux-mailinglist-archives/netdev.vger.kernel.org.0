Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8977C4461D
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404146AbfFMQt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:49:26 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:26968
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727643AbfFMEer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 00:34:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6dg8ebZCspA9SBalTiQqMB3jkF5JwK9tzroGEq/4L0=;
 b=dXA8XaQdCteckvsbG3ULAhSaDH4ivI+9OqgsyZ9usVTK3wKKhYDGsRAXFgfQgNnkc8gvIQwZaCAP2VGIlnEpmRyyfZpsVCdw6KtOGcF6Y1EOr21vJO1DdOnLskjMZqYjnW4JyYRjcLrDVKCSbKfvNhG6VqV7aSKWt3U2C/z542U=
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com (10.169.134.149) by
 VI1PR0501MB2480.eurprd05.prod.outlook.com (10.168.136.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.11; Thu, 13 Jun 2019 04:34:42 +0000
Received: from VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6]) by VI1PR0501MB2271.eurprd05.prod.outlook.com
 ([fe80::10d7:3b2d:5471:1eb6%10]) with mapi id 15.20.1987.012; Thu, 13 Jun
 2019 04:34:42 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>, Petr Vorel <pvorel@suse.cz>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: RE: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
Thread-Topic: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
Thread-Index: AQHVIRk3qF4KV1EKd0CJo1dhG6j6qKaZAE2A
Date:   Thu, 13 Jun 2019 04:34:42 +0000
Message-ID: <VI1PR0501MB2271FD29406927D5F4327A0DD1EF0@VI1PR0501MB2271.eurprd05.prod.outlook.com>
References: <20190612122014.22359-1-leon@kernel.org>
 <20190612122014.22359-3-leon@kernel.org>
In-Reply-To: <20190612122014.22359-3-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [122.182.253.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8950c7da-8b48-45ba-12fd-08d6efb8743e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2480;
x-ms-traffictypediagnostic: VI1PR0501MB2480:
x-microsoft-antispam-prvs: <VI1PR0501MB24800389BA4E3AD61B11A53CD1EF0@VI1PR0501MB2480.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(13464003)(8676002)(229853002)(66476007)(73956011)(66946007)(486006)(6436002)(76116006)(478600001)(66446008)(81156014)(66556008)(33656002)(81166006)(64756008)(66066001)(9686003)(86362001)(8936002)(6506007)(6116002)(3846002)(14454004)(53546011)(54906003)(446003)(6246003)(25786009)(316002)(99286004)(52536014)(55016002)(107886003)(4326008)(476003)(102836004)(53936002)(6636002)(7736002)(110136005)(186003)(5660300002)(2906002)(305945005)(76176011)(71190400001)(7696005)(71200400001)(11346002)(68736007)(74316002)(256004)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2480;H:VI1PR0501MB2271.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EvoA+WqCb6nblIpqAVftfYkbd9TkgerQUVCvXhi3b2dSic2+fHxQpqdpR9/laflvzwORDD5vzPfYy5gzEG14FB233nivAvnk5JXMjVruMFbFVRfctgUwpoC7AmFf79iKwh0kQMgUweXyGzHGRCUdOcuHAsZm2zS6jruC6AvVXEJnImSWrdvx51zqbq86QHCOTQwV1yj4kobbPcBNs7/CxCL5I8oZXUN73FTbkxTKbjFF2pdWrLsMd2mao0LXEt9Gmgu9C3GD/PYgf4HE12cvuN5SXXEJwRuEXGByRyOAmDle3yXi567CvVPQ2EezA56MI95QutBRvXFUNVH9pcBEslIF0bG98RG4KWGx2QPQCuuFSRo0caR1NqO0GhjbPweA0bT63dnl3UrANLIqsmeKraPC2sOZY/rBTEqkZ5q4dg4=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8950c7da-8b48-45ba-12fd-08d6efb8743e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 04:34:42.1518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2480
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, June 12, 2019 5:50 PM
> To: Doug Ledford <dledford@redhat.com>; Jason Gunthorpe
> <jgg@mellanox.com>
> Cc: Leon Romanovsky <leonro@mellanox.com>; RDMA mailing list <linux-
> rdma@vger.kernel.org>; Maor Gottlieb <maorg@mellanox.com>; Mark Bloch
> <markb@mellanox.com>; Parav Pandit <parav@mellanox.com>; Petr Vorel
> <pvorel@suse.cz>; Saeed Mahameed <saeedm@mellanox.com>; linux-
> netdev <netdev@vger.kernel.org>; Jiri Pirko <jiri@mellanox.com>
> Subject: [PATCH mlx5-next v1 2/4] net/mlx5: Expose eswitch encap mode
>=20
> From: Maor Gottlieb <maorg@mellanox.com>
>=20
> Add API to get the current Eswitch encap mode.
> It will be used in downstream patches to check if flow table can be creat=
ed
> with encap support or not.
>=20
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 11 +++++++++++
>  include/linux/mlx5/eswitch.h                      | 12 ++++++++++++
>  2 files changed, 23 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> index 9ea0ccfe5ef5..0c68d93bea79 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
> @@ -2452,6 +2452,17 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch
> *esw)  }  EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
>=20
> +enum devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev) {
> +	struct mlx5_eswitch *esw;
> +
> +	esw =3D dev->priv.eswitch;
> +	return ESW_ALLOWED(esw) ? esw->offloads.encap :
> +		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
> +}
> +EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
> +
>  bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct
> mlx5_core_dev *dev1)  {
>  	if ((dev0->priv.eswitch->mode =3D=3D SRIOV_NONE && diff --git
> a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h index
> 0ca77dd1429c..f57c73e81267 100644
> --- a/include/linux/mlx5/eswitch.h
> +++ b/include/linux/mlx5/eswitch.h
> @@ -7,6 +7,7 @@
>  #define _MLX5_ESWITCH_
>=20
>  #include <linux/mlx5/driver.h>
> +#include <net/devlink.h>
>=20
>  #define MLX5_ESWITCH_MANAGER(mdev) MLX5_CAP_GEN(mdev,
> eswitch_manager)
>=20
> @@ -60,4 +61,15 @@ u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
> struct mlx5_flow_handle *  mlx5_eswitch_add_send_to_vport_rule(struct
> mlx5_eswitch *esw,
>  				    int vport, u32 sqn);
> +
> +#ifdef CONFIG_MLX5_ESWITCH
> +enum devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev); #else  /*
> +CONFIG_MLX5_ESWITCH */ static inline enum
> devlink_eswitch_encap_mode
> +mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev) {
> +	return DEVLINK_ESWITCH_ENCAP_MODE_NONE; } #endif /*
> +CONFIG_MLX5_ESWITCH */
>  #endif
> --
> 2.20.1
Reviewed-by: Parav Pandit <parav@mellanox.com>

