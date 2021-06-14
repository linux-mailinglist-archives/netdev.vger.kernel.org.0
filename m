Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2BF3A6EC3
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 21:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhFNTWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 15:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234042AbhFNTWE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 15:22:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19C5561076;
        Mon, 14 Jun 2021 19:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623698401;
        bh=SNkJm9bxSe/6nodnBazmIwjcG/N4cjyDH9DNPYhdXwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CdDnwWSODrTycBFJZSoQIeXc5TgOdBsMyl8AZkylgumPP+Q3WhX4MN32SgYrSnb+n
         x3MIPCEe2t2oZ9D23ASuKz0RM+2NQ77i/treC+6oj4alRXmXnWUKK4M19KAAL/i7Bt
         aE097ih7a9WfF3/sRmPu2QMjJ//FtHGiqaSidbu3y1i4CrAZJPTo8lQPBrL5446M3e
         wA2Xv0FpiNBYDkrszMFZw35YbM32YwUkZDBI5+7LMCtmZ2fUiCucSwp18zF/VVxsJO
         SKIJM0Kg7hzHXzFbxK8Rs7w/M/3yOXhOCz+Ja+9ZvPrEO6XKbFBfCuk3+rvG0vkW+k
         NpQn50G2Wt6IA==
Date:   Mon, 14 Jun 2021 12:20:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH] net: usbnet: allow overriding of default USB interface
 naming
Message-ID: <20210614122000.7cdef052@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <80b6e3ab-6b8f-abaa-9d20-859c89789add@nutanix.com>
References: <20210611152339.182710-1-jonathan.davies@nutanix.com>
        <YMRbt+or+QTlqqP9@kroah.com>
        <469dd530-ebd2-37a4-9c6a-9de86e7a38dc@nutanix.com>
        <YMckz2Yu8L3IQNX9@kroah.com>
        <a620bc87-5ee7-6132-6aa0-6b99e1052960@nutanix.com>
        <YMde1fN+qIBfCWpD@kroah.com>
        <80b6e3ab-6b8f-abaa-9d20-859c89789add@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 15:53:53 +0100 Jonathan Davies wrote:
> >> Compare implementations of rename_netif in
> >> https://git.kernel.org/pub/scm/linux/hotplug/udev.git/tree/src/udev-event.c 
> >> (traditional udev, which handles collisions) and
> >> https://github.com/systemd/systemd/blob/main/src/udev/udev-event.c 
> >> (systemd-udevd, which does not handle collisions).  

That explains some user reports I've been seeing :o

> > Then submit a change to add the logic back.  This looks like a userspace
> > tool breaking existing setups, so please take it up with the developers
> > of that tool.  The kernel has not changed or "broken" anything here.  
> 
> (I didn't mean to imply that the kernel was to blame, merely that a 
> kernel change could help make things tidier.)

If you're attempting to fix this in systemd please share the PR info
so we can voice support!
