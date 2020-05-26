Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7991E1A64
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 06:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgEZE3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 00:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbgEZE3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 00:29:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972A5C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 21:29:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id m18so22824022ljo.5
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 21:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y2cWAzgMy0wY4wfmw9UDAMtGHuJWLUL4fl6PHCgitto=;
        b=JrG1YmipK3VeFNUzlW/vg/xHlsGU3iCEwMiuHZLAgppywThIzXXl7eqxJGSEMoycU4
         7AhzdJO3RzbCvgpPt/jKiTrzjVfDOvramPZYBrBXVrXlUoJM0n7q9qQiThkGq5OoZecc
         F/8QIB2ke7R/lBhM3PM56nqPJBy+2DcCx4c2E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y2cWAzgMy0wY4wfmw9UDAMtGHuJWLUL4fl6PHCgitto=;
        b=Pj5gV46l5Ja7DrE/BBjCf31kljZed2RrmhL3TODbaIMySac8dADtK3/IjHwPCIcE7K
         nlHR6I4rPYazrypLtsFrmmsR9TXycZ3l0B35PS5gAPzX80IEWkzC3f9lPt29Fz1M+t2T
         P+srttTbE/J44q8y7RXNmfWnfnjSseKA33bJRmhHy94Cot5LsEtpNAXNKfDaJTTlRu6X
         chXAUPaFzMMOA5mUQ+0460gNhwAQqHNtmWl6mkS7kZORtAmoikCtq6XHgsPLndZIlv0a
         NuNSYG9TOguOaKY52SNFu45yHMeva5fVjYJ16WnR4H+K864KU3YZr+mijGWIe/HZ3rnk
         qZCg==
X-Gm-Message-State: AOAM533L2OMd6n/v/yhls8kq6c2JGnDkG5vIYjtir8RAuI/cesnSZjJF
        wtBw452p4Xj4o3RFJ3JjFhUuX55U7SDAaeb0LMGIXSMAuyE=
X-Google-Smtp-Source: ABdhPJwASqgnEKHsCfsecrRFhSl/TNvtOhWw+CCwOwveAML8ZWn0CTOP3AbKX3tREqMUM6P0SliIRjfNYsLJQHIwn4E=
X-Received: by 2002:a2e:8154:: with SMTP id t20mr13303960ljg.326.1590467350902;
 Mon, 25 May 2020 21:29:10 -0700 (PDT)
MIME-Version: 1.0
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho> <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho>
In-Reply-To: <20200525172602.GA14161@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 26 May 2020 09:58:59 +0530
Message-ID: <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
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

On Mon, May 25, 2020 at 10:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Sun, May 24, 2020 at 08:29:56AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >> >Add a new "allow_fw_live_reset" generic device bool parameter. When
> >> >parameter is set, user is allowed to reset the firmware in real time.
> >> >
> >> >This parameter is employed to communicate user consent or dissent for
> >> >the live reset to happen. A separate command triggers the actual live
> >> >reset.
> >> >
> >> >Cc: Jiri Pirko <jiri@mellanox.com>
> >> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> >> >---
> >> >v2: Rename param name to "allow_fw_live_reset" from
> >> >"enable_hot_fw_reset".
> >> >Update documentation for the param in devlink-params.rst file.
> >> >---
> >> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
> >> > include/net/devlink.h                               | 4 ++++
> >> > net/core/devlink.c                                  | 5 +++++
> >> > 3 files changed, 15 insertions(+)
> >> >
> >> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
> >> >index d075fd0..ad54dfb 100644
> >> >--- a/Documentation/networking/devlink/devlink-params.rst
> >> >+++ b/Documentation/networking/devlink/devlink-params.rst
> >> >@@ -108,3 +108,9 @@ own name.
> >> >    * - ``region_snapshot_enable``
> >> >      - Boolean
> >> >      - Enable capture of ``devlink-region`` snapshots.
> >> >+   * - ``allow_fw_live_reset``
> >> >+     - Boolean
> >> >+     - Firmware live reset allows users to reset the firmware in real time.
> >> >+       For example, after firmware upgrade, this feature can immediately reset
> >> >+       to run the new firmware without reloading the driver or rebooting the
> >>
> >> This does not tell me anything about the reset being done on another
> >> host. You need to emhasize that, in the name of the param too.
> >I am not sure if I completely understand your query.
> >
> >Reset is actually initiated by one of the PF/host of the device, which
> >resets the entire same device.
> >
> >Reset is not initiated by any other remote device/host.
>
> Well, in case of multihost system, it might be, right?
>
In case of multi-host system also, it is one of the host that triggers
the reset, which resets the entire same device. I don't think this is
remote.

As the parameter is a device parameter, it is applicable to the entire
device. When a user initiates the reset from any of the host in case
of multi-host and any of the PF in case of stand-alone or smartNIC
device, the entire device goes for a reset.

I will be expanding the description to the following to make it more clear.

------------------------
- Firmware live reset allows users to reset the firmware in real time.
For example, after firmware upgrade, this feature can immediately
reset to run the new firmware without reloading the driver or
rebooting the system.
When a user initiates the reset from any of the host (in case of
multi-host system) / PF (in case of stand-alone or smartNIC device),
the entire device goes for a reset when the parameter is enabled.
------------------------

Thanks,
Vasundhara
>
> >
> >Thanks,
> >Vasundhara
> >>
> >>
> >>
> >> >+       system.
> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >> >index 8ffc1b5c..488b61c 100644
> >> >--- a/include/net/devlink.h
> >> >+++ b/include/net/devlink.h
> >> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
> >> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
> >> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
> >> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
> >> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> >> >
> >> >       /* add new param generic ids above here*/
> >> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
> >> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
> >> >
> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
> >> >+
> >> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
> >> > {                                                                     \
> >> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> >index 7b76e5f..8544f23 100644
> >> >--- a/net/core/devlink.c
> >> >+++ b/net/core/devlink.c
> >> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
> >> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
> >> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
> >> >       },
> >> >+      {
> >> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
> >> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
> >> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
> >> >+      },
> >> > };
> >> >
> >> > static int devlink_param_generic_verify(const struct devlink_param *param)
> >> >--
> >> >1.8.3.1
> >> >
