Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC6B5240
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 18:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfIQQBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 12:01:05 -0400
Received: from esa3.mentor.iphmx.com ([68.232.137.180]:64085 "EHLO
        esa3.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIQQBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 12:01:05 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Sep 2019 12:01:05 EDT
IronPort-SDR: 7on06mcRA9trxE8BmbsaOJb8DCf1NRg2zy/EOAi+G0XUmg7wbWOyyv55RQNDwFxIvA3rwT2Ye7
 a1H1QjrYUSp6tiTkTtcdv3r//iNYrw2fJ5iat5LSvFFG2+3km6hiFgwfm951RbbiJEQu1XZWtD
 fNdxETQyb/PE3k/l1kpIhtvCuEMJpokPyRrrP3hxiUB8dBfDVyP9BK58VM9pWYpYctNBpdUlwK
 90ZwtNKogssSQiuPbkqAqFQbyRuez3SUjVpyEwx2ZqMnRHJuzXMsGFIdN0wc/zBRSLKF7bMmLt
 mUw=
X-IronPort-AV: E=Sophos;i="5.64,517,1559548800"; 
   d="scan'208";a="41431874"
Received: from orw-gwy-02-in.mentorg.com ([192.94.38.167])
  by esa3.mentor.iphmx.com with ESMTP; 17 Sep 2019 07:53:58 -0800
IronPort-SDR: AfJPn/LnTl0pF0pn72vZpwKKlQMxJ3INwLj0DYLkHjfGZd6VIXIm8SDQVlh5KRxazcoft2SdJc
 iMuMgufH5yqwI/a9wagFvWmqeUwA22vCbUcGI7hvK/NVzzRc9fVBkY4bd3CpxaLSZmQ95E56yE
 4QuZDkGXAAk0ZcGZTEZMec+iWNzc/MOasanYRaam+cTULScOQ7j57FwllFNo9hgQX8I22+9n4G
 3wUsiQ5F7iBeP9G62X5Q5+Td/eisL5je8E4MdP6h9GR85Lf76AVRCNFBpTcYUo1lpyC0e04nES
 DGY=
Date:   Tue, 17 Sep 2019 11:53:54 -0400
From:   "George G. Davis" <george_davis@mentor.com>
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: sysctl: cleanup net_sysctl_init error exit paths
Message-ID: <20190917155354.GA15686@mam-gdavis-lt>
References: <1558020189-16843-1-git-send-email-george_davis@mentor.com>
 <20190516.142744.1107545161556108780.davem@davemloft.net>
 <20190517144345.GA16926@mam-gdavis-lt>
 <20190708224732.GA8009@mam-gdavis-lt>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190708224732.GA8009@mam-gdavis-lt>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: svr-orw-mbx-02.mgc.mentorg.com (147.34.90.202) To
 svr-orw-mbx-01.mgc.mentorg.com (147.34.90.201)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Mon, Jul 08, 2019 at 06:47:32PM -0400, George G. Davis wrote:
> Hello David,
> 
> On Fri, May 17, 2019 at 10:43:45AM -0400, George G. Davis wrote:
> > Hello David,
> > 
> > On Thu, May 16, 2019 at 02:27:44PM -0700, David Miller wrote:
> > > From: "George G. Davis" <george_davis@mentor.com>
> > > Date: Thu, 16 May 2019 11:23:08 -0400
> > > 
> > > > Unwind net_sysctl_init error exit goto spaghetti code
> > > > 
> > > > Suggested-by: Joshua Frkuska <joshua_frkuska@mentor.com>
> > > > Signed-off-by: George G. Davis <george_davis@mentor.com>
> > > 
> > > Cleanups are not appropriate until the net-next tree opens back up.
> > > 
> > > So please resubmit at that time.
> > 
> > I fear that I may be distracted by other shiny objects by then but
> > I'll make a reminder and try to resubmit during the next merge window.
> 
> Since the "Linux 5.2" kernel has been released [1], I'm guessing that the
> net-next merge window is open now? If yes, the patch remains unchanged
> since my initial post. Please consider applying or let me know when to
> resubmit when the net-next merge window is again open.

Ping, "Linux 5.3" kernel has been released [1] and it appears that the
5.4 merge window is open. The patch [2] remains unchanged since my initial
post. Please consider applying it.

Thanks!

-- 
Regards,
George
[1] https://lwn.net/Articles/799250/
[2] https://lore.kernel.org/patchwork/patch/1074969/
