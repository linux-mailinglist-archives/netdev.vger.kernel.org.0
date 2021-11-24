Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D4745B4D6
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 08:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240573AbhKXHDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 02:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240532AbhKXHDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 02:03:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D4A60FE3;
        Wed, 24 Nov 2021 07:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637737240;
        bh=WpycCd7rA2r5gbWL6+TQtvCF3GxPjHNQ4cBOFi+oqEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FRTT+YeBjfefAmrOy8RRXTFw92Xgdr4UYgOAycvKgAQM5ecVJItEfqpwH4tfYxKFJ
         e8Iq5HNdKnJI/W2IuHdyXTjZEtMp7d9lo9H83d+M7vKojfF9RtRhBQUY3Es2eIe9Vq
         h6c69b8CGYoTDKn9m+ZSNzI/yYxBrPfsC8AMK578=
Date:   Wed, 24 Nov 2021 08:00:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        msizanoen1 <msizanoen@qtmlabs.xyz>, stable@vger.kernel.org
Subject: Re: [PATCH net] ipv6: fix memory leak in fib6_rule_suppress
Message-ID: <YZ3jFik9MNi8m6JV@kroah.com>
References: <20211123124832.15419-1-Jason@zx2c4.com>
 <20211123200347.597e2daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123200347.597e2daf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 08:03:47PM -0800, Jakub Kicinski wrote:
> On Tue, 23 Nov 2021 13:48:32 +0100 Jason A. Donenfeld wrote:
> > The original author of this commit and commit message is anonymous and
> > is therefore unable to sign off on it. Greg suggested that I do the sign
> > off, extracting it from the bugzilla entry above, and post it properly.
> > The patch "seems to work" on first glance, but I haven't looked deeply
> > at it yet and therefore it doesn't have my Reviewed-by, even though I'm
> > submitting this patch on the author's behalf. And it should probably get
> > a good look from the v6 fib folks. The original author should be on this
> > thread to address issues that come off, and I'll shephard additional
> > versions that he has.
> 
> Does the fact that the author responded to the patch undermine the need
> for this special handling?

Unless the author wishes to use their real name, sadly it does not :(
