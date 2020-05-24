Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09481DFD70
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 08:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgEXGaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 02:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgEXGaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 02:30:09 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53401C061A0E
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 23:30:09 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id o14so17453941ljp.4
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 23:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4vDyJztujhiTj8goyLXkUGdHv8Hlk7GmMricHfzVNrQ=;
        b=hFhVvt6PTwXx6ROQpJ3h8IwKbXuEUb+jcAQbcZZsA/0MM9snkrjdMlKV8C1CmhJiWk
         TVLjV4pBpKMWVKwa9p/poPy0X553+0Vd3JPvKZfdSexjsO62CdC0sNTASvdMAFZwXr4r
         nOoMcPu3pYeAiC8ozwdjJOBZM1w5zEgOISDFc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4vDyJztujhiTj8goyLXkUGdHv8Hlk7GmMricHfzVNrQ=;
        b=c6VqQAOgrbnw5CRnoBrbbk+rYDN2LAeg3NxMJzqfq7UB5Jxs+HWUhAijk6HU4/1G48
         avDEQw8PqFC6wXZ2HlWr4vpHKSswXFT/pC5ME2go/6Slru+wS+njoOufJfaGo2HMzK1B
         NjtVUNvE3mCJp7EvmLFM/yl5qSxgxqCOLd+TDvnCoMFJM7Uo/FqSCjg97G3No9lAGudx
         677+wjdygxjLLOJHH8WApxSnBO1g+zwpiZ0oUk6qYRn1oyDkCXPUV2gLa4Lzx3NBi5x1
         g5QiWtpSNQWfwdrIXr3OQFuRYGQuZ6Vosbvz3XlFyFdPYj7LquD2b96PwPeerU7gpe9S
         JYcQ==
X-Gm-Message-State: AOAM533z3Zuzq9ze6IKF9x+UL2g+YrPsK3w18F2AsKsmf9hnGY2zsRJ5
        jlHgSFLeyW3SXhKZ1egn1FBu0iYtRSmqzDgcqAhTcs8J
X-Google-Smtp-Source: ABdhPJyYay+ZmhmbvUavL/4SfuR5fMXjRdNIX5xn6GU31RHHuKyXlodmJlGyxJJVLnMopu8C8ys1Ior8u2Qc5nESS6M=
X-Received: by 2002:a2e:2a43:: with SMTP id q64mr9183903ljq.419.1590301807463;
 Sat, 23 May 2020 23:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com> <20200524045335.GA22938@nanopsycho>
In-Reply-To: <20200524045335.GA22938@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sun, 24 May 2020 11:59:56 +0530
Message-ID: <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >Add a new "allow_fw_live_reset" generic device bool parameter. When
> >parameter is set, user is allowed to reset the firmware in real time.
> >
> >This parameter is employed to communicate user consent or dissent for
> >the live reset to happen. A separate command triggers the actual live
> >reset.
> >
> >Cc: Jiri Pirko <jiri@mellanox.com>
> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >---
> >v2: Rename param name to "allow_fw_live_reset" from
> >"enable_hot_fw_reset".
> >Update documentation for the param in devlink-params.rst file.
> >---
> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
> > include/net/devlink.h                               | 4 ++++
> > net/core/devlink.c                                  | 5 +++++
> > 3 files changed, 15 insertions(+)
> >
> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
> >index d075fd0..ad54dfb 100644
> >--- a/Documentation/networking/devlink/devlink-params.rst
> >+++ b/Documentation/networking/devlink/devlink-params.rst
> >@@ -108,3 +108,9 @@ own name.
> >    * - ``region_snapshot_enable``
> >      - Boolean
> >      - Enable capture of ``devlink-region`` snapshots.
> >+   * - ``allow_fw_live_reset``
> >+     - Boolean
> >+     - Firmware live reset allows users to reset the firmware in real time.
> >+       For example, after firmware upgrade, this feature can immediately reset
> >+       to run the new firmware without reloading the driver or rebooting the
>
> This does not tell me anything about the reset being done on another
> host. You need to emhasize that, in the name of the param too.
I am not sure if I completely understand your query.

Reset is actually initiated by one of the PF/host of the device, which
resets the entire same device.

Reset is not initiated by any other remote device/host.

Thanks,
Vasundhara
>
>
>
> >+       system.
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index 8ffc1b5c..488b61c 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> >
> >       /* add new param generic ids above here*/
> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
> >
> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
> >+
> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
> > {                                                                     \
> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >index 7b76e5f..8544f23 100644
> >--- a/net/core/devlink.c
> >+++ b/net/core/devlink.c
> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
> >       },
> >+      {
> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
> >+      },
> > };
> >
> > static int devlink_param_generic_verify(const struct devlink_param *param)
> >--
> >1.8.3.1
> >
