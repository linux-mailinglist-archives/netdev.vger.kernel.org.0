Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5564A4731DD
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237444AbhLMQci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:32:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:35850 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233962AbhLMQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:32:37 -0500
Date:   Mon, 13 Dec 2021 17:32:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639413156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l/o9NNCf6o81abGjXJcgio9IBjvwavhfuwFkoSEKieo=;
        b=FTNxzB5pL4XtGEeJ/YMf3no1IzsPUt6we5IBa7SDAjGZQ8iqHO0swixgKpuHcu1ZWv66ZR
        M+48+o1dGUaHbom6lpMJXWwRoRnSIPxnMO2uIHWYTyRmnpTRwdThzOdnXM/ST8U7ZAlrm+
        tbztiW8iwkpwlidP5If8aDpsTOByfd3J4zRS/xIy69m7DKAOhfE6JdZ9XUwFpvUeqr4G0W
        2qDh8ZPq7KKcvHD6IgzswzEBI6cSTwLjRZUmMqSgLvcoEnQgE2Bze+m9T5eiyW3fmNgavb
        mWvn+TVJAwB53CwZSbYec2v3wSZHWj0eb1n0YuOdpNMoULGsusDb3f4VJp/VSA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639413156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=l/o9NNCf6o81abGjXJcgio9IBjvwavhfuwFkoSEKieo=;
        b=XIvVHO+/1xeJOsocLRjjtX3iu43cRp1i3XaOt+2z1dDwDXIOiIXtq+QFFY/oD80lxPOsKD
        HeZq6iBkqcFUxACA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next] net: dev: Always serialize on Qdisc::busylock
 in __dev_xmit_skb() on PREEMPT_RT.
Message-ID: <Ybd1o6ZXs2C5rzaz@linutronix.de>
References: <YbN1OL0I1ja4Fwkb@linutronix.de>
 <20211210203256.09eec931@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbckZ8VxICTThXOn@linutronix.de>
 <20211213081556.1a575a28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YbdyPR0keP1wJmCC@linutronix.de>
 <20211213082046.17360ddd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213082046.17360ddd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-13 08:20:46 [-0800], Jakub Kicinski wrote:
> On Mon, 13 Dec 2021 17:18:05 +0100 Sebastian Andrzej Siewior wrote:
> > On 2021-12-13 08:15:56 [-0800], Jakub Kicinski wrote:
> > > FWIW I disagree. My version was more readable. The sprinkling of the
> > > PREEMPT_RT tosh is getting a little annoying. Trying to regress the 
> > > clarity of the code should be top of mind here.  
> > 
> > No worries. Let me spin a new version with a swap.
> 
> Dave applied your previous version, it's not a big deal, we'll live.

but happy. Not just live. I've sent a follow-up. I need the network
department in a happy mood :)

Sebastian
