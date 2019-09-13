Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A74B1A6E
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387772AbfIMJGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:06:52 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:35301
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387594AbfIMJGv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 05:06:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1W5paEPKV8IZ4atYBqF8uptaj+xHZPoA+exiVzOxHzWqm1bbLHglhUA+uLswKvtkZxQyAglW8h4WAdebtidSa7FGSND67hArurpVwqHWV7RKlQxRoXeyBlLWUTx/ftZsvU01B1EX5mpRwOXO84/kFyJd0+IY+KLcP1gc1OYxy8aR2Tvb/+Ov/2oxM/8T4+5g6q+uSgRsTIAuyJlbNWXIS3Qh2IbPYOggVlEQv0Ir45rnkKq3yT/eFxfsfRZk92v67oGsxBLfpyLj/AhbEdcrv5s96k2B3J3GIZzWNZuiGFfxKLhDb7k+s+721k+A7+fn8qV8TTUtuhkb95V8TQJSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRGnBYVIwYn+kukcg7fAnQrTCkrpgLnItCXihoKcc5E=;
 b=nNZ3cRBrWWYQcfAKK3fE1+oiJKiWT632jzh3vFR1aPonQa4zmYhAoKFx8gLJGwi3/NnkOFXyBicg+vVvgUyDUb4I1vaKYRZgZ4AYNk4XRephu5e8ZXm5Lw+JV0zkEjD0bak2sw7aGxPSMfkvh1Nw80f4DWJlkK59WpzqlpNhx0P43C9ooVFzgeljIJADn8mkOI8l2ZKFfjXuH3uak3ojCN2zfvryt6CleL2RsDhXgLfIsUGbPh0aE0Dxqm2/r5uYHr2St+n+GpHP6JhmWW7D9yAG9IHQRC8PC9AcJbnujEbpcUGZjdNxjLTUTi49Q/LzLEkMYgBxm7weu+0iyDej0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRGnBYVIwYn+kukcg7fAnQrTCkrpgLnItCXihoKcc5E=;
 b=UV7D1URZmJR0lc9bndDqBJmxch3UA8QFNgqDwa7zeWgOepnXee8p2DQ6pxXHo956YFnlhb4x1uD2pisbT9r227Pwa1wyIwN4RhHzh7MvkMgCdvqug8Q+wmFbKwlEJ0kwoUcveAquv6RMNr6P2dYdenSR2iu2piimeJoIvxTG2Sw=
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com (52.133.17.145) by
 AM6PR0502MB4005.eurprd05.prod.outlook.com (52.133.29.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.20; Fri, 13 Sep 2019 09:06:46 +0000
Received: from AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::d948:8f02:2013:991b]) by AM6PR0502MB3783.eurprd05.prod.outlook.com
 ([fe80::d948:8f02:2013:991b%3]) with mapi id 15.20.2241.018; Fri, 13 Sep 2019
 09:06:46 +0000
From:   Shalom Toledo <shalomt@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: spectrum: Register CPU port with
 devlink
Thread-Topic: [PATCH net-next 1/2] mlxsw: spectrum: Register CPU port with
 devlink
Thread-Index: AQHVaWsoljJMoyCJi0CeYCvQUFWjP6cpQE+AgAAR+oA=
Date:   Fri, 13 Sep 2019 09:06:45 +0000
Message-ID: <20190913090643.GA3598@newton>
References: <20190912130740.22061-1-idosch@idosch.org>
 <20190912130740.22061-2-idosch@idosch.org> <20190913080223.GB2330@nanopsycho>
