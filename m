Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BFE1E1A7A
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 06:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgEZErc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 00:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgEZErb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 00:47:31 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AAAC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 21:47:30 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id h4so1869954wmb.4
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 21:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b7l+Roz213G9HerxC3DpVZJyciTPwZ/8WTa7s9bt+jE=;
        b=ebotkvcpeNvni9wqEsGs1Xs3D82FFmkLWydaBGt8Oglqev+XCuW4NGByVcw+mqXwMT
         5TaUOtQ16pd5qsUXwDDYYUke0/tXCt9jSaqWQyJucV0xArP2GGfGCgJHNru00/H18beN
         SdqwZcjqqj8C2GKb23zQ/Z2Lop5vzBmNrolP5vC9VWT1La2fVo+Hir/1xOhz2l27MuEm
         a0UORXFVdj+3+MXZmSZk01lisyXa2byHNYJP4c7lqpb6fJNpgPsFK2CkeQ9fP+JjxAzo
         15ETMPLF1dyAWxQr2taj6/HqFFEVQPgMYichkZegJb0Ny/mAnajvXmzWmHb5wwvXjwB4
         gHZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b7l+Roz213G9HerxC3DpVZJyciTPwZ/8WTa7s9bt+jE=;
        b=phu72tjNER8K0eI2kjypIiUAgKts771VHCVPe9uYcdqgKLPQccSDJ9yUCKJQZxiRbk
         a952DJxO1YvWuCl/L20n+pLt/GF1fukYusTi+Vq9x5W1J9HcP+oZYrPQ3RlYKb0hs6us
         5l5zddYT6eMO/wL+y6LzJZm30eo+fU+fXFW77R1eL+6OymXlUNFD0JxZ4fIiEHxNnPvu
         Oyzf2sGGZULPkVgIKnEcOx53v2ZrIDXBiF46Y4lTigEJXXz02u/y1ckPWf+VWKEslCIl
         RFHYAR+v2diFRhDe3yPO4F+GKNzPcKV0iLPQ39f1E+7J/5pLkHYLzrZbsuTl6ccNuSd+
         rCdA==
X-Gm-Message-State: AOAM533HLxPlzpgkyppktCUHBtfmkaK6PcSXnfkCJgxcmaof+4BUGAq+
        MEloIRzSKCqsIR0uPhmylOcuuA==
X-Google-Smtp-Source: ABdhPJxBZ9vaerYFiF1MSGIO/77brMKhkutj+kWOQYi1ubswkRn/IU6ut3D0LKjIHy+9gnqnPlFFcQ==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr29412815wmj.118.1590468449039;
        Mon, 25 May 2020 21:47:29 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id z132sm21589812wmc.29.2020.05.25.21.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 21:47:28 -0700 (PDT)
Date:   Tue, 26 May 2020 06:47:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 net-next 1/4] devlink: Add new "allow_fw_live_reset"
 generic device parameter.
Message-ID: <20200526044727.GB14161@nanopsycho>
References: <1590214105-10430-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <1590214105-10430-2-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200524045335.GA22938@nanopsycho>
 <CAACQVJpbXSnf0Gc5HehFc6KzKjZU7dV5tY9cwR72pBhweVRkFw@mail.gmail.com>
 <20200525172602.GA14161@nanopsycho>
 <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpRrOSn2eLzS1z9rmATrmzA2aNG-9pcbn-1E+sQJ5ET_g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 26, 2020 at 06:28:59AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, May 25, 2020 at 10:56 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Sun, May 24, 2020 at 08:29:56AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Sun, May 24, 2020 at 10:23 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Sat, May 23, 2020 at 08:08:22AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >Add a new "allow_fw_live_reset" generic device bool parameter. When
