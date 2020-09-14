Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76DC268A7B
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 14:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgINMAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 08:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgINLnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 07:43:22 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D46C06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 04:43:21 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o8so22770438ejb.10
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 04:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EorQ4+lFRDMIIwVJVubxPfngkVD7wpy5XnFzjtyaCII=;
        b=cEieP5uetVjdC8PZd4Ru1iB2Nef0yKOKkYyYizT9bwmkXEKdO1cikfrP2sOkOdB1Zr
         FI9vYfQCfX2c5Uo50C8lRbiXEZ7CqDZHxhlB9bKTryX2nl8+/SdZFnl2pjIKnUM6RtLH
         jXwToEOnBNkB287LKU+8TDjrR/6wbnqmhRQSc1b7X1+7bqk538Seh3CLJAqfe/8xw8b2
         B35lux0oUategBjqPcr6i6fItIMfrH8kRacS94/1OTXVxS9iWoO5zBo0nLG2dExxY4vg
         cECI9qFEDArN3E1INVmuU/4vTVLHQXLILSA9TVVGLI+XkGC5/TUkZ8gE3frGh2jwMwkw
         yC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EorQ4+lFRDMIIwVJVubxPfngkVD7wpy5XnFzjtyaCII=;
        b=tb3VSQXGMrhADI2GBEXlPQ4gxG3BCTdkWprEShbOYE+bad1xifPrwQ3qOH42Zgrsl6
         4FrQ25ATCOW1AsliswbDFZPJxxj9YCICX61rmtiz5KKAimosE1ajtLZyuldCqLr09y6Y
         mPd2IUtL6qThqTo1i4lOpIazLnVowRPkQ/8NOf7IL1onw4xR1UwKGlujMwTSALrpd0XQ
         rdvPGp5Y30zEqpy3iIR7+kOzPE8OKVUb/XtUUKeAzgPrP7tv7CwlHGENi9q0IbaJUeW3
         2XjpUZyYfmA3iMkNaCPpE3Oc14aotPPzmO6jLHGfXheKrx5d3/wqFtRXEys69XyNH46B
         WSOw==
X-Gm-Message-State: AOAM533ifzVNJvbAbHLiBVkzaQP6vVofESUYqdLZ+uwxOOrKsiKCjzYb
        OVXTawBppcxiPfEM51WuhzAOQrZn2sEf+tnt
X-Google-Smtp-Source: ABdhPJzVBIkjmcXzKOZKv9MKgpLPw6zIkoxrrF0qu90ZuuZOdF8ccgxoqEDEBgyOFojfgFJim8eJdQ==
X-Received: by 2002:a17:907:685:: with SMTP id wn5mr6516776ejb.285.1600083799791;
        Mon, 14 Sep 2020 04:43:19 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z23sm7542624eja.29.2020.09.14.04.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 04:43:19 -0700 (PDT)
Date:   Mon, 14 Sep 2020 13:43:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v4 15/15] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
Message-ID: <20200914114318.GD2236@nanopsycho.orion>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-16-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600063682-17313-16-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 14, 2020 at 08:08:02AM CEST, moshe@mellanox.com wrote:
>Add devlink reload rst documentation file.
>Update index file to include it.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>v3 -> v4:
>- Remove reload action fw_activate_no_reset
>- Add reload actions limit levels and document the no_reset limit level
>  constrains
>v2 -> v3:
>- Devlink reload returns the actions done
>- Replace fw_live_patch action by fw_activate_no_reset
>- Explain fw_activate meaning
>v1 -> v2:
>- Instead of reload levels driver,fw_reset,fw_live_patch have reload
>  actions driver_reinit,fw_activate,fw_live_patch
>---
> .../networking/devlink/devlink-reload.rst     | 80 +++++++++++++++++++
> Documentation/networking/devlink/index.rst    |  1 +
> 2 files changed, 81 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>
>diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>new file mode 100644
>index 000000000000..6ac9dddd2208
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-reload.rst
>@@ -0,0 +1,80 @@
>+.. SPDX-License-Identifier: GPL-2.0
>+
>+==============
>+Devlink Reload
>+==============
>+
>+``devlink-reload`` provides mechanism to either reload driver entities,
>+applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>+activation depends on reload action selected.
>+
>+Reload actions
>+==============
>+
>+User may select a reload action.
>+By default ``driver_reinit`` action is selected.
>+
>+.. list-table:: Possible reload actions
>+   :widths: 5 90
>+
>+   * - Name
>+     - Description
>+   * - ``driver-reinit``
>+     - Devlink driver entities re-initialization, including applying
>+       new values to devlink entities which are used during driver
>+       load such as ``devlink-params`` in configuration mode
>+       ``driverinit`` or ``devlink-resources``
>+   * - ``fw_activate``
>+     - Firmware activate. Activates new firmware if such image is stored and
>+       pending activation. This action involves firmware reset, if no new image
>+       pending this action will reload current firmware image.
>+
>+Note that when required to do firmware activation some drivers may need
>+to reload the driver. On the other hand some drivers may need to reset

s/reload/reinit" ?

>+the firmware to reinitialize the driver entities. Therefore, the devlink
>+reload command returns the actions which were actually performed.

I would perhaps say something more generic like:
Note that even though user asks for a specific action, the driver
implementation might require to perform another action alongside with
it. For example, some driver do not support driver reinitialization
being performed without fw activation. Therefore, the devlink reload
command return the list of actions which were actrually performed.


>+
>+Reload action limit levels
>+==========================
>+
>+By default reload actions are not limited and Driver implementation may

Why capital "D"?


>+include reset or downtime as needed to perform the actions.
>+
>+However, some drivers support action limit levels, which limits the action
>+implementation to specific constrains.
>+
>+.. list-table:: Possible reload action limit levels
>+   :widths: 5 90
>+
>+   * - Name
>+     - Description
>+   * - ``no_reset``
>+     - No reset allowed, no down time allowed, no link flap and no
>+       configuration is lost.
>+
>+Change namespace
>+================
>+
>+All devlink instances are created in init_net and stay there for a
>+lifetime. Allow user to be able to move devlink instances into
>+namespaces during devlink reload operation. That ensures proper
>+re-instantiation of driver objects, including netdevices.

This sounds like a commit message :) Could you please re-phrase a bit?


>+
>+example usage
>+-------------
>+
>+.. code:: shell
>+
>+    $ devlink dev reload help
>+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [limit_level no_reset]
>+
>+    # Run reload command for devlink driver entities re-initialization:
>+    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>+    reload_actions_performed:
>+      driver_reinit
>+
>+    # Run reload command to activate firmware:
>+    # Note that mlx5 driver reloads the driver while activating firmware
>+    $ devlink dev reload pci/0000:82:00.0 action fw_activate
>+    reload_actions_performed:
>+      driver_reinit fw_activate

This looks fine to me.


>diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
>index 7684ae5c4a4a..d82874760ae2 100644
>--- a/Documentation/networking/devlink/index.rst
>+++ b/Documentation/networking/devlink/index.rst
>@@ -20,6 +20,7 @@ general.
>    devlink-params
>    devlink-region
>    devlink-resource
>+   devlink-reload
>    devlink-trap
> 
> Driver-specific documentation
>-- 
>2.17.1
>
