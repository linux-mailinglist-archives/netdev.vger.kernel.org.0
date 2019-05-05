Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F997140DD
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 17:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbfEEPwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 11:52:46 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45904 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfEEPwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 11:52:46 -0400
Received: by mail-wr1-f67.google.com with SMTP id s15so14030630wra.12
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 08:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ERJ/7DXiiZHzwXC9z9FVEAwFdly0UVsm6YrMhSp64f4=;
        b=OYKQUaOPgrDviyvwo5QPjTdnC/ZqoM6tqSEDCDV/7FZzfoK6zBdyqyF3C0+LCrmLsc
         D3Erm7ApsQzArSIelra3BS43bNc91ob1v0Fu8MEe5qQ4VEbRPa8G3DBydacqBYWl7xMk
         zFszgfnMIkFmlKMkskI+vKrZLkoZs67vpau7ZxDGzXPB+vpZzNprP/b1w6er0ypI3efp
         bVXcj/BtA6YBduvwng+pL4MrAbR2J3sI8C3uhL0vzubBCP0IHtttBXfjunIZgWg6GhIY
         WybSLsQx6jk9ISF8firNJ3YFnlJ9Frh8+iRT62bAVrmlYUvSORQy1xqlUnaA2cc2DfNa
         Uokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ERJ/7DXiiZHzwXC9z9FVEAwFdly0UVsm6YrMhSp64f4=;
        b=Q+2wwnbaGIkEkFTBzrqta4sg/OV3la8ceUhjQ26uUVso/pkfHloCXMTLKrLkSY8cTp
         c2cUSwJ3eCT4Dgg06Z4DHoYN4plHmtGOX7uX0lHe7uSXKCryYtcS2OmJdp0zmJkrN36+
         DqD/koWzpbA1fJE7XrCTPVilKBNJYokITso8GhA89ArZ9u9TzqADnVxF/IM+Mebx9ubt
         Ov5S7BcHschScsYqN44uJHG6/Tx/S4ihlJjWF/Pp9aN8BxV+rei/zuXzZsvCGn7jDtvM
         06ySmnO4+nE0uZXb1MPq3zWude+Cv6yMd/iMxISIs1RiKhOowP0WqNC23lBO5lLdHjPX
         Uc9g==
X-Gm-Message-State: APjAAAWEiPmp5xOKG1avsW6QVpAAfblqXNMtjantWAEt/D+ZuMFX8MpA
        /zA818gBjBAm+5x6dGD6CcHoPA==
X-Google-Smtp-Source: APXvYqwOmYt2H3dsv7c65Ko5xGAwk+kZmZLtGbEg7wHQGs3o5pZ8ABRKqIWl4ZBij7Y6Rf3gcDdAgg==
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr8808007wro.121.1557071564775;
        Sun, 05 May 2019 08:52:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c21sm13698507wme.36.2019.05.05.08.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 05 May 2019 08:52:44 -0700 (PDT)
Date:   Sun, 5 May 2019 17:52:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [net-next 14/15] net/mlx5: Add support for FW fatal reporter dump
Message-ID: <20190505155243.GG31501@nanopsycho.orion>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-15-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505003207.1353-15-saeedm@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 05, 2019 at 02:33:33AM CEST, saeedm@mellanox.com wrote:
>From: Moshe Shemesh <moshe@mellanox.com>
>
>Add support of dump callback for mlx5 FW fatal reporter.
>The FW fatal dump use cr-dump functionality to gather cr-space data for
>debug. The cr-dump uses vsc interface which is valid even if the FW
>command interface is not functional, which is the case in most FW fatal
>errors.
>The cr-dump is stored as a memory region snapshot to ease read by
>address.
>
>Command example and output:
>$ devlink health dump show pci/0000:82:00.0 reporter fw_fatal
>devlink_region_name: cr-space snapshot_id: 1
>
>$ devlink region read pci/0000:82:00.0/cr-space snapshot 1 address 983064 length 8
>00000000000f0018 e1 03 00 00 fb ae a9 3f
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>---
> .../net/ethernet/mellanox/mlx5/core/health.c  | 39 +++++++++++++++++++
> 1 file changed, 39 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>index e64f0e32cd67..5271c88ef64c 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
>@@ -547,9 +547,48 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
> 	return mlx5_health_care(dev);
> }
> 
>+static int
>+mlx5_fw_fatal_reporter_dump(struct devlink_health_reporter *reporter,
>+			    struct devlink_fmsg *fmsg, void *priv_ctx)
>+{
>+	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
>+	char crdump_region[20];
>+	u32 snapshot_id;
>+	int err;
>+
>+	if (!mlx5_core_is_pf(dev)) {
>+		mlx5_core_err(dev, "Only PF is permitted run FW fatal dump\n");
>+		return -EPERM;
>+	}
>+
>+	err = mlx5_crdump_collect(dev, crdump_region, &snapshot_id);
>+	if (err)
>+		return err;
>+
>+	if (priv_ctx) {
>+		struct mlx5_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
>+
>+		err = mlx5_fw_reporter_ctx_pairs_put(fmsg, fw_reporter_ctx);
>+		if (err)
>+			return err;
>+	}
>+
>+	err = devlink_fmsg_string_pair_put(fmsg, "devlink_region_name",
>+					   crdump_region);

Oh come on. You cannot be serious :/ Please do proper linkage to region
and snapshot in devlink core.



>+	if (err)
>+		return err;
>+
>+	err = devlink_fmsg_u32_pair_put(fmsg, "snapshot_id", snapshot_id);
>+	if (err)
>+		return err;
>+
>+	return 0;
>+}
>+
> static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
> 		.name = "fw_fatal",
> 		.recover = mlx5_fw_fatal_reporter_recover,
>+		.dump = mlx5_fw_fatal_reporter_dump,
> };
> 
> #define MLX5_REPORTER_FW_GRACEFUL_PERIOD 1200000
>-- 
>2.20.1
>
