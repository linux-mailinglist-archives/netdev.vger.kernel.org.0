Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302BA422D25
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbhJEP7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:48480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234282AbhJEP7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:59:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D99D16120A;
        Tue,  5 Oct 2021 15:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633449481;
        bh=TV6N9QCS7x0T75ql3vVUYe4U2uq/x+LtnM/stpKWe2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c69kueUeFXXriOkRWVWDJu0GWzOjay7I3kiQUyDZzJQ5lPpyz7Ihz9MP6hYxI20oq
         LobVysaDxSR9SvsLfav2liiAodauKKufJU8neV+6Yi0ElbvWik2dRlEbcarn4hsnaj
         yiNnbcYFr177oNGpCZEmj4IkHG324M0ys5JpfOdI=
Date:   Tue, 5 Oct 2021 17:57:54 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, rafael@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        robh+dt@kernel.org, frowand.list@gmail.com,
        heikki.krogerus@linux.intel.com, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] device property: add a helper for loading
 netdev->dev_addr
Message-ID: <YVx2AvEgLFx06M5U@kroah.com>
References: <20211005155321.2966828-1-kuba@kernel.org>
 <20211005155321.2966828-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211005155321.2966828-4-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 08:53:20AM -0700, Jakub Kicinski wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> There is a handful of drivers which pass netdev->dev_addr as
> the destination buffer to device_get_mac_address(). Add a helper
> which takes a dev pointer instead, so it can call an appropriate
> helper.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/base/property.c  | 20 ++++++++++++++++++++
>  include/linux/property.h |  2 ++
>  2 files changed, 22 insertions(+)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
