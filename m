Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7BB1EA6EA
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFAPb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 11:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgFAPb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 11:31:56 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E5C05BD43
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 08:31:55 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d7so4143666lfi.12
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 08:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i3satfxDYarNtRU6OdeukkiPiFfuOanYtkaipLLncFI=;
        b=RhQ4Abf9IsqRdBx1wUfOlDgMBdJ+tc7vbMdjM3x5d6xCa4VF9h2XUEMDn0p8dtWhlv
         zMr7/Q1Le35QZl/tS8Og3YvPK4s/ehQnoCb3U23z3+I0Iz415OYekGbU9yauZtKndOqo
         QmDz0k91LZFfDT73E3iO1sQ8lgLruowGhwkx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i3satfxDYarNtRU6OdeukkiPiFfuOanYtkaipLLncFI=;
        b=InlIR4PovUEqdm0NOHMx7oJUNM8uLEsSdGYvviTbOpuOl709eu8IHhxxKC5Y0SH3UA
         hSTvFUQ2IfssoG0a1szhF65NUPhPG53PfFo+X/T50mtXaYr1+ADxIyV/ypU3RcrkLVKp
         ieI8zGoT+VkHKne0XSFoMo69UJPt2dCXSIlJglpJase0j+etG6zA3IrkxRTsO/ssTZmO
         zEkeHLqfRNP/y1Qj3X//Mm3LTXcdiYG/ZWi9l3sycKb1CT8mZpnOvIjl997mEj4BAc+6
         GpfLq5UkqOs7jXN91aj16nIZpucz6zjXvQ0EVTzGpFaMGEz00ruvH4weLde7J1eC/LwL
         K0VQ==
X-Gm-Message-State: AOAM532eOMtJeZJnnSFUud/Bg9D9qDrz4SLyUR8V5gSGIEl5SYGycqRn
        M0tw10WBVZ4eSMOwrKDOZwDQBvnOl01hzLNLuP12uw==
X-Google-Smtp-Source: ABdhPJwqQxXvLn1vupZM0ieQM8Q6pevrJrsUD9y0KfReR2hNo8S784bAKx/QODnQwS64AReKFS8Ct+suSOb7xwETAZo=
X-Received: by 2002:a19:7e15:: with SMTP id z21mr11674031lfc.103.1591025513838;
 Mon, 01 Jun 2020 08:31:53 -0700 (PDT)
MIME-Version: 1.0
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho> <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com> <20200601100411.GL2282@nanopsycho>
In-Reply-To: <20200601100411.GL2282@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 1 Jun 2020 21:01:42 +0530
Message-ID: <CAACQVJomhn1p2L=ZQakwSRXAci2oK0EG0HQsTVhRz6NLFZEHqw@mail.gmail.com>
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

On Mon, Jun 1, 2020 at 3:34 PM Jiri Pirko <jiri@resnulli.us> wrote:
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
> >
> >>
> >> I think that you can do the indication in a follow-up patchset. But
> >> please remove it from this one where you do it with params.
> >
> >Could you please see the complete patchset and use it bnxt_en driver
> >to get a clear picture? We are not indicating the support.
>
> Right. I see.
>
> There is still one thing that I see problematic. There is no clear
> semantics on when the "live fw update" is going to be performed. You
> enable the feature in NVRAM and you set to "allow" it from all the host.
> Now the user does reset, the driver has 2 options:
> 1) do the live fw reset
> 2) do the ordinary fw reset
>
> This specification is missing and I believe it should be part of this
> patchset, otherwise the behaviour might not be deterministic between
> drivers and driver versions.

I see, this makes sense. It takes little time for me to extend
"devlink dev reload". I will spend time on it and send the next
version with 'devlink dev reload' patches included.

>
> I think that the legacy ethtool should stick with the "ordinary fw reset",
> becase that is what user expects. You should add an attribute to
> "devlink dev reload" to trigger the "live fw reset"

Okay.

I am planning to add a type field with "driver-only | fw-reset |
live-fw-reset | live-fw-patch" to "devlink dev reload" command.

driver-only - Resets host driver instance of the 'devlink dev'
(current behaviour). This will be default, if the user does not
provide the type option.
fw-reset - Initiate the reset command for the currently running
firmware and wait for the driver reload for completing the reset.
(This is similar to the legacy "ethtool --reset all" command).
live-fw-reset - Resets the currently running firmware and driver entities.
live-fw-patch - Loads the currently pending flashed firmware and
reloads all driver entities. If no pending flashed firmware, resets
currently loaded firmware.

Thanks.
>
>
>
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
