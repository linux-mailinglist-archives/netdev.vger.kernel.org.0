Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB80149A68
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 12:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgAZLcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 06:32:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44643 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZLcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 06:32:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id q10so7487861wrm.11
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 03:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GXKyIYmr4EQGB5WXC/HimGvE2YHHdahIQYU0nsd1dZA=;
        b=wmViJQ/ttIMyQSKfWV7I0f80PXp9QoZDVA07ixf2yt531k1ab5iokmRUhO+gX7gfeh
         SG2xT8743wK9mhwA9UGryybGTSQoF3ReRpaFhDBeyeDcgTydGx0BSgrtk4VWAau3scP0
         8ucM4xZV0sG6vQWpojCFY037wLoVl2UlzPny6ebPBo0bvJLyPsKv3Euaoq9alYC8U7dV
         a73wKZJ+Ik6DQTYr+5Kpc412Cr9UIbAM594wCyZG0uZJ+l9zdxitbwV6XO42XqYfFmca
         K8cFbePz6x5ICla8XIcZO3PKv83IS59B1sD0g/v2KSQq/m2d0w1O3mcOza5cBjvz4FTa
         2/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GXKyIYmr4EQGB5WXC/HimGvE2YHHdahIQYU0nsd1dZA=;
        b=RUm0Qc7DvDqhubV+Wax+A4e1kUoErnU8/zUjR84ovIHN9L1VyMihlRdzyKyStJcQBY
         lgqNO98cqpuGxUjiXcKGvtYO0MeEAXz5ZpNpk494ORbHnQ5z0eXPbn9GlZai4bEfHRq8
         aFLqJA14oRrc/lUITWQLXxgZx6X93Lzklop8sceT6Q9Yt+YF/yrFfZggg62LJfrkOItP
         xzDcIdEMb+0IIsIFfzDeaSe5XoZ0uMEOde/LVkDW1JAcfEdO7gwM0QJIoiH+E0K/cl2N
         d4cLZphYwMvdHE5rRftXLQQQ1oEXulDyLwiil5X+h8mPQT7XKAgtZL2tzuUrP3JcHFVq
         RN/g==
X-Gm-Message-State: APjAAAWSAkLX/GsZhr0X5ljvXBjKUlPyBW6zzL6uXJ8hlpcRziPlvBkQ
        uAzjhv6xjTM7OgsdHQOaZgwoTw==
X-Google-Smtp-Source: APXvYqwWwOU2/LK4Bfnn1Qs6J5JYm2NkyfX6v2/05VbK1lmZbFdH+whcfRtwBBsyaZubMqYxVZUSPA==
X-Received: by 2002:adf:b648:: with SMTP id i8mr14838275wre.91.1580038340888;
        Sun, 26 Jan 2020 03:32:20 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n28sm16049765wra.48.2020.01.26.03.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 03:32:20 -0800 (PST)
Date:   Sun, 26 Jan 2020 12:32:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next 09/16] bnxt_en: Refactor bnxt_dl_register()
Message-ID: <20200126113219.GI2254@nanopsycho.orion>
References: <1580029390-32760-1-git-send-email-michael.chan@broadcom.com>
 <1580029390-32760-10-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580029390-32760-10-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jan 26, 2020 at 10:03:03AM CET, michael.chan@broadcom.com wrote:
>From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>
>Define bnxt_dl_params_register() and bnxt_dl_params_unregister()
>functions and move params register/unregister code to these newly
>defined functions. This patch is in preparation to register
>devlink irrespective of firmware spec. version in the next patch.
>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>---
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 60 ++++++++++++++---------
> 1 file changed, 36 insertions(+), 24 deletions(-)
>
>diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>index 0c3d224..9253eed 100644
>--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>@@ -485,6 +485,38 @@ static const struct devlink_param bnxt_dl_params[] = {
> static const struct devlink_param bnxt_dl_port_params[] = {
> };
> 
>+static int bnxt_dl_params_register(struct bnxt *bp)
>+{
>+	int rc;
>+
>+	rc = devlink_params_register(bp->dl, bnxt_dl_params,
>+				     ARRAY_SIZE(bnxt_dl_params));
>+	if (rc) {
>+		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
>+			    rc);
>+		return rc;
>+	}
>+	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
>+					  ARRAY_SIZE(bnxt_dl_port_params));

