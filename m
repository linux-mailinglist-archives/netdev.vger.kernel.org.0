Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3262E6C4C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730092AbgL1Wzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgL1VbR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:31:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE6FF208D5;
        Mon, 28 Dec 2020 21:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609191037;
        bh=mBn4kEKq5fTLloy0XBZkBU+UnHh4E+qddzACieSTL5o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dwJFsqIfvpiuVWwDDR5yo9uHaiibQuIrhyfWpZIIE8NBF4EMbcKgW3h1kdvRZAyxZ
         VKFSISthzvHbGqCKSeGIqbPLPSqP6au7wxnJOQ5M8sqBHW1cWA4Q5pSb3BaYgtbOfj
         PG4/YYLHZPYscR7sbiF7T4xnnGSve66/0WKFHDNsLNcWT7n6yJTftHYy1vGh10ieSc
         GrmDMk/8BVMgZneIkGxRjShnjbt1j3EtGDLp2vKTo3GqQZfe7VDINJyW2+FJCQPXlV
         ncf0wA+6CTVUrzROsqf7zhUVHmFSb6lG1L69zcU4Nf0XWHwz9nO57YTntmPgRfKHud
         BtVMD0gSOpRFQ==
Date:   Mon, 28 Dec 2020 13:30:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Roland Dreier <roland@kernel.org>
Cc:     Oliver Neukum <oliver@neukum.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
Message-ID: <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X+RJEI+1AR5E0z3z@kroah.com>
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201224032116.2453938-1-roland@kernel.org>
        <X+RJEI+1AR5E0z3z@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Dec 2020 08:53:52 +0100 Greg KH wrote:
> On Wed, Dec 23, 2020 at 07:21:16PM -0800, Roland Dreier wrote:
> > The cdc_ncm driver passes network connection notifications up to
> > usbnet_link_change(), which is the right place for any logging.
> > Remove the netdev_info() duplicating this from the driver itself.
> > 
> > This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
> > (ID 20f4:e02b) adapter from spamming the kernel log with
> > 
> >     cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected
> > 
> > messages every 60 msec or so.
> > 
> > Signed-off-by: Roland Dreier <roland@kernel.org>
>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to net and queued for LTS, thanks!
