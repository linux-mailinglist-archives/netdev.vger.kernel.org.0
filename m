Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC11EA1D6
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 12:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgFAK1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 06:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgFAK1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 06:27:06 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6F6C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 03:27:05 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u26so11741259wmn.1
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 03:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rk2IVhYVqt+2QYtzczCn8zapBxX7Up+X6vGfVFI+B4I=;
        b=cQaVpDdD2JS7WdcTACnHC/+MLv+nS0HX+TkHtP0QNkZZJHswkVnzcQvPYWRtkCHUgj
         xIJDdc+VYaP0mvaidvVT4sNn02V2XpTTRldBwGMyhYDv6DDwg57dW1cuC93P4eoFt2JS
         P9oDtdJe3rgHkre8xdiy6x9XjJyKiPEucsylfVrgcWT2Up01CLXbqx8PJ7eWVBIROSf7
         fKrHZOhpC8nY0A2g4lxq/pilsNjB3CC/lMrrsYV/kUAVCW9fcleQb/1Ypa+MmHRCsMoo
         GRmKnUZ+GdXb/VZBKTmPLpQ51BckVh/QezZpmgsITbsdSTErGzdCMPYmKvs8fTwfFI3d
         1XPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rk2IVhYVqt+2QYtzczCn8zapBxX7Up+X6vGfVFI+B4I=;
        b=ggONMwwWBIHZR/Um8dWpQn0UUA/wXx6hq4hq8EKVPFygkfFPXPySyKUTKuHQHb+xTA
         9e+W1gnBBByBGIqZrt2rIAntZEiTZJiChWV7TJzQscJVnnXWf9dmlNH+gms2h+uUsWzC
         QLarniqAylniOnFjpXQ7Yze6HeB2ePlUoBQwFEv5gZP+s3XuAu3oJIHXxi8UY+YsfNVP
         jD1cO1tJTLJ1h9Oj+rYHJnFlfClRLt67CEZmyAD/hCSBoTfNMyIVWSbl4Sw6kPi14g1V
         IG9GdznSCRwi4uT3KUt/DUKIFS/KhofCxN4lFKWfBkaeDX/2AXAQfl7ibIiFKBvaxO4/
         1m+g==
X-Gm-Message-State: AOAM533SKFgkS+UVt8HoLLXTNNLyyYMlPy+lWL8Bem3kNdJ7aSAun5z9
        rZDbAT6oLzc2C+LqBldo/lTEP/KaDU8=
X-Google-Smtp-Source: ABdhPJxJ6Ks3W+npuSt2a4R1mKqj/0j1BTZc6lwCn9hMolpk4Pqi1BsPimonYhhltzqXbiBPbKFfoQ==
X-Received: by 2002:a7b:c3c6:: with SMTP id t6mr13112658wmj.159.1591007224468;
        Mon, 01 Jun 2020 03:27:04 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id b201sm9644362wmb.36.2020.06.01.03.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 03:27:04 -0700 (PDT)
Date:   Mon, 1 Jun 2020 12:27:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601102703.GO2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho>
 <20200601064323.GF2282@nanopsycho>
 <CAACQVJoW9TcTkKgzAhoz=ejr693JyBzUzOK75GhFrxPTYOkAaw@mail.gmail.com>
 <20200601095217.GJ2282@nanopsycho>
 <CAACQVJr4eOkW9PQwZBxPN_jVz_+P94xTDJ0sMa1wi-8n_s=ghA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJr4eOkW9PQwZBxPN_jVz_+P94xTDJ0sMa1wi-8n_s=ghA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 12:08:14PM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Jun 1, 2020 at 3:22 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Mon, Jun 01, 2020 at 10:58:09AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >On Mon, Jun 1, 2020 at 12:13 PM Jiri Pirko <jiri@resnulli.us> wrote:
>> >>
>> >> Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
>> >> >Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>> >> >>Live device reset capability allows the users to reset the device in real
>> >> >>time. For example, after flashing a new firmware image, this feature allows
>> >> >>a user to initiate the reset immediately from a separate command, to load
>> >> >>the new firmware without reloading the driver or resetting the system.
>> >> >>
>> >> >>When device reset is initiated, services running on the host interfaces
>> >> >>will momentarily pause and resume once reset is completed, which is very
>> >> >>similar to momentary network outage.
>> >> >>
>> >> >>This patchset adds support for two new generic devlink parameters for
>> >> >>controlling the live device reset capability and use it in the bnxt_en
>> >> >>driver.
>> >> >>
>> >> >>Users can initiate the reset from a separate command, for example,
>> >> >>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
>> >> >>device.
>> >> >>Where ethX or dev is any PF with administrative privileges.
>> >> >>
>> >> >>Patchset also updates firmware spec. to 1.10.1.40.
>> >> >>
>> >> >>
>> >> >>v2->v3: Split the param into two new params "enable_live_dev_reset" and
>> >> >
>> >> >Vasundhara, I asked you multiple times for this to be "devlink dev reload"
>> >> >attribute. I don't recall you telling any argument against it. I belive
>> >> >that this should not be paramater. This is very tightly related to
>> >> >reload, could you please have it as an attribute of reload, as I
>> >> >suggested?
>> >>
>> >> I just wrote the thread to the previous version. I understand now why
>> >> you need param as you require reboot to activate the feature.
>> >
>> >Okay.
>> >>
>> >> However, I don't think it is correct to use enable_live_dev_reset to
>> >> indicate the live-reset capability to the user. Params serve for
>> >> configuration only. Could you please move the indication some place
>> >> else? ("devlink dev info" seems fitting).
>> >
>> >Here we are not indicating the support. If the parameter is set to
>> >true, we are enabling the feature in firmware and driver after reboot.
>> >Users can disable the feature by setting the parameter to false and
>> >reboot. This is the configuration which is enabling or disabling the
>> >feature in the device.
>>
>> You are talking about cmode permanent here. I'm talking about cmode
>> runtime.
>For cmode runtime, I have renamed it to "allow_live_dev_reset". As I
>see the comment under "enable_live_dev_reset", I thought you are
>talking about permanent cmode.
>
>"allow_live_dev_reset" is runtime cmode, which will allow users to
>disable the "live reset" feature temporarily. It just not only
>indicate the support but user can configure it to control the "live
>reset" at runtime.

Okay, that looks fine to me now.


>>
>>
>> >
>> >>
>> >> I think that you can do the indication in a follow-up patchset. But
>> >> please remove it from this one where you do it with params.
>> >
>> >Could you please see the complete patchset and use it bnxt_en driver
>> >to get a clear picture? We are not indicating the support.
>> >
>> >Thanks.
>> >
>> >>
>> >>
>> >> >
>> >> >Thanks!
>> >> >
>> >> >
>> >> >>"allow_live_dev_reset".
>> >> >>- Expand the documentation of each param and update commit messages
>> >> >> accordingly.
>> >> >>- Separated the permanent configuration mode code to another patch and
>> >> >>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
>> >> >>
>> >> >>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
>> >> >>- Update documentation files and commit messages with more details of the
>> >> >> feature.
>> >> >>
>> >> >>Vasundhara Volam (6):
>> >> >>  devlink: Add 'enable_live_dev_reset' generic parameter.
>> >> >>  devlink: Add 'allow_live_dev_reset' generic parameter.
>> >> >>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
>> >> >>  bnxt_en: Update firmware spec. to 1.10.1.40.
>> >> >>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
>> >> >>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
>> >> >>
>> >> >> Documentation/networking/devlink/bnxt.rst          |  4 ++
>> >> >> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
>> >> >> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
>> >> >> include/net/devlink.h                              |  8 +++
>> >> >> net/core/devlink.c                                 | 10 ++++
>> >> >> 10 files changed, 175 insertions(+), 36 deletions(-)
>> >> >>
>> >> >>--
>> >> >>1.8.3.1
>> >> >>
