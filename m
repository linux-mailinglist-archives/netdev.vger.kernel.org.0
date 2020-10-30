Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2695D2A0AF6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgJ3QSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:18:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3QSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 12:18:03 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E42AD20719;
        Fri, 30 Oct 2020 16:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604074683;
        bh=qc7JBg75QbyHeN8hIxPfsqmQIEy61qUjh+GZ1gIIJAo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Arp72sFb2kYLVii96eL0/P993W/K8aiRVySoDw5wi4MHjs2L3+a/UH2IRIHQ6UzPx
         6egSmV8Z376UaatryNJARr9AGAH7+0U5VPC9NJByo6MuLXsN8YLSJJQ3QlsOoheq5D
         6L4XI10l6krH0VCeyof9s/Sa/IaX1hYNRUW+iA+Y=
Date:   Fri, 30 Oct 2020 09:18:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     gregkh <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [GIT PULL, staging, net-next] wimax: move to staging
Message-ID: <20201030091801.2ac8ef1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201030122231.GA2522837@kroah.com>
References: <CAK8P3a2zy2X9rivWcGaOB=c8SQ8Gcc8tm_6DMOmcQVKFift+Tg@mail.gmail.com>
        <20201030122231.GA2522837@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:22:31 +0100 gregkh wrote:
> On Thu, Oct 29, 2020 at 10:06:14PM +0100, Arnd Bergmann wrote:
> > The following changes since commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec:
> > 
> >   Linux 5.10-rc1 (2020-10-25 15:14:11 -0700)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git
> > tags/wimax-staging  
> 
> Line wrapping makes this hard :(
> 
> Anyway, pulled into the staging-next branch now, so it's fine if this
> also gets pulled into the networking branch/tree as well, and then all
> should be fine.

..and pulled into net-next, thanks!
