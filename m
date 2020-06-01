Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9971EA18A
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgFAKF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgFAKF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:05:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D46C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:05:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l10so10844841wrr.10
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+07rA7L0LBcgLLhPWItiiparveE/Kma7UaMGN6/grOs=;
        b=d01slhzSxYYCIRa9r8Mk2BNjY4fVLo6yDapDgPoI94hMq4t4xWkH+89kbfb9PfmaDs
         a2zfb6XfJF7GfSbNN4ckR7WXVvT5sdlhH7Z29j/oHks5UkU+8aNjwVhTBglTszLPpUzK
         kxe+2O05B/COW60oDUVe61zadaZrW9CH//tyCMXX4vhY6tpfU7jm7IbzzwPlbbpkyfAM
         czqy9Cu1j38wqaN0rbZd13w6ksiwfMazglpsjucrJfqK2sBjA1LPkKxdJ80u4aWEjxuC
         0fKB0pwtdfY9diLG7Sjcy8DuoUZQufEaazLJGVSmPofnvbITCbm+4q+uao+YPOdvCOJV
         +4ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+07rA7L0LBcgLLhPWItiiparveE/Kma7UaMGN6/grOs=;
        b=braSVao2/mo9OoVL7IDNMSzbSbc68Xgi9PRyQ3076BETU7m7p2t4gFdsq4EC0msc3D
         +t7mIg/1cpSJDEelFKoh2DzzlGdOnWPPs6oG3vrYNJLlMUeQu/4bTn65EESwh6cdHBFO
         sILPiRDjJmTmOxJOgvpEpa0ZMqbdqr+9ydfEI+qcQ63B0Fk49T135nEc15/RAUFu6hdB
         ubUIHNPukD5pZq1wavvsLHnEKbTomoXiilJb/8631fi65F+1hqbQiA/zsnJcGo0INzpm
         0tbT5pW6XJP+AchGoVgO65KIEo92aKgc4xbQ9v2iIOX2rT/xQy7cIG8Ey+Li+uCU0cW7
         gxNw==
X-Gm-Message-State: AOAM530Fl5JO6D/XUxwdioOCKGo8G50yJkVdMBr4JMndx03WNWLoVA6T
        3K7Kt5iHryVnnhcOkjQmjupnwg==
X-Google-Smtp-Source: ABdhPJzy4kXjDtv31IM00fSU4kgfprF0+CFM554M7YqPGgxvo6Pet7JR0REMazO1u4OZHMIzth8ZaA==
X-Received: by 2002:a5d:4ec3:: with SMTP id s3mr22709823wrv.103.1591005954467;
        Mon, 01 Jun 2020 03:05:54 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id o20sm20830906wra.29.2020.06.01.03.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:05:53 -0700 (PDT)
Date:   Mon, 1 Jun 2020 12:05:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200601100553.GN2282@nanopsycho>
References: <20200525172602.GA14161@nanopsycho>
 <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
 <20200526044727.GB14161@nanopsycho>
 <CAACQVJp8SfmP=R=YywDWC8njhA=ntEcs5o_KjBoHafPkHaj-iA@mail.gmail.com>
 <20200526134032.GD14161@nanopsycho>
 <CAACQVJrwFB4oHjTAw4DK28grxGGP15x52+NskjDtOYQdOUMbOg@mail.gmail.com>
 <20200601071847.GG2282@nanopsycho>
 <CAACQVJowMSW1kZLW+5XHBq8Hm8v9idj0sqxQPuCJh5epySo8-g@mail.gmail.com>
 <20200601095052.GI2282@nanopsycho>
 <CAACQVJpRZ==qre8jxD0=1-E_FFRxjJktp79TQQs60k-3T6Li9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpRZ==qre8jxD0=1-E_FFRxjJktp79TQQs60k-3T6Li9g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 11:59:38AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Jun 1, 2020 at 3:20 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 01, 2020 at 10:53:19AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Mon, Jun 1, 2020 at 12:48 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Tue, May 26, 2020 at 04:23:48PM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >On Tue, May 26, 2020 at 7:10 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >>
