Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E43D40575D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357614AbhIINdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:33:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358060AbhIINbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66ED360555;
        Thu,  9 Sep 2021 13:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631194241;
        bh=TwE5ieLltQT1dAuj4+qxelD1xElQNJNdGPiXzXPxTtc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OkVimI2MX61gciZOGFagbIvRicVWt2kjUC3pBlGR6Thu8KIKMZUuc6lt6umQLcnhN
         CPolFhE+gHMNMNElNUlmG87gH2rJc3YnXdO4RrLeLMSCtSbWSUAj/qXEiPD0W8TvfG
         UfzOmR8BvpPPagcO7xjHJnR1TmANlewHTahS+pxU=
Date:   Thu, 9 Sep 2021 15:30:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux-Net <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: Please add 2dce224f469f ("netns: protect netns ID lookups with
 RCU") to LTS
Message-ID: <YToMf8zUVNVDCAKX@kroah.com>
References: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7F058034-8A2B-4C19-A39E-12B0DB117328@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 01:10:05PM +0000, Haakon Bugge wrote:
> Hi Greg & Sasha,
> 
> 
> tl;dr: Please add 2dce224f469f ("netns: protect netns ID lookups with
> RCU") to the stable releases from v5.4 and older. It fixes a
> spin_unlock_bh() in peernet2id() called with IRQs off. I think this
> neat side-effect of commit 2dce224f469f was quite un-intentional,
> hence no Fixes: tag or CC: stable.

Please provide a working backport for all of the relevant kernel
verisons, as it does not apply cleanly on it's own.

thanks,

greg k-h
