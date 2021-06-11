Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5BE3A4662
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFKQX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhFKQX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:23:56 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC6FC061574
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:21:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id x16so651860pfa.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmu2VupjojFnJtYGBglgsMLEEkVqwtXc6a87qiZGhc4=;
        b=eh8890IIJF4BuyYi1yvwEyQGWEA/rEmjBUgqWzT/RA8nV0KFT5xxSCG7iAeY2cA+Ii
         AXHCPoxtJ+U3PFwhIVMJgf2Fpp9sFtlw4t05NkJ1psJ5rGANeFy3YZlfQqFE26/KE3D7
         dxXCvlK/JuDnlIFaI0rkFdwLKzsV3sXtjYX/idTVJs4n18ulmj+WNmwvcUJdqKVri6IM
         Vh3Q/PbujY5rODnIGs/lZE/KTqzPznhDNNkydjYUEKrA7Kug94aNtQ/Js4nqiA+uNJ8B
         towzK3NshUb2VmbWMfgB7CC1kQ98lirmZPr2hzhwN1mefjX73zJzZX/3Vp6k/H0XbscE
         ShYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmu2VupjojFnJtYGBglgsMLEEkVqwtXc6a87qiZGhc4=;
        b=gIFO51P5tq5u7ibi72SMxkE9NCntCoNxjhiLXpyL8swUziAU4/VeLeg0ZAqaHcW6HA
         ls/v7gvP8wKEdGFRmZhZKiBhXaPER0x65x0OiDmSU/z0ex1BovJ86zz4ARuO+/QDsaLQ
         NwNH6Vss/jJ43Jya5ocU+mHPE08sZ+ZHZL4F4GnHdLZn26eUkjdeqgxMU2/yRvNPBxw+
         2hbkzpWvpeE04RtSoU5mnuI+5xWdq8BzS+YEGIpct8QufV2OoYeKQ+sLpgRmUNrSFM2X
         6LTWqMm0rJjRt93KJISIfeiyJgqCYiEgOTgydVci2/wPiVs57rjVjkTthTVDhVo/stXr
         eDoQ==
X-Gm-Message-State: AOAM533vi2azhfsO1ktmPoj8tU1kNMZWm6NVOYRISoYf16S3msKGHutJ
        AD6FlxetAPi7rPPKj7Kqvfwp3Q==
X-Google-Smtp-Source: ABdhPJwfOnqVLJhx9eaJZ96oDUuHuD2cHBeerr9bA3ciZdTF48OrE9fYNkyLnwNrBkeCQS5fq8oVgA==
X-Received: by 2002:a63:5504:: with SMTP id j4mr4502862pgb.238.1623428502125;
        Fri, 11 Jun 2021 09:21:42 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id ge13sm10724410pjb.2.2021.06.11.09.21.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 09:21:41 -0700 (PDT)
Date:   Fri, 11 Jun 2021 09:21:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH iproute2] uapi: add missing virtio related headers
Message-ID: <20210611092132.5f66f710@hermes.local>
In-Reply-To: <41c8cf83-6b7d-1d55-fd88-5b84732f9d70@gmail.com>
References: <20210423174011.11309-1-stephen@networkplumber.org>
        <DM8PR12MB5480D92EE39584EDCFF2ECFBDC369@DM8PR12MB5480.namprd12.prod.outlook.com>
        <41c8cf83-6b7d-1d55-fd88-5b84732f9d70@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Jun 2021 20:54:45 -0600
David Ahern <dsahern@gmail.com> wrote:

> On 6/8/21 11:15 PM, Parav Pandit wrote:
> > Hi Stephen,
> > 
> > vdpa headers were present in commit c2ecc82b9d4c at [1].
> > 
> > I added them at [1] after David's recommendation in [2].
> > 
> > Should we remove [1]?
> > Did you face compilation problem without this fix?
> > 
> > [1] ./vdpa/include/uapi/linux/vdpa.h
> > [2] https://lore.kernel.org/netdev/abc71731-012e-eaa4-0274-5347fc99c249@gmail.com/
> > 
> > Parav  
> 
> Stephen: Did you hit a compile issue? vdpa goes beyond networking and
> features go through other trees AIUI so the decision was to put the uapi
> file under the vdpa command similar to what rdma is doing.
> 

In iproute2, all kernel headers used during the build should come from include/uapi.
If new command or function needs a new header, then the sanitized version should be
included.

I update these with an automated script, and making special case for vdpa
seems to be needless effort. Please just let iproute's include/uapi just be
a copy of what kernel "make install_headers" generates.