>> >> >> Tue, May 26, 2020 at 08:42:28AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >> >On Tue, May 26, 2020 at 10:17 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >> >>
>> >> >> >> Tue, May 26, 2020 at 06:28:59AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >> >> >On Mon, May 25, 2020 at 10:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >> >> >>
>> >> >> >> >> Sun, May 24, 2020 at 08:29:56AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >> >> >> >On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >> >> >> >>
>> >> >> >> >> >> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >> >> >> >> >Add a new "allow_fw_live_reset" generic device bool parameter. When
>> >> >> >> >> >> >parameter is set, user is allowed to reset the firmware in real time.
>> >> >> >> >> >> >
>> >> >> >> >> >> >This parameter is employed to communicate user consent or dissent for
>> >> >> >> >> >> >the live reset to happen. A separate command triggers the actual live
>> >> >> >> >> >> >reset.
>> >> >> >> >> >> >
>> >> >> >> >> >> >Cc: Jiri Pirko <jiri@mellanox.com>
>> >> >> >> >> >> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> >> >> >> >> >> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>> >> >> >> >> >> >---
>> >> >> >> >> >> >v2: Rename param name to "allow_fw_live_reset" from
>> >> >> >> >> >> >"enable_hot_fw_reset".
>> >> >> >> >> >> >Update documentation for the param in devlink-params.rst file.
>> >> >> >> >> >> >---
>> >> >> >> >> >> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
>> >> >> >> >> >> > include/net/devlink.h                               | 4 ++++
>> >> >> >> >> >> > net/core/devlink.c                                  | 5 +++++
>> >> >> >> >> >> > 3 files changed, 15 insertions(+)
>> >> >> >> >> >> >
>> >> >> >> >> >> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> >> >> >> >> >> >index d075fd0..ad54dfb 100644
>> >> >> >> >> >> >--- a/Documentation/networking/devlink/devlink-params.rst
>> >> >> >> >> >> >+++ b/Documentation/networking/devlink/devlink-params.rst
>> >> >> >> >> >> >@@ -108,3 +108,9 @@ own name.
>> >> >> >> >> >> >    * - ``region_snapshot_enable``
>> >> >> >> >> >> >      - Boolean
>> >> >> >> >> >> >      - Enable capture of ``devlink-region`` snapshots.
>> >> >> >> >> >> >+   * - ``allow_fw_live_reset``
>> >> >> >> >> >> >+     - Boolean
>> >> >> >> >> >> >+     - Firmware live reset allows users to reset the firmware in real time.
>> >> >> >> >> >> >+       For example, after firmware upgrade, this feature can immediately reset
>> >> >> >> >> >> >+       to run the new firmware without reloading the driver or rebooting the
>> >> >> >> >> >>
>> >> >> >> >> >> This does not tell me anything about the reset being done on another
>> >> >> >> >> >> host. You need to emhasize that, in the name of the param too.
>> >> >> >> >> >I am not sure if I completely understand your query.
>> >> >> >> >> >
>> >> >> >> >> >Reset is actually initiated by one of the PF/host of the device, which
>> >> >> >> >> >resets the entire same device.
>> >> >> >> >> >
>> >> >> >> >> >Reset is not initiated by any other remote device/host.
>> >> >> >> >>
>> >> >> >> >> Well, in case of multihost system, it might be, right?
>> >> >> >> >>
>> >> >> >> >In case of multi-host system also, it is one of the host that triggers
>> >> >> >> >the reset, which resets the entire same device. I don't think this is
>> >> >> >> >remote.
>> >> >> >> >
>> >> >> >> >As the parameter is a device parameter, it is applicable to the entire
>> >> >> >> >device. When a user initiates the reset from any of the host in case
>> >> >> >> >of multi-host and any of the PF in case of stand-alone or smartNIC
>> >> >> >> >device, the entire device goes for a reset.
>> >> >> >> >
>> >> >> >> >I will be expanding the description to the following to make it more clear.
>> >> >> >> >
>> >> >> >> >------------------------
>> >> >> >> >- Firmware live reset allows users to reset the firmware in real time.
>> >> >> >> >For example, after firmware upgrade, this feature can immediately
>> >> >> >> >reset to run the new firmware without reloading the driver or
>> >> >> >> >rebooting the system.
>> >> >> >> >When a user initiates the reset from any of the host (in case of
>> >> >> >> >multi-host system) / PF (in case of stand-alone or smartNIC device),
>> >> >> >> >the entire device goes for a reset when the parameter is enabled.
>> >> >> >>
>> >> >> >> Sorry, this is still not clear. I think that you are mixing up two
>> >> >> >> different things:
>> >> >> >> 1) option of devlink reload to indicate that user is interested in "live
>> >> >> >>    reset" of firmware without reloading driver
>> >> >> >
>> >> >> >This is the option we are trying to add. If a user is interested in
>> >> >> >"live reset", he needs to enable the parameter to enable it in device
>> >> >> >capabilities, which is achieved by permanent configuration mode. When
>> >> >> >capability is enabled in the device, new firmware which is aware will
>> >> >> >allocate the resources and exposes the capability to host drivers.
>> >> >> >
>> >> >> >But firmware allows the "live reset" only when all the loaded drivers
>> >> >> >are aware of/supports the capability. For example, if any of the host
>> >> >> >is loaded with an old driver, "live reset" is not allowed until the
>> >> >> >driver is upgraded or unloaded. or if the host driver turns it off,
>> >> >> >then also "live reset" is not allowed.
>> >> >> >
>> >> >> >In case of runtime parameter cmode, if any of the host turns off the
>> >> >> >capability in the host driver, "live reset" is not allowed until the
>> >> >> >driver is unloaded or the user enables it again.
>> >> >> >
>> >> >> >To make it clear, I can add two parameters.
>> >> >> >
>> >> >> >1. enable_fw_live_reset - To indicate that the user is interested in
>> >> >> >"live reset". This will be a generic param.
>> >> >>
>> >> >> As I wrote above, I believe this should be an option
>> >> >> to "devlink dev reload", not a param.
>> >> >I think you are still confused with enabling feature in NVRAM
>> >> >configuration of the device and command to trigger reset. This param
>> >> >will enable the feature in the device NVRAM configuration and does not
>> >> >trigger the actual reset.
>> >> >
>> >> >Only when the param is set, feature will be enabled in the device and
>> >> >firmware supports the "live reset". When the param is disabled,
>> >> >firmware cannot support "live reset" and user needs to do PCIe reset
>> >> >after flashing the firmware for it to take effect..
>> >>
>> >> Does that mean that after reboot, when user triggers fw reset, it will
>> >> be always "live" is possible? Meaning, user will no have a way to
>> >> specify that per-reset?
>> >Right now, there is no option for user to mention the type of reset.
>> >
>> >As you suggested, we need to extend 'devlink dev reload' for users to
>> >mention the type of reset.
>>
>> Does your fw support it? The option of "I want live reset now/I
>> don't want live reset now"?
>
>Yes, our firmware supports both. Even when "live reset" is enabled,
>users can choose the option of "live reset" / "reset on driver
>reload".