>> >> >parameter is set, user is allowed to reset the firmware in real time.
>> >> >
>> >> >This parameter is employed to communicate user consent or dissent for
>> >> >the live reset to happen. A separate command triggers the actual live
>> >> >reset.
>> >> >
>> >> >Cc: Jiri Pirko <jiri@mellanox.com>
>> >> >Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> >> >Signed-off-by: Michael Chan <michael.chan@broadcom.com>
>> >> >---
>> >> >v2: Rename param name to "allow_fw_live_reset" from
>> >> >"enable_hot_fw_reset".
>> >> >Update documentation for the param in devlink-params.rst file.
>> >> >---
>> >> > Documentation/networking/devlink/devlink-params.rst | 6 ++++++
>> >> > include/net/devlink.h                               | 4 ++++
>> >> > net/core/devlink.c                                  | 5 +++++
>> >> > 3 files changed, 15 insertions(+)
>> >> >
>> >> >diff --git a/Documentation/networking/devlink/devlink-params.rst b/Documentation/networking/devlink/devlink-params.rst
>> >> >index d075fd0..ad54dfb 100644
>> >> >--- a/Documentation/networking/devlink/devlink-params.rst
>> >> >+++ b/Documentation/networking/devlink/devlink-params.rst
>> >> >@@ -108,3 +108,9 @@ own name.
>> >> >    * - ``region_snapshot_enable``
>> >> >      - Boolean
>> >> >      - Enable capture of ``devlink-region`` snapshots.
>> >> >+   * - ``allow_fw_live_reset``
>> >> >+     - Boolean
>> >> >+     - Firmware live reset allows users to reset the firmware in real time.
>> >> >+       For example, after firmware upgrade, this feature can immediately reset
>> >> >+       to run the new firmware without reloading the driver or rebooting the
>> >>
>> >> This does not tell me anything about the reset being done on another
>> >> host. You need to emhasize that, in the name of the param too.
>> >I am not sure if I completely understand your query.
>> >
>> >Reset is actually initiated by one of the PF/host of the device, which
>> >resets the entire same device.
>> >
>> >Reset is not initiated by any other remote device/host.
>>
>> Well, in case of multihost system, it might be, right?
>>
>In case of multi-host system also, it is one of the host that triggers
>the reset, which resets the entire same device. I don't think this is
>remote.
>
>As the parameter is a device parameter, it is applicable to the entire
>device. When a user initiates the reset from any of the host in case
>of multi-host and any of the PF in case of stand-alone or smartNIC
>device, the entire device goes for a reset.
>
>I will be expanding the description to the following to make it more clear.
>
>------------------------
>- Firmware live reset allows users to reset the firmware in real time.
>For example, after firmware upgrade, this feature can immediately
>reset to run the new firmware without reloading the driver or
>rebooting the system.
>When a user initiates the reset from any of the host (in case of
>multi-host system) / PF (in case of stand-alone or smartNIC device),
>the entire device goes for a reset when the parameter is enabled.

Sorry, this is still not clear. I think that you are mixing up two
different things:
1) option of devlink reload to indicate that user is interested in "live
   reset" of firmware without reloading driver
2) devlink param that would indicate "I am okay if someone else (not by
   my devlink instance) resets my firmware".

Could you please split?


>------------------------
>
>Thanks,
>Vasundhara
>>
>> >
>> >Thanks,
>> >Vasundhara
>> >>
>> >>
>> >>
>> >> >+       system.
>> >> >diff --git a/include/net/devlink.h b/include/net/devlink.h
>> >> >index 8ffc1b5c..488b61c 100644
>> >> >--- a/include/net/devlink.h
>> >> >+++ b/include/net/devlink.h
>> >> >@@ -406,6 +406,7 @@ enum devlink_param_generic_id {
>> >> >       DEVLINK_PARAM_GENERIC_ID_FW_LOAD_POLICY,
>> >> >       DEVLINK_PARAM_GENERIC_ID_RESET_DEV_ON_DRV_PROBE,
>> >> >       DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
>> >> >+      DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >> >
>> >> >       /* add new param generic ids above here*/
>> >> >       __DEVLINK_PARAM_GENERIC_ID_MAX,
>> >> >@@ -443,6 +444,9 @@ enum devlink_param_generic_id {
>> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME "enable_roce"
>> >> > #define DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >> >
>> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME "allow_fw_live_reset"
>> >> >+#define DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE DEVLINK_PARAM_TYPE_BOOL
>> >> >+
>> >> > #define DEVLINK_PARAM_GENERIC(_id, _cmodes, _get, _set, _validate)    \
>> >> > {                                                                     \
>> >> >       .id = DEVLINK_PARAM_GENERIC_ID_##_id,                           \
>> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
>> >> >index 7b76e5f..8544f23 100644
>> >> >--- a/net/core/devlink.c
>> >> >+++ b/net/core/devlink.c
>> >> >@@ -3011,6 +3011,11 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>> >> >               .name = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_NAME,
>> >> >               .type = DEVLINK_PARAM_GENERIC_ENABLE_ROCE_TYPE,
>> >> >       },
>> >> >+      {
>> >> >+              .id = DEVLINK_PARAM_GENERIC_ID_ALLOW_FW_LIVE_RESET,
>> >> >+              .name = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_NAME,
>> >> >+              .type = DEVLINK_PARAM_GENERIC_ALLOW_FW_LIVE_RESET_TYPE,
>> >> >+      },
>> >> > };
>> >> >
>> >> > static int devlink_param_generic_verify(const struct devlink_param *param)
>> >> >--
>> >> >1.8.3.1
>> >> >
