Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0CDF219EA
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfEQOnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 10:43:53 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:63008 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbfEQOnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 10:43:53 -0400
Received: from svr-orw-mbx-01.mgc.mentorg.com ([147.34.90.201])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1hRe5N-0006kV-DH from George_Davis@mentor.com ; Fri, 17 May 2019 07:43:49 -0700
Received: from localhost (147.34.91.1) by svr-orw-mbx-01.mgc.mentorg.com
 (147.34.90.201) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Fri, 17 May
 2019 07:43:47 -0700
Date:   Fri, 17 May 2019 10:43:46 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sysctl: cleanup net_sysctl_init error exit paths
Message-ID: <20190517144345.GA16926@mam-gdavis-lt>
References: <1558020189-16843-1-git-send-email-george_davis@mentor.com>
 <20190516.142744.1107545161556108780.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190516.142744.1107545161556108780.davem@davemloft.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: SVR-ORW-MBX-07.mgc.mentorg.com (147.34.90.207) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Thu, May 16, 2019 at 02:27:44PM -0700, David Miller wrote:
> From: "George G. Davis" <george_davis@mentor.com>
> Date: Thu, 16 May 2019 11:23:08 -0400
> 
> > Unwind net_sysctl_init error exit goto spaghetti code
> > 
> > Suggested-by: Joshua Frkuska <joshua_frkuska@mentor.com>
> > Signed-off-by: George G. Davis <george_davis@mentor.com>
> 
> Cleanups are not appropriate until the net-next tree opens back up.
> 
> So please resubmit at that time.

I fear that I may be distracted by other shiny objects by then but
I'll make a reminder and try to resubmit during the next merge window.

Thanks!

> 
> Thank you.

-- 
Regards,
George
