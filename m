Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10640140A9
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfEEPgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:36:11 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46094 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfEEPgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:36:11 -0400
Received: by mail-wr1-f65.google.com with SMTP id r7so13994035wrr.13
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NTmJ74DL6ba11mzoVEW+MyB3Wq7SAUqCMq9Ztnp/zkk=;
        b=0JrFO7PXAt46VWnGRV2SfuM4kEb4mLJbtdbvuUtj35dipWrEKup0J7rfqqKb0HbEIC
         GVUmDaIGcuZclBWhTEqvLGkeXRo3mj6zeUCTJHhAIALBHat/S3nuednzT2Zn+WTiV4y4
         IEpPWtZyH2gdyg9VlQiDM2ufNAGjjTX4TlFGT2rmcF3vZ2pihW+i+FJ4XcDvHTa86mrX
         NPOO/Ng2GbSRloxUFYnvZiqo8Fkb9vExkYSU2OC5dn0Ieb7nryQPhr12D1Wokut3Qz0r
         1XHysr8ys5iMgHUgJ7syu5o/J4EDN/nLpGwh4BTW70FK69rkFwCU8tKCiEGq0ugH/Enf
         wYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=NTmJ74DL6ba11mzoVEW+MyB3Wq7SAUqCMq9Ztnp/zkk=;
        b=B2d85OhYzcaHVEeZHjDsnc8qOktGI2ZcODYmS+dVFCMbluZyELVBa0/I9VRQIFWChM
         5or2cOJMgjv/fn+dyu3eFCZbOHn7bevoZ+nGYvOW0icUCMyyl4bbQq4IW0K/GzCEtS+v
         qLa7mdmgjqaqSJcw8Ze96AdyhA5HMBXN4uY9HBJRCpZkQAz0oLuZy8Vn90EGqBzgmB3e
         PFWryk+H9dD+tF9ntL5R9k30zC3RE4Ihg/iDK5VnWAqMZpcvtgXoDKrg0RE2AqqBaxVu
         6n2Axcg/gh010DTeK4yU5litDWG/dQTvdPLMR5d95ZSLLkqERqvr6mkaITJxPOrTn1LY
         m49g==
X-Gm-Message-State: APjAAAWmXT1LGWHlVuTEJZzID4rPOrVOXdc2EKLNjSx58zQydOVigno/
        uMIPkvXZsiTxe+OCEnIR7/iNWQ==
X-Google-Smtp-Source: APXvYqyr5TOCVkqjY5p+pObWnHaqwQcRureT73oH9IJxkK0yY+xtLUQjp1sYnYPQb5+KTBC5wbBf2A==
X-Received: by 2002:adf:ef43:: with SMTP id c3mr15633469wrp.141.1557070568536;
        Sun, 05 May 2019 08:36:08 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b11sm15703826wmh.29.2019.05.05.08.36.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:36:08 -0700 (PDT)
Date:   Sun, 5 May 2019 17:36:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>
Subject: Re: [net-next 03/15] net/mlx5: Add Crdump FW snapshot support
Message-ID: <20190505153605.GA31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-4-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-4-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:00AM CEST, saeedm@mellanox.com wrote:
>From: Alex Vesker <valex@mellanox.com>
>
>Crdump allows the driver to create a snapshot of the FW PCI crspace.
>This is useful in case of catastrophic issues which may require FW
>reset. The snapshot can be used for later debug.
>
>The snapshot is exposed using devlink region_snapshot in downstream patch,
>cr-space address regions are registered on init and snapshots are attached
>once a new snapshot is collected by the driver.
>
>Signed-off-by: Alex Vesker <valex@mellanox.com>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Reviewed-by: Feras Daoud <ferasda@mellanox.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>---
> .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
> .../ethernet/mellanox/mlx5/core/diag/crdump.c | 179 ++++++++++++++++++
> .../net/ethernet/mellanox/mlx5/core/health.c  |   1 +
> .../ethernet/mellanox/mlx5/core/lib/mlx5.h    |   4 +
> .../net/ethernet/mellanox/mlx5/core/main.c    |   5 +
> include/linux/mlx5/driver.h                   |   4 +
> 6 files changed, 194 insertions(+), 1 deletion(-)
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/crdump.c
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>index 34d9a079b608..5feed9e1bec7 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
>@@ -16,7 +16,7 @@ mlx5_core-y :=	main.o cmd.o debugfs.o fw.o eq.o uar.o pagealloc.o \
> 		transobj.o vport.o sriov.o fs_cmd.o fs_core.o \
> 		fs_counters.o rl.o lag.o dev.o events.o wq.o lib/gid.o \
> 		lib/devcom.o lib/pci_vsc.o diag/fs_tracepoint.o \
>-		diag/fw_tracer.o devlink.o
>+		diag/fw_tracer.o diag/crdump.o devlink.o
> 
> #
> # Netdev basic
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/crdump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/crdump.c
>new file mode 100644
>index 000000000000..6430ceeefb53
>--- /dev/null
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/crdump.c
>@@ -0,0 +1,179 @@
>+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>+/* Copyright (c) 2019 Mellanox Technologies */
>+
>+#include <linux/proc_fs.h>
>+#include <linux/mlx5/driver.h>
>+#include <net/devlink.h>
>+#include "mlx5_core.h"
>+#include "lib/pci_vsc.h"
>+#include "lib/mlx5.h"
>+
>+#define BAD_ACCESS			0xBADACCE5
>+#define MLX5_PROTECTED_CR_SCAN_CRSPACE	0x7
>+#define MAX_NUM_OF_DUMPS_TO_STORE	(8)

