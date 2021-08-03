Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC22B3DF6CC
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhHCVSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232056AbhHCVSw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:18:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A46BF60C3F;
        Tue,  3 Aug 2021 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628025520;
        bh=I088ZRH/p1JgKR9cQ9lGRjb8LcRqPb5AzcOEizYNYgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=R0hhGZ/K6Qo88HHivpe/mkY1SBJoBUsnlUOMq3RX4trYwrUubq1o/7eZaqskKoF9W
         4VVKcLWGA3nEjkkQQG/ywWC9JSdU42pLY1c9DpDwcULJq5Lilwnoyvmg6gbPmvBytj
         Fzr84dSR9SB9/X/CbCF4i0ZQtvERlWKSw5wXJQYmxQgoT/k+JsN+gfIwbZqCZZBnYt
         FPXfu0/EWBxp2vSc/BRxIqXy6q6r9XMKt2R/CxII8i3tDe6A0B9N2cZCrIIYhPR+an
         tBp5g7KbwKS0e1mnndo15rr3Z19+gI5sZXMrZPcqaK6Ta1OIg3umIkkhj8puOxCQ8w
         qgn5EjMmi9VDA==
Date:   Tue, 3 Aug 2021 14:18:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Peilin Ye <peilin.ye@bytedance.com>
Subject: Re: [PATCH net-next] Revert "netdevsim: Add multi-queue support"
Message-ID: <20210803141839.79e99e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
References: <20210803123921.2374485-1-kuba@kernel.org>
        <CAM_iQpUS_hNAb_-NmbcywyERwYp06ebJqv5Ve__okY6755-F=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Aug 2021 10:11:13 -0700 Cong Wang wrote:
> On Tue, Aug 3, 2021 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > This reverts commit d4861fc6be581561d6964700110a4dede54da6a6.
> >
> > netdevsim is for enabling upstream tests, two weeks in
> > and there's no sign of upstream test using the "mutli-queue"
> > option.  
> 
> Since when netdevsim is *only* for upstream tests?

Since it was created.

> Even if so, where is this documented? And why not just point it 
> out when reviewing it instead of silently waiting for weeks?

I was AFK for the last two weeks.

> > We can add this option back when such test materializes.
> > Right now it's dead code.  
> 
> It is clearly not dead. We internally used it for testing sch_mq,
> this is clearly stated in the git log.

Please contribute those tests upstream or keep any test harness 
they require where such test are, out of tree.

> How did you draw such a conclusion without talking to authors?

There is no upstream test using this code, and I did CC you, didn't I?

> But this does remind me of using netdevsim for tc-testing.

Please bring the code back as part of the series adding upstream tests.

Thank you.
