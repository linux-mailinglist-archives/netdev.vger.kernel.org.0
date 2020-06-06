Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33E1F06EE
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 16:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgFFOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgFFOTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 10:19:01 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD111C03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 07:19:00 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z9so15181643ljh.13
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 07:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V108OYMbGpWR6PQp7ms723oZnGbBzvpm2tMsEtoJSvU=;
        b=Ni3Ey7mTEgim4Lw/G1VfX87M2VzBi/OG4ZI2DYLipKMtLH8GVsDSXm/aiS/BAlrX9a
         gbhw2otagN6EKnSQzHfTbSzwmuXvJcWHYGZRfVgR1uRCM16nXxX2Htp4DoWuSUNZppAk
         yrh3nmd2o6QI+OwKOfobxvWpl4f2P7AaKw1To=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V108OYMbGpWR6PQp7ms723oZnGbBzvpm2tMsEtoJSvU=;
        b=NXvDIWpy7Kv+6+P/c8PDGX+kUg5XCCzlRvzj9IpfI+bWbOSFtvsGmYyXlIO6o+mjw1
         BXtc06aIIkiU9eacTWFehMilVXhPq8oMSdNAoXY/QCVZtvfJ6sIcrSuxzG3I351oBvCT
         oG5eiS600SpVJDwcoN6ay6aTzBsB3pE+N+eHpht0qOAi4u+fbNBjbfhduGqPdWjX2t3h
         YDzH7JS4Bz4HBBwHef98gu8jsJ1X1M538QLSSBPqvjtdMP7q0pUyKZzJgA+BToVh3Qj2
         g7CeIR5icE34d2P/f5EWjCN+spuMcRgy49B6W/+3hhLKQGhM/DkvL6dWUO42QgmQKMx/
         yz+w==
X-Gm-Message-State: AOAM533Wc7nlUycGUxUsBDZwqXVHSChJ/MyYfT4zaooZivutua1dpN3t
        PnjVh77rd8Jq1Z4si8Y1fZ1XecdNuvXhOpcFBceuvA==
X-Google-Smtp-Source: ABdhPJyc7Sf93/otKsSgD4fd38yO54utwjHEo+CjQEOoEt6ZgVwmRyOxVAPOlibi2UbeXIR9JjeOIoLO7VxYgMrerlc=
X-Received: by 2002:a2e:9d48:: with SMTP id y8mr4191374ljj.419.1591453138766;
 Sat, 06 Jun 2020 07:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho> <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
 <20200601100411.GL2282@nanopsycho> <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
In-Reply-To: <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Sat, 6 Jun 2020 19:48:47 +0530
Message-ID: <CAACQVJqf+Kfg+eat9FR-qBEFbkMBHESwdr6RMX+k=FrYuMmS0A@mail.gmail.com>
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

