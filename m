Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEE634C308
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 07:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhC2FaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 01:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230334AbhC2FaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 01:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC10B6195C;
        Mon, 29 Mar 2021 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616995811;
        bh=0RjrkcyILjCKOXyihRFwyZwl1A04NBjpC5Y8mVQdLIM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DCKz7ODZ6kVElyqeBpqDmFPOxKFpzCg9kxGZJijWsn02oUzI9yiZ3rEOxcax9V1uY
         lKhXK4tgi0ukqcByu3fgWjZVs+6wz3fSCVt1euhf57CCzY/NG+JESw7PyvsH5dlDbB
         Sw5yk48ZC3MzZQ1owKGhJPRaA1OYutx15wl6BbrM=
Date:   Mon, 29 Mar 2021 07:30:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: Re: [PATCH net-next] qrtr: move to staging
Message-ID: <YGFl4IcdLfbsyO51@kroah.com>
References: <20210328122621.2614283-1-gregkh@linuxfoundation.org>
 <YGFi0uIfavNsXhfs@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGFi0uIfavNsXhfs@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 08:17:06AM +0300, Leon Romanovsky wrote:
> On Sun, Mar 28, 2021 at 02:26:21PM +0200, Greg Kroah-Hartman wrote:
> > There does not seem to be any developers willing to maintain the
> > net/qrtr/ code, so move it to drivers/staging/ so that it can be removed
> > from the kernel tree entirely in a few kernel releases if no one steps
> > up to maintain it.
> > 
> > Reported-by: Matthew Wilcox <willy@infradead.org>
> > Cc: Du Cheng <ducheng2@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> 
> Greg,
> 
> Why don't you simply delete it like other code that is not maintained?

"normally" we have been giving code a chance by having it live in
drivers/staging/ for a bit before removing it to allow anyone that
actually cares about the codebase to notice it before removing it.

We've done this for many drivers and code-chunks over the years, wimax
was one recent example.

Just trying to be nice :)

thanks,

greg k-h
