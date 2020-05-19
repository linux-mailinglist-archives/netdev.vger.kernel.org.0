Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEBEE1D8F4D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgESFnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgESFnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:43:14 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ECBC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:43:14 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z18so4119810lji.12
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 22:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T6PyjHGNw0rF5Q2n//5tbl/g1x2mjsxnt8B1kRrCfUw=;
        b=c4qrwDKX+tWa8jA5sfPyFzIIXx8gw+wGU/zSATmv7WJV/PLPIxu6vZ91e+/4O7Wfq0
         gqpYdIODefbOidkq7X1khGuQIk0j1EKgLbmiK5rFDly0+o8EfVTAhqu1pM6FhiHTvWKy
         apNSredDB7cRrz/ca+q16rQ6t8dkCNnLa00jQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T6PyjHGNw0rF5Q2n//5tbl/g1x2mjsxnt8B1kRrCfUw=;
        b=Vi99iXPrY9VhitEsiyUHr/RXF49cXDcPVa7XSItGth8HThWnMZgGdQzZR5N1tlPCiA
         tjzqaOLvMtKWtZDqO8OKfqiBS806R+sT5fPk1FQAKCvU/EZNGUYFYdOsnWsOMiPwgHZW
         kxEGx/wmNYGwMr7nkk/zpgeU7vDORddgKPTezbXd0tqJfUBxHegW6H3BrAOEIxBWrQhJ
         PzfWXY61yfLPyPvwo1oxOCLQ99V5sGLFbTUk5iuUTkAHUWMFYfGtT3EKsmy+xriy3GWw
         Bo8N/Anq16eXEuRjcLcZabsV80AkQq0yLgnKw+f7CIVTCfFtfOrDxGdfLBqs9SsudWU9
         IAIg==
X-Gm-Message-State: AOAM5338PFw9wpxHylqGPeW2cE++C3FbJF+fpUTSroYY428eojVe90xH
        ToSL8PK1kaOHYA8jXH1/b8rZth9iqy8UVecqmDXY1De+oAU=
X-Google-Smtp-Source: ABdhPJz/G7ZrqynKbnysAvDmB/eRvCZHjMwRmYeAi6yEngAB86FA8mH6Aa01JfN5NTEbLPPEA6QxDtRaNYIPd/p28uw=
X-Received: by 2002:a2e:9b48:: with SMTP id o8mr4982072ljj.130.1589866992649;
 Mon, 18 May 2020 22:43:12 -0700 (PDT)
MIME-Version: 1.0
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho> <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho>
In-Reply-To: <20200519052745.GC4655@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 19 May 2020 11:13:01 +0530
Message-ID: <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, May 19, 2020 at 06:31:27AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Mon, May 18, 2020 at 4:31 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
> >> >parameter and use it in bnxt_en driver.
> >> >
> >> >Also, firmware spec. is updated to 1.10.1.40.
> >>
> >> Hi.
> >>
> >> We've been discussing this internally for some time.
> >> I don't like to use params for this purpose.
> >> We already have "devlink dev flash" and "devlink dev reload" commands.
> >> Combination of these two with appropriate attributes should provide what
> >> you want. The "param" you are introducing is related to either "flash"
> >> or "reload", so I don't think it is good to have separate param, when we
> >> can extend the command attributes.
> >>
> >> How does flash&reload work for mlxsw now:
> >>
> >> # devlink flash
> >> Now new version is pending, old FW is running
> >> # devlink reload
> >> Driver resets the device, new FW is loaded
> >>
> >> I propose to extend reload like this:
> >>
> >>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
> >>    driver-default - means one of following to, according to what is
> >>                     default for the driver
> >>    fw-reset - does FW reset and driver entities re-instantiation
> >>    driver-only - does driver entities re-instantiation only
> >>    fw-live-patch - does only FW live patching - no effect on kernel
> >>
> >> Could be an enum or bitfield. Does not matter. The point is to use
> >> reload with attribute to achieve what user wants. In your usecase, user
> >> would do:
> >>
> >> # devlink flash
> >> # devlink reload level fw-live-patch
> >
> >Jiri,
> >
> >I am adding this param to control the fw hot reset capability of the device.
>
> I don't follow, sorry. Could you be more verbose about what you are
> trying to achieve here?
As mentioned below, hot_fw_reset is a device capability similar to roce.
Capability can be enabled or disabled on the device, if the device supports.
When enabled and if supported firmware and driver are loaded, user can
utilise the capability to fw_reset or fw_live_patch.

So, we need a policy to enable/disable the capability.

Thanks.
>
> >Permanent configuration mode will toggle the NVM config space which is
> >very similar to enable_roce/enable_sriov param and runtime configuration
> >mode will toggle the driver level knob to avoid/allow fw-live-reset.
> >
> >From above. I see that you are suggesting how to trigger the fw hot reset.
> >This is good to have, but does not serve the purpose of enabling or disabling
> >of the feature. Our driver is currently using "ethtool --reset" for
> >triggering fw-reset
> >or fw-live-patch.
> >
> >Thanks,
> >Vasundhara
