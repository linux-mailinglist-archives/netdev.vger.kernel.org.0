Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4203D37C4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 11:33:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbhGWIxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhGWIxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:53:07 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DA1C061575
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:33:40 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id o5-20020a1c4d050000b02901fc3a62af78so3110285wmh.3
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 02:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wNO/xufjm/ydO0nEAzAdC1TVpL4USaiY16dhslOWRMU=;
        b=q3AvKTf7zNfzeLb2JY4UUrPHviGUcd4UnjJWnM4hWtlHN5z3AMm6PedCcyaYxo+wQJ
         RE2iZZMelc63WocDKmgocjer9y11/TGzakrS3GiddltRkmjRVvgoORx83Hm1cqFT0t/X
         Lg3VhErnb2UyGfb2lu+Wnu/NACon2YLJCuMlrQcQPkng18lZTLtyyPQpVdCIYXIN9Bgh
         Q1VJU4Dh7YQPULE9IBqNFxpBi2Gp3NoCRukj6ss8fZGPPPf5dEpOXz0rRQyDe60R5RXN
         SYvebtv+ZG7hgGAxiZyjVpNAoXf4Xtd5e9eQHFT38+rB4maC3w+BSlytWaE/pGm1o37T
         H91Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wNO/xufjm/ydO0nEAzAdC1TVpL4USaiY16dhslOWRMU=;
        b=kze8FdZhwJd/33JNIxzn9zcuds9G/41gmua9d0T5RPoRiKEwkk3YgUG/78BP+6Ca4n
         wpvnQCqRBzjmdpeBYgdJfu/vXg3Qg6wcGJfYgdw7QOqaeuoB1W0D4YvnEokZd782UAJP
         OrftO9F6Vl4zsX07NaagJOflTWFQzFMbttxS36OcVM/KhV6INc0hCONgRKqD/UKTf70a
         D4AEm3fIhr/CGsgi5j5oNidZgXySnJ+M+/zoE9uTQHRs8/LnMyOmtV6kRyuJ5dXz7Cun
         Whwgy33bDmKpQPaDEvmeo45j6B6I6JdJ3BV3p8kXe/0bqpe1wso2SsUi6Usz8lh+IqLL
         8Ynw==
X-Gm-Message-State: AOAM531AXiCyrtLFboOSfbNS/Ae5D2O/+CLpi4Y/qCGHC/TSd07U9vdz
        2xxjYGdDFH+HySzTD3m9k4YRxg==
X-Google-Smtp-Source: ABdhPJycn4YG4c32IaWIGbh4txpacWjLJEZVCvv0tODqTOl/CD0MKomcIPFB1PG/5Jn6whiAkZEkeg==
X-Received: by 2002:a05:600c:1c9f:: with SMTP id k31mr13458225wms.47.1627032818619;
        Fri, 23 Jul 2021 02:33:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id o7sm37724787wrv.72.2021.07.23.02.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 02:33:37 -0700 (PDT)
Date:   Fri, 23 Jul 2021 11:33:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com
Subject: Re: [patch net-next v2] devlink: append split port number to the
 port name
Message-ID: <YPqM8HUUsl1n0RKD@nanopsycho>
References: <20210527104819.789840-1-jiri@resnulli.us>
 <162215100360.12583.10419235646821072826.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162215100360.12583.10419235646821072826.git-patchwork-notify@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 27, 2021 at 11:30:03PM CEST, patchwork-bot+netdevbpf@kernel.org wrote:
>Hello:
>
>This patch was applied to netdev/net-next.git (refs/heads/master):
>
>On Thu, 27 May 2021 12:48:19 +0200 you wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Instead of doing sprintf twice in case the port is split or not, append
>> the split port suffix in case the port is split.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> 
>> [...]
>
>Here is the summary with links:
>  - [net-next,v2] devlink: append split port number to the port name
>    https://git.kernel.org/netdev/net-next/c/f285f37cb1e6
>
>You are awesome, thank you!

Something wrong happened. The patch was applied but eventually, the
removed lines are back:

acf1ee44ca5da (Parav Pandit    2020-03-03 08:12:42 -0600 9331)  case DEVLINK_PORT_FLAVOUR_VIRTUAL:
f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9332)          n = snprintf(name, len, "p%u", attrs->phys.port_number);
f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9333)          if (n < len && attrs->split)
f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9334)                  n += snprintf(name + n, len - n, "s%u",
f285f37cb1e6b (Jiri Pirko      2021-05-27 12:48:19 +0200 9335)                                attrs->phys.split_subport_number);
08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9336)          if (!attrs->split)
378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9337)                  n = snprintf(name, len, "p%u", attrs->phys.port_number);
08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9338)          else
378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9339)                  n = snprintf(name, len, "p%us%u",
378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9340)                               attrs->phys.port_number,
378ef01b5f75e (Parav Pandit    2019-07-08 23:17:35 -0500 9341)                               attrs->phys.split_subport_number);
126285651b7f9 (David S. Miller 2021-06-07 13:01:52 -0700 9342) 
08474c1a9df0c (Jiri Pirko      2018-05-18 09:29:02 +0200 9343)          break;

If I do "git reset --hard f285f37cb1e6b", everything is looking fine,
in the current net-next, the removed lines are still present :O
I see ghosts...

Could you check & fix?
