Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA023C18D6
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbhGHSEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 14:04:50 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:53427 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbhGHSEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 14:04:49 -0400
Received: (qmail 42578 invoked by uid 89); 8 Jul 2021 18:02:06 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 8 Jul 2021 18:02:06 -0000
Date:   Thu, 8 Jul 2021 11:02:04 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     dariobin@libero.it, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH] ptp: fix PTP PPS source's lookup cookie set
Message-ID: <20210708180204.4id5ediirvmfoath@bsd-mbp.dhcp.thefacebook.com>
References: <20210708050849.11959-1-dariobin@libero.it>
 <20210708.001404.122934424143086559.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210708.001404.122934424143086559.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 08, 2021 at 12:14:04AM -0700, David Miller wrote:
> this pastch does not apply to the current net tree, that is why I keep marking it "Not Applicable"
> in patchwork.

I'll send a patch against -net in a minue.  The earlier ones
were against -net-next, I didn't realize the window closed.
-- 
Jonathan
