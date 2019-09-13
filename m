Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25812B1948
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 10:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728825AbfIMIC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 04:02:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40464 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfIMIC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 04:02:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id l3so8354272wru.7
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 01:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HT7TdFKnHKXWTGVoa4901xmHtwCCeg1vQ2wWZBn3TNw=;
        b=BTMC3XGbFuNQC6Yenpdtj0x0R0PB7iWjzOerh0audM1gt0gORen1hJ2t1Xujqvh6vm
         zys/hsgfyL+CBo5y6QH5Gk0ecOSjTsHuD5AXoRCU3Tb9TV6/pxGdIeCgZh9rC14RXMQJ
         MAU3l/7V48F1tlKabr33CuFxjEP5l11qiyiKRVOCv61YtjKJqPM/T7urWJYc19s2FuhM
         xmX2Q1kSlgxbqVEYOwHc/8GlnhHWPhdja4UnmkeR5JJkG16cGgUZKZ3rIR9/Nqh29DGn
         nTncg79MCjc0R9gPmDUzrSlYxnjpUdGji6uoggc/3jPObziSl1aX11ikAs8nXYldt7uE
         gnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HT7TdFKnHKXWTGVoa4901xmHtwCCeg1vQ2wWZBn3TNw=;
        b=d5cgZ2vdOTs03aly60O1A/7AnKuAOR2rPM/Z2b1nUuxBSMi5C9Im7XztNnpCzKmvNu
         dzSJyVlDsFZzWTOICNyFsqXVl3GZJLduX5uhe8UhjOF5LNxYo/uvTOJgY/G4vd79fYpP
         MEZeMMqZ9qLvDTfvXzmSc084aHghW+x51xMKaVcpuy3O6THGrRUMuf42Wj9Ie4Qv7RvF
         4BqfQljS89yW2+kkHf9bT/dh6Kx3NyrKIKTkWYvzFyZubn+q//Licgdhsvmmcig83n4N
         53rieXcDqHsXrfp3ppD2sAZfR+9tgydXnasPTbt8HLVVU2AoNQJTEMICxydBCrHGp8BL
         wunA==
X-Gm-Message-State: APjAAAXCNuO65UIPv5WKAB8xue8zWFFLDX6SbD5rm0FDDHnoY+TDRhd4
        8NGH2iO5JC6kaF/Ympjg9fpNZA==
X-Google-Smtp-Source: APXvYqy9+6yFqZSM0cNukune7I7qkxe0bLBmOklQSr0DIKag96IILsMkcomg/jWwegVHKwi3SM9qPg==
X-Received: by 2002:a5d:504d:: with SMTP id h13mr37842177wrt.342.1568361744985;
        Fri, 13 Sep 2019 01:02:24 -0700 (PDT)
Received: from localhost (ip-213-220-255-83.net.upcbroadband.cz. [213.220.255.83])
        by smtp.gmail.com with ESMTPSA id b7sm7064083wrj.28.2019.09.13.01.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 01:02:24 -0700 (PDT)
Date:   Fri, 13 Sep 2019 10:02:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: spectrum: Register CPU port with
 devlink
Message-ID: <20190913080223.GB2330@nanopsycho>
References: <20190912130740.22061-1-idosch@idosch.org>
 <20190912130740.22061-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912130740.22061-2-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 12, 2019 at 03:07:39PM CEST, idosch@idosch.org wrote:
>From: Shalom Toledo <shalomt@mellanox.com>
>
>Register CPU port with devlink.
>
>Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> drivers/net/ethernet/mellanox/mlxsw/core.c    | 33 +++++++++++++
> drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
> .../net/ethernet/mellanox/mlxsw/spectrum.c    | 47 +++++++++++++++++++
> 3 files changed, 85 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
>index 963a2b4b61b1..94f83d2be17e 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
>@@ -1892,6 +1892,39 @@ void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
> }
> EXPORT_SYMBOL(mlxsw_core_port_fini);
> 
>+int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
>+			     void *port_driver_priv,
>+			     const unsigned char *switch_id,
>+			     unsigned char switch_id_len)
>+{
>+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
>+	struct mlxsw_core_port *mlxsw_core_port =
>+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
>+	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
>+	int err;
>+
>+	mlxsw_core_port->local_port = MLXSW_PORT_CPU_PORT;
>+	mlxsw_core_port->port_driver_priv = port_driver_priv;
>+	devlink_port_attrs_set(devlink_port, DEVLINK_PORT_FLAVOUR_CPU,
>+			       0, false, 0, switch_id, switch_id_len);
>+	err = devlink_port_register(devlink, devlink_port, MLXSW_PORT_CPU_PORT);
>+	if (err)
>+		memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
>+	return err;

This duplicates almost 100% of code of mlxsw_core_port_init. Please do a
common function what can be used by both.


>+}
>+EXPORT_SYMBOL(mlxsw_core_cpu_port_init);
>+
>+void mlxsw_core_cpu_port_fini(struct mlxsw_core *mlxsw_core)
>+{
>+	struct mlxsw_core_port *mlxsw_core_port =
>+					&mlxsw_core->ports[MLXSW_PORT_CPU_PORT];
>+	struct devlink_port *devlink_port = &mlxsw_core_port->devlink_port;
>+
>+	devlink_port_unregister(devlink_port);
>+	memset(mlxsw_core_port, 0, sizeof(*mlxsw_core_port));
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
>index 91e4792bb7e7..1fc73a9ad84d 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
>@@ -3872,6 +3872,46 @@ static void mlxsw_sp_port_remove(struct mlxsw_sp *mlxsw_sp, u8 local_port)
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
>+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = mlxsw_sp_port;

Assign this at the end of the function and avoid NULL assignment on
error path.


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
>+	return err;
>+
>+err_core_cpu_port_init:
>+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
>+	kfree(mlxsw_sp_port);
>+	return err;
>+}
>+
>+static void mlxsw_sp_cpu_port_remove(struct mlxsw_sp *mlxsw_sp)
>+{
>+	struct mlxsw_sp_port *mlxsw_sp_port = mlxsw_sp->ports[0];

s/0/MLXSW_PORT_CPU_PORT/


>+
>+	mlxsw_core_cpu_port_fini(mlxsw_sp->core);
>+	mlxsw_sp->ports[MLXSW_PORT_CPU_PORT] = NULL;
>+	kfree(mlxsw_sp_port);
>+}
>+
> static bool mlxsw_sp_port_created(struct mlxsw_sp *mlxsw_sp, u8 local_port)
> {
> 	return mlxsw_sp->ports[local_port] != NULL;
>@@ -3884,6 +3924,7 @@ static void mlxsw_sp_ports_remove(struct mlxsw_sp *mlxsw_sp)
> 	for (i = 1; i < mlxsw_core_max_ports(mlxsw_sp->core); i++)
> 		if (mlxsw_sp_port_created(mlxsw_sp, i))
> 			mlxsw_sp_port_remove(mlxsw_sp, i);
>+	mlxsw_sp_cpu_port_remove(mlxsw_sp);
> 	kfree(mlxsw_sp->port_to_module);
> 	kfree(mlxsw_sp->ports);
> }
>@@ -3908,6 +3949,10 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
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
>@@ -3931,6 +3976,8 @@ static int mlxsw_sp_ports_create(struct mlxsw_sp *mlxsw_sp)
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
