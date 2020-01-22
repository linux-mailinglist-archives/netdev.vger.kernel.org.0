Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0358B1456CC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgAVNcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 08:32:23 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37039 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgAVNcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 08:32:23 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so7308552wru.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 05:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aaWVZMCIJKWa6lBIJez05M0WjFsygSYckYuyMqMHqQ4=;
        b=AqcUega1/oZozOZQFjGP5CasGxk4Z9iR5XETWK+sSb/rdLf/K0Dv8vr1sg9diPb5iE
         9r6/JlWfY2qRIlz18vJjoPNEsnAhEmnzTw2Xfhr/EFGnzHEAqzK+BvGKjNmyh32DrHDO
         GJJKGnLlndd4hNZH1M/oXd4fQ6hJom6nOm23aIjjttX7kh4FM9rLxSaxpm/F9EF7KRYH
         DH6iulTyd1HjhMKc2ENwukwApYdfsIk0h18w+nEuPTJmptdM2r01dLSJtigIVTVXt7yA
         ZUymzldzXNrCzBAApmekWTmasd8/TqJ8q+22yfC3a4rEkRS97oYuinmiB2+3YRhSmeOI
         5YbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aaWVZMCIJKWa6lBIJez05M0WjFsygSYckYuyMqMHqQ4=;
        b=QlPizjBsBREKaGfG2kPenPvIb8c04M8erSktu1B+OxauCJqTUb38qOu1dFrYrVHlcH
         UjBiXHTvseJnGflGttlVjvSVUHJnqVUSzCKrx71wbzHdA57dFmuLPicGdgUpGIbyTuOG
         vX8eKR7GxnLuncBNMXc6GJ//uLMoExLqrGQAnR8ThumMneZKvjwKbL8FUtvboMylQCMd
         psP4p0e93ihf2JKuCW/RKS/uUMc473dcUd4Ve1zQdKSD2aFSh9U3v9KVq1RQ5ClNztmG
         IYRkfA2VvUm0Nodc3sUVKcGiCWUxKsVR7QugpqH5GeW9fsEi+i2JOMjIDOygyt546ri5
         TWMQ==
X-Gm-Message-State: APjAAAVwHqfcgEqZFm0UNIYzKCdgz46Dd4/X2ebRjucc1dwA6b3ftrzg
        DGdgfELGGXCBqmfH1lJJ9/3YIw==
X-Google-Smtp-Source: APXvYqxFJvC06ZIyFwffm+9Tqd9tCZfq0XG35ggTr1+SBc0V6PIkbiepLwRGDFCGPSQpMOYwU4K7dA==
X-Received: by 2002:adf:f5cf:: with SMTP id k15mr11705979wrp.182.1579699940986;
        Wed, 22 Jan 2020 05:32:20 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id c195sm4569458wmd.45.2020.01.22.05.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:32:20 -0800 (PST)
Date:   Wed, 22 Jan 2020 14:32:19 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     davem@davemloft.net, michael.chan@broadcom.com,
        vasundhara-v.volam@broadcom.com, netdev@vger.kernel.org,
        jiri@mellanox.com
Subject: Re: [PATCH] devlink: Add enable_ecn boolean generic parameter
Message-ID: <20200122133219.GA2196@nanopsycho>
References: <1579689646-13123-1-git-send-email-pavan.chebbi@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579689646-13123-1-git-send-email-pavan.chebbi@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 22, 2020 at 11:40:46AM CET, pavan.chebbi@broadcom.com wrote:
>enable_ecn - Enables Explicit Congestion Notification
>characteristic of the device.
>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>

NAK.

You are missing at least:
documentation
driver user


>---
> include/net/devlink.h | 4 ++++
> net/core/devlink.c    | 5 +++++
> 2 files changed, 9 insertions(+)
>
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 5e46c24..52315dd 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -403,6 +403,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
> 	DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
>+	DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -440,6 +441,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
> #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
> 
>+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_NAME "enable_ecn"
>+#define DEVLINK_PARAM_GENERIC_ENABLE_ECN_TYPE DEVLINK_PARAM_TYPE_BOOL
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index 64367ee..298dcd1 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> 		.name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_ENABLE_ECN,
>+		.name = DEVLINK_PARAM_GENERIC_ENABLE_ECN_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_ENABLE_ECN_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>1.8.3.1
>
