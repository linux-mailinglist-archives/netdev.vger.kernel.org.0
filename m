Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBE9B3521
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfIPHIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:08:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43813 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfIPHIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:08:51 -0400
Received: by mail-wr1-f68.google.com with SMTP id q17so32924642wrx.10
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 00:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q8Xk+4D0OZwI7YJq7R8MXtnOiY+axhnHfT99qheeWGc=;
        b=JcSTEkOJIFtQ5Jl1mG8immISt/5qxkK8WOO/DSPteELgN3XrWZbZiJ0JZe6mWlDF5p
         bzlTSXKJzCkCp5T1ZNTZYsK1MBbqavHDT/r8lZCm8A7XJFC0xtLH5cbCPuBFFO+YtRiP
         d2pxnxZByZqhldRVtH/+mbW705IRF6yoaccvOpgmJv5IqptxCHqQX/J8sjpDM/Jbt4Ey
         otZQUgen9P+SsKBAz394QUzmY8H9EEAmABTD7YR0L6WhnGf4bKqaTWogTCCLd0PAsDvX
         sLgnDlDc+wP10tmsVJN7hOzr1dh703AG3VnRjyBE3IGnAD0dbMdeP6Ue0zyOIzhE/A1y
         jsTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=q8Xk+4D0OZwI7YJq7R8MXtnOiY+axhnHfT99qheeWGc=;
        b=XtY6AJ0Vm4lnwQRbOod7wtbXZdfPI1x3C8LRn/lQh/1c0C3wm/og56NiFktK2b85Si
         mbXNgnq4L6ksbObwjNCCU4RdoWYHOOBD8lqWHeRvWLxZwYsFk5FGdExSWWFfrY4t/LZ1
         sSE5jLUj60exEwOfg/bJ0h5+wVkQorU12fCWHN7r4FsBRwwytIB1PqOBER+yRMdJHl7z
         xepYyleDP21KulTa3q2xq5/jfV2elziRaFaqt0qSW9Egu6meOmtCb2qIrVN6JVLet9xe
         ONNtuHjVH2K3ZQehASv/Xf0KWLbnVqAzQUkKHUU97l7neAny8wuoAqWPV14zq97izXQp
         YPWQ==
X-Gm-Message-State: APjAAAUYjX1UiR7Glw7+FGd6VekzKkiQgbXKkEh8ba3G35rzY2ZviIdi
        MEaFNteGnHmJcvpiCLTznxhi+g==
X-Google-Smtp-Source: APXvYqxXIoBBpMpZmrBdUZ+nONfAsBXlAy1OhdNT0ylge9j5CuNXzPYNqqBnpOyZOG2pUUmvMMMEsw==
X-Received: by 2002:a5d:558c:: with SMTP id i12mr23421171wrv.8.1568617728755;
        Mon, 16 Sep 2019 00:08:48 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 33sm46173891wra.41.2019.09.16.00.08.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 00:08:47 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:08:47 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v2 2/3] mlxsw: spectrum: Register CPU port with
 devlink
Message-ID: <20190916070847.GJ2286@nanopsycho.orion>
References: <20190916061750.26207-1-idosch@idosch.org>
 <20190916061750.26207-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916061750.26207-3-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 16, 2019 at 08:17:49AM CEST, idosch@idosch.org wrote:
>From: Shalom Toledo <shalomt@mellanox.com>
>
>Register CPU port with devlink.
>
>Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlxsw/core.c    | 65 ++++++++++++++++---
> drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
> .../net/ethernet/mellanox/mlxsw/spectrum.c    | 46 +++++++++++++
> 3 files changed, 107 insertions(+), 9 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>index 3fa96076e8a5..66354b05fd6c 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>@@ -1864,11 +1864,13 @@ u64 mlxsw_core_res_get(struct mlxsw_core *mlxsw_core,
> }
> EXPORT_SYMBOL(mlxsw_core_res_get);
> 
>-int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
>-			 u32 port_number, bool split,
>-			 u32 split_port_subnumber,
>-			 const unsigned char *switch_id,
>-			 unsigned char switch_id_len)
>+static int
>+__mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
>+		       enum devlink_port_flavour flavour,
>+		       u32 port_number, bool split,
>+		       u32 split_port_subnumber,
>+		       const unsigned char *switch_id,
>+		       unsigned char switch_id_len)

No need to wrap after "static int":

static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
				  enum devlink_port_flavour flavour,
				  u32 port_number, bool split,
				  u32 split_port_subnumber,
				  const unsigned char *switch_id,
				  unsigned char switch_id_len)


> {
> 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
> 	struct mlxsw_core_port *mlxsw_core_port =
>@@ -1877,17 +1879,17 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
> 	int err;
> 
> 	mlxsw_core_port->local_port = local_port;
>-	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>-			       port_number, split, split_port_subnumber,
>+	devlink_port_attrs_set(devlink_port, flavour, port_number,
>+			       split, split_port_subnumber,
> 			       switch_id, switch_id_len);
> 	err = devlink_port_register(devlink, devlink_port, local_port);
> 	if (err)
> 		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
> 	return err;
> }
>-EXPORT_SYMBOL(mlxsw_core_port_init);
> 
>-void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
>+static void
>+__mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)

No need to wrap:

static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)