Wait, this assumes that you have 1:1 devlink:devlink_port setup. Is that
correct? Don't you have other devlink_ports for eswitch representors
that have params?
 

>+	if (rc) {
>+		netdev_err(bp->dev, "devlink_port_params_register failed");
>+		devlink_params_unregister(bp->dl, bnxt_dl_params,
>+					  ARRAY_SIZE(bnxt_dl_params));
>+		return rc;
>+	}
>+	devlink_params_publish(bp->dl);
>+
>+	return 0;
>+}
>+
>+static void bnxt_dl_params_unregister(struct bnxt *bp)
>+{
>+	devlink_params_unregister(bp->dl, bnxt_dl_params,
>+				  ARRAY_SIZE(bnxt_dl_params));
>+	devlink_port_params_unregister(&bp->dl_port, bnxt_dl_port_params,
>+				       ARRAY_SIZE(bnxt_dl_port_params));
>+}
>+
> int bnxt_dl_register(struct bnxt *bp)
> {
> 	struct devlink *dl;
>@@ -520,40 +552,24 @@ int bnxt_dl_register(struct bnxt *bp)
> 	if (!BNXT_PF(bp))
> 		return 0;
> 
>-	rc = devlink_params_register(dl, bnxt_dl_params,
>-				     ARRAY_SIZE(bnxt_dl_params));
>-	if (rc) {
>-		netdev_warn(bp->dev, "devlink_params_register failed. rc=%d",
>-			    rc);
>-		goto err_dl_unreg;
>-	}
>-
> 	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
> 			       bp->pf.port_id, false, 0,
> 			       bp->switch_id, sizeof(bp->switch_id));
> 	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
> 	if (rc) {
> 		netdev_err(bp->dev, "devlink_port_register failed");
>-		goto err_dl_param_unreg;
>+		goto err_dl_unreg;
> 	}
> 	devlink_port_type_eth_set(&bp->dl_port, bp->dev);
> 
>-	rc = devlink_port_params_register(&bp->dl_port, bnxt_dl_port_params,
>-					  ARRAY_SIZE(bnxt_dl_port_params));
>-	if (rc) {
>-		netdev_err(bp->dev, "devlink_port_params_register failed");
>+	rc = bnxt_dl_params_register(bp);
>+	if (rc)
> 		goto err_dl_port_unreg;
>-	}
>-
>-	devlink_params_publish(dl);
> 
> 	return 0;
> 
> err_dl_port_unreg:
> 	devlink_port_unregister(&bp->dl_port);
>-err_dl_param_unreg:
>-	devlink_params_unregister(dl, bnxt_dl_params,
>-				  ARRAY_SIZE(bnxt_dl_params));
> err_dl_unreg:
> 	devlink_unregister(dl);
> err_dl_free:
>@@ -570,12 +586,8 @@ void bnxt_dl_unregister(struct bnxt *bp)
> 		return;
> 
> 	if (BNXT_PF(bp)) {
>-		devlink_port_params_unregister(&bp->dl_port,
>-					       bnxt_dl_port_params,
>-					       ARRAY_SIZE(bnxt_dl_port_params));
>+		bnxt_dl_params_unregister(bp);
> 		devlink_port_unregister(&bp->dl_port);
>-		devlink_params_unregister(dl, bnxt_dl_params,
>-					  ARRAY_SIZE(bnxt_dl_params));
> 	}
> 	devlink_unregister(dl);
> 	devlink_free(dl);
>-- 
>2.5.1
>
