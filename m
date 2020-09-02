Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E225A719
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIBHzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgIBHzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:55:33 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A689C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 00:55:32 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a17so4148553wrn.6
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 00:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=faX/RRq17Z93RCYcR/iHAPench8MRWplt4raEZZtM1Q=;
        b=QHmKlJmo13sJp2ks272+vwy3vsaPj0fmH5AbaLAfxlRRWwjC/auGHbilYIMIRYAjlQ
         nOrMknhFFq7pe5Bn2VRIWDAmyTAHURgrxl2adLYHw3RszdlIRHXjuiAhFJ4DkltDSzLB
         XUiuS7QRPClEdBae2uSmApbMbyfRYGy2JwLzHJZw6fIrt5VD5tIMbI+5LWpeN3PamGYt
         UAv514ThiiKg7oo+WI7yqK76DKxNP3pSAsHuZaUR5ZoRfIPKMurgkiTzQsoOpkwnYb/D
         VPm6D/Dw42ErRTB/8GMr26pOwLO2xITwK6M0Dc0ULGLliEOKY+8ODS2oDcPWp2/mk+rx
         hxxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=faX/RRq17Z93RCYcR/iHAPench8MRWplt4raEZZtM1Q=;
        b=WJpvCwonB/pBhpQSj9a73wS9XDGKgs0xTX/Xro9oJUytwFoqKtMwXOvlRSz3OUWWBG
         lP9x31aB7n1ga705BKS3g0SvgmhXkkAfbZPimyRuvhDcnrJCYSvW87lM6N69JSiO+vyd
         1ZzZOLQycd6gw/aUcszT2EoTfmPJa3Ic4F2GX7Hxh8WdFyW0bpUD6fVxdYUbCxThQNDa
         UGBGHJKC9gZby62nTgkUP77PAKpaQ/BDmo45Sf1ehJ7q5vkkoeXuqV35q6YhDKxRkVDS
         78K0m6ymZNMXLCCNyIekpDvfcB8susSbcpAjgFfxNQifqBcY5hrI3KTJQp9L7pPCmHI3
         gD2w==
X-Gm-Message-State: AOAM530xmvVk8VUBIBxdTo+O/H9O81Q+l1lHmOS2Y9V4ylq5f8JhOOur
        ozyUxgKsAufo2daH+6Ikfk4Hyg==
X-Google-Smtp-Source: ABdhPJzLNQ0H42IjS7iYpFJGmlyly9hQhjAGOv9RjPW/VhbgX/had+l5pzAHODow4zLXJolPRUdckg==
X-Received: by 2002:adf:e6cf:: with SMTP id y15mr5825642wrm.346.1599033330443;
        Wed, 02 Sep 2020 00:55:30 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p22sm4984344wmc.38.2020.09.02.00.55.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 00:55:29 -0700 (PDT)
Date:   Wed, 2 Sep 2020 09:55:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v3 00/14] Add devlink reload action option
Message-ID: <20200902075528.GG3794@nanopsycho.orion>
References: <1598801254-27764-1-git-send-email-moshe@mellanox.com>
 <20200831104956.GC3794@nanopsycho.orion>
 <36e30108-26e3-44ae-e133-48d412f7efe6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36e30108-26e3-44ae-e133-48d412f7efe6@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Sep 01, 2020 at 09:16:17PM CEST, moshe@nvidia.com wrote:
>
>On 8/31/2020 1:49 PM, Jiri Pirko wrote:
>> Sun, Aug 30, 2020 at 05:27:20PM CEST, moshe@mellanox.com wrote:
>> > Introduce new option on devlink reload API to enable the user to select the
>> > reload action required. Complete support for all actions in mlx5.
>> > The following reload actions are supported:
>> >   driver_reinit: driver entities re-initialization, applying devlink-param
>> >                  and devlink-resource values.
>> >   fw_activate: firmware activate.
>> >   fw_activate_no_reset: Activate new firmware image without any reset.
>> >                         (also known as: firmware live patching).
>> > 
>> > Each driver which support this command should expose the reload actions
>> > supported.
>> > The uAPI is backward compatible, if the reload action option is omitted
>> >from the reload command, the driver reinit action will be used.
>> > Note that when required to do firmware activation some drivers may need
>> > to reload the driver. On the other hand some drivers may need to reset
>> > the firmware to reinitialize the driver entities. Therefore, the devlink
>> > reload command returns the actions which were actually done.
>> > 
>> > Add reload actions counters to hold the history per reload action type.
>> > For example, the number of times fw_activate has been done on this
>> > device since the driver module was added or if the firmware activation
>> > was done with or without reset.
>> > 
>> > Patch 1 adds the new API reload action option to devlink.
>> > Patch 2 adds reload actions counters.
>> > Patch 3 exposes the reload actions counters on devlink dev get.
>> > Patches 4-9 add support on mlx5 for devlink reload action fw_activate
>> >             and handle the firmware reset events.
>> > Patches 10-11 add devlink enable remote dev reset parameter and use it
>> >              in mlx5.
>> > Patches 12-13 mlx5 add devlink reload action fw_activate_no_reset support
>> >               and event handling.
>> > Patch 14 adds documentation file devlink-reload.rst
>> > 
>> > command examples:
>> > $devlink dev reload pci/0000:82:00.0 action driver_reinit
>> > reload_actions_done:
>> >   driver_reinit
>> > 
>> > $devlink dev reload pci/0000:82:00.0 action fw_activate
>> > reload_actions_done:
>> >   driver_reinit fw_activate
>> > 
>> > $ devlink dev reload pci/0000:82:00.0 action fw_activate no_reset
>> You are missing "_".
>
> I meant that no_reset is an option here, so the uAPI is :
>
>$ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action {
>driver_reinit | fw_activate [no_reset] } ]

