Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354512862FD
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgJGQCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgJGQCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:02:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598C3C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 09:02:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d3so2979195wma.4
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 09:02:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c+qu2p5G8BrkuES5RNsE8tqXhcZ9P1cBpxl6wwrb658=;
        b=AN0kvfw6vjQ/xf8qVvgSneIvf64UvUcIPMnSoX/UZin+GOgkWJUZmM/J9cT7wqG48p
         97+DkF+lsLzXY08L5pO6ukFQVxVgOxKrj3maEw2EE6uM8SRXyjY+rRZhJwj4qxBcuE2T
         R+OrhBSuLSz3tx2KuTOoyTeDmcyEPv5+CAXefGDKYoBQbniQftqrENGWhBNXeivZtF2Y
         nUCYieRv8axTO9IeC4A2eDckuHqLwVOs44E2vqm9LAamg/bJXPORnDHqXJcJDNuSPJte
         wZ6G5TKdw8umeHlH9EfrY4pIqYAg6QQo9fEIsWSpaYhW9UuJHYsnQ+rIAGaAVekpZEg+
         SBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c+qu2p5G8BrkuES5RNsE8tqXhcZ9P1cBpxl6wwrb658=;
        b=SO2Z61Pkah4HhcjUzCark2NXDB6UTNmQmbIPbDVlJg476phIcBSNrjcKHY12Pi++bH
         HgGm6F4lG7iO5OAGkrA9PHj7s/1sSz7UuQ5YVWBv6/R+E5VMkzI7hhxmX/nXO1IfHKIv
         CDLPkQgxnxAnyu014I6YSAkNb0ZXg7ude+1/ibWUFFP+1Y/LxFylzzYtAfDxhC3g/IP9
         +k0Fx/cnlopwFNB/L1vvwAzwQLSRQbQ5uRK+C7wRYd78HhS1PlVf4xozb7smnTQZ5Qrv
         lMCcLdtBmsvMCWixX66AQDcEpuQgtuje+KC6fAWSKmsEAzG+mH3J6mUqaLfg99/SRQUT
         YcCw==
X-Gm-Message-State: AOAM530QFsL32W8lkRbNmdeq7Zcn63tlal8gEKTJiAgyBnfTxh1R0wz+
        I0Ozc8mkupI5eq4Zb8sPTnZFuA==
X-Google-Smtp-Source: ABdhPJwGNc59SEUCyrGDoHpukjGVfvlMb5fxa+XJbTVpk9Z5lA153Sx6JCKNYc67aq/6VMX73/OZKg==
X-Received: by 2002:a1c:6488:: with SMTP id y130mr3978568wmb.94.1602086521044;
        Wed, 07 Oct 2020 09:02:01 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id j13sm3520769wru.86.2020.10.07.09.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 09:02:00 -0700 (PDT)
Date:   Wed, 7 Oct 2020 18:01:59 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 05/16] devlink: Add remote reload stats
Message-ID: <20201007160159.GD3064@nanopsycho>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
 <1602050457-21700-6-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602050457-21700-6-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 07, 2020 at 08:00:46AM CEST, moshe@mellanox.com wrote:
>Add remote reload stats to hold the history of actions performed due
>devlink reload commands initiated by remote host. For example, in case
>firmware activation with reset finished successfully but was initiated
>by remote host.
>
>The function devlink_remote_reload_actions_performed() is exported to
>enable drivers update on remote reload actions performed as it was not
>initiated by their own devlink instance.
>
>Expose devlink remote reload stats to the user through devlink dev get
>command.
>
>Examples:
>$ devlink dev show
>pci/0000:82:00.0:
>  stats:
>      reload:
>        driver_reinit 2 fw_activate 1 fw_activate_no_reset 0
>      remote_reload:
>        driver_reinit 0 fw_activate 0 fw_activate_no_reset 0
>pci/0000:82:00.1:
>  stats:
>      reload:
>        driver_reinit 1 fw_activate 0 fw_activate_no_reset 0
>      remote_reload:
>        driver_reinit 1 fw_activate 1 fw_activate_no_reset 0
>
>$ devlink dev show -jp
>{
>    "dev": {
>        "pci/0000:82:00.0": {
>            "stats": {
>                "reload": {
>                    "driver_reinit": 2,
>                    "fw_activate": 1,
>                    "fw_activate_no_reset": 0
>                },
>                "remote_reload": {
>                    "driver_reinit": 0,
>                    "fw_activate": 0,
>                    "fw_activate_no_reset": 0
>                }
>            }
>        },
>        "pci/0000:82:00.1": {
>            "stats": {
>                "reload": {
>                    "driver_reinit": 1,
>                    "fw_activate": 0,
>                    "fw_activate_no_reset": 0
>                },
>                "remote_reload": {
>                    "driver_reinit": 1,
>                    "fw_activate": 1,
>                    "fw_activate_no_reset": 0
>                }
>            }
>        }
>    }
>}
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
