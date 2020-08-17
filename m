Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463F8246CFF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 18:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388893AbgHQQjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 12:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388879AbgHQQjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 12:39:36 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5849C061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:39:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id x5so13775119wmi.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 09:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8FMpxQy0XpZh5qIz+hqunbKOx8M3EEAQ3BzT6q0ExMo=;
        b=OM4mVNdcFimDjL6Aeqf44YgKR1Uf9xpPwIHJfBzxrqNLfV7VrGaKPLwSD/3XY/AtAQ
         Zxfl0UJ/Qo3svd2FOY9sRJc/15/es/6wZeZQeooEo1bhWi6296CWq9tfqUzSTC40N1Cc
         WL1Jn5p7zm6UQbUPO8GGQtGp3VN14nSSTizvrhi1tUR0ipTj7X3lHSRLaIQTc6R0ICyQ
         zxo57e+2hYRyTwpzbshLzCJGUkjWAWcRzZQkoIQ604x6IXvZxCZBfqlzDMj6DPmm/kOF
         FofURcWy0QNuFCXpWhIs9gQ6q//l+cPiLnqFqP/LAJBD2xsBzS9N3o5WjEIEFfDgN/5a
         vN0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8FMpxQy0XpZh5qIz+hqunbKOx8M3EEAQ3BzT6q0ExMo=;
        b=OOLDuJ4wRlaexJkkHaY6AhqyDYhwr3nyfwo5tnyCvSRp+KgbXFz00xc7jXruO5nxb9
         e6ipxG6D44aTsLO08ph/HGZOc+3i4mgMA2Ni1ZyP6myWeM+h+6CyGub1YvgZZKV0QSK9
         /tu88GmauLE4lPBcY0Vk/hjKDbXslYKTz1R+m7rWh6me76ozJ2PoAA4AOSeaTM3Q7HB2
         gY0Gb6P4xwPyvKklrdYpHyrKO9Htkq7QVhCPYstrkPdfQaAXWIiBiDA/ZO4iB7AWbCDr
         5/4mOHhMuyqpwXagCQQBkHn3LNijFyR5g79ntLTPdZh52WUgnjJeuw+b7EoKdBfddVyd
         Ozug==
X-Gm-Message-State: AOAM530l1sTrok1fPeTaT1JznumM7xl5ktfe1jmlXV8FnD6IPK1q0zlb
        k5KcVW+8Z/Nqg9/T23WFElehkw==
X-Google-Smtp-Source: ABdhPJzBpVacu/sjEsIXpASeL4pnndDe9A1NIzmgcZKW570+kbWLIt+clVFKzu8eRq0W8iYNgi/1Ig==
X-Received: by 2002:a7b:cc95:: with SMTP id p21mr14738601wma.167.1597682374676;
        Mon, 17 Aug 2020 09:39:34 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id x82sm30524182wmb.30.2020.08.17.09.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 09:39:34 -0700 (PDT)
Date:   Mon, 17 Aug 2020 18:39:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v2 13/13] devlink: Add
 Documentation/networking/devlink/devlink-reload.rst
Message-ID: <20200817163933.GB2627@nanopsycho>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
 <1597657072-3130-14-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597657072-3130-14-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 17, 2020 at 11:37:52AM CEST, moshe@mellanox.com wrote:
>Add devlink reload rst documentation file.
>Update index file to include it.
>
>Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>---
>- Instead of reload levels driver,fw_reset,fw_live_patch have reload
>  actions driver_reinit,fw_activate,fw_live_patch
>---
> .../networking/devlink/devlink-reload.rst     | 54 +++++++++++++++++++
> Documentation/networking/devlink/index.rst    |  1 +
> 2 files changed, 55 insertions(+)
> create mode 100644 Documentation/networking/devlink/devlink-reload.rst
>
>diff --git a/Documentation/networking/devlink/devlink-reload.rst b/Documentation/networking/devlink/devlink-reload.rst
>new file mode 100644
>index 000000000000..9846ea727f3b
>--- /dev/null
>+++ b/Documentation/networking/devlink/devlink-reload.rst
>@@ -0,0 +1,54 @@
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
>+=============
>+
>+User may select a reload action.
>+By default ``driver_reinit`` action is done.
>+
>+.. list-table:: Possible reload actions
>+   :widths: 5 90
>+
>+   * - Name
>+     - Description
>+   * - ``driver-reinit``
>+     - Driver entities re-initialization, including applying
>+       new values to devlink entities which are used during driver
>+       load such as ``devlink-params`` in configuration mode
>+       ``driverinit`` or ``devlink-resources``
>+   * - ``fw_activate``
>+     - Firmware activate. Can be used for firmware reload or firmware
>+       upgrade if new firmware is stored and driver supports such
>+       firmware upgrade.

Does this do the same as "driver-reinit" + fw activation? If yes, it
should be written here. If no, it should be written here as well.


>+   * - ``fw_live_patch``
>+     - Firmware live patch, applies firmware changes without reset.
>+
>+Change namespace
>+================
>+
>+All devlink instances are created in init_net and stay there for a
>+lifetime. Allow user to be able to move devlink instances into
>+namespaces during devlink reload operation. That ensures proper
>+re-instantiation of driver objects, including netdevices.
>+
>+example usage
>+-------------
>+
>+.. code:: shell
>+
>+    $ devlink dev reload help
>+    $ devlink dev reload DEV [ netns { PID | NAME | ID } ] [ action { fw_live_patch | driver_reinit | fw_activate } ]
>+
>+    # Run reload command for devlink driver entities re-initialization:
>+    $ devlink dev reload pci/0000:82:00.0 action driver_reinit
>+
>+    # Run reload command to activate firmware:
>+    $ devlink dev reload pci/0000:82:00.0 action fw_activate
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
