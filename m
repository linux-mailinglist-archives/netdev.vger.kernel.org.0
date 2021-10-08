Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A326426AF9
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbhJHMjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 08:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbhJHMjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 08:39:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8407AC061570
        for <netdev@vger.kernel.org>; Fri,  8 Oct 2021 05:37:40 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g10so34990222edj.1
        for <netdev@vger.kernel.org>; Fri, 08 Oct 2021 05:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6Kzq+Hb4BEQR6S7AcXsoWy598tmOz8shczHFxyDivbw=;
        b=pEy/lJVewdt1Z/DeHTyDOY5oAb/5q4vows6Abc1iNwtQ3D/kQ8RuYHXmeESsiYDpEc
         tcOyjmfRvTe/XeWkX4EHHnF3HIQnHnL7IpKg0gJAN1/2hOAFZKHkuzaaCN5soA8TX70s
         YEIrRk7CvKO5KqGbyBQZNu5OyQ83toSUGW4edSr4fWKXU8bveXbfcdIdT/u7lrBJcAT/
         +9hzeFCNAwPfj9FPZBPqte0aRrNtzmxVJKtN4hMhJs8EPylXrfW7F7tWAVyb819zbn/c
         6ro5ESuNehz8LjKCCnKVpT5MbeUO+0XMMVd0VEZutAbxX0zma9WD4CGdgRkeisN83eDg
         r+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6Kzq+Hb4BEQR6S7AcXsoWy598tmOz8shczHFxyDivbw=;
        b=ojYqEqOL0Phs1T2g8nFzgvIWloNAjzze7pLBn4cAd2QN29FYmJUAetyjXgPHbeGDtY
         AjEqouCVVn4jqj7iXaM4erEzbmqlP4fKJxEOAeEi2eLqJUOJGJiuotey0zNt8cR/vjk+
         o7Ai8y4a+Imwow6c8wQSFrBna2bGGyRBRa5xj2+pJFj9l8LM/rY2JCbidQHkI3jUhrrW
         mQpKovoI+ida0iSq94iYzXZu6j4TRBRbz/n7NdhLhhgmuqwZdXHOMWoiHXDFxebUiih+
         KOL5W5Zgtce7Z70UNxi1y8CgTPQ5wVlnfshFsuHeN09rD3sEDawS5y28rHtJl++crrOF
         2cmA==
X-Gm-Message-State: AOAM5305Pbi/qDKhFUdft9LEi9GwZLBIo35maCP+YShMgZhARlKU9vck
        6M2sIr4yzcNSqM4mMWZbZOt1WA==
X-Google-Smtp-Source: ABdhPJyhwYcHXKf/8LpWekAz9xi834pj37HdeXQjSfXoMUvXjcRAuWCcH2uUVKH3wZSM4VmonDQE0w==
X-Received: by 2002:a05:6402:2744:: with SMTP id z4mr14278105edd.88.1633696658958;
        Fri, 08 Oct 2021 05:37:38 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u18sm910135eds.86.2021.10.08.05.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 05:37:38 -0700 (PDT)
Date:   Fri, 8 Oct 2021 14:37:37 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
Message-ID: <YWA7keYHnhlHCkKT@nanopsycho>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008104115.1327240-1-jacob.e.keller@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
>This is an implementation of a previous idea I had discussed on the list at
>https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.com/
>
>The idea is to allow user space to query whether a given destructive devlink
>command would work without actually performing any actions. This is commonly
>referred to as a "dry run", and is intended to give tools and system
>administrators the ability to test things like flash image validity, or
>whether a given option is valid without having to risk performing the update
>when not sufficiently ready.
>
>The intention is that all "destructive" commands can be updated to support
>the new DEVLINK_ATTR_DRY_RUN, although this series only implements it for
>flash update.
>
>I expect we would want to support this for commands such as reload as well
>as other commands which perform some action with no interface to check state
>before hand.
>
>I tried to implement the DRY_RUN checks along with useful extended ACK
>messages so that even if a driver does not support DRY_RUN, some useful
>information can be retrieved. (i.e. the stack indicates that flash update is
>supported and will validate the other attributes first before rejecting the
>command due to inability to fully validate the run within the driver).

Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
really dry run. I guess that user might be surprised in that case...


>
>Jacob Keller (4):
>  ice: move and rename ice_check_for_pending_update
>  ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
>  devlink: add dry run attribute to flash update
>  ice: support dry run of a flash update to validate firmware file
>
> Documentation/driver-api/pldmfw/index.rst     |  10 ++
> drivers/net/ethernet/intel/ice/ice_devlink.c  |  53 +-----
> .../net/ethernet/intel/ice/ice_fw_update.c    | 170 ++++++++++--------
> .../net/ethernet/intel/ice/ice_fw_update.h    |   7 +-
> include/linux/pldmfw.h                        |   5 +
> include/net/devlink.h                         |   2 +
> include/uapi/linux/devlink.h                  |   2 +
> lib/pldmfw/pldmfw.c                           |  12 ++
> net/core/devlink.c                            |  19 +-
> 9 files changed, 145 insertions(+), 135 deletions(-)
>
>
>base-commit: c514fbb6231483b05c97eb22587188d4c453b28e
>-- 
>2.31.1.331.gb0c09ab8796f
>
