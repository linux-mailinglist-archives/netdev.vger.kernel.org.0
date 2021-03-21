Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785963431D1
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 10:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCUJOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 05:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCUJOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Mar 2021 05:14:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B00E461930;
        Sun, 21 Mar 2021 09:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616318081;
        bh=z97kX6cRsiWQ+kLn2PcEWBpfL+Nxlr7V5w7JYn8raEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TvBVtgqetIN8APxXPAErCysuUdh/nZg0AoZ2Nld3XgCVpurPKbzK6hcOPDhezkMQB
         r2CarikIJkobRmGb+0Jj0uRXH4hskPuUrm8CbfwqMkEpAX6qMkRneNbwyhj/lNHLUt
         1lSHrzyRGmpd3quKdzk27Ea2rzoQncTkYHv3AWoUuFPsrpm+zFHHl9N90oJrxcJxp4
         dCQKc10KNDMri8FFw0kx0IOyRDdWHQEElulJPA/TO5ZdJn6D8GpSyzHN88XJQXTS7C
         rgKT2GxCAOO95lpn+n+NF/9mjtbb7MNg0DOp2JrcnmncL5Nh0vsJw1Qq001W3ObOQQ
         5LSMhVISbskXA==
Date:   Sun, 21 Mar 2021 11:14:37 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>
Subject: Re: linux-next: manual merge of the net tree with Linus' tree
Message-ID: <YFcOffNUTg8qxuNp@unreal>
References: <20210319082939.77495e55@canb.auug.org.au>
 <YFTJdL1yDId+iae4@unreal>
 <65e47dcc-702b-98e0-2750-d5b11a7c0ae1@pengutronix.de>
 <CAHk-=wgmL3qJhjnoG1z9kH-N0RokWOHATRjPyLWGx=U7Ar-1qA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgmL3qJhjnoG1z9kH-N0RokWOHATRjPyLWGx=U7Ar-1qA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 12:42:06PM -0700, Linus Torvalds wrote:
> On Sat, Mar 20, 2021 at 12:28 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > Good idea. I'll send a pull request to David and Jakub.
> 
> I don't think the revert is necessary. The conflict is so trivial that
> it doesn't really matter.

<...>

> But something like this that just removes the
> MODULE_SUPPORTED_DEVICE() thing that basically never gets touched
> anyway, and we happened to be unlucky in *one* file? Not a worry at
> all.

For me this specific revert is a way to reduce the overhead from the maintainer
when they prepare PRs. At least for me, PRs are most time consuming tasks.

No patch - no conflict - less worries.

Thanks
