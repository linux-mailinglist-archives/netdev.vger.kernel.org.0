Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9381EA13A
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 11:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFAJwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 05:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgFAJwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 05:52:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F0DC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 02:52:19 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u13so10094060wml.1
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 02:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MxxwihvRIHXHw7VEIbotyABtTO8x8zlaFesGqEjOcXU=;
        b=Soh1Qvo6acHWZ3Moo+mcwofTjToXV0cNt1rDzJymIecSk3eQc2fEJRUR4i32udfxAh
         KVyDKKg/7iTNFo7BHPXmEYkC1oqycjoIV0TCEb/Ppt/juZrpgvLMcseV+odPKPJFxdoc
         D2Y5PIaimhZc8DzhL4L2A0oi/meyCtRQ1sLgQGtvaLuD2b9UZXTN1GGiaBHBKzjJ1NoJ
         /D6UdoGyTqdI6f4PB45A0Qb93HtJXH6QQvZVE7dLFAKt0xTueWw/EYKpmH0+u51pNdYm
         iZRyNua2OL9vDdqVZIK1c8g2HzsGqfz0QSHu4WmZWJoX7ZMbrWmaseVA1hpEyW1k4Doh
         jpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MxxwihvRIHXHw7VEIbotyABtTO8x8zlaFesGqEjOcXU=;
        b=B/v7g5jCcAry1mDWVF5eK/LS9dmw5Zd5U+AGXrPtif/SxSLl4qOIILdFFDsfx1nitM
         2NIiSxNpdaKFJoiutPrUEBVTaJhYLJlVQ25gTHVp8a626Vex9EGFBgfc9gGIZTqFtiZh
         4IFhgEAsquTWERPQgRnv/TvxyUQcHgO46NPlKzEpotnN4VlcjhcVel1q0+NCD0QmdzY+
         XdP3SkGW2KNbGh0vAa4lxvNTKUCX03zEAHgQUwHIoHoHr7jeslcnEBhxayJDf7s0DWB8
         EKP8vxmcPorPbspghDfvMC1cEyNrxCPmSe+qNP9JRlN69JtwS5mnMtldzItuOfC6rF+x
         LYiw==
X-Gm-Message-State: AOAM533pa0bJ51msVErkmp+QKrm6F442uSD1JEmYBaSjPEtTh3JyaiSc
        KXwVDFCaGRl5HOYKdcb3kWWRJA==
X-Google-Smtp-Source: ABdhPJxAGYOU6xT75JIccIn1zoxrIjDC/gJbGmIYenPK5YFbV1fv5zeExROOw0qryAEP2wgSr8Bl+A==
X-Received: by 2002:a05:600c:2294:: with SMTP id 20mr15223502wmf.51.1591005138592;
        Mon, 01 Jun 2020 02:52:18 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id d2sm19762862wrs.95.2020.06.01.02.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 02:52:17 -0700 (PDT)
Date:   Mon, 1 Jun 2020 11:52:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601095217.GJ2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho>
 <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 10:58:09AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
>> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >>Live device reset capability allows the users to reset the device in real
>> >>time. For example, after flashing a new firmware image, this feature allows
>> >>a user to initiate the reset immediately from a separate command, to load
>> >>the new firmware without reloading the driver or resetting the system.
>> >>
>> >>When device reset is initiated, services running on the host interfaces
>> >>will momentarily pause and resume once reset is completed, which is very
>> >>similar to momentary network outage.
>> >>
>> >>This patchset adds support for two new generic devlink parameters for
>> >>controlling the live device reset capability and use it in the bnxt_en
>> >>driver.
>> >>
>> >>Users can initiate the reset from a separate command, for example,
>> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
>> >>device.
>> >>Where ethX or dev is any PF with administrative privileges.
>> >>
>> >>Patchset also updates firmware spec. to 1.10.1.40.
>> >>
>> >>
>> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
>> >
>> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
>> >attribute. I don't recall you telling any argument against it. I belive
>> >that this should not be paramater. This is very tightly related to
>> >reload, could you please have it as an attribute of reload, as I
>> >suggested?
>>
>> I just wrote the thread to the previous version. I understand now why
>> you need param as you require reboot to activate the feature.
>
>Okay.
>>
>> However, I don't think it is correct to use enable_live_dev_reset to
>> indicate the live-reset capability to the user. Params serve for
>> configuration only. Could you please move the indication some place
>> else? ("devlink dev info" seems fitting).
>
>Here we are not indicating the support. If the parameter is set to
>true, we are enabling the feature in firmware and driver after reboot.
>Users can disable the feature by setting the parameter to false and
>reboot. This is the configuration which is enabling or disabling the
>feature in the device.

You are talking about cmode permanent here. I'm talking about cmode
runtime.


>
>>
>> I think that you can do the indication in a follow-up patchset. But
>> please remove it from this one where you do it with params.
>
>Could you please see the complete patchset and use it bnxt_en driver
>to get a clear picture? We are not indicating the support.
>
>Thanks.
>
>>
>>
>> >
>> >Thanks!
>> >
>> >
>> >>"allow_live_dev_reset".
>> >>- Expand the documentation of each param and update commit messages
>> >> accordingly.
>> >>- Separated the permanent configuration mode code to another patch and
>> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
>> >>
>> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
>> >>- Update documentation files and commit messages with more details of the
>> >> feature.
>> >>
>> >>Vasundhara Volam (6):
>> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
>> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
>> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
>> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
>> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
>> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
>> >>
>> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
>> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
>> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
>> >> include/net/devlink.h                              |  8 +++
>> >> net/core/devlink.c                                 | 10 ++++
>> >> 10 files changed, 175 insertions(+), 36 deletions(-)
>> >>
>> >>--
>> >>1.8.3.1
>> >>