Please make your local defines prefixed with "mlx5_". For example
"BAD_ACCESS" sounds way too generic.


>+
>+static const char *region_cr_space_str = "cr-space";
>+
>+struct mlx5_fw_crdump {
>+	u32			size;
>+	struct devlink_region	*region_crspace;
>+};
>+
>+static bool mlx5_crdump_enbaled(struct mlx5_core_dev *dev)

Typo: s/enbaled/enabled/


>+{
>+	struct mlx5_priv *priv = &dev->priv;
>+
>+	return (!!priv->health.crdump);

Poitlesss brackets. Please remove.


>+}
>+
>+static int mlx5_crdump_fill(struct mlx5_core_dev *dev,
>+			    char *crdump_region, u32 *snapshot_id)
>+{
>+	struct devlink *devlink = priv_to_devlink(dev);
>+	struct mlx5_priv *priv = &dev->priv;
>+	struct mlx5_fw_crdump *crdump = priv->health.crdump;
>+	int i, ret = 0;
>+	u32 *cr_data;
>+	u32 id;
>+
>+	cr_data = kvmalloc(crdump->size, GFP_KERNEL);
>+	if (!cr_data)
>+		return -ENOMEM;
>+
>+	for (i = 0; i < (crdump->size / 4); i++)
>+		cr_data[i] = BAD_ACCESS;
>+
>+	ret = mlx5_vsc_gw_read_block_fast(dev, cr_data, crdump->size);
>+	if (ret <= 0) {
>+		if (ret == 0)
>+			ret = -EIO;
>+		goto free_data;
>+	}
>+
>+	if (crdump->size != ret) {
>+		mlx5_core_warn(dev, "failed to read full dump, read %d out of %u\n",
>+			       ret, crdump->size);
>+		ret = -EINVAL;
>+		goto free_data;
>+	}
>+
>+	/* Get the available snapshot ID for the dumps */
>+	id = devlink_region_shapshot_id_get(devlink);
>+	ret = devlink_region_snapshot_create(crdump->region_crspace,
>+					     crdump->size, (u8 *)cr_data,
>+					     id, &kvfree);
>+	if (ret) {
>+		mlx5_core_warn(dev, "crdump: devlink create %s snapshot id %d err %d\n",
>+			       region_cr_space_str, id, ret);
>+		goto free_data;
>+	} else {
>+		*snapshot_id = id;
>+		strcpy(crdump_region, region_cr_space_str);
>+	}
>+	return 0;
>+
>+free_data:
>+	kvfree(cr_data);
>+	return ret;
>+}
>+
>+int mlx5_crdump_collect(struct mlx5_core_dev *dev,
>+			char *crdump_region, u32 *snapshot_id)
>+{
>+	int ret = 0;
>+
>+	if (!mlx5_crdump_enbaled(dev))
>+		return -ENODEV;
>+
>+	ret = mlx5_vsc_gw_lock(dev);
>+	if (ret) {
>+		mlx5_core_warn(dev, "crdump: failed to lock vsc gw err %d\n",
>+			       ret);
>+		return ret;
>+	}
>+
>+	ret = mlx5_vsc_gw_set_space(dev, MLX5_VSC_SPACE_SCAN_CRSPACE, NULL);
>+	if (ret)
>+		goto unlock;
>+
>+	ret = mlx5_crdump_fill(dev, crdump_region, snapshot_id);
>+
>+unlock:
>+	mlx5_vsc_gw_unlock(dev);
>+	return ret;
>+}
>+
>+int mlx5_crdump_init(struct mlx5_core_dev *dev)
>+{
>+	struct devlink *devlink = priv_to_devlink(dev);
>+	struct mlx5_priv *priv = &dev->priv;
>+	struct mlx5_fw_crdump *crdump;
>+	u32 space_size;
>+	int ret;
>+
>+	if (!mlx5_core_is_pf(dev) || !mlx5_vsc_accessible(dev) ||
>+	    mlx5_crdump_enbaled(dev))
>+		return 0;
>+
>+	ret = mlx5_vsc_gw_lock(dev);
>+	if (ret)
>+		return ret;
>+
>+	/* Check if space is supported and get space size */
>+	ret = mlx5_vsc_gw_set_space(dev, MLX5_VSC_SPACE_SCAN_CRSPACE,
>+				    &space_size);
>+	if (ret) {
>+		/* Unlock and mask error since space is not supported */
>+		mlx5_vsc_gw_unlock(dev);
>+		return 0;
>+	}
>+
>+	if (!space_size) {
>+		mlx5_core_warn(dev, "Invalid Crspace size, zero\n");
>+		mlx5_vsc_gw_unlock(dev);
>+		return -EINVAL;
>+	}
>+
>+	ret = mlx5_vsc_gw_unlock(dev);
>+	if (ret)
>+		return ret;
>+
>+	crdump = kzalloc(sizeof(*crdump), GFP_KERNEL);
>+	if (!crdump)
>+		return -ENOMEM;
>+
>+	/* Create cr-space region */
>+	crdump->size = space_size;
>+	crdump->region_crspace =
>+		devlink_region_create(devlink,
>+				      region_cr_space_str,
>+				      MAX_NUM_OF_DUMPS_TO_STORE,
>+				      space_size);

Unnecessary wraps.


>+	if (IS_ERR(crdump->region_crspace)) {
>+		mlx5_core_warn(dev,

Unnecessary wrap.


>+			       "crdump: create devlink region %s err %ld\n",
>+			       region_cr_space_str,
>+			       PTR_ERR(crdump->region_crspace));
>+		ret = PTR_ERR(crdump->region_crspace);
>+		goto free_crdump;
>+	}
>+	priv->health.crdump = crdump;
>+	return 0;
>+
>+free_crdump:
>+	kfree(crdump);
>+	return ret;
>+}
>+
>+void mlx5_crdump_cleanup(struct mlx5_core_dev *dev)
>+{
>+	struct mlx5_priv *priv = &dev->priv;
>+	struct mlx5_fw_crdump *crdump = priv->health.crdump;
>+
>+	if (!crdump)
>+		return;
>+
>+	devlink_region_destroy(crdump->region_crspace);
>+	kfree(crdump);
>+	priv->health.crdump = NULL;

Why do you need to have this NULL. Where do you check for NULL?


>+}
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>index a2656f4008d9..90f3da6da7f9 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>@@ -388,6 +388,7 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
> 	spin_lock_init(&health->wq_lock);
> 	INIT_WORK(&health->work, health_care);
> 	INIT_DELAYED_WORK(&health->recover_work, health_recover);
>+	health->crdump = NULL;

