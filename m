Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8982D1D9116
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgESHaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 03:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgESHaf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 03:30:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175FBC061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:30:35 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f134so1941394wmf.1
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 00:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=75kjOhwcBeyDdAl6p+9aXDIULdp0927c7hM4LOyhKak=;
        b=l+vwzsmvGLirND5yyVVuIgzIh5pOuAs8WJEiliaTomEy95tzfgDNBws5qqt7fcZH2A
         KHY/DSdNoMTY6comvV0RilTEvTENSr3Rf/7xYX/e+FRf8B7kBCtQXnyVIzMc0NKJdchQ
         AM0x2tv+nSR2bnKOf6TlKOsqHhUnMLgL5WX2XFfvBgOJ6EVhyijVpqreg2ASTfR3Yoh8
         zWzOwmFZSCgkIMmgASS+3ycwG1X9b5cgmu7uFwf/bWZd2ipt572FtnfeDfb4wq8eQh74
         cZ/EZQBkKeUVoezAaHr8dT2wisdcOifwoxANu1SYkDvVw3E7CA/7ts/OeoeET6lAZQoO
         l7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=75kjOhwcBeyDdAl6p+9aXDIULdp0927c7hM4LOyhKak=;
        b=KsYn0gsw+hqsppMzta6WzT04CTI0CS2UHRTU2kPwN6KNnysF7UfT1Py6CpGkyogtPE
         6Rp24MKYYjbGX1ixJ3vqU4Uvv1TMXBqwapxXqo8ol4OWx2pRx+IYkzKhWQQbcboHuIEs
         cYrZ96FmrWEREnGVlzGWQoliss0iNtbjevwXkHtJYjT59T21dyZRMhG2GgLFTB7gNYT3
         98jJCmoEElf5ptVZdV7WKSewt8ROwslfZXZqH9Jrx5KVxG5Ew7TIMulblEkHNcXqSou2
         i5cMkCS1NW6RVnfiP5fJOtlmA6mbidiixMmYajLtVKKCDNlZnHDCM8zc4HGUU/FCdjHu
         zyDg==
X-Gm-Message-State: AOAM5334Jqa1AMm40XRHncdCFoOk440Gg6EZI2GJUoBW1oOzBODWi3GL
        6iinF87JHq3iBgdrlMGxgeJc3A==
X-Google-Smtp-Source: ABdhPJy4QWjjY07i8DDZKs2V+QrgAG2YOrCehxak2+LY0+q6/h8Wk5fMaLLs4iAT+jbFHiRfGeqPsQ==
X-Received: by 2002:a1c:a74a:: with SMTP id q71mr3713691wme.23.1589873433856;
        Tue, 19 May 2020 00:30:33 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i4sm15237777wrv.23.2020.05.19.00.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 00:30:33 -0700 (PDT)
Date:   Tue, 19 May 2020 09:30:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
Message-ID: <20200519073032.GE4655@nanopsycho>
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
 <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
 <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, May 19, 2020 at 07:43:01AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Tue, May 19, 2020 at 06:31:27AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Mon, May 18, 2020 at 4:31 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
>> >> >parameter and use it in bnxt_en driver.
>> >> >
>> >> >Also, firmware spec. is updated to 1.10.1.40.
>> >>
>> >> Hi.
>> >>
>> >> We've been discussing this internally for some time.
>> >> I don't like to use params for this purpose.
>> >> We already have "devlink dev flash" and "devlink dev reload" commands.
>> >> Combination of these two with appropriate attributes should provide what
>> >> you want. The "param" you are introducing is related to either "flash"
>> >> or "reload", so I don't think it is good to have separate param, when we
>> >> can extend the command attributes.
>> >>
>> >> How does flash&reload work for mlxsw now:
>> >>
>> >> # devlink flash
>> >> Now new version is pending, old FW is running
>> >> # devlink reload
>> >> Driver resets the device, new FW is loaded
>> >>
>> >> I propose to extend reload like this:
>> >>
>> >>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
>> >>    driver-default - means one of following to, according to what is
>> >>                     default for the driver
>> >>    fw-reset - does FW reset and driver entities re-instantiation
>> >>    driver-only - does driver entities re-instantiation only
>> >>    fw-live-patch - does only FW live patching - no effect on kernel
>> >>
>> >> Could be an enum or bitfield. Does not matter. The point is to use
>> >> reload with attribute to achieve what user wants. In your usecase, user
>> >> would do:
>> >>
>> >> # devlink flash
>> >> # devlink reload level fw-live-patch
>> >
>> >Jiri,
>> >
>> >I am adding this param to control the fw hot reset capability of the device.
>>
>> I don't follow, sorry. Could you be more verbose about what you are
>> trying to achieve here?
>As mentioned below, hot_fw_reset is a device capability similar to roce.
>Capability can be enabled or disabled on the device, if the device supports.
>When enabled and if supported firmware and driver are loaded, user can
>utilise the capability to fw_reset or fw_live_patch.

I don't undestand what exactly is this supposed to enable/disable. Could
you be more specific?


>
>So, we need a policy to enable/disable the capability.
>
>Thanks.
>>
>> >Permanent configuration mode will toggle the NVM config space which is
>> >very similar to enable_roce/enable_sriov param and runtime configuration
>> >mode will toggle the driver level knob to avoid/allow fw-live-reset.
>> >
>> >From above. I see that you are suggesting how to trigger the fw hot reset.
>> >This is good to have, but does not serve the purpose of enabling or disabling
>> >of the feature. Our driver is currently using "ethtool --reset" for
>> >triggering fw-reset
>> >or fw-live-patch.
>> >
>> >Thanks,
>> >Vasundhara
