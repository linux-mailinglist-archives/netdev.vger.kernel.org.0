Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4A0062C16
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGHWrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:47:37 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:64027 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbfGHWrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:47:37 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hkcQ3-0005v2-Rm from George_Davis@mentor.com ; Mon, 08 Jul 2019 15:47:35 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Mon, 8 Jul
 2019 15:47:33 -0700
Date:   Mon, 8 Jul 2019 18:47:32 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sysctl: cleanup net_sysctl_init error exit paths
Message-ID: <20190708224732.GA8009@mam-gdavis-lt>
References: <1558020189-16843-1-git-send-email-george_davis@mentor.com>
 <20190516.142744.1107545161556108780.davem@davemloft.net>
 <20190517144345.GA16926@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190517144345.GA16926@mam-gdavis-lt>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-03.mgc.mentorg.com (147.34.90.203) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Fri, May 17, 2019 at 10:43:45AM -0400, George G. Davis wrote:
> Hello David,
> 
> On Thu, May 16, 2019 at 02:27:44PM -0700, David Miller wrote:
> > From: "George G. Davis" <george_davis@mentor.com>
> > Date: Thu, 16 May 2019 11:23:08 -0400
> > 
> > > Unwind net_sysctl_init error exit goto spaghetti code
> > > 
> > > Suggested-by: Joshua Frkuska <joshua_frkuska@mentor.com>
> > > Signed-off-by: George G. Davis <george_davis@mentor.com>
> > 
> > Cleanups are not appropriate until the net-next tree opens back up.
> > 
> > So please resubmit at that time.
> 
> I fear that I may be distracted by other shiny objects by then but
> I'll make a reminder and try to resubmit during the next merge window.

Since the "Linux 5.2" kernel has been released [1], I'm guessing that the
net-next merge window is open now? If yes, the patch remains unchanged
since my initial post. Please consider applying or let me know when to
resubmit when the net-next merge window is again open.

TIA!


> 
> Thanks!
> 
> > 
> > Thank you.
> 
> -- 
> Regards,
> George

-- 
Regards,
George
[1] https://lwn.net/Articles/792995/
