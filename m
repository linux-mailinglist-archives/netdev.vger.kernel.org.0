Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94943C35AA
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhGJQ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 12:59:20 -0400
Received: from smtp1.emailarray.com ([65.39.216.14]:48554 "EHLO
        smtp1.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhGJQ7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 12:59:19 -0400
Received: (qmail 88055 invoked by uid 89); 10 Jul 2021 16:56:31 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp1.emailarray.com with SMTP; 10 Jul 2021 16:56:31 -0000
Date:   Sat, 10 Jul 2021 09:56:30 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     dariobin@libero.it
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] ptp: Relocate lookup cookie to correct block.
Message-ID: <20210710165630.kfuo6ffgi7es37zy@bsd-mbp.dhcp.thefacebook.com>
References: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
 <691638583.174057.1625922797445@mail1.libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <691638583.174057.1625922797445@mail1.libero.it>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 03:13:17PM +0200, dariobin@libero.it wrote:
> Hi Jonathan,
> IMHO it is unfair that I am not the commit author of this patch.

Richard alerted me to the error, and I sent a fix on July 6th when
I came back from vacation.  I saw your fix go by 2 days later - which
was also for net-next, and tossed as well.

So when I respun my initial patch against -net, I added your
signoff, since the two patches were identical.

No slight intended...
-- 
Jonathan
