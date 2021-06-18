Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7A63AC8BD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhFRK0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhFRK0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 06:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 87F616117A;
        Fri, 18 Jun 2021 10:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624011879;
        bh=D4AuELaLNiFNv3CP+vGfYuaFK7KeBacpL83m0TZ33VE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BbweEaz375f0SKyqNBp8/jwO5GQ0a4ahI+O21R6sJZvmUaP8DZVAPQ9mZi/kseyO2
         7/KnqM3ZhcZIUU1mTpSEPgsA4v+cH+rBy8mEV/v4m9PRjpFcL1oS9sfmZUZWeiWgE9
         TeAMkNZID6ErNSCd6GM1ObsAemliqy1uVv7CZbUc=
Date:   Fri, 18 Jun 2021 12:24:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        edumazet@google.com, w@1wt.eu, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 4.14] inet: use bigger hash table for IP ID generation
 (backported to 4.14)
Message-ID: <YMx0ZIAkTloug34m@kroah.com>
References: <60cc6c9a.1c69fb81.70a57.7034@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60cc6c9a.1c69fb81.70a57.7034@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 02:51:22AM -0700, Amit Klein wrote:
> Subject: inet: use bigger hash table for IP ID generation (backported to 4.14)
> From: Amit Klein <aksecurity@gmail.com>
> 
> This is a backport to 4.14 of the following patch, originally
> developed by Eric Dumazet.
> 
> In commit 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> I used a very small hash table that could be abused
> by patient attackers to reveal sensitive information.
> 
> Switch to a dynamic sizing, depending on RAM size.
> 
> Typical big hosts will now use 128x more storage (2 MB)
> to get a similar increase in security and reduction
> of hash collisions.
> 
> As a bonus, use of alloc_large_system_hash() spreads
> allocated memory among all NUMA nodes.
> 
> Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
> Reported-by: Amit Klein <aksecurity@gmail.com>
> Cc: stable@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Willy Tarreau <w@1wt.eu>
> ---

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
