Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1715013CBB0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgAOSIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:08:50 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42398 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728928AbgAOSIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:08:49 -0500
Received: by mail-qt1-f195.google.com with SMTP id j5so16554988qtq.9
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:08:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DbNxMeA4XOtNCETrBCdq4uCDGOJYzYMRQjc2MJfRV9E=;
        b=gjZRbxZW6Q9M2sP1AVtttPD4X06SaNIy/s7qGP6OyzExaSY7MXvXbw7LfhVDkbR9+q
         WpqtVxcBj7JahfSkYq1tDBdNkqE3lY125GFLrkQ5kkJHFy/zVEgwWJuWCgfT7DuYtx3J
         fZ/ewW8apSMBfw7/hsl+DE9MM8ScNSxAaF5hsb9jEh291X8drUxLcC9hoOAmm1C2gq8g
         o/NmaZPW67R7lJRHcDHRUmuZQnOS9Qh5wZfG3Muf4J7S7gQK3g7qni4G1UFdWg3PCJqE
         wdtdG/Lah4rPeZ/ZVcbyArtP0H4bxaK/uQtzUB2SZQcEPteNztRLcBQVTQi0Sz+3NYW/
         ZLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DbNxMeA4XOtNCETrBCdq4uCDGOJYzYMRQjc2MJfRV9E=;
        b=BySqDUgc3hLj5+14zQu1yQISQbEFKRt4FUvmAz36OL0eVTRWhaD3lbgr3EUT6PntY7
         YFy5jnFrcfJ3noLrW9FGqo/z/PxCbRaLl3kVF33Zf9g5cEzqwirGg2Edg3GMYTBUKC2g
         kuLrERNHAN8feoh7mo46asJDz8sdR/+cq0LHzDD70OdPUb8ED+0fw3bWWaYqlD+3JJpu
         n7QgcH6Ta78YILb37B/9wdBF44tg6C3BgvCY0U1LyKTtYNiu34ze1vERBo6C30GJMHFe
         9V7j0my6SYvlDt54NymO1AvVaERD/Ky+HR53Nw4dmg97opwNuOECd2Kl9FX5UECL/R3t
         53pw==
X-Gm-Message-State: APjAAAWs6w1jMNoQgoU8dckpwxqwdCYNIFUKOtu4fi4jgSF0Zn2qPDhY
        KTAL226ReitVbLUyIVXniE21eQ==
X-Google-Smtp-Source: APXvYqzEjTh8By02rqdm5JPhp7w+4ngsPAMDVccZz4DguCmHJ5qPF/g1t+kctKTLrdCUH0GTgSqytg==
X-Received: by 2002:ac8:3631:: with SMTP id m46mr4909888qtb.226.1579111728988;
        Wed, 15 Jan 2020 10:08:48 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id w21sm10075182qth.17.2020.01.15.10.08.48
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 10:08:48 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irn60-0003Wa-4z; Wed, 15 Jan 2020 14:08:48 -0400
Date:   Wed, 15 Jan 2020 14:08:48 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Yishai Hadas <yishaih@mellanox.com>
Cc:     linux-rdma@vger.kernel.org, dledford@redhat.com,
        saeedm@mellanox.com, maorg@mellanox.com, michaelgur@mellanox.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH rdma-next 00/10] Relaxed ordering memory regions
Message-ID: <20200115180848.GA13397@ziepe.ca>
References: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1578506740-22188-1-git-send-email-yishaih@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 08:05:30PM +0200, Yishai Hadas wrote:
> This series adds an ioctl command to allocate an async event file followed by a
> new ioctl command to get a device context.
> 
> The get device context command enables reading some core generic capabilities
> such as supporting an optional MR access flags by IB core and its related
> drivers.
> 
> Once the above is enabled, a new optional MR access flag named
> IB_UVERBS_ACCESS_RELAXED_ORDERING is added and is used by mlx5 driver.
> 
> This optional flag allows creation of relaxed ordering memory regions.  Access
> through such MRs can improve performance by allowing the system to reorder
> certain accesses.
> 
> As relaxed ordering is an optimization, drivers that do not support it can
> simply ignore it.
> 
> Note: This series relies on the 'Refactoring FD usage' series [1] that was sent
> to rdma-next.
> [1] https://patchwork.kernel.org/project/linux-rdma/list/?series=225541
> 
> Yishai
> 
> Jason Gunthorpe (3):
>   RDMA/core: Add UVERBS_METHOD_ASYNC_EVENT_ALLOC
>   RDMA/core: Remove ucontext_lock from the uverbs_destry_ufile_hw() path
>   RDMA/uverbs: Add ioctl command to get a device context
> 
> Michael Guralnik (7):
>   net/mlx5: Expose relaxed ordering bits
>   RDMA/uverbs: Verify MR access flags
>   RDMA/core: Add optional access flags range
>   RDMA/efa: Allow passing of optional access flags for MR registration
>   RDMA/uverbs: Add new relaxed ordering memory region access flag
>   RDMA/core: Add the core support field to METHOD_GET_CONTEXT
>   RDMA/mlx5: Set relaxed ordering when requested

This looks OK, can you update the shared branch please

Thanks,
Jason
