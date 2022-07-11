Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD4657059E
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiGKOcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiGKOcB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:32:01 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73B363917
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:31:59 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id p4so3166678wms.0
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i2bXSjbDPCJQYolTV+M2y6+D6HQf1X9TZy5UHHpnxWo=;
        b=RmVvA3SCnjnN9yCOap61fG00dbv9gYw/k7/Im/FcavYSRdU4imWlsPKunXtbuaQdfs
         UF20SMi9Rre96AXH4SfhJ4NPBWbsHR63s2WVBEvTW0RG9OCZ/3rPX2Nn7Os+Jk55g2hF
         rsoyv64LT2pU7S3hJLuZ7Ps19LrWCK82nsCzszKiUA1ShWu5/hFXXYInRu6fOTy0BI2y
         DZZ2YTDInb5uSGL7HtCgSCI17+u4LiJbxOiQUr7fm41MuYOhgdTzrJH5hnoFCBTqK98z
         1gs8DLX/58HItfeyKN0r/s2sfkr5hdZ4Ln1Dd+1O3qHuLuJ0SPMnFbjGQzX29/kBTIzD
         Ajdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i2bXSjbDPCJQYolTV+M2y6+D6HQf1X9TZy5UHHpnxWo=;
        b=D84zA+DCglOIccekpst2ICu/Ax0aoyRqRc8dUiUmDzm7wbk5etrAeCdI2uPVhzPoXM
         2LjyaIzRX64Y18AdbmP1kNHxgnbeKQsnLc4AZNzcdU7XlzEob9LEAGFzqmZhctWf9Fhx
         oESxRYgqch8DHC8yW7/GrTPdIj7wDb2x6HhTP3lWPz3+QNmxB2jJxiIG2SERv3FevEWo
         r9VfOLcrrRlzb1aINpe+lvH2pfD0v76KPJaOYQOLaZYgNI69Ug/dxjcEKo4zumFNScfW
         H08zG9iG8g0vStJ/d8hmxJv3rc8MupJzUtcKF4iGlDxoP8Pfv+8nks0Zp/060XdeHaiO
         Bdcw==
X-Gm-Message-State: AJIora9p/aVGelP1sB5YRKojv0+SLNxTBM8H7bEnu9VCNuc1gFMbx5K1
        HV2B5YAqa4/6URPbR5d7OfG8DQFHj7iLSw4DHrY=
X-Google-Smtp-Source: AGRyM1vrrRaE2afab3U2yXh6wTzMU8j6j37D4D1xmgNlcQaRfbM9T/nly3s+cMH3tGy2lqcuypDwTA==
X-Received: by 2002:a7b:c385:0:b0:3a2:cfad:ea9c with SMTP id s5-20020a7bc385000000b003a2cfadea9cmr16239474wmj.136.1657549918432;
        Mon, 11 Jul 2022 07:31:58 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id b5-20020adfe305000000b0021d8c8c79dbsm5833082wrj.65.2022.07.11.07.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 07:31:57 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:31:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next v3/repost 0/3] net: devlink: devl_* cosmetic
 fixes
Message-ID: <Ysw0XA2NC3cGxWIY@nanopsycho>
References: <20220711132607.2654337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711132607.2654337-1-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub, this will probably conflict with Saeeds PR. Let me know and I
will rebase. Thanks!

Mon, Jul 11, 2022 at 03:26:04PM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>Hi. This patches just fixes some small cosmetic issues of devl_* related
>functions which I found on the way.
>
>Jiri Pirko (3):
>  net: devlink: fix unlocked vs locked functions descriptions
>  net: devlink: use helpers to work with devlink->lock mutex
>  net: devlink: move unlocked function prototypes alongside the locked
>    ones
>
> include/net/devlink.h |  16 ++-
> net/core/devlink.c    | 284 ++++++++++++++++++++++++------------------
> 2 files changed, 167 insertions(+), 133 deletions(-)
>
>-- 
>2.35.3
>
