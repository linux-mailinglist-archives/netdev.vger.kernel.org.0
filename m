Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5923447317F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhLMQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbhLMQUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:20:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E86C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 08:20:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EE4D6115C
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 16:20:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDC6C34602;
        Mon, 13 Dec 2021 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639412447;
        bh=zIobHsCb+F0GSVkmsUXKWUurjJxczWxlK4+lxseeRlA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YIpotM+g/VJT+I8bNcwLmxdZK+HWWJEaW+Dk8zC81qhvtsL45QGQkIDIU7Ey6I7IB
         8iEWeg16lOrRg70fvq99c+yHAr3+eHb4vsT+WXW1HHzyE0+Q0f4ApnmOvRc9ee38Mr
         5Bv+euAf8ux+o3zamA8/FDO6JwgMriKoOL0o5gqZHLc0Ctda/iIBpzrkKTcwLk/RjC
         idiFggr4RRu7gAOnEa/aFfNecsGKomDREGLdM37x68w2oBEYCUPqJK+PRPmxpGD3nj
         KWkRuQfTNfIiWqY+p2dreu7TiuU8pWoPlkofMgEL5Af/X734RJAHK1OSClpnGsCrWu
         O7IGA4B0QEazQ==
Date:   Mon, 13 Dec 2021 08:20:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <20211213082046.17360ddd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YbdyPR0keP1wJmCC@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
        <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbckZ8VxICTThXOn@linutronix.de>
        <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YbdyPR0keP1wJmCC@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Dec 2021 17:18:05 +0100 Sebastian Andrzej Siewior wrote:
> On 2021-12-13 08:15:56 [-0800], Jakub Kicinski wrote:
> > FWIW I disagree. My version was more readable. The sprinkling of the
> > PREEMPT_RT tosh is getting a little annoying. Trying to regress the 
> > clarity of the code should be top of mind here.  
> 
> No worries. Let me spin a new version with a swap.

Dave applied your previous version, it's not a big deal, we'll live.
