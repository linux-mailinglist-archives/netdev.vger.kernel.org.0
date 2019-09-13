Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DF2B1971
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 10:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387455AbfIMIRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 04:17:39 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36257 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387459AbfIMIRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 04:17:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id t3so1738044wmj.1
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 01:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2H4C3P/z94Baj3MAsCZAluUpkn3Jt7sHgtGsmNl/3P8=;
        b=aMH81G+9Z6UWcVI8yZbVBFibXd8bGdh4b+6PKqqJfsdo3d0RKmyactdEqrNAUrbLnR
         uYWCXgblLJmT8e5RumI2vsnflwceUBMj0isdnj0sc6+6i7MfLfMtXLtV341+qdAZLfHM
         d8S2WsRwwIi8BoIqZLc4i9qE4hg/V5EZP+gmJedAFdIHXd3YeXXPsSnU/GfGGsVzHE6j
         KAB4Yf91XtcSXuyhTLhlsg6vjZoF/GzW7b3DGrVU3/QhMz0rMrwJebir5IW1ttuusu84
         vVEhWwXh3yaRfOM/HILA4SvsT7YiKxHFQGr0RcwilpLb/jcaEHQCsp/zZtuS9fCcHhcr
         /8fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2H4C3P/z94Baj3MAsCZAluUpkn3Jt7sHgtGsmNl/3P8=;
        b=a+C/p5JZvTpVX25QSKLKa9HJJBrtJEkBUY6MQ3byCX/M5qPRY7J0S5exPU93Sn5Haa
         sitGDw4WUnliZDaONVcRDY9dJgObD+iOyTQqEeo5h6VZZeLo1SiPlToF7kqSZupkC6x1
         luj67q0EwQTHlf+MPxkKV3aKWDWaRAdV7d+5Jn/t5q9Ai5lqRimL7bh1OpNl4diWIyZX
         8Dxl+dhwwu9NSOJ2jXtiFGtvNdlcQk+u0VSVtt7JUgCbJOEshjrmD2MLHkfBSJ2KZYvg
         XO5e+jZPRuG5B29Hwqfg2WsMPPX+aIN3e619HEgO8R3GBSXYZZsDeWgOC7UdIH/afRGa
         gLpA==
X-Gm-Message-State: APjAAAU7ZdyE7u2g9bi1X5+I6MXoL0xa3kpMJSWMdNLvLP2D3ha35Qcg
        6Wu0RVKJFIfAHngKCr9tikLYKOE+2XY=
X-Google-Smtp-Source: APXvYqx8wX9Q389hsCduyvvmlb+d2cvnJDt+1rSMoJ1C8TT/dZ/6sbAXSbMn+FAfenoG6Dt6ZYIfdQ==
X-Received: by 2002:a1c:7a14:: with SMTP id v20mr2478851wmc.75.1568362657394;
        Fri, 13 Sep 2019 01:17:37 -0700 (PDT)
Received: from localhost (ip-213-220-255-83.net.upcbroadband.cz. [213.220.255.83])
        by smtp.gmail.com with ESMTPSA id n2sm1433682wmc.1.2019.09.13.01.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 01:17:36 -0700 (PDT)
Date:   Fri, 13 Sep 2019 10:17:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        shalomt@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 2/2] mlxsw: spectrum_buffers: Add the ability to
 query the CPU port's shared buffer
Message-ID: <20190913081736.GC2330@nanopsycho>
References: <20190912130740.22061-1-idosch@idosch.org>
 <20190912130740.22061-3-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912130740.22061-3-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 12, 2019 at 03:07:40PM CEST, idosch@idosch.org wrote:
