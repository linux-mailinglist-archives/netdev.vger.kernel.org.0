Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C072EB65B
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbhAEXlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:41:25 -0500
Received: from smtp6.emailarray.com ([65.39.216.46]:32351 "EHLO
        smtp6.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbhAEXlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:41:25 -0500
Received: (qmail 96552 invoked by uid 89); 5 Jan 2021 23:40:41 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp6.emailarray.com with SMTP; 5 Jan 2021 23:40:41 -0000
Date:   Tue, 5 Jan 2021 15:40:38 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemdebruijn.kernel@gmail.com, edumazet@google.com,
        dsahern@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next v1 00/13] Generic zcopy_* functions
Message-ID: <20210105234038.xr6xwgnhgpnzwwci@bsd-mbp.dhcp.thefacebook.com>
References: <20210105220706.998374-1-jonathan.lemon@gmail.com>
 <c7d877d9-d3ea-fedc-6492-9954cfded3eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7d877d9-d3ea-fedc-6492-9954cfded3eb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 03:11:03PM -0800, Florian Fainelli wrote:
> On 1/5/21 2:06 PM, Jonathan Lemon wrote:
> > From: Jonathan Lemon <bsd@fb.com>
> > 
> > This is set of cleanup patches for zerocopy which are intended
> > to allow a introduction of a different zerocopy implementation.
> > 
> > The top level API will use the skb_zcopy_*() functions, while
> > the current TCP specific zerocopy ends up using msg_zerocopy_*()
> > calls.
> > 
> > There should be no functional changes from these patches.
> 
> Your From and Signed-off-by tags are not matching and this is likely
> going to be flagged as an issue by Jakub and/or linux-next if/when this
> lands. You would want to get that fixed in your v2 along with the other
> feedback you may get.

Grr.  I don't know where this is coming from. 
The From: line is correct, and matches my Signed-off-by.

The envelopeSender is set to my work email in order to get
through the firewall.  Something is copying that into the 
mail body.
--
Jonathan
