Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3346E569
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhLIJZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhLIJZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:25:26 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74FAC0617A1
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 01:21:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d24so8638081wra.0
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 01:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=St6fDpRWrbOPyw4DfGpCPD6GxfBlr4YguXkOcg68dNg=;
        b=o+9UvLDbQOEPRilcKb/qH4X6eZuq738oiVOQMO6XUUab+xFmKbH54Bm6xchb3APmyP
         HRjNqCG4XGX7q06CHARzf09/VLjxkjE0dVUqspqnlyMhGI8Rt1qGu6i0pETRhUz8ct4X
         nxLVaF2TxPA+IiQF9TLxc9ukca6aN0oofW6k3ZI6zdRbyo5lZYBMJjP3oft12jG/WFXP
         lZ0DqKVPP9ATaFHJ9V9OL61sSwZccfHK9WcJ1PjNu0qPjY1G61HQNU99/uCFdWYXFyHk
         FF7Iq1jh+VpHts7SoAiuaNm1C0WKKIuayPmAKbGCXMP5g/DV63ZIX7BBhl9VTYdkl/f6
         IFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=St6fDpRWrbOPyw4DfGpCPD6GxfBlr4YguXkOcg68dNg=;
        b=5FREuZtrznYLlRCrWKJYZR3Br60GvrxmjnJ292mpJsmb4u2bhuP/tg5aLxcKT3yLab
         Zhch55iQf17SEwAVti1h+efix5GLU6SOKpPPsR0tQLeNuv9Mu6147awsZBB0JDf1iufE
         ZERQIMIx/iOEZnaXmSxeu7ez6Y/F6DxdqmpBo8LX0TP0hnV3EHP4bGaWvmqxK0SobBuL
         ZsoHistmzR0jujFavLmuXx7HrbWydt+r5dOSkSnTOwyFcTjLZtsh0N8shlYl13jGR1Tn
         Y1cn0eGz5yNFQyT+r42RVhDsFITyI725gGsu81/iuOq3wcBoWrgHO4nuNzfn0b7vrQWV
         8lTg==
X-Gm-Message-State: AOAM5318gB6fr9LLHjFI+RvkzqOGxoqk7DUYEK5iX8SWgIUrxsmGJXZs
        h6yBgWwmD3UXFElLojRtkLMsjw==
X-Google-Smtp-Source: ABdhPJzNPpjoCVeIxBCP3phySICTw/Bf+6f+5JOTYxO6sV45jLHPz+AS+EAk+UCD2n8BFWxIM0PA4g==
X-Received: by 2002:adf:df85:: with SMTP id z5mr4982298wrl.445.1639041711374;
        Thu, 09 Dec 2021 01:21:51 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id w17sm5034369wmc.14.2021.12.09.01.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 01:21:50 -0800 (PST)
Date:   Thu, 9 Dec 2021 10:21:50 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Shay Drory <shayd@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com,
        saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next v3 2/7] devlink: Add new "io_eq_size" generic
 device param
Message-ID: <YbHKrpDiuuXHttQg@nanopsycho>
References: <20211208141722.13646-1-shayd@nvidia.com>
 <20211208141722.13646-3-shayd@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208141722.13646-3-shayd@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 08, 2021 at 03:17:17PM CET, shayd@nvidia.com wrote:
>Add new device generic parameter to determine the size of the
>I/O completion EQs.
>
>For example, to reduce I/O EQ size to 64, execute:
>$ devlink dev param set pci/0000:06:00.0 \
>              name io_eq_size value 64 cmode driverinit
>$ devlink dev reload pci/0000:06:00.0
>
>Signed-off-by: Shay Drory <shayd@nvidia.com>
>Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
>---
> Documentation/networking/devlink/devlink-params.rst | 3 +++
> include/net/devlink.h                               | 4 ++++
> net/core/devlink.c                                  | 5 +++++
> 3 files changed, 12 insertions(+)
>
>diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>index b7dfe693a332..cd9342305a13 100644
>--- a/Documentation/networking/devlink/devlink-params.rst
>+++ b/Documentation/networking/devlink/devlink-params.rst
>@@ -129,3 +129,6 @@ own name.
>        will NACK any attempt of other host to reset the device. This parameter
>        is useful for setups where a device is shared by different hosts, such
>        as multi-host setup.
>+   * - ``io_eq_size``
>+     - u16

You missed this.


>+     - Control the size of I/O completion EQs.
>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 3276a29f2b81..b5f4acd0e0cd 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -459,6 +459,7 @@ enum devlink_param_generic_id {
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
> 	DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
>+	DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
> 
> 	/* add new param generic ids above here*/
> 	__DEVLINK_PARAM_GENERIC_ID_MAX,
>@@ -511,6 +512,9 @@ enum devlink_param_generic_id {
> #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME "enable_iwarp"
> #define DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE DEVLINK_PARAM_TYPE_BOOL
> 
>+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME "io_eq_size"
>+#define DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE DEVLINK_PARAM_TYPE_U32
>+
> #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)	\
> {									\
> 	.id = DEVLINK_PARAM_GENERIC_ID_##_id,				\
>diff --git a/net/core/devlink.c b/net/core/devlink.c
>index db3b52110cf2..0d4e63d11585 100644
>--- a/net/core/devlink.c
>+++ b/net/core/devlink.c
>@@ -4466,6 +4466,11 @@ static const struct devlink_param devlink_param_generic[] = {
> 		.name = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_NAME,
> 		.type = DEVLINK_PARAM_GENERIC_ENABLE_IWARP_TYPE,
> 	},
>+	{
>+		.id = DEVLINK_PARAM_GENERIC_ID_IO_EQ_SIZE,
>+		.name = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_NAME,
>+		.type = DEVLINK_PARAM_GENERIC_IO_EQ_SIZE_TYPE,
>+	},
> };
> 
> static int devlink_param_generic_verify(const struct devlink_param *param)
>-- 
>2.21.3
>
