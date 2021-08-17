Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5EF3EEFF3
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhHQQGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhHQQGr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:06:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37A6E6054E;
        Tue, 17 Aug 2021 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629216373;
        bh=NZw4XOoUWEfRHscEvAAAadavXr/gyDCjshgThc1nlFs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFxlu6NbyMlgKUgxMf/C9sULXfJYGWkLXxXoVtniNNnDGWCR3uV7Y8qchBdXdpw5+
         5lAiVS5J+BSGWv0gq3SB7qqfbwPC26o/3MMEvxL4RkjhWx5hgWnP+EcQMsnrQnOH+Z
         1qA54H9qarwFrA6Jzs5aRd+hYLQf5x6nmBYaguD4=
Date:   Tue, 17 Aug 2021 18:06:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Petko Manolov <petko.manolov@konsulko.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, paskripkin@gmail.com,
        stable@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH] net: usb: pegasus: fixes of set_register(s) return value
 evaluation;
Message-ID: <YRvecjqHxP5CGGlB@kroah.com>
References: <20210817140613.27737-1-petko.manolov@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817140613.27737-1-petko.manolov@konsulko.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 05:06:13PM +0300, Petko Manolov wrote:
>   - restore the behavior in enable_net_traffic() to avoid regressions - Jakub
>     Kicinski;
>   - hurried up and removed redundant assignment in pegasus_open() before yet
>     another checker complains;
>   - explicitly check for negative value in pegasus_set_wol(), even if
>     usb_control_msg_send() never return positive number we'd still be in sync
>     with the rest of the driver style;
> 
> Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
> ---
>  drivers/net/usb/pegasus.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
