Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B739E170DF7
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 02:37:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgB0Bhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 20:37:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35936 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbgB0Bhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 20:37:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74A3F15AE9EF2;
        Wed, 26 Feb 2020 17:37:53 -0800 (PST)
Date:   Wed, 26 Feb 2020 17:37:50 -0800 (PST)
Message-Id: <20200226.173750.2149877624295674225.davem@davemloft.net>
To:     gregkh@linuxfoundation.org
Cc:     christian.brauner@ubuntu.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 0/9] net: fix sysfs permssions when device changes
 network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226081757.GF24447@kroah.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
        <20200226081757.GF24447@kroah.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 17:37:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 26 Feb 2020 09:17:57 +0100

> On Tue, Feb 25, 2020 at 02:19:29PM +0100, Christian Brauner wrote:
>> Hey everyone,
>> 
>> /* v6 */
>> This is v6 with two small fixups. I missed adapting the commit message
>> to reflect the renamed helper for changing the owner of sysfs files and
>> I also forgot to make the new dpm helper static inline.
> 
> All of the sysfs and driver core bits look good to me now.  Thanks for
> taking the time to update the documentation and other bits based on
> reviews.
> 
> So now it's just up to the netdev developers to review the netdev parts :)
> 
> The sysfs and driver core patches can all go through the netdev tree to
> make it easier for you.

I'm fine with these changes, and will apply this series to net-next.

Thanks everyone.