In the uapi enum, it's a different value. It is desirable to follow the
uapi for things like this. I don't see why not.

>
> Should have been as "--no_reset" or "-no_reset" but it seemed that all
>options in devlink are global, not specific to command
>
>Do you see a better way, please advise

if you want to do it this way, you need a separate netlink attr. But I
don't think it is necessary. I provided suggestion in the other email.


>
>> 
>> > reload_actions_done:
>> No need to have "reload" word here. And maybe "performed" would be
>> better than "done". Idk:
>> "actions_performed"
>> ?
>
>
>Yes, that's better, I will fix.
>
>> 
>> >   fw_activate_no_reset
>> > 
>> > v2 -> v3:
>> > - Replace fw_live_patch action by fw_activate_no_reset
>> > - Devlink reload returns the actions done over netlink reply
>> > - Add reload actions counters
>> > 
>> > v1 -> v2:
>> > - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>> >   actions driver_reinit,fw_activate,fw_live_patch
>> > - Remove driver default level, the action driver_reinit is the default
>> >   action for all drivers
>> > 
>> > Moshe Shemesh (14):
>> >   devlink: Add reload action option to devlink reload command
>> >   devlink: Add reload actions counters
>> >   devlink: Add reload actions counters to dev get
>> >   net/mlx5: Add functions to set/query MFRL register
>> >   net/mlx5: Set cap for pci sync for fw update event
>> >   net/mlx5: Handle sync reset request event
>> >   net/mlx5: Handle sync reset now event
>> >   net/mlx5: Handle sync reset abort event
>> >   net/mlx5: Add support for devlink reload action fw activate
>> >   devlink: Add enable_remote_dev_reset generic parameter
>> >   net/mlx5: Add devlink param enable_remote_dev_reset support
>> >   net/mlx5: Add support for fw live patch event
>> >   net/mlx5: Add support for devlink reload action fw activate no reset
>> >   devlink: Add Documentation/networking/devlink/devlink-reload.rst
>> > 
>> > .../networking/devlink/devlink-params.rst     |   6 +
>> > .../networking/devlink/devlink-reload.rst     |  68 +++
>> > Documentation/networking/devlink/index.rst    |   1 +
>> > drivers/net/ethernet/mellanox/mlx4/main.c     |  14 +-
>> > .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
>> > .../net/ethernet/mellanox/mlx5/core/devlink.c | 117 ++++-
>> > .../mellanox/mlx5/core/diag/fw_tracer.c       |  31 ++
>> > .../mellanox/mlx5/core/diag/fw_tracer.h       |   1 +
>> > .../ethernet/mellanox/mlx5/core/fw_reset.c    | 453 ++++++++++++++++++
>> > .../ethernet/mellanox/mlx5/core/fw_reset.h    |  19 +
>> > .../net/ethernet/mellanox/mlx5/core/health.c  |  35 +-
>> > .../net/ethernet/mellanox/mlx5/core/main.c    |  13 +
>> > .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
>> > drivers/net/ethernet/mellanox/mlxsw/core.c    |  24 +-
>> > drivers/net/netdevsim/dev.c                   |  16 +-
>> > include/linux/mlx5/device.h                   |   1 +
>> > include/linux/mlx5/driver.h                   |   4 +
>> > include/net/devlink.h                         |  13 +-
>> > include/uapi/linux/devlink.h                  |  24 +
>> > net/core/devlink.c                            | 174 ++++++-
>> > 20 files changed, 967 insertions(+), 51 deletions(-)
>> > create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>> > create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>> > create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>> > 
>> > -- 
>> > 2.17.1
>> > 
