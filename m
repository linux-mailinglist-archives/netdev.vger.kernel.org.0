Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A60D91DFD37
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 06:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725826AbgEXExl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 00:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgEXExk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 00:53:40 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0960EC061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 21:53:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c71so1882938wmd.5
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 21:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sODNdL7JuoyOSYIcTXON0bp71qc14zVW8/ihDegqJxw=;
        b=p+0MuonaM6xtRG+GBwn/iMIzjjC7bPWkLR6heyPfWBFz+zRckUwx1Of7cNlY1y2X6J
         TJDLimvzBaaXk+YM06nw3gG73x9JKimHjCUd0iTwG9Jyt8MIRYv/AkoSNuEw1yZNxjdh
         Pdw+lgLm0Q77+LXDFeETjUKcDTjX7UHKaBOs3P2jInD1zp9vKvL44SDcDMsgYxIv5kyC
         8wjY9/upD0vSdy2kLJlZMlvM4giEkq7CavQwC63PS90iHcKnVZcGIWimj4FDYFxbDo6p
         PuxOy2OSlYa8sPbeinB4O5rMfl1PtAlGSH+OGhStnU/TT9NsI5OE+AI4lYcmtM1x+X1G
         m0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sODNdL7JuoyOSYIcTXON0bp71qc14zVW8/ihDegqJxw=;
        b=VvrvRehSml2MQYcYxL9fkyvEKwEvhi+nc02f6pLf3wu3YN+3hDBjjpkWfeltBbvFDf
         AuzVv/EjPmMPNFlSB9UrKRYgiEIL73GW7NScKqiINKfsNwkn7j9PI3HhBpxhSMFa+4zL
         uWqUUE4oN6yRrPC5YkFxk+8KFalnPvyttKoWeqyQLsVPCzQpklPylzzLgk4zBul8bN56
         fvxU7Gx7MuBQA+531bSuz4WaEuqUilaXGSpOkPtIoY+qMVNvrAv/yFNuJJs9UB32ltlj
         1c7eb3eYZuxd/JS79jNR7MV1ryto4/7OirnHUKuxHghfMziXFzvE+JVhkJ6RBfzwXOzw
         2/dQ==
X-Gm-Message-State: AOAM530zz+zxOsao7VR1G18s3wuugMBpRT5u/WZmkzT+0KTUVQprUStr
        v12GvyWVsPIch5dKF5A5IsZ6Ew==
X-Google-Smtp-Source: ABdhPJxWnL5J6GxBpvdKrESyzJgkBRaFnvs2SK0Zy8/LgF66UxGYdN7P7zkx497+XKw31fvrlO2VNw==
X-Received: by 2002:a1c:1b96:: with SMTP id b144mr19472420wmb.6.1590296017721;
        Sat, 23 May 2020 21:53:37 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id n9sm13440296wrv.43.2020.05.23.21.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 21:53:37 -0700 (PDT)
Date:   Sun, 24 May 2020 06:53:35 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200524045335.GA22938@nanopsycho>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
>Add a new "allow_fw_live_reset" generic device bool parameter. When
>parameter is set, user is allowed to reset the firmware in real time.
>
>This parameter is employed to communicate user consent or dissent for
>the live reset to happen. A separate command triggers the actual live
>reset.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>---
>v2: Rename param name to "allow_fw_live_reset" from
>"enable_hot_fw_reset".
>Update documentation for the param in devlink-params.rst file.
>---
> Documentation/networking/devlink/devlink-params.rst | 6 ++++++
> include/net/devlink.h                               | 4 ++++
> net/core/devlink.c                                  | 5 +++++
> 3 files changed, 15 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>index d075fd0..ad54dfb 100644
>--- a/Documentation/networking/devlink/devlink-params.rst
>+++ b/Documentation/networking/devlink/devlink-params.rst
>@@ -108,3 +108,9 @@ own name.
>    * - ``region_snapshot_enable``
>      - Boolean
>      - Enable capture of ``devlink-region`` snapshots.
>+   * - ``allow_fw_live_reset``
>+     - Boolean
>+     - Firmware live reset allows users to reset the firmware in real time.
>+       For example, after firmware upgrade, this feature can immediately reset
>+       to run the new firmware without reloading the driver or rebooting the

This does not tell me anything about the reset being done on another
host. You need to emhasize that, in the name of the param too.



>+       system.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 8ffc1b5c..488b61c 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
> 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
>+	DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
> #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
> 
>+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
>+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 7b76e5f..8544f23 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>+		.name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>1.8.3.1
>
