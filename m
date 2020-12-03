Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F692CE0F8
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbgLCVkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:40:18 -0500
Received: from static.214.254.202.116.clients.your-server.de ([116.202.254.214]:44174
        "EHLO ciao.gmane.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgLCVkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:40:18 -0500
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <gl-netdev-2@m.gmane-mx.org>)
        id 1kkwK7-0005kI-Nl
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 22:39:35 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     netdev@vger.kernel.org
From:   Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: net: macb: fail when there's no PHY
Date:   Thu, 3 Dec 2020 21:39:31 -0000 (UTC)
Message-ID: <rqbluj$l72$1@ciao.gmane.io>
References: <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante> <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io> <20201202211134.GM2324545@lunn.ch>
 <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io> <20201203040758.GC2333853@lunn.ch>
 <rqav0e$4m3$1@ciao.gmane.io> <20201203211702.GK2333853@lunn.ch>
User-Agent: slrn/1.0.3 (Linux)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-03, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Dec 03, 2020 at 03:07:58PM -0000, Grant Edwards wrote:
>
>> I don't think I can justify the additional effort to devlope and
>> maintain a custom kern-space driver.
>
> Why custom? You should contribute it.

I can't imagine that it would be useful to anybody else. My attempts
to donate drivers in the past were unproductive wastes of time, so I'm
not doing that again.

>>>> Was there some other way I should have done this with a 5.4 kernel
>>>> that I was unable to discover?
>
> Ah, i missed you are using 5.4. You should probably jump to
> 5.10. There have been quite a few changes in this area in the macb
> driver.

I don't think there's any way I could justify using a kernel that
doesn't have long-term support.

[It looks like we're going to have to abandon the effort to use
5.4. The performance is so bad compared to 2.6.33.7 that our product
just plain won't work. We've already had remove features to the get
5.4 kernel down to a usable size, but we were prepared to live with
that.]

>> BTW Andrew, we're still shipping plenty of product that running
>> eCos. :)
>
> Cool. There is still a space for such an RTOS, linux has not yet taken
> over the world everywhere.

I keep thinking that one of these days something is going to happen
that will force us to switch to a different RTOS, but it hasn't
happened yet...

--
Grant


