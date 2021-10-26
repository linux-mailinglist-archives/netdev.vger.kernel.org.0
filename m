Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B246243BA70
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhJZTPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:15:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236125AbhJZTPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:15:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 411056108D;
        Tue, 26 Oct 2021 19:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635275579;
        bh=VHYkKyvnA6mMb891JpWFq+i3U7jSXk1ZXJNgw0mug/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BzD1QQR9YLS9yCGVUAR7NKkzEkoIahg7EU6BK7WNBJy2IVdLYHrX6vYDn5CUgDC5f
         4Lwnlf8xNZDfDg0rl6h8kWEZK4xZtGRYss/E84uLjSqECpekUE4zUVtbNqx3vRxDtw
         qLQvr/N739diFcy0XrY00N71uBP7ALhH6RGm9mno=
Date:   Tue, 26 Oct 2021 21:12:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH net-next] staging: use of_get_ethdev_address()
Message-ID: <YXhTNtwjjU+VjEB/@kroah.com>
References: <20211026175038.3197397-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026175038.3197397-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 10:50:38AM -0700, Jakub Kicinski wrote:
> Use the new of_get_ethdev_address() helper for the cases
> where dev->dev_addr is passed in directly as the destination.
> 
>   @@
>   expression dev, np;
>   @@
>   - of_get_mac_address(np, dev->dev_addr)
>   + of_get_ethdev_address(np, dev)
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Hi Greg, this needs to go to net-next, the helper is new.
> ---
>  drivers/staging/octeon/ethernet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