In-Reply-To: <20190913080223.GB2330@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.12.1 (2019-06-15)
x-clientproxiedby: LO2P265CA0262.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::34) To AM6PR0502MB3783.eurprd05.prod.outlook.com
 (2603:10a6:209:3::17)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=shalomt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [84.108.45.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b8bcd30-2cc7-4335-db86-08d73829b3a0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0502MB4005;
x-ms-traffictypediagnostic: AM6PR0502MB4005:|AM6PR0502MB4005:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0502MB400558CB25FFBB9B03EA2E01C5B30@AM6PR0502MB4005.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(39860400002)(346002)(366004)(396003)(376002)(136003)(189003)(199004)(6116002)(58126008)(71190400001)(66946007)(52116002)(33716001)(71200400001)(54906003)(316002)(478600001)(25786009)(256004)(66066001)(486006)(4326008)(14454004)(446003)(66446008)(6486002)(26005)(11346002)(6246003)(6436002)(2906002)(476003)(66556008)(64756008)(66476007)(102836004)(229853002)(186003)(8936002)(8676002)(3846002)(7736002)(81156014)(6506007)(386003)(1076003)(305945005)(76176011)(81166006)(9686003)(6512007)(5660300002)(6916009)(107886003)(99286004)(86362001)(33656002)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0502MB4005;H:AM6PR0502MB3783.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rLWLasy0oTSuifn74Hkj1Zp2bfGoKZnGa2Y1m12ZmbdLIntF/pbgF/nF+uf8kUOoHNYKw1H7q8GpqP84f/ROEmy0F9EqXOzlkW5NqRphwOhEikmj1MgslOxBrEM8XND7JTAz8UKatr4stl0WeWf2AMYEMd0AGCPTp9mnbMF1f+uzpV/OvB/so3yJCir/W+8Dr9y78GymIb52HL3sz9QQYMRNmHJzHoXc6m1seDkDvw39bEcEEANz+o8UoRR5ZpO8ugCH0CYHiIuwmLq10XXEJ68GVFpNdc85OYASOWkhPp5m1pZMdD9HtCVKsGqhCt/jp2FCg/3hqr16xnU09wwD2Xy2esasRvCcNJYLOJsQamtsgwFIHJd0jHQBR8TaUDF00Fqx+1HoIALTHhovj4E31bBPcd+Qo13Ac+M9m3fY8KQ=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E5BABA235711C14EAF0AE910D61D1129@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8bcd30-2cc7-4335-db86-08d73829b3a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 09:06:46.0956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F+ilCBMjzxP4ybScGqUv4flYvL4v7eU84XMXlR1zp0iuSwH7WyheKa3i8xXLM2JvfGPkqHyPYoU2/zXi+OMpLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB4005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 10:02:23AM +0200, Jiri Pirko wrote:
> Thu, Sep 12, 2019 at 03:07:39PM CEST, idosch@idosch.org wrote:
> >From: Shalom Toledo <shalomt@mellanox.com>
> >
> >Register CPU port with devlink.
> >
> >Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
> >Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> >---
> > drivers/net/ethernet/mellanox/mlxsw/core.c    | 33 +++++++++++++
> > drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
> > .../net/ethernet/mellanox/mlxsw/spectrum.c    | 47 +++++++++++++++++++
> > 3 files changed, 85 insertions(+)
> >
> >diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/et=
hernet/mellanox/mlxsw/core.c
> >index 963a2b4b61b1..94f83d2be17e 100644
> >--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
> >+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
> >@@ -1892,6 +1892,39 @@ void mlxsw_core_port_fini(struct mlxsw_core *mlxs=
w_core, u8 local_port)
> > }
> > EXPORT_SYMBOL(mlxsw_core_port_fini);
> >=20
> >+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
> >+			     void *port_driver_priv,
> >+			     const unsigned char *switch_id,
> >+			     unsigned char switch_id_len)
> >+{
> >+	struct devlink *devlink =3D priv_to_devlink(mlxsw_core);
> >+	struct mlxsw_core_port *mlxsw_core_port =3D
> >+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
> >+	struct devlink_port *devlink_port =3D &mlxsw_core_port->devlink_port;
> >+	int err;
> >+
> >+	mlxsw_core_port->local_port =3D MLXSW_PORT_CPU_PORT;
> >+	mlxsw_core_port->port_driver_priv =3D port_driver_priv;
> >+	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_CPU,
> >+			       0, false, 0, switch_id, switch_id_len);
> >+	err =3D devlink_port_register(devlink, devlink_port, MLXSW_PORT_CPU_PO=
RT);
> >+	if (err)
> >+		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
> >+	return err;
>=20
> This duplicates almost 100% of code of mlxsw_core_port_init. Please do a
> common function what can be used by both.

Ok, I will send another version on Sunday.


