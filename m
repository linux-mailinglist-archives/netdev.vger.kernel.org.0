Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BBB2CE127
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgLCVuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:50:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgLCVuX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 16:50:23 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkwTt-00A70M-T2; Thu, 03 Dec 2020 22:49:41 +0100
Date:   Thu, 3 Dec 2020 22:49:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201203214941.GA2409950@lunn.ch>
References: <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
 <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io>
 <20201203040758.GC2333853@lunn.ch>
 <rqav0e$4m3$1@ciao.gmane.io>
 <20201203211702.GK2333853@lunn.ch>
 <rqbluj$l72$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rqbluj$l72$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I don't think there's any way I could justify using a kernel that
> doesn't have long-term support.

5.10 is LTS. Well, it will be, once it is actually released!

     Andrew

> [It looks like we're going to have to abandon the effort to use
> 5.4. The performance is so bad compared to 2.6.33.7 that our product
> just plain won't work. We've already had remove features to the get
> 5.4 kernel down to a usable size, but we were prepared to live with
> that.]

Ah. Small caches? The OpenWRT guys make valid complaints that the code
hot path of the network stack is getting too big to fit in the cache
of small systems. So there is a lot of cache misses and performance is
not good. If i remember correctly, just having netfilter in the build
is bad, even if it is not used.

   Andrew
