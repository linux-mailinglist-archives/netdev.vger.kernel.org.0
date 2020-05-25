Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7461E135F
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 19:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391322AbgEYR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389251AbgEYR0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 13:26:36 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D806AC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:26:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r7so1040760wro.1
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 10:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DxZHlbqdxpOY7NGkhu8IOPsbm3+yyWwAAMN7Y6XVCiM=;
        b=YWv90dKop0vHrpcxib5UkqVRPLgHVYj56YkOuuK+Y6ExR2CTwPXgdir84QfAjG79Ta
         X+9fXTNFHQh0Kkq5dlo9N+2bWTQGN76EL1G+0j5OLx95qmpVdSExKvIAZZlM40YKUyLS
         2lCB05ToWypJzRH39CzPOlcx4uzNEtqnsZ9/W6oZsP+eNiJz9uHKms+HDro0/Putw2dY
         68vgIwqrtWcT4SZfUiWbUsp+9s7GpQM5H+GxBtRdsEOhNkeY4jB381O5A3rm9KzjCVlt
         h9MbeGWXAql8I+WjWixuDTSPWFZzc0ofOLyY2NelF4QjPTyzBqoNJzOfE37NKjOAPUmS
         x5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DxZHlbqdxpOY7NGkhu8IOPsbm3+yyWwAAMN7Y6XVCiM=;
        b=CceWYJWjAwAdtjl6RuL2mwO7sUgJWlCZkZaeiXKwzfHWYRGWXdK4wS8Qw/XC019qep
         vW3k4tNZ0RIR/l1Addt058cz6JKr8FEVMFesxveh+121IksWcyQBT27hOiqydbXn+22K
         HQcoUYQF2l37tdKT6xlK2LkVBASE1aoccq0lv2CFshUou3rohsDpKkiyT1L4Rig/iMx8
         4BSpY8r8wB/mitc85dtEM7q4/xKLoJoi9GVUksYYr0eqpQ4F6J7a/XIdbsnSvuA+e5Zg
         jgcRUZdtz521tq0MJq260yGz6wd+UzY1K4tBsxtZxdkzOi0NENVL7lJzdRHO3hkyIQwn
         n/1A==
X-Gm-Message-State: AOAM531Jh+GjmAWnr4/Rl6u1KkS6XcrWzJoHnwN5ouL/zUU55nP/vrO1
        IzUrvIE6vLY7tVTvPuXg/QO4xw==
X-Google-Smtp-Source: ABdhPJxYzCM5kh++5+2gZn8DlTuUt4aW0Cv8O3qq5ZEnQhBA9aciHg5zDnLlF8eVq3l9hxMmSRY1Lw==
X-Received: by 2002:a5d:5001:: with SMTP id e1mr17585104wrt.56.1590427563631;
        Mon, 25 May 2020 10:26:03 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y25sm1227829wmi.2.2020.05.25.10.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 10:26:03 -0700 (PDT)
Date:   Mon, 25 May 2020 19:26:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200525172602.GA14161@nanopsycho>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho>
 <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 24, 2020 at 08:29:56AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >Add a new "allow_fw_live_reset" generic device bool parameter. When
>> >parameter is set, user is allowed to reset the firmware in real time.
>> >
>> >This parameter is employed to communicate user consent or dissent for
>> >the live reset to happen. A separate command triggers the actual live
>> >reset.
>> >
>> >Cc: Jiri Pirko <jiri@mellanox.com>
>> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>> >---
>> >v2: Rename param name to "allow_fw_live_reset" from
>> >"enable_hot_fw_reset".
>> >Update documentation for the param in devlink-params.rst file.
>> >---
>> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
>> > include/net/devlink.h                               | 4 ++++
>> > net/core/devlink.c                                  | 5 +++++
>> > 3 files changed, 15 insertions(+)
>> >
>> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> >index d075fd0..ad54dfb 100644
>> >--- a/Documentation/networking/devlink/devlink-params.rst
>> >+++ b/Documentation/networking/devlink/devlink-params.rst
>> >@@ -108,3 +108,9 @@ own name.
>> >    * - ``region_snapshot_enable``
>> >      - Boolean
>> >      - Enable capture of ``devlink-region`` snapshots.
>> >+   * - ``allow_fw_live_reset``
>> >+     - Boolean
>> >+     - Firmware live reset allows users to reset the firmware in real time.
>> >+       For example, after firmware upgrade, this feature can immediately reset
>> >+       to run the new firmware without reloading the driver or rebooting the
>>
>> This does not tell me anything about the reset being done on another
>> host. You need to emhasize that, in the name of the param too.
>I am not sure if I completely understand your query.
>
>Reset is actually initiated by one of the PF/host of the device, which
>resets the entire same device.
>
>Reset is not initiated by any other remote device/host.

Well, in case of multihost system, it might be, right?


>
>Thanks,
>Vasundhara
>>
>>
>>
>> >+       system.
>> >diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >index 8ffc1b5c..488b61c 100644
>> >--- a/include/net/devlink.h
>> >+++ b/include/net/devlink.h
>> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
>> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
>> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
>> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
>> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >
>> >       /* add new param generic ids above here*/
>> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
>> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
>> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
>> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >
>> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
>> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >+
>> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> > {                                                                     \
>> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >index 7b76e5f..8544f23 100644
>> >--- a/net/core/devlink.c
>> >+++ b/net/core/devlink.c
>> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
>> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
>> >       },
>> >+      {
>> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
>> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
>> >+      },
>> > };
>> >
>> > static int devlink_param_generic_verify(const struct devlink_param *param)
>> >--
>> >1.8.3.1
>> >
