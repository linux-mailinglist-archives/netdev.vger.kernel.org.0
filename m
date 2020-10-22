Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEBE2963F9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S369342AbgJVRrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:47:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:51644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S369335AbgJVRrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:47:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6F51205CA;
        Thu, 22 Oct 2020 17:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603388865;
        bh=uOUY3iza4z0i29x7c2GNav63vSfutKmexoVvZMTu7FI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sBiUH3PzD8nGeosdT/InpYebJVA5Kgrq8OomNGt6YK3gQBvkHxphio4mMzquSU7sv
         duxzT96Bsp78oRB00KPgflexR78W5Nk2cfPnSib/uCadAlF15CvXF72ZCgnJVLXwOU
         7gnrx2qys2zgMaInk+PU4Gnjh9I5q5q1+g1bFdRg=
Date:   Thu, 22 Oct 2020 10:47:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast
 path
Message-ID: <20201022104742.5093cce1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CADVnQy=KhEZ6OA+Kr2M8iP7zuPO7uc2jLJ1rxi1Qq8pau2KZ2w@mail.gmail.com>
References: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
        <20201022090757.4ac6ba0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CADVnQy=KhEZ6OA+Kr2M8iP7zuPO7uc2jLJ1rxi1Qq8pau2KZ2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 13:04:04 -0400 Neal Cardwell wrote:
> > In that case - can I slap:
> >
> > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >
> > on it?  
> 
> Yes, slapping that Fixes footer on it sounds fine to me. I see
> that it does apply cleanly to 1da177e4c3f4.

FWIW even if it didn't - my modus operandi is to have the tag pointing
at the earliest point in the git history where the bug exists. Even if
the implementation was completely rewritten - we want to let the people
who run old kernels know they may experience the issue.

Backporters will see the patch doesn't apply and make the right call.

That said I don't think the process documentation is very clear on
this, so maybe someone more experienced will correct my course :)

> Or let me know if you would prefer for me to resubmit a v2 with that footer.

I'll add it, no worries.
