Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0302577B2
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 12:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHaKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 06:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbgHaKt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 06:49:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0659C061575
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:49:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id a65so4911795wme.5
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 03:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PeH1EcKk6Qz2A88oCy9yT1i+SGRWmbrUQhTOvvCNIN8=;
        b=fX17MzbPIkihQR85M6C+eiSxtNq3iRYd5trtcc6sIQL99rOfypNIH1GIEqOQJqWUdb
         wNG+YfY/79ZRrn9s3z6aKxvKJ34qC/tx7Lc9OKH3l9cV31qv2jR7RwgU4vnTpl1qpwvP
         GVsIqfXkc8rGixK66t9RdJFLVq0pg8EP+RiDjqQbccxkN5LmWOkX6DISkXn2k+tM9Ck5
         qX/QKm9zxgtzdX8B+m8neFEFonpY+2z6yoHz0eNgnyGAlY1YJ5Y3zB6Su1YXGIGVOFhL
         zfEacxqQSYHcDtWjUpAjG8N8x/YWDFpfeLC/OBlB3lml/iV/ejUpclNmLKrlIfExDA3s
         VgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PeH1EcKk6Qz2A88oCy9yT1i+SGRWmbrUQhTOvvCNIN8=;
        b=qgvW1UJ95MsnIgmcx7OeE8spFTcd4f6WBDJmq2DItorJJqBM3gwrl1Bjf+CwCa2cfz
         T3fy8l7RomZWTVUCMNvRexSOTWX0KNbjPmdLzf6uVqUhj0yEhgd9AwSSt8RSkIjTaBKk
         Vc8qre4BqUzX1XC76BdX9u49uN1kJJ4gkA2Bx35qRWMKM3I8uRaqRCSAXmUoq+2Uztfa
         tC3krS0fJv9WOdpeARA4TiOXzB8kfq2V+CGKS6knovS3NYafIsP4olo4aEVe8A9nFFXC
         SZNSPqyD2spFpBdcP/LIM/Xlrb64o6sQSXfHWaR4jrBJ+S7cNnvZTmKJ/Ogc/G9s9e70
         0xvQ==
X-Gm-Message-State: AOAM533aExnKoxhzkvmekPA/6wS5AxqvmoH2DbPy1GW7BoZ0lIV+E1mN
        aAlys+GVqXwUhBowi0kL6ETlug==
X-Google-Smtp-Source: ABdhPJwwZR1PXhPlx6ZkBCP4j5SAPMUSqeHZ0reLXmGL4KM7jTlK7WHOdkNUDlExPzfUxOmRs4dG7g==
X-Received: by 2002:a1c:9c0b:: with SMTP id f11mr831020wme.0.1598870997347;
        Mon, 31 Aug 2020 03:49:57 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id f126sm2956411wmf.13.2020.08.31.03.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2020 03:49:56 -0700 (PDT)
Date:   Mon, 31 Aug 2020 12:49:56 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 00/14] Add devlink reload action option
Message-ID: <20200831104956.GC3794@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Aug 30, 2020 at 05:27:20PM CEST, moshe@mellanox.com wrote:
>Introduce new option on devlink reload API to enable the user to select the
>reload action required. Complete support for all actions in mlx5.
>The following reload actions are supported:
>  driver_reinit: driver entities re-initialization, applying devlink-param
>                 and devlink-resource values.
>  fw_activate: firmware activate.
>  fw_activate_no_reset: Activate new firmware image without any reset.
>                        (also known as: firmware live patching).
>
>Each driver which support this command should expose the reload actions
>supported.
>The uAPI is backward compatible, if the reload action option is omitted
>from the reload command, the driver reinit action will be used.
>Note that when required to do firmware activation some drivers may need
>to reload the driver. On the other hand some drivers may need to reset
>the firmware to reinitialize the driver entities. Therefore, the devlink
>reload command returns the actions which were actually done.
>
>Add reload actions counters to hold the history per reload action type.
>For example, the number of times fw_activate has been done on this
>device since the driver module was added or if the firmware activation
>was done with or without reset.
>
>Patch 1 adds the new API reload action option to devlink.
>Patch 2 adds reload actions counters.
>Patch 3 exposes the reload actions counters on devlink dev get.
>Patches 4-9 add support on mlx5 for devlink reload action fw_activate
>            and handle the firmware reset events.
>Patches 10-11 add devlink enable remote dev reset parameter and use it
>             in mlx5.
>Patches 12-13 mlx5 add devlink reload action fw_activate_no_reset support
>              and event handling.
>Patch 14 adds documentation file devlink-reload.rst 
>
>command examples:
>$devlink dev reload pci/0000:82:00.0 action driver_reinit
>reload_actions_done:
>  driver_reinit
>
>$devlink dev reload pci/0000:82:00.0 action fw_activate
>reload_actions_done:
>  driver_reinit fw_activate
>
>$ devlink dev reload pci/0000:82:00.0 action fw_activate no_reset

You are missing "_".


>reload_actions_done:

No need to have "reload" word here. And maybe "performed" would be
better than "done". Idk:
"actions_performed"
?


>  fw_activate_no_reset
>
>v2 -> v3:
>- Replace fw_live_patch action by fw_activate_no_reset
>- Devlink reload returns the actions done over netlink reply
>- Add reload actions counters
>
>v1 -> v2:
>- Instead of reload levels driver,fw_reset,fw_live_patch have reload
>  actions driver_reinit,fw_activate,fw_live_patch
>- Remove driver default level, the action driver_reinit is the default
>  action for all drivers 
>
>Moshe Shemesh (14):
>  devlink: Add reload action option to devlink reload command
>  devlink: Add reload actions counters
>  devlink: Add reload actions counters to dev get
>  net/mlx5: Add functions to set/query MFRL register
>  net/mlx5: Set cap for pci sync for fw update event
>  net/mlx5: Handle sync reset request event
>  net/mlx5: Handle sync reset now event
>  net/mlx5: Handle sync reset abort event
>  net/mlx5: Add support for devlink reload action fw activate
>  devlink: Add enable_remote_dev_reset generic parameter
>  net/mlx5: Add devlink param enable_remote_dev_reset support
>  net/mlx5: Add support for fw live patch event
>  net/mlx5: Add support for devlink reload action fw activate no reset
>  devlink: Add Documentation/networking/devlink/devlink-reload.rst
>
> .../networking/devlink/devlink-params.rst     |   6 +
> .../networking/devlink/devlink-reload.rst     |  68 +++
> Documentation/networking/devlink/index.rst    |   1 +
> drivers/net/ethernet/mellanox/mlx4/main.c     |  14 +-
> .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
> .../net/ethernet/mellanox/mlx5/core/devlink.c | 117 ++++-
> .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
> .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
> .../ethernet/mellanox/mlx5/core/fw_reset.c    | 453 ++++++++++++++++++
> .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
> .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
> .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
> .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
> drivers/net/ethernet/mellanox/mlxsw/core.c    |  24 +-
> drivers/net/netdevsim/dev.c                   |  16 +-
> include/linux/mlx5/device.h                   |   1 +
> include/linux/mlx5/driver.h                   |   4 +
> include/net/devlink.h                         |  13 +-
> include/uapi/linux/devlink.h                  |  24 +
> net/core/devlink.c                            | 174 ++++++-
> 20 files changed, 967 insertions(+), 51 deletions(-)
> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
> create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>
>-- 
>2.17.1
>