> {
> 	struct mlxsw_core_port *mlxsw_core_port =
> 					&mlxsw_core->ports[local_port];
>@@ -1896,8 +1898,53 @@ void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
> 	devlink_port_unregister(devlink_port);
> 	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
> }
>+
>+int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
>+			 u32 port_number, bool split,
>+			 u32 split_port_subnumber,
>+			 const unsigned char *switch_id,
>+			 unsigned char switch_id_len)
>+{
>+	return __mlxsw_core_port_init(mlxsw_core, local_port,
>+				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
>+				      port_number, split, split_port_subnumber,
>+				      switch_id, switch_id_len);
>+}
>+EXPORT_SYMBOL(mlxsw_core_port_init);
>+
>+void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
>+{
>+	__mlxsw_core_port_fini(mlxsw_core, local_port);
>+}
> EXPORT_SYMBOL(mlxsw_core_port_fini);
> 
>+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
>+			     void *port_driver_priv,
>+			     const unsigned char *switch_id,
>+			     unsigned char switch_id_len)
>+{
>+	struct mlxsw_core_port *mlxsw_core_port =
>+				&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
>+	int err;
>+
>+	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
>+				     DEVLINK_PORT_FLAVOUR_CPU,
>+				     0, false, 0,
>+				     switch_id, switch_id_len);
>+	if (err)
>+		return err;
>+
>+	mlxsw_core_port->port_driver_priv = port_driver_priv;

It is a bit confusing why this is done here comparing to physical ports,
where it is done during type set. But I didn't find better solution.


>+	return 0;
>+}
>+EXPORT_SYMBOL(mlxsw_core_cpu_port_init);
>+
>+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
>+{
>+	__mlxsw_core_port_fini(mlxsw_core, MLXSW_PORT_CPU_PORT);
>+}
>+EXPORT_SYMBOL(mlxsw_core_cpu_port_fini);
>+
> void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
> 			     void *port_driver_priv, struct net_device *dev)
> {
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
>index b65a17d49e43..5d7d2ab6d155 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
>@@ -177,6 +177,11 @@ int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
> 			 const unsigned char *switch_id,
> 			 unsigned char switch_id_len);
> void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
>+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
>+			     void *port_driver_priv,
>+			     const unsigned char *switch_id,
>+			     unsigned char switch_id_len);
>+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core);
> void mlxsw_core_port_eth_set(struct mlxsw_core *mlxsw_core, u8 local_port,
> 			     void *port_driver_priv, struct net_device *dev);
> void mlxsw_core_port_ib_set(struct mlxsw_core *mlxsw_core, u8 local_port,
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>index 91e4792bb7e7..dd234cf7b39d 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>@@ -3872,6 +3872,45 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
> 	mlxsw_core_port_fini(mlxsw_sp->core, local_port);
> }
> 
>+static int mlxsw_sp_cpu_port_create(struct mlxsw_sp *mlxsw_sp)
>+{
>+	struct mlxsw_sp_port *mlxsw_sp_port;
>+	int err;
>+
>+	mlxsw_sp_port = kzalloc(sizeof(*mlxsw_sp_port), GFP_KERNEL);
>+	if (!mlxsw_sp_port)
>+		return -ENOMEM;
>+
>+	mlxsw_sp_port->mlxsw_sp = mlxsw_sp;
>+	mlxsw_sp_port->local_port = MLXSW_PORT_CPU_PORT;
>+
>+	err = mlxsw_core_cpu_port_init(mlxsw_sp->core,
>+				       mlxsw_sp_port,
>+				       mlxsw_sp->base_mac,
>+				       sizeof(mlxsw_sp->base_mac));
>+	if (err) {
>+		dev_err(mlxsw_sp->bus_info->dev, "Failed to initialize core CPU port\n");
>+		goto err_core_cpu_port_init;
>+	}
>+
>+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = mlxsw_sp_port;
>+	return 0;
>+
>+err_core_cpu_port_init:
>+	kfree(mlxsw_sp_port);
>+	return err;
>+}
>+
>+static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
>+{
>+	struct mlxsw_sp_port *mlxsw_sp_port =
>+				mlxsw_sp->ports[MLXSW_PORT_CPU_PORT];
>+
>+	mlxsw_core_cpu_port_fini(mlxsw_sp->core);
>+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
>+	kfree(mlxsw_sp_port);
>+}
>+
> static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
> {
> 	return mlxsw_sp->ports[local_port] != NULL;
>@@ -3884,6 +3923,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
> 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
> 		if (mlxsw_sp_port_created(mlxsw_sp, i))
> 			mlxsw_sp_port_remove(mlxsw_sp, i);
>+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
> 	kfree(mlxsw_sp->port_to_module);
> 	kfree(mlxsw_sp->ports);
> }
>@@ -3908,6 +3948,10 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
> 		goto err_port_to_module_alloc;
> 	}
> 
>+	err = mlxsw_sp_cpu_port_create(mlxsw_sp);
>+	if (err)
>+		goto err_cpu_port_create;
>+
> 	for (i = 1; i < max_ports; i++) {
> 		/* Mark as invalid */
> 		mlxsw_sp->port_to_module[i] = -1;
>@@ -3931,6 +3975,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
> 	for (i--; i >= 1; i--)
> 		if (mlxsw_sp_port_created(mlxsw_sp, i))
> 			mlxsw_sp_port_remove(mlxsw_sp, i);
>+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
>+err_cpu_port_create:
> 	kfree(mlxsw_sp->port_to_module);
> err_port_to_module_alloc:
> 	kfree(mlxsw_sp->ports);
>-- 
>2.21.0
>
