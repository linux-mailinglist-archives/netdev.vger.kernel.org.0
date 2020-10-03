Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6475C2822F5
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJCJOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgJCJOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:14:33 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4B8C0613E7
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:14:33 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id c18so4301791wrm.9
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 02:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dE+mp6CvJ+Rm67MjVF3KVatmX9kZjm6IJMWnD9PC+yo=;
        b=pvVAMnUMKp2KDA/SvropcJLIVKfuhBCs0iTd6+Rg7CC2cEGn0M5BN6FF63WOnS3dzX
         Fj2gx0Xr+MyJ3thn/RzIWYRpHbUuG7AYfvhU3Zn9/X4rJs7xmHD2DvtgPQkATYEnZ0vh
         SLlykEhwsX9BYXEE9NJdhAapvQX7X5xJDC7SMevirOiQNrDQNAMGyq0xaxf/JcQwMlRG
         TXwUXsMeh7cTIifZDLA3aHm/1UnQP9yRaiL80tzINxbs9iEkUxUoKEqQ0zhyqa/YpG7w
         K7XD12I76DPTpge5m/FnunVJEvaITjyFco8Os1YW2QrJ9wI/Z0ysvyszoB8b4CF728Dc
         Aukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dE+mp6CvJ+Rm67MjVF3KVatmX9kZjm6IJMWnD9PC+yo=;
        b=EBg5dZgt1V5Uz0CScjlD4wSMas1gU/Ctyr03z6h1B+FPbY529WKFX57AIMI8Z9xzdj
         d1s0pBOnP9xeQv5BPvRlCuXZqVyOC/+1XurkSWnlqewPBPDw6TWofedbm5+F5P2q/xrn
         e2u4vEINAQeD42OYZSTWErauaX7xH6yRb0GjGJ9go3k15e8eBMIMt1mKT6uRcVUhsfGh
         KsJDA2NUug2TqM5lMjwGMQi935Tj6RmnKlhTD5l/z9/vghB4LhRqVvPXff6TOtvc80Iq
         EQkW63CGfQ9wuFNnLzz1CPo8JXo/OFl8cA4RQt74HI6Q0bF4f5d7RuO1EjexXkojYWwU
         vyXw==
X-Gm-Message-State: AOAM530LWyoUQgcavA5/mt2m2jq8zTBg/OY3qkburDGlNyPNOF1sOirO
        ueuQ8FuKJpFjK+exMTCK9/9bjQ==
X-Google-Smtp-Source: ABdhPJyB41F4r+UGFJxr9dLuua8eg5hKftEiergj4DDKcXKIhI5V74g3SzdWyte/oeCPktVz+nbooQ==
X-Received: by 2002:a5d:55c8:: with SMTP id i8mr7367543wrw.331.1601716471969;
        Sat, 03 Oct 2020 02:14:31 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v128sm4483721wme.2.2020.10.03.02.14.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 02:14:31 -0700 (PDT)
Date:   Sat, 3 Oct 2020 11:14:30 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 16/16] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
Message-ID: <20201003091430.GG3159@nanopsycho.orion>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-17-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1601560759-11030-17-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Oct 01, 2020 at 03:59:19PM CEST, moshe@mellanox.com wrote:
>Add devlink reload rst documentation file.
>Update index file to include it.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>RFCv5 -> v1:
>- Rename reload_action_limit_level to reload_limit
>RFCv4 -> RFCv5:
>- Rephrase namespace chnage section
>- Rephrase note on actions performed
>RFCv3 -> RFCv4:
>- Remove reload action fw_activate_no_reset
>- Add reload actions limit levels and document the no_reset limit level
>  constrains
>RFCv2 -> RFCv3:
>- Devlink reload returns the actions done
>- Replace fw_live_patch action by fw_activate_no_reset
>- Explain fw_activate meaning
>RFCv1 -> RFCv2:
>- Instead of reload levels driver,fw_reset,fw_live_patch have reload
>  actions driver_reinit,fw_activate,fw_live_patch
>---
> .../networking/devlink/devlink-reload.rst     | 81 +++++++++++++++++++
> Documentation/networking/devlink/index.rst    |  1 +
> 2 files changed, 82 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>
>diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>new file mode 100644
>index 000000000000..5abc5c2c75fd
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-reload.rst
>@@ -0,0 +1,81 @@
>+.. SPDX-License-Identifier: GPL-2.0
>+
>+==============
>+Devlink Reload

No reason for capital "R".


>+==============
>+
>+``devlink-reload`` provides mechanism to either reinit driver entities,
>+applying ``devlink-params`` and ``devlink-resources`` new values or firmware
>+activation depends on reload action selected.

Could you perhaps split the sentense? It is hard to read.


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
>+       pending activation. If no limitation specified this action may involve
>+       firmware reset. If no new image pending this action will reload current
>+       firmware image.
>+
>+Note that even though user asks for a specific action, the driver
>+implementation might require to perform another action alongside with
>+it. For example, some driver do not support driver reinitialization
>+being performed without fw activation. Therefore, the devlink reload
>+command returns the list of actions which were actrually performed.
>+
>+Reload limits
>+=============
>+
>+By default reload actions are not limited and driver implementation may
>+include reset or downtime as needed to perform the actions.
>+
>+However, some drivers support action limits, which limit the action
>+implementation to specific constrains.
>+
>+.. list-table:: Possible reload limits
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
>+The netns option allow user to be able to move devlink instances into

"allows"


>+namespaces during devlink reload operation.
>+By default all devlink instances are created in init_net and stay there.
>+
>+example usage
>+-------------
>+
>+.. code:: shell
>+
>+    $ devlink dev reload help
>+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { driver_reinit | fw_activate } ] [ limit no_reset ]
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
>2.18.2
>