Same here.


> 
> 	return 0;
> }
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
>index 397a2847867a..3c9a6dedccaa 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
>@@ -41,6 +41,10 @@ int  mlx5_core_reserve_gids(struct mlx5_core_dev *dev, unsigned int count);
> void mlx5_core_unreserve_gids(struct mlx5_core_dev *dev, unsigned int count);
> int  mlx5_core_reserved_gid_alloc(struct mlx5_core_dev *dev, int *gid_index);
> void mlx5_core_reserved_gid_free(struct mlx5_core_dev *dev, int gid_index);
>+int mlx5_crdump_init(struct mlx5_core_dev *dev);
>+void mlx5_crdump_cleanup(struct mlx5_core_dev *dev);
>+int mlx5_crdump_collect(struct mlx5_core_dev *dev,
>+			char *crdump_region, u32 *snapshot_id);
> 
> /* TODO move to lib/events.h */
> 
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>index 64eb2a558b30..43f5487de4c3 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>@@ -1320,6 +1320,10 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *id)
> 	if (err)
> 		goto clean_load;
> 
>+	err = mlx5_crdump_init(dev);
>+	if (err)
>+		dev_err(&pdev->dev, "mlx5_crdump_init failed with error code %d\n", err);
>+
> 	pci_save_state(pdev);
> 	return 0;
> 
>@@ -1341,6 +1345,7 @@ static void remove_one(struct pci_dev *pdev)
> 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
> 	struct devlink *devlink = priv_to_devlink(dev);
> 
>+	mlx5_crdump_cleanup(dev);
> 	mlx5_devlink_unregister(devlink);
> 	mlx5_unregister_device(dev);
> 
>diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
>index 56d0a116f575..ddf6f41a75d3 100644
>--- a/include/linux/mlx5/driver.h
>+++ b/include/linux/mlx5/driver.h
>@@ -53,6 +53,7 @@
> #include <linux/mlx5/eq.h>
> #include <linux/timecounter.h>
> #include <linux/ptp_clock_kernel.h>
>+#include <net/devlink.h>
> 
> enum {
> 	MLX5_BOARD_ID_LEN = 64,
>@@ -427,6 +428,8 @@ struct mlx5_sq_bfreg {
> 	unsigned int		offset;
> };
> 
>+struct mlx5_fw_crdump;
>+
> struct mlx5_core_health {
> 	struct health_buffer __iomem   *health;
> 	__be32 __iomem		       *health_counter;
>@@ -440,6 +443,7 @@ struct mlx5_core_health {
> 	unsigned long			flags;
> 	struct work_struct		work;
> 	struct delayed_work		recover_work;
>+	struct mlx5_fw_crdump	       *crdump;
> };
> 
> struct mlx5_qp_table {
>-- 
>2.20.1
>
