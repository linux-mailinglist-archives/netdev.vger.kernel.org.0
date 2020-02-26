Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6881E16F976
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:18:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBZISB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgBZISB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 03:18:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 397F120714;
        Wed, 26 Feb 2020 08:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582705080;
        bh=dQJfSSq/VBRG50lk2yy5WSenygsHghFYvH7m+uxwttI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UVKyzIgWJbq/9N2C/n50JXzjd7rdCfB+D3oFT417X5GpLqv48Z2XuOiAJcWFi6at3
         PQulPTTAE+yd3coPJEOkev0ga9lVBMmv5eFBxkUysXsfhsoQXIj/Q11rqSFFVLPD0V
         2a0OJZfcRPX67tjJ+WgsYEDMfDLplAVrXO9YlOks=
Date:   Wed, 26 Feb 2020 09:17:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/9] net: fix sysfs permssions when device changes
 network
Message-ID: <20200226081757.GF24447@kroah.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225131938.120447-1-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:19:29PM +0100, Christian Brauner wrote:
> Hey everyone,
> 
> /* v6 */
> This is v6 with two small fixups. I missed adapting the commit message
> to reflect the renamed helper for changing the owner of sysfs files and
> I also forgot to make the new dpm helper static inline.

All of the sysfs and driver core bits look good to me now.  Thanks for
taking the time to update the documentation and other bits based on
reviews.

So now it's just up to the netdev developers to review the netdev parts :)

The sysfs and driver core patches can all go through the netdev tree to
make it easier for you.

thanks,

greg k-h
