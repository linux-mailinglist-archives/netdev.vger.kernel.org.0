Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B60A1E9DF3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 08:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgFAGSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 02:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgFAGSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 02:18:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00D2C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:18:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j198so11311398wmj.0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 23:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hOK7MxBeY9tB53s9WZ+tRFuN89lwmFt3jmxnIXeDD7I=;
        b=qKAXIgrVbX/zXgpzgcXRnDiN9+ryjOU4znrDQDU7lgXcFECIidWV4GAy17FcZRrdou
         jz60p0HY4o3KYRl0caECYRalp2WWMqhXntrtihIMpPP3H6NxgEO68/JpuH00iTzw2kwy
         iXziXEaWuhlaQNVSy715eRsQwIsvdl72l8pvA5zeuPWRiLnhDhlRLuG8p7oHgw1SN5X7
         eK49FunXTWo75DrWQ+YnKy9dhtlYi/ctbr64KmKUhmNfvccnp00gKrGHs6IEHe0VkgyE
         iob0Xe/AthN4FdAgmnxMJ3aIJRsbWNC411AHPjMWqMBANweLrmkg54lpWmz9+vSEbuN0
         VYQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hOK7MxBeY9tB53s9WZ+tRFuN89lwmFt3jmxnIXeDD7I=;
        b=FsdG7sLitq/hJf9ersxnFMyOH5+KwxwIRX2s/7YKA1X5lvnalZVllWRqBWl1ubwSTD
         w/L5CHIxczY0oAq55QJEMsCFD9NCAulI6lk1lxDm7gXZm2ozc9FgE0PWLYb8swDmkVhX
         ndT6OhnSWbrDFzi3kNN/tmgQdHSFK4iNz8Dsvg84/MTAUGBm/RiCu+nrNtpcROIzYRSK
         HzOqU8L0KuU5iQ+jK9hUzeKFzTMGxC23Ep9I2/Lrplk3TyY4K4aOIMt6Paa+aVSdKSYS
         NjCnHOGkExTZjRMAazSHBGo8KX7unuZ19HUAlQDHITAsDCEBW5h5dvksP5AfN3aCx9wO
         hhjQ==
X-Gm-Message-State: AOAM53363kay9Z7KaWnAfEuzJEi5s7Jf5UPbx30VF1Wh1DKLd2KnXOiY
        PXqrWu9Qt7/t3oZVPw9B+samBw==
X-Google-Smtp-Source: ABdhPJy6OoOYGXmJPsrKYpoZJwAB9TCsKqB1LmsWMurA56+xTlX0fk7ZtIYpwCgZCLhCpx2uhA4ViQ==
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr21545032wme.91.1590992300656;
        Sun, 31 May 2020 23:18:20 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id q4sm11289542wma.47.2020.05.31.23.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 23:18:19 -0700 (PDT)
Date:   Mon, 1 Jun 2020 08:18:19 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        michael.chan@broadcom.com
Subject: Re: [PATCH v3 net-next 0/6] bnxt_en: Add 'enable_live_dev_reset' and
 'allow_live_dev_reset' generic devlink params.
Message-ID: <20200601061819.GA2282@nanopsycho>
References: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1590908625-10952-1-git-send-email-vasundhara-v.volam@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 31, 2020 at 09:03:39AM CEST, vasundhara-v.volam@broadcom.com wrote:
>Live device reset capability allows the users to reset the device in real
>time. For example, after flashing a new firmware image, this feature allows
>a user to initiate the reset immediately from a separate command, to load
>the new firmware without reloading the driver or resetting the system.
>
>When device reset is initiated, services running on the host interfaces
>will momentarily pause and resume once reset is completed, which is very
>similar to momentary network outage.
>
>This patchset adds support for two new generic devlink parameters for
>controlling the live device reset capability and use it in the bnxt_en
>driver.
>
>Users can initiate the reset from a separate command, for example,
>'ethtool --reset ethX all' or 'devlink dev reload' to reset the
>device.
>Where ethX or dev is any PF with administrative privileges.
>
>Patchset also updates firmware spec. to 1.10.1.40.
>
>
>v2->v3: Split the param into two new params "enable_live_dev_reset" and

Vasundhara, I asked you multiple times for this to be "devlink dev reload"
attribute. I don't recall you telling any argument against it. I belive
that this should not be paramater. This is very tightly related to
reload, could you please have it as an attribute of reload, as I
suggested?

Thanks!


>"allow_live_dev_reset".
>- Expand the documentation of each param and update commit messages
> accordingly.
>- Separated the permanent configuration mode code to another patch and
>rename the callbacks of the "allow_live_dev_reset" parameter accordingly.
>
>v1->v2: Rename param to "allow_fw_live_reset" from "enable_hot_fw_reset".
>- Update documentation files and commit messages with more details of the
> feature.
>
>Vasundhara Volam (6):
>  devlink: Add 'enable_live_dev_reset' generic parameter.
>  devlink: Add 'allow_live_dev_reset' generic parameter.
>  bnxt_en: Use 'enable_live_dev_reset' devlink parameter.
>  bnxt_en: Update firmware spec. to 1.10.1.40.
>  bnxt_en: Use 'allow_live_dev_reset' devlink parameter.
>  bnxt_en: Check if fw_live_reset is allowed before doing ETHTOOL_RESET
>
> Documentation/networking/devlink/bnxt.rst          |  4 ++
> .../networking/devlink/devlink-params.rst          | 28 ++++++++++
> drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 28 +++++++++-
> drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  2 +
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  | 49 +++++++++++++++++
> drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |  1 +
> drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 17 +++---
> drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      | 64 +++++++++++++---------
> include/net/devlink.h                              |  8 +++
> net/core/devlink.c                                 | 10 ++++
> 10 files changed, 175 insertions(+), 36 deletions(-)
>
>-- 
>1.8.3.1
>
