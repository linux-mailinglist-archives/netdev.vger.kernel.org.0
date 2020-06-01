Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A081EA18C
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgFAKI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAKI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:08:28 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA9CC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:08:28 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id q2so7363209ljm.10
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSVdPpdHshw3iP+x6s7Ml4fPp31t6oRVr9Y0IN83h0k=;
        b=Ljk9IxhI9uMho/PpdJQ3q+yX83elTVW1bEta54LUSSlTajXzoZMA0SBhM3OPv9xdv/
         fMK01cP4rojAhRxXDZUZcc4LaFYK2UgVfjKaKUTunLOSr7oYVh9odEUgnOovkWwHcEhj
         iISTbD/9P5SYsnWDhPTpFE13a6nxJoUAmnncg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSVdPpdHshw3iP+x6s7Ml4fPp31t6oRVr9Y0IN83h0k=;
        b=TEotLGSbvM9fKQbnw6VzckaShi0ornilf1777gNHRgR4/8ep5vRa+/VaZTC5TPfimK
         IAJ0o0fCA6k4TVl8U2ACUs09EEU7Olyjbi1yhYsiKKn5HD03Lmnf1YCxru447udpyFis
         n9flPCwaJi+jK3WynegUcM7hqjmay2BDqXpcpFsyY6zkbcJXwy7HFn0rfSAxY9O7Wd1G
         sO/TtbL78tq7gnvAgTBlj0BckXvLz8qxqZKpgLTt12XlTWbLQ7UilxP4PSdG/lrieV/a
         8W2UvLjrcEZ7SCCkiQrUAo3lPJTpjFAVfvZLMcwJCjIQy11VDwu4FiYJAblFiOLSn5fv
         /4Iw==
X-Gm-Message-State: AOAM533fx/l4XKcIsWlYQSfm4cq1kAZ8kY4I70zqooUQy5N+fsHTs6+C
        JFokrGAG1aDU3iYbIC3S5vEnJeIvx+ghZPtqenxdeg==
X-Google-Smtp-Source: ABdhPJzCSa9mSLsDHM8jeSdy9UT7CDhCjSbSJJYSNDKT5xGMteQjmsNVKy5AmD/dnJ1Ane/JUs5zIGPKfJyu7ZXSAqo=
X-Received: by 2002:a2e:7c02:: with SMTP id x2mr10667291ljc.316.1591006106373;
 Mon, 01 Jun 2020 03:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho> <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com> <20200601095217.GJ2282@nanopsycho>
In-Reply-To: <20200601095217.GJ2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 15:38:14 +0530
Message-ID: <CAACQVJr4eOkW9PQwZBxPN_jVz_+P94xTDJ0sMa1wi-8n_s=ghA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 1, 2020 at 3:22 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Jun 01, 2020 at 10:58:09AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
> >> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >> >>Live device reset capability allows the users to reset the device in real
> >> >>time. For example, after flashing a new firmware image, this feature allows
> >> >>a user to initiate the reset immediately from a separate command, to load
> >> >>the new firmware without reloading the driver or resetting the system.
> >> >>
> >> >>When device reset is initiated, services running on the host interfaces
> >> >>will momentarily pause and resume once reset is completed, which is very
> >> >>similar to momentary network outage.
> >> >>
> >> >>This patchset adds support for two new generic devlink parameters for
> >> >>controlling the live device reset capability and use it in the bnxt_en
> >> >>driver.
> >> >>
> >> >>Users can initiate the reset from a separate command, for example,
> >> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
> >> >>device.
> >> >>Where ethX or dev is any PF with administrative privileges.
> >> >>
> >> >>Patchset also updates firmware spec. to 1.10.1.40.
> >> >>
> >> >>
> >> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
> >> >
> >> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
> >> >attribute. I don't recall you telling any argument against it. I belive
> >> >that this should not be paramater. This is very tightly related to
> >> >reload, could you please have it as an attribute of reload, as I
> >> >suggested?
> >>
> >> I just wrote the thread to the previous version. I understand now why
> >> you need param as you require reboot to activate the feature.
> >
> >Okay.
> >>
> >> However, I don't think it is correct to use enable_live_dev_reset to
> >> indicate the live-reset capability to the user. Params serve for
> >> configuration only. Could you please move the indication some place
> >> else? ("devlink dev info" seems fitting).
> >
> >Here we are not indicating the support. If the parameter is set to
> >true, we are enabling the feature in firmware and driver after reboot.
> >Users can disable the feature by setting the parameter to false and
> >reboot. This is the configuration which is enabling or disabling the
> >feature in the device.
>
> You are talking about cmode permanent here. I'm talking about cmode
> runtime.
For cmode runtime, I have renamed it to "allow_live_dev_reset". As I
see the comment under "enable_live_dev_reset", I thought you are
talking about permanent cmode.

"allow_live_dev_reset" is runtime cmode, which will allow users to
disable the "live reset" feature temporarily. It just not only
indicate the support but user can configure it to control the "live
reset" at runtime.
>
>
> >
> >>
> >> I think that you can do the indication in a follow-up patchset. But
> >> please remove it from this one where you do it with params.
> >
> >Could you please see the complete patchset and use it bnxt_en driver
> >to get a clear picture? We are not indicating the support.
> >
> >Thanks.
> >
> >>
> >>
> >> >
> >> >Thanks!
> >> >
> >> >
> >> >>"allow_live_dev_reset".
> >> >>- Expand the documentation of each param and update commit messages
> >> >> accordingly.
> >> >>- Separated the permanent configuration mode code to another patch and
> >> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
> >> >>
> >> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
> >> >>- Update documentation files and commit messages with more details of the
> >> >> feature.
> >> >>
> >> >>Vasundhara Volam (6):
> >> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
> >> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
> >> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
> >> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
> >> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
> >> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
> >> >>
> >> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
> >> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> >> >> include/net/devlink.h                              |  8 +++
> >> >> net/core/devlink.c                                 | 10 ++++
> >> >> 10 files changed, 175 insertions(+), 36 deletions(-)
> >> >>
> >> >>--
> >> >>1.8.3.1
> >> >>
