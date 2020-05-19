Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8B1D9798
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgESNZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgESNZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:25:07 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87644C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:25:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so15897752wrt.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 06:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MvYmbEnhZhx5hj+5lgcXwkvaoizA0+CsDgGuVKUg/ig=;
        b=NKy3+wVgtQ5YWHcYSEn5EC8/bmjbg739piPaSD8sEd4PFCcxoGPrr1eyFqjTcg6GVG
         PbdC6fil8z4bwnEzxDGtzPuaYZGA1xgZ/58/r0cwwviwmf3PbjHlO7faOytgFD7BbEr7
         u7xViA1XjY1NfqDTiMgThihjzhE1aKbFMbZTwmHeFcf6wmWvXUt5gL1WSZLnZPsAzCW6
         qog024i2K207ktwQeZMlP9rzzHXwlSRreTQo19lSbd7rvj9y2qXcLLR0CbKtgb8OhetK
         uhytHP2BnjPQpK3Cnd1MfUbedbxGyDRoPG5g5jNVQuHgUxKTg/hIQRoPeyrourMF7AvU
         bjlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MvYmbEnhZhx5hj+5lgcXwkvaoizA0+CsDgGuVKUg/ig=;
        b=srSdwd1UApvzbj+/jOM7XmO0lh0vhnqnphe5y5uknZGSG1qYmoYCkTCBxMX/cAZaxg
         pRVYKkFtmsDX8D9XEpjOpMDSIESv6dzCfY+gHD2+z1mJz07NnR1k1dw5IXKe6xcXgCQT
         6JmKzqVcFwoPtymm+7EAgd+Yx0ESdTBCs9mCP+Z76tIVysqw7dXqtkW9GmKiQaFONqj5
         FoA2ivsJYz+C1ryhIr4J/atwY4vlS64CtoESwGRcwuhDiL66LqSL396W0c8uZyGbjyLU
         u6ccGO9u/47Yq/hjYMhJCHoXSz8egR9qQt/HdrXYCNtBGXhiCAoEDJQ05KbgKKrKRVoR
         YSqA==
X-Gm-Message-State: AOAM533iR57Y1utUk/3FEQ6TsLqOoieYjY5wGq+Vx8AkxDYfLonMFO2m
        dUZnNeV3cEZKX7zb8HbVzitwTozVzOY=
X-Google-Smtp-Source: ABdhPJyZ5bX7nxixJ3VTo5IKJvh1sZXpwsegsEP3SNAjAuzEycJHOIOSK1XfzpMpXsmhko6cd9tZnw==
X-Received: by 2002:adf:e511:: with SMTP id j17mr27867794wrm.204.1589894704297;
        Tue, 19 May 2020 06:25:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id m1sm23423746wrx.44.2020.05.19.06.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 06:25:03 -0700 (PDT)
Date:   Tue, 19 May 2020 15:25:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519132010.GH4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
 <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
 <20200519073032.GE4655@nanopsycho>
 <CACKFLinpyX-sgkOMQd=uEVZzn1-+doJoV-t5NRRNrcnE+=tR3A@mail.gmail.com>
 <20200519094132.GG4655@nanopsycho>
 <CAACQVJreEC+0XhLAXpY5iPYL3R=Vpd-Bs-YXjRBKapDvfvzcng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJreEC+0XhLAXpY5iPYL3R=Vpd-Bs-YXjRBKapDvfvzcng@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 12:50:14PM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Tue, May 19, 2020 at 3:11 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Tue, May 19, 2020 at 10:41:44AM CEST, michael.chan@broadcom.com wrote:
>> >On Tue, May 19, 2020 at 12:30 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Tue, May 19, 2020 at 07:43:01AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
>> >> >>
>> >> >> I don't follow, sorry. Could you be more verbose about what you are
>> >> >> trying to achieve here?
>> >> >As mentioned below, hot_fw_reset is a device capability similar to roce.
>> >> >Capability can be enabled or disabled on the device, if the device supports.
>> >> >When enabled and if supported firmware and driver are loaded, user can
>> >> >utilise the capability to fw_reset or fw_live_patch.
>> >>
>> >> I don't undestand what exactly is this supposed to enable/disable. Could
>> >> you be more specific?
>> >
>> >Let me see if I can help clarify.  Here's a little background.  Hot
>> >reset is a feature supported by the firmware and requires the
>> >coordinated support of all function drivers.  The firmware will only
>> >initiate this hot reset when all function drivers can support it.  For
>> >example, if one function is running a really old driver that doesn't
>> >support it, the firmware will not support this until this old driver
>> >gets unloaded or upgraded.  Until then, a PCI reset is needed to reset
>> >the firmware.
>> >
>> >Now, let's say one function driver that normally supports this
>> >firmware hot reset now wants to disable this feature.  For example,
>> >the function is running a mission critical application and does not
>> >want any hot firmware reset that may cause a hiccup during this time.
>> >It will use this devlink parameter to disable it.  When the critical
>> >app is done, it can then re-enable the parameter.  Of course other
>> >functions can also disable it and it is only enabled when all
>> >functions have enabled it.
>> >
>> >Hope this clarifies it.  Thanks.
>>
>> Okay. So this is about the "allowing to be reseted from the outside".
>> I see. For that I think it makes sense to have the devlink param.
>
>> However, I think that it would be fine to find more suitable name and
>> describe this properly in the docs.
>>
>I felt enable_hot_fw_reset is a self-descriptive name.
>
>But to make it more common, is the name enable_live_fw_reset good?
>or simply fw_reset?

I think it is important to emhasize that this setting is related to
"remote" reset.


>
>Thanks.
