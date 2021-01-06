Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D458A2EB6DA
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhAFA0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:26:12 -0500
Received: from smtp6.emailarray.com ([65.39.216.46]:56088 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhAFA0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:26:12 -0500
Received: (qmail 42822 invoked by uid 89); 6 Jan 2021 00:25:30 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 6 Jan 2021 00:25:30 -0000
Date:   Tue, 5 Jan 2021 16:25:27 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, edumazet@google.com,
        dsahern@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 00/13] Generic zcopy_* functions
Message-ID: <20210106002527.ozfo5mfckpxt3cjn@bsd-mbp.dhcp.thefacebook.com>
References: <20210105220706.998374-1-jonathan.lemon@gmail.com>
 <c7d877d9-d3ea-fedc-6492-9954cfded3eb@gmail.com>
 <20210105234038.xr6xwgnhgpnzwwci@bsd-mbp.dhcp.thefacebook.com>
 <0c67ac21-4f1b-fb4d-fc66-30b3d74c7682@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c67ac21-4f1b-fb4d-fc66-30b3d74c7682@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 03:45:55PM -0800, Florian Fainelli wrote:
> On 1/5/21 3:40 PM, Jonathan Lemon wrote:
> > On Tue, Jan 05, 2021 at 03:11:03PM -0800, Florian Fainelli wrote:
> >> On 1/5/21 2:06 PM, Jonathan Lemon wrote:
> >>> From: Jonathan Lemon <bsd@fb.com>
> >>>
> >>> This is set of cleanup patches for zerocopy which are intended
> >>> to allow a introduction of a different zerocopy implementation.
> >>>
> >>> The top level API will use the skb_zcopy_*() functions, while
> >>> the current TCP specific zerocopy ends up using msg_zerocopy_*()
> >>> calls.
> >>>
> >>> There should be no functional changes from these patches.
> >>
> >> Your From and Signed-off-by tags are not matching and this is likely
> >> going to be flagged as an issue by Jakub and/or linux-next if/when this
> >> lands. You would want to get that fixed in your v2 along with the other
> >> feedback you may get.
> > 
> > Grr.  I don't know where this is coming from. 
> > The From: line is correct, and matches my Signed-off-by.
> 
> Your email addresses are different though, From is using your fb.com
> address and your Signed-off-by is with your gmail.com address so there
> is something in your git configuration or in the way you
> imported/formatted patches that results in this difference.

In the From: line, or in the message body?  Here, I see a @gmail
address in the From: line.  It looks like "git send-email" is
not doing what I expect.  I figured this out and should be fixed now.
-- 
Jonathan
