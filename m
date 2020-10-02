Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABD281667
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 17:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388226AbgJBPTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 11:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBPTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 11:19:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB265C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 08:19:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w5so2232750wrp.8
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 08:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LKNths/LPQbAs0cdB5bW5xnTf55TpFYTO0PPt8yn7hM=;
        b=HmtgrxraewM+QiIP5fF3kDfxH+EmFXsFA+9vQWpXPUnmkEM0HtsW9+VTFWmAcdO9ND
         G/KAiTsCOQ9nGgYR5+kgU8dxn8FQ3yYel6OyOHGVrKcQksJew5YNQ5fSMG4d0GYguB2P
         /PUnEHPYURpy7YGupOiGQvkHX4wQGcD4OLb42VLLXZNeiK5o4rOzcVRFLlUIZDhtvupk
         pVAJICVVwgTSRqIiqqZg4YqdjditXgjaRtxhsfpuMYtb2cncgSUQinPd7BvCyqfn1dEI
         op56BMgRzIfTXJfwwoPBJJVNbW/qtXmvlozQNgt1CrR3al8yECelmI9/GxOvY4yKEXpH
         FFPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LKNths/LPQbAs0cdB5bW5xnTf55TpFYTO0PPt8yn7hM=;
        b=n4O8LpAlhlZkkeiaFM7Mszn3E8/MSuQlZyDIpRSJzz58w+T5k5M0mN3LJxWJkGCOgl
         Q6zQ8PNS+Qt3JMztA+6Zpq9//IE/Oixvn4Xz/ceL8wlEMbdO+w+cqFQk+7Wh5jPmnMdY
         xRikX8N7G+ZBLYFoTU9U4yeZozkoda4LRMh4j291+WxrM0atn2nVkLrUCjQeL6LHjRxs
         Td2Kw0oGGFM10Q14giy+DeMKnyTd6qU97FZSUcGrQfdsb2p3LTib8c8sDANoKwr62Ahs
         Q1PxSB2PdKgqcmVVg8nMhPuTJnw1yhMrZ6LN7gXgvs5zt2EaDrCKGhcI/PBOWoStN8c/
         ndsw==
X-Gm-Message-State: AOAM530FEJp8oNwku87lRZXlX8tDRi+fZii4H2qGnu6RaxPoPLp8+Cth
        ZSQ6nx6AKZAS+G4ST7FT+HQm3w==
X-Google-Smtp-Source: ABdhPJx3IBbQHwBSSzG6L4x/26S6UraQ0pRj1kDGMlBA3/UoTNvnCSqve7suFeszzrKl5zrRYzxPtQ==
X-Received: by 2002:adf:dcc7:: with SMTP id x7mr3722324wrm.203.1601651984611;
        Fri, 02 Oct 2020 08:19:44 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id y6sm2080079wrn.41.2020.10.02.08.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 08:19:44 -0700 (PDT)
Date:   Fri, 2 Oct 2020 17:19:43 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 02/16] devlink: Add reload action option to
 devlink reload command
Message-ID: <20201002151943.GB3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-3-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-3-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:05PM CEST, moshe@mellanox.com wrote:

[...]


>diff --git a/include/net/devlink.h b/include/net/devlink.h
>index 1c286e9a3590..ddba63bce7ad 100644
>--- a/include/net/devlink.h
>+++ b/include/net/devlink.h
>@@ -1077,10 +1077,11 @@ struct devlink_ops {
> 	 * implemementation.
> 	 */
> 	u32 supported_flash_update_params;
>+	unsigned long reload_actions;
> 	int (*reload_down)(struct devlink *devlink, bool netns_change,
>-			   struct netlink_ext_ack *extack);
>-	int (*reload_up)(struct devlink *devlink,
>-			 struct netlink_ext_ack *extack);
>+			   enum devlink_reload_action action, struct netlink_ext_ack *extack);
>+	int (*reload_up)(struct devlink *devlink, enum devlink_reload_action action,
>+			 struct netlink_ext_ack *extack, unsigned long *actions_performed);

Nit. Could you please push extack to be the last arg here? It is common
to have extack as the last arg + action and actions_performed are going
to be side by side.

Otherwise the patch looks fine.
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
