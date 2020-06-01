Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D131E9E69
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgFAGn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgFAGn1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 02:43:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E25C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:43:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id r7so10341761wro.1
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WVrrnWXC8GJFkvTL8NPKN1TpU259pBWyh6KFIVNPR8A=;
        b=PdIKlYWmuGNA1m+oJHEmCHVGkbDn1AAwaxApz1aL4nGmq4IEpaixMhio6dFx6k92cp
         TtExmpheZF6e8beAbgpM3qaA3FXSwBlZBI8zjVVNH7PyAe8K+/Gmx4ITR9rhFpCFrEZ5
         Z5QOwF/kg/oRIC+y3SxxVPjrAC7l48UaWRccCSJ/I9x4krkmYVLGO7YTG/kgoJGb7jCx
         SvYtXpoMDAaM5XkO6BRzurHk+FSlD4D7a+w2T1YWCe2qSWoqLy99gQHwnB0UXegLaDea
         VJSYBcPGGZ3yVHJUwyvO7HvVfmY2uzI63ZomBvnINO2Tvf6GtCRskkp5oCQHVP0hOou7
         i81Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WVrrnWXC8GJFkvTL8NPKN1TpU259pBWyh6KFIVNPR8A=;
        b=PEh0bGREL6BT+ngbkdOB5G6lnuwKMWrDHNtwTbkKAefuXSbrCSp8MhOF6p6mF5w9u5
         UtgtJO7+5Y0jms6qCe/PYvFeJviztSounETes5CuNoHVdZcV6QVw4aNNbhmjELADucQ4
         C4gtZoLT0FrvQ/jMUWlI3ktqpzlbzVguuYcdmB3GqQ1r+/N1wH+n2Z2HMql7vXP00rrc
         VjAPfkHkYjx2uTb52zWRvDRoRrB0Wk5/Vo3t6F5GqY1oV2SjrkDAD2avXg3TGBD1fJXR
         Iw85wk/GY8pOnLMe/h0kECrTKcVIvztQ2Mxyv1KogGh2x/Ys43d+8SJWhlQT5lq6mLgC
         288Q==
X-Gm-Message-State: AOAM533aM4PgFJmxPV4jx9sabqEkjZLPR3BxVcQX65FSz40tzESEO2e+
        ZrMaHQCrXdBiKi9JeH4jy8CJ3g==
X-Google-Smtp-Source: ABdhPJyTnDivxqI+N4mrPhwWW9nsmOofVjhUtbcOr3FkbYnNdS0fGz+vaqp2Vo0hG4lxskhOlO7Ndg==
X-Received: by 2002:a5d:4bc5:: with SMTP id l5mr20776849wrt.104.1590993804912;
        Sun, 31 May 2020 23:43:24 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id u130sm10750832wmg.32.2020.05.31.23.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 23:43:24 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:43:23 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601064323.GF2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200601061819.GA2282@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601061819.GA2282@nanopsycho>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jun 01, 2020 at 08:18:19AM CEST, jiri@resnulli.us wrote:
>Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>>Live device reset capability allows the users to reset the device in real
>>time. For example, after flashing a new firmware image, this feature allows
>>a user to initiate the reset immediately from a separate command, to load
>>the new firmware without reloading the driver or resetting the system.
>>
>>When device reset is initiated, services running on the host interfaces
>>will momentarily pause and resume once reset is completed, which is very
>>similar to momentary network outage.
>>
>>This patchset adds support for two new generic devlink parameters for
>>controlling the live device reset capability and use it in the bnxt_en
>>driver.
>>
>>Users can initiate the reset from a separate command, for example,
>>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
>>device.
>>Where ethX or dev is any PF with administrative privileges.
>>
>>Patchset also updates firmware spec. to 1.10.1.40.
>>
>>
>>v2->v3: Split the param into two new params "enable_live_dev_reset" and
>
>Vasundhara, I asked you multiple times for this to be "devlink dev reload"
>attribute. I don't recall you telling any argument against it. I belive
>that this should not be paramater. This is very tightly related to
>reload, could you please have it as an attribute of reload, as I
>suggested?

I just wrote the thread to the previous version. I understand now why
you need param as you require reboot to activate the feature.

However, I don't think it is correct to use enable_live_dev_reset to
indicate the live-reset capability to the user. Params serve for
configuration only. Could you please move the indication some place
else? ("devlink dev info" seems fitting).

I think that you can do the indication in a follow-up patchset. But
please remove it from this one where you do it with params.


>
>Thanks!
>
>
>>"allow_live_dev_reset".
>>- Expand the documentation of each param and update commit messages
>> accordingly.
>>- Separated the permanent configuration mode code to another patch and
>>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
>>
>>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
>>- Update documentation files and commit messages with more details of the
>> feature.
>>
>>Vasundhara Volam (6):
>>  devlink: Add 'enable_live_dev_reset' generic parameter.
>>  devlink: Add 'allow_live_dev_reset' generic parameter.
>>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
>>  bnxt_en: Update firmware spec. to 1.10.1.40.
>>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
>>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
>>
>> Documentation/networking/devlink/bnxt.rst          |  4 ++
>> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
>> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
>> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
>> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
>> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
>> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
>> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
>> include/net/devlink.h                              |  8 +++
>> net/core/devlink.c                                 | 10 ++++
>> 10 files changed, 175 insertions(+), 36 deletions(-)
>>
>>-- 
>>1.8.3.1
>>
