Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33BF2B6AAF
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 17:52:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgKQQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 11:52:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727100AbgKQQwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 11:52:32 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 507F322447;
        Tue, 17 Nov 2020 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605631951;
        bh=VVm+5yKkD7QeM0fpIgW2W6Gwnfsw8e1bmws809SNAmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N/9N4lQyylJNqc8JGtfCSkp1Beul/YCXVR2/Xw2aoLQYH6xgPGhfXxeWsB9IyAYJR
         TB076DIm26o54U2VY69q1jOeVF3zyENJ8DEf+vqTnVZAeLcX6/gu2pqLwk/F9DdOk2
         Yw9IpdUsd//OqcDJ1vfM7mq/PHAoK2sWN4lbJTWg=
Date:   Tue, 17 Nov 2020 08:52:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     Guillaume Nault <gnault@redhat.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201117085230.03209114@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201117125422.GC4640@katalix.com>
References: <20201106181647.16358-1-tparkin@katalix.com>
        <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201110092834.GA30007@linux.home>
        <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201117125422.GC4640@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 12:54:22 +0000 Tom Parkin wrote:
> > > I think the question is more about long term maintainance. Do we want
> > > to keep PPP related module self contained, with low maintainance code
> > > (the current proposal)? Or are we willing to modernise the
> > > infrastructure, add support and maintain PPP features in other modules
> > > like flower, tunnel_key, etc.?  
> > 
> > Right, it's really not great to see new IOCTLs being added to drivers,
> > but the alternative would require easily 50 times more code.  
> 
> Jakub, could I quickly poll you on your current gut-feel level of
> opposition to the ioctl-based approach?
> 
> Guillaume has given good feedback on the RFC code which I can work
> into an actual patch submission, but I don't really want to if you're
> totally opposed to the whole idea :-)

I'll merge it if no one else speaks up in opposition.
