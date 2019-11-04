Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECA0ED9FD
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 08:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbfKDHjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 02:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:51860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfKDHjk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 02:39:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFBB2205C9;
        Mon,  4 Nov 2019 07:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572853178;
        bh=0btWQZ/A2BUDNkIHPwbXhBS2yMK898sYA7OTvZ/A/kM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eP4zRw3aA67jEZP2e1660qzvfePuKZvb1xI9F6E/uHXRsxN+Lsi3Mofnfo2oStjmQ
         b2bfTIei9WEZxjGb7i1aLsxUFvg1NsS323Lgui0Xr+5PfZl3vYQjrF7S2lqOUJrpLb
         5pORMKu6PSNjmYOZdL4mVa4Cy6HQLVUQeF6nnpzk=
Date:   Mon, 4 Nov 2019 08:39:35 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jonathan Corbet <corbet@lwn.net>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/7] mac80211: Use debugfs_create_xul() helper
Message-ID: <20191104073935.GA1292321@kroah.com>
References: <20191025094130.26033-1-geert+renesas@glider.be>
 <20191025094130.26033-3-geert+renesas@glider.be>
 <69baa44c928ae7f6ca1f4631b7beb6b2c2b1c033.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69baa44c928ae7f6ca1f4631b7beb6b2c2b1c033.camel@sipsolutions.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 08:28:57AM +0100, Johannes Berg wrote:
> On Fri, 2019-10-25 at 11:41 +0200, Geert Uytterhoeven wrote:
> > Use the new debugfs_create_xul() helper instead of open-coding the same
> > operation.
> > 
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> Sorry Greg, this slipped through on my side.
> 
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> 
> Do you prefer to take this to your tree still, or should I pick it up
> later once debugfs_create_xul() is available (to me)?

I can take it now, thanks!

greg k-h
