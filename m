Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5ED2B81FD
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 17:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbgKRQea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 11:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbgKRQea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 11:34:30 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF24C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:34:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id u12so2886186wrt.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 08:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EUa5fG/1lWEe55jqIkIrVwTzdaW15NJYX+1efCFG+O4=;
        b=fMC4Glhe8CWbNxXZdyBf9GAUjl/Te1XZjIdLcURXzkqE3I8CpH6aRxwvJHW9VCPDIz
         abp3hxlKayyKIQmx83jiH3CcoQ0RM9tahyZCqUwtFvUVQzZPHnPscy5IPQhPP2urd5zG
         fEb908XWpKzkY7Qht430G+cbj7Hq9KTUIPqlOqtvwiFhTpL7rg3yBpMzlhkK3Pr6/Vo4
         cAxh9JgmjED7wNb8Iflf3jYF6nNwH4Qx65ex+vON7WfGM2+LUIhSy2Jq/hMB8885ZSZD
         gC0TbvJzEOaWoJX6wWdOjQiHjJyFrNEQ3btU3yX2Wy0aEEVNzt7yit97w0y3AUnn4Yyo
         b00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EUa5fG/1lWEe55jqIkIrVwTzdaW15NJYX+1efCFG+O4=;
        b=W/rEy8GrQeUBMfKX1O0Rqg7bygpjil5DPEQmRFeSErb7jFzPcgpsJyd1NOkPEiETXa
         deDU+VXIFoxp+CpTgP81nRTw3sxkZ+UaXWPDd6or1VSsWA1EWrmRWerxAqadNbNfJAyL
         Yfb55cFYhnX5mFKVUCV1Y9E4O/IrWyLqWBl+CZd+UvTwpA53v4Zu6sMPgmcd+4/zcFG/
         99rER1sHOtawDgiLJvDRUDBSlpasPR9GOOzIozfCDNIU+v+FpKO2qNl98h7mZmpjBy+4
         OXP9sm0f3IKahhPZrHQHeRVX9UubxH6Xpx1MIl6y3WUFIuC60zt3m1P8cOJ/OLA2r80h
         0EVw==
X-Gm-Message-State: AOAM532+9dIjwS/Q80CqXPALaWH5M0d9Nf1kB06i9mnivaojTkL+YDSb
        aBM657CNi+TyJyEA/mTst0u4Rw==
X-Google-Smtp-Source: ABdhPJwTTX5DpME+uW9vdkL5pqIFMEyk6dtD8TDTm+Zn7i7TYB0+J7tfgKhlw6BJ+Jq4aRM6yGVcuw==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr6135101wrn.56.1605717268680;
        Wed, 18 Nov 2020 08:34:28 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id n123sm4457321wmn.38.2020.11.18.08.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 08:34:28 -0800 (PST)
Date:   Wed, 18 Nov 2020 17:34:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>, Jakub Kicinksi <kuba@kernel.org>
Subject: Re: [net-next v3 2/2] devlink: move flash end and begin to core
 devlink
Message-ID: <20201118163427.GB3055@nanopsycho.orion>
References: <20201117200820.854115-1-jacob.e.keller@intel.com>
 <20201117200820.854115-3-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117200820.854115-3-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 17, 2020 at 09:08:20PM CET, jacob.e.keller@intel.com wrote:
>When performing a flash update via devlink, device drivers may inform
>user space of status updates via
>devlink_flash_update_(begin|end|timeout|status)_notify functions.
>
>It is expected that drivers do not send any status notifications unless
>they send a begin and end message. If a driver sends a status
>notification without sending the appropriate end notification upon
>finishing (regardless of success or failure), the current implementation
>of the devlink userspace program can get stuck endlessly waiting for the
>end notification that will never come.
>
>The current ice driver implementation may send such a status message
>without the appropriate end notification in rare cases.
>
>Fixing the ice driver is relatively simple: we just need to send the
>begin_notify at the start of the function and always send an end_notify
>no matter how the function exits.
>
>Rather than assuming driver authors will always get this right in the
>future, lets just fix the API so that it is not possible to get wrong.
>Make devlink_flash_update_begin_notify and
>devlink_flash_update_end_notify static, and call them in devlink.c core
>code. Always send the begin_notify just before calling the driver's
>flash_update routine. Always send the end_notify just after the routine
>returns regardless of success or failure.
>
>Doing this makes the status notification easier to use from the driver,
>as it no longer needs to worry about catching failures and cleaning up
>by calling devlink_flash_update_end_notify. It is now no longer possible
>to do the wrong thing in this regard. We also save a couple of lines of
>code in each driver.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Good idea.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