On Mon, Jun 1, 2020 at 9:01 PM Vasundhara Volam
<vasundhara-v.volam@broadcom.com> wrote:
>
> On Mon, Jun 1, 2020 at 3:34 PM Jiri Pirko <jiri@resnulli.us> wrote:
> >
> > Mon, Jun 01, 2020 at 10:58:09AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
> > >>
> > >> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
> > >> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
> > >> >>Live device reset capability allows the users to reset the device in real
> > >> >>time. For example, after flashing a new firmware image, this feature allows
> > >> >>a user to initiate the reset immediately from a separate command, to load
> > >> >>the new firmware without reloading the driver or resetting the system.
> > >> >>
> > >> >>When device reset is initiated, services running on the host interfaces
> > >> >>will momentarily pause and resume once reset is completed, which is very
> > >> >>similar to momentary network outage.
> > >> >>
> > >> >>This patchset adds support for two new generic devlink parameters for
> > >> >>controlling the live device reset capability and use it in the bnxt_en
> > >> >>driver.
> > >> >>
> > >> >>Users can initiate the reset from a separate command, for example,
> > >> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
> > >> >>device.
> > >> >>Where ethX or dev is any PF with administrative privileges.
> > >> >>
> > >> >>Patchset also updates firmware spec. to 1.10.1.40.
> > >> >>
> > >> >>
> > >> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
> > >> >
> > >> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
> > >> >attribute. I don't recall you telling any argument against it. I belive
> > >> >that this should not be paramater. This is very tightly related to
> > >> >reload, could you please have it as an attribute of reload, as I
> > >> >suggested?
> > >>
> > >> I just wrote the thread to the previous version. I understand now why
> > >> you need param as you require reboot to activate the feature.
> > >
> > >Okay.
> > >>
> > >> However, I don't think it is correct to use enable_live_dev_reset to
> > >> indicate the live-reset capability to the user. Params serve for
> > >> configuration only. Could you please move the indication some place
> > >> else? ("devlink dev info" seems fitting).
> > >
> > >Here we are not indicating the support. If the parameter is set to
> > >true, we are enabling the feature in firmware and driver after reboot.
> > >Users can disable the feature by setting the parameter to false and
> > >reboot. This is the configuration which is enabling or disabling the
> > >feature in the device.
> > >
> > >>
> > >> I think that you can do the indication in a follow-up patchset. But
> > >> please remove it from this one where you do it with params.
> > >
> > >Could you please see the complete patchset and use it bnxt_en driver
> > >to get a clear picture? We are not indicating the support.
> >
> > Right. I see.
> >
> > There is still one thing that I see problematic. There is no clear
> > semantics on when the "live fw update" is going to be performed. You
> > enable the feature in NVRAM and you set to "allow" it from all the host.
> > Now the user does reset, the driver has 2 options:
> > 1) do the live fw reset
> > 2) do the ordinary fw reset
> >
> > This specification is missing and I believe it should be part of this
> > patchset, otherwise the behaviour might not be deterministic between
> > drivers and driver versions.
>
> I see, this makes sense. It takes little time for me to extend
> "devlink dev reload". I will spend time on it and send the next
> version with 'devlink dev reload' patches included.
>
> >
> > I think that the legacy ethtool should stick with the "ordinary fw reset",
> > becase that is what user expects. You should add an attribute to
> > "devlink dev reload" to trigger the "live fw reset"
>
> Okay.
>
> I am planning to add a type field with "driver-only | fw-reset |
> live-fw-reset | live-fw-patch" to "devlink dev reload" command.
>
> driver-only - Resets host driver instance of the 'devlink dev'
> (current behaviour). This will be default, if the user does not
> provide the type option.
> fw-reset - Initiate the reset command for the currently running
> firmware and wait for the driver reload for completing the reset.
> (This is similar to the legacy "ethtool --reset all" command).
> live-fw-reset - Resets the currently running firmware and driver entities.
> live-fw-patch - Loads the currently pending flashed firmware and
> reloads all driver entities. If no pending flashed firmware, resets
> currently loaded firmware.
I take back my proposal after taking a closer look at 'devlink dev
reload' implementation. 'devlink dev reload' is a synchronous
mechanism, which calls the reload_down and reload_up similar to remove
and probe callbacks respectively, per my understanding. This is not
what 'ethtool --reset' does.

'ethtool --reset' invokes driver callback, which in turn issues a
firmware command for reset.

We need to either extend ethtool for users to provide additional
entire-sled depth and type of reset as live/no-live. Or add a new
devlink command for fw-reset and add fallback to ethtool from there.

Thanks.
>
> Thanks.
> >
> >
> >
> > >
> > >Thanks.
> > >
> > >>
> > >>
> > >> >
> > >> >Thanks!
> > >> >
> > >> >
> > >> >>"allow_live_dev_reset".
> > >> >>- Expand the documentation of each param and update commit messages
> > >> >> accordingly.
> > >> >>- Separated the permanent configuration mode code to another patch and
> > >> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
> > >> >>
> > >> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
> > >> >>- Update documentation files and commit messages with more details of the
> > >> >> feature.
> > >> >>
> > >> >>Vasundhara Volam (6):
> > >> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
> > >> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
> > >> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
> > >> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
> > >> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
> > >> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
> > >> >>
> > >> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
> > >> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> > >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> > >> >> include/net/devlink.h                              |  8 +++
> > >> >> net/core/devlink.c                                 | 10 ++++
> > >> >> 10 files changed, 175 insertions(+), 36 deletions(-)
> > >> >>
> > >> >>--
> > >> >>1.8.3.1
> > >> >>