>=20
>=20
> >+}
> >+EXPORT_SYMBOL(mlxsw_core_cpu_port_init);
> >+
> >+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
> >+{
> >+	struct mlxsw_core_port *mlxsw_core_port =3D
> >+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
> >+	struct devlink_port *devlink_port =3D &mlxsw_core_port->devlink_port;
> >+
> >+	devlink_port_unregister(devlink_port);
> >+	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
> >+}
> >+EXPORT_SYMBOL(mlxsw_core_cpu_port_fini);
> >+
> > void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_po=
rt,
> > 			     void *port_driver_priv, struct net_device *dev)
> > {
> >diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/et=
hernet/mellanox/mlxsw/core.h
> >index b65a17d49e43..5d7d2ab6d155 100644
> >--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
> >+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
> >@@ -177,6 +177,11 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_c=
ore, u8 local_port,
> > 			 const unsigned char *switch_id,
> > 			 unsigned char switch_id_len);
> > void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)=
;
> >+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
> >+			     void *port_driver_priv,
> >+			     const unsigned char *switch_id,
> >+			     unsigned char switch_id_len);
> >+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
> > void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_po=
rt,
> > 			     void *port_driver_priv, struct net_device *dev);
> > void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_por=
t,
> >diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/ne=
t/ethernet/mellanox/mlxsw/spectrum.c
> >index 91e4792bb7e7..1fc73a9ad84d 100644
> >--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
> >+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
> >@@ -3872,6 +3872,46 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp =
*mlxsw_sp, u8 local_port)
> > 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
> > }
> >=20
> >+static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
> >+{
> >+	struct mlxsw_sp_port *mlxsw_sp_port;
> >+	int err;
> >+
> >+	mlxsw_sp_port =3D kzalloc(sizeof(*mlxsw_sp_port), GFP_KERNEL);
> >+	if (!mlxsw_sp_port)
> >+		return -ENOMEM;
> >+
> >+	mlxsw_sp_port->mlxsw_sp =3D mlxsw_sp;
> >+	mlxsw_sp_port->local_port =3D MLXSW_PORT_CPU_PORT;
> >+
> >+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] =3D mlxsw_sp_port;
>=20
> Assign this at the end of the function and avoid NULL assignment on
> error path.
>=20
>=20
> >+
> >+	err =3D mlxsw_core_cpu_port_init(mlxsw_sp->core,
> >+				       mlxsw_sp_port,
> >+				       mlxsw_sp->base_mac,
> >+				       sizeof(mlxsw_sp->base_mac));
> >+	if (err) {
> >+		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize core CPU port\=
n");
> >+		goto err_core_cpu_port_init;
> >+	}
> >+
> >+	return err;
> >+
> >+err_core_cpu_port_init:
> >+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] =3D NULL;
> >+	kfree(mlxsw_sp_port);
> >+	return err;
> >+}
> >+
> >+static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
> >+{
> >+	struct mlxsw_sp_port *mlxsw_sp_port =3D mlxsw_sp->ports[0];
>=20
> s/0/MLXSW_PORT_CPU_PORT/
>=20
>=20
> >+
> >+	mlxsw_core_cpu_port_fini(mlxsw_sp->core);
> >+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] =3D NULL;
> >+	kfree(mlxsw_sp_port);
> >+}
> >+
> > static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_p=
ort)
> > {
> > 	return mlxsw_sp->ports[local_port] !=3D NULL;
> >@@ -3884,6 +3924,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp =
*mlxsw_sp)
> > 	for (i =3D 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
> > 		if (mlxsw_sp_port_created(mlxsw_sp, i))
> > 			mlxsw_sp_port_remove(mlxsw_sp, i);
> >+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
> > 	kfree(mlxsw_sp->port_to_module);
> > 	kfree(mlxsw_sp->ports);
> > }
> >@@ -3908,6 +3949,10 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp =
*mlxsw_sp)
> > 		goto err_port_to_module_alloc;
> > 	}
> >=20
> >+	err =3D mlxsw_sp_cpu_port_create(mlxsw_sp);
> >+	if (err)
> >+		goto err_cpu_port_create;
> >+
> > 	for (i =3D 1; i < max_ports; i++) {
> > 		/* Mark as invalid */
> > 		mlxsw_sp->port_to_module[i] =3D -1;
> >@@ -3931,6 +3976,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *=
mlxsw_sp)
> > 	for (i--; i >=3D 1; i--)
> > 		if (mlxsw_sp_port_created(mlxsw_sp, i))
> > 			mlxsw_sp_port_remove(mlxsw_sp, i);
> >+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
> >+err_cpu_port_create:
> > 	kfree(mlxsw_sp->port_to_module);
> > err_port_to_module_alloc:
> > 	kfree(mlxsw_sp->ports);
> >--=20
> >2.21.0
> >