>From: Shalom Toledo <shalomt@mellanox.com>
>
>While debugging packet loss towards the CPU, it is useful to be able to
>query the CPU port's shared buffer quotas and occupancy.
>
>Since the CPU port has no ingress buffers, all the shared buffers ingress
>information will be cleared.
>
>Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>
>---
> .../mellanox/mlxsw/spectrum_buffers.c         | 51 ++++++++++++++++---
> 1 file changed, 43 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
>index 888ba4300bcc..b9eeae37a4dc 100644
>--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
>+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
>@@ -250,6 +250,10 @@ static int mlxsw_sp_sb_pm_occ_clear(struct mlxsw_sp *mlxsw_sp, u8 local_port,
> 		&mlxsw_sp->sb_vals->pool_dess[pool_index];
> 	char sbpm_pl[MLXSW_REG_SBPM_LEN];
> 
>+	if (local_port == MLXSW_PORT_CPU_PORT &&
>+	    des->dir == MLXSW_REG_SBXX_DIR_INGRESS)
>+		return 0;
>+
> 	mlxsw_reg_sbpm_pack(sbpm_pl, local_port, des->pool, des->dir,
> 			    true, 0, 0);
> 	return mlxsw_reg_trans_query(mlxsw_sp->core, MLXSW_REG(sbpm), sbpm_pl,
>@@ -273,6 +277,10 @@ static int mlxsw_sp_sb_pm_occ_query(struct mlxsw_sp *mlxsw_sp, u8 local_port,
> 	char sbpm_pl[MLXSW_REG_SBPM_LEN];
> 	struct mlxsw_sp_sb_pm *pm;
> 
>+	if (local_port == MLXSW_PORT_CPU_PORT &&
>+	    des->dir == MLXSW_REG_SBXX_DIR_INGRESS)
>+		return 0;
>+
> 	pm = mlxsw_sp_sb_pm_get(mlxsw_sp, local_port, pool_index);
> 	mlxsw_reg_sbpm_pack(sbpm_pl, local_port, des->pool, des->dir,
> 			    false, 0, 0);
>@@ -1085,6 +1093,11 @@ int mlxsw_sp_sb_port_pool_set(struct mlxsw_core_port *mlxsw_core_port,
> 	u32 max_buff;
> 	int err;
> 
>+	if (local_port == MLXSW_PORT_CPU_PORT) {
>+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's threshold is forbidden");
>+		return -EINVAL;
>+	}
>+
> 	err = mlxsw_sp_sb_threshold_in(mlxsw_sp, pool_index,
> 				       threshold, &max_buff, extack);
> 	if (err)
>@@ -1130,6 +1143,11 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
> 	u32 max_buff;
> 	int err;
> 
>+	if (local_port == MLXSW_PORT_CPU_PORT) {
>+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's binding is forbidden");

I believe you need to add this check before the previous patch that
introduces the cpu port.


>+		return -EINVAL;
>+	}
>+
> 	if (dir != mlxsw_sp->sb_vals->pool_dess[pool_index].dir) {
> 		NL_SET_ERR_MSG_MOD(extack, "Binding egress TC to ingress pool and vice versa is forbidden");
> 		return -EINVAL;
>@@ -1187,6 +1205,11 @@ static void mlxsw_sp_sb_sr_occ_query_cb(struct mlxsw_core *mlxsw_core,
> 	     local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
> 		if (!mlxsw_sp->ports[local_port])
> 			continue;
>+		if (local_port == MLXSW_PORT_CPU_PORT) {
>+			/* Ingress quotas are not supported for the CPU port */
>+			masked_count++;
>+			continue;
>+		}
> 		for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++) {
> 			cm = mlxsw_sp_sb_cm_get(mlxsw_sp, local_port, i,
> 						MLXSW_REG_SBXX_DIR_INGRESS);
>@@ -1222,7 +1245,7 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
> 	char *sbsr_pl;
> 	u8 masked_count;
> 	u8 local_port_1;
>-	u8 local_port = 0;
>+	u8 local_port;
> 	int i;
> 	int err;
> 	int err2;
>@@ -1231,8 +1254,8 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
> 	if (!sbsr_pl)
> 		return -ENOMEM;
> 
>+	local_port = MLXSW_PORT_CPU_PORT;
> next_batch:
>-	local_port++;
> 	local_port_1 = local_port;
> 	masked_count = 0;
> 	mlxsw_reg_sbsr_pack(sbsr_pl, false);
>@@ -1243,7 +1266,11 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
> 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
> 		if (!mlxsw_sp->ports[local_port])
> 			continue;
>-		mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl, local_port, 1);
>+		if (local_port != MLXSW_PORT_CPU_PORT) {
>+			/* Ingress quotas are not supported for the CPU port */
>+			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
>+							     local_port, 1);
>+		}
> 		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
> 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
> 			err = mlxsw_sp_sb_pm_occ_query(mlxsw_sp, local_port, i,
>@@ -1264,8 +1291,10 @@ int mlxsw_sp_sb_occ_snapshot(struct mlxsw_core *mlxsw_core,
> 				    cb_priv);
> 	if (err)
> 		goto out;
>-	if (local_port < mlxsw_core_max_ports(mlxsw_core))
>+	if (local_port < mlxsw_core_max_ports(mlxsw_core)) {
>+		local_port++;
> 		goto next_batch;
>+	}
> 
> out:
> 	err2 = mlxsw_reg_trans_bulk_wait(&bulk_list);
>@@ -1282,7 +1311,7 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
> 	LIST_HEAD(bulk_list);
> 	char *sbsr_pl;
> 	unsigned int masked_count;
>-	u8 local_port = 0;
>+	u8 local_port;
> 	int i;
> 	int err;
> 	int err2;
>@@ -1291,8 +1320,8 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
> 	if (!sbsr_pl)
> 		return -ENOMEM;
> 
>+	local_port = MLXSW_PORT_CPU_PORT;
> next_batch:
>-	local_port++;
> 	masked_count = 0;
> 	mlxsw_reg_sbsr_pack(sbsr_pl, true);
> 	for (i = 0; i < MLXSW_SP_SB_ING_TC_COUNT; i++)
>@@ -1302,7 +1331,11 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
> 	for (; local_port < mlxsw_core_max_ports(mlxsw_core); local_port++) {
> 		if (!mlxsw_sp->ports[local_port])
> 			continue;
>-		mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl, local_port, 1);
>+		if (local_port != MLXSW_PORT_CPU_PORT) {
>+			/* Ingress quotas are not supported for the CPU port */
>+			mlxsw_reg_sbsr_ingress_port_mask_set(sbsr_pl,
>+							     local_port, 1);
>+		}
> 		mlxsw_reg_sbsr_egress_port_mask_set(sbsr_pl, local_port, 1);
> 		for (i = 0; i < mlxsw_sp->sb_vals->pool_count; i++) {
> 			err = mlxsw_sp_sb_pm_occ_clear(mlxsw_sp, local_port, i,
>@@ -1319,8 +1352,10 @@ int mlxsw_sp_sb_occ_max_clear(struct mlxsw_core *mlxsw_core,
> 				    &bulk_list, NULL, 0);
> 	if (err)
> 		goto out;
>-	if (local_port < mlxsw_core_max_ports(mlxsw_core))
>+	if (local_port < mlxsw_core_max_ports(mlxsw_core)) {
>+		local_port++;
> 		goto next_batch;
>+	}
> 
> out:
> 	err2 = mlxsw_reg_trans_bulk_wait(&bulk_list);
>-- 
>2.21.0
>