Good, I believe you need to expose this option now.


>
>>
>>
>>
>> >
>> >>
>> >>
>> >> >
>> >> >Once feature is enabled in NVRAM configuration, it will be persistent
>> >> >across reboots.
>> >> >
>> >> >User still needs to use "devlink dev reload" command to do the "live reset".
>> >> >>
>> >> >>
>> >> >> >
>> >> >> >2. allow_fw_live_reset - To indicate, if any of the host/PF turns it
>> >> >> >off, "live reset" is not allowed. This serves the purpose of what we
>> >> >> >are trying to add in runtime cmode.
>> >> >>
>> >> >> Yeah.
>> >> >And this param will enable the feature in the driver for driver to
>> >> >allow the firmware to go for "live reset", where as above param will
>> >> >enable the feature in NVRAM configuration of the device.
>> >> >>
>> >> >> >Do you want me to keep it as a driver-specific param?
>> >> >>
>> >> >> There is nothing driver-specific about this.
>> >> >okay.
>> >> >>
>> >> >>
>> >> >> >
>> >> >> >Please let me know if this is clear and makes less confusion.
>> >> >> >
>> >> >> >Thanks,
>> >> >> >Vasundhara
>> >> >> >
>> >> >> >> 2) devlink param that would indicate "I am okay if someone else (not by
>> >> >> >>    my devlink instance) resets my firmware".
>> >> >> >>
>> >> >> >> Could you please split?
>> >> >> >>
>> >> >> >>
>> >> >> >> >------------------------
>> >> >> >> >
>> >> >> >> >Thanks,
>> >> >> >> >Vasundhara
>> >> >> >> >>
>> >> >> >> >> >
>> >> >> >> >> >Thanks,
>> >> >> >> >> >Vasundhara
>> >> >> >> >> >>
>> >> >> >> >> >>
>> >> >> >> >> >>
>> >> >> >> >> >> >+       system.
>> >> >> >> >> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >> >> >> >> >> >index 8ffc1b5c..488b61c 100644
>> >> >> >> >> >> >--- a/include/net/devlink.h
>> >> >> >> >> >> >+++ b/include/net/devlink.h
>> >> >> >> >> >> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
>> >> >> >> >> >> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
>> >> >> >> >> >> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
>> >> >> >> >> >> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
>> >> >> >> >> >> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >> >> >> >> >> >
>> >> >> >> >> >> >       /* add new param generic ids above here*/
>> >> >> >> >> >> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
>> >> >> >> >> >> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
>> >> >> >> >> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
>> >> >> >> >> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >> >> >> >> >> >
>> >> >> >> >> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
>> >> >> >> >> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >> >> >> >> >> >+
>> >> >> >> >> >> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> >> >> >> >> >> > {                                                                     \
>> >> >> >> >> >> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> >> >> >> >> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >> >> >> >> >> >index 7b76e5f..8544f23 100644
>> >> >> >> >> >> >--- a/net/core/devlink.c
>> >> >> >> >> >> >+++ b/net/core/devlink.c
>> >> >> >> >> >> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>> >> >> >> >> >> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
>> >> >> >> >> >> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
>> >> >> >> >> >> >       },
>> >> >> >> >> >> >+      {
>> >> >> >> >> >> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >> >> >> >> >> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
>> >> >> >> >> >> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
>> >> >> >> >> >> >+      },
>> >> >> >> >> >> > };
>> >> >> >> >> >> >
>> >> >> >> >> >> > static int devlink_param_generic_verify(const struct devlink_param *param)
>> >> >> >> >> >> >--
>> >> >> >> >> >> >1.8.3.1
>> >> >> >> >> >> >
