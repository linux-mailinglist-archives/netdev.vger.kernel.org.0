Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF6B1D9246
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbgESIl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgESIl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:41:57 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05456C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:41:57 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id m44so10463528qtm.8
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 01:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6l0Y+pGPMSeZgXGGg9YMkqz+VDATVhpHze7oVIcNjEE=;
        b=JGcznu9GbmYfI2ycAf+0xQJv5nP8xplGOHYd029gugc5lS3Lt7KbZgAOSYI8EX0iMe
         VPspxgVo6myadPeK/6qOvycyQUyzYbaSsL+Hz3YKfvCtcp7iSgK4EONDgrscG6i9lIMw
         UnSJexnrems4V0rgo/nckaJuLrP6Mr2qz04Ls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6l0Y+pGPMSeZgXGGg9YMkqz+VDATVhpHze7oVIcNjEE=;
        b=kZrDeUPqHEURLIU1SwRWJgGHbbRlkDoqupFDdhG7C35kiv6699jC+grukp4Qa+skst
         oBNnvwI4+Rpgm8idOhE/aQrmoj/KXBUhdVM4hbvCY5frXIMiOeM8RYZ7uQ5w5Ifv/TGw
         OA//9JbTZNnW3JBeJb0c5g6fgm87bEOMR6iIctpOT44oLlGCF9qklRBNG50Zxg2H6tVc
         RNfAb4dSLnjspU3N5oI6tCKMCrqpkKckB7h4tegxtP7Md48HYnwxbsUppFRB58nvFu16
         pwZWUJRM1PQAMVOxuc0yippoASnHOHvWBcaZRCZCSjgwHxiAIWU1Ym19u5AE772uoZBg
         N2Eg==
X-Gm-Message-State: AOAM531EoJEqRtO5dcnK6WPTcZ2sEcEqcppn6BfTpnsEI0F7/R7waizt
        B8MQk/h2kG9+zx4YLPR8HLWTDZx2nHOj6coMUSLTMd6m
X-Google-Smtp-Source: ABdhPJzUJQDuIVb+G7xstgdx+RcN+EMDV80p7sVZni9f/uGg/fedYPi0t/97iY58dNsHVJ0cjbp3gGR65k0UQQBMqN0=
X-Received: by 2002:ac8:3292:: with SMTP id z18mr19801328qta.32.1589877716181;
 Tue, 19 May 2020 01:41:56 -0700 (PDT)
MIME-Version: 1.0
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho> <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
 <20200519052745.GC4655@nanopsycho> <CAACQVJpAYuJJC3tyBkhYkLVQYypuaWEPk_+NhSncAUg2g7h5SQ@mail.gmail.com>
 <20200519073032.GE4655@nanopsycho>
In-Reply-To: <20200519073032.GE4655@nanopsycho>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Tue, 19 May 2020 01:41:44 -0700
Message-ID: <CACKFLinpyX-sgkOMQd=uEVZzn1-+doJoV-t5NRRNrcnE+=tR3A@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 12:30 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, May 19, 2020 at 07:43:01AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Tue, May 19, 2020 at 10:57 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> I don't follow, sorry. Could you be more verbose about what you are
> >> trying to achieve here?
> >As mentioned below, hot_fw_reset is a device capability similar to roce.
> >Capability can be enabled or disabled on the device, if the device supports.
> >When enabled and if supported firmware and driver are loaded, user can
> >utilise the capability to fw_reset or fw_live_patch.
>
> I don't undestand what exactly is this supposed to enable/disable. Could
> you be more specific?

Let me see if I can help clarify.  Here's a little background.  Hot
reset is a feature supported by the firmware and requires the
coordinated support of all function drivers.  The firmware will only
initiate this hot reset when all function drivers can support it.  For
example, if one function is running a really old driver that doesn't
support it, the firmware will not support this until this old driver
gets unloaded or upgraded.  Until then, a PCI reset is needed to reset
the firmware.

Now, let's say one function driver that normally supports this
firmware hot reset now wants to disable this feature.  For example,
the function is running a mission critical application and does not
want any hot firmware reset that may cause a hiccup during this time.
It will use this devlink parameter to disable it.  When the critical
app is done, it can then re-enable the parameter.  Of course other
functions can also disable it and it is only enabled when all
functions have enabled it.

Hope this clarifies it.  Thanks.
