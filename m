Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C347E2DA608
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 03:15:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgLOCOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 21:14:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726412AbgLOCOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 21:14:21 -0500
Date:   Mon, 14 Dec 2020 18:13:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607998421;
        bh=j+mo+RL8S/hnsnS3PJ9sF0CcyLg7yIw0RyPIdNZ6Ttg=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PX51nWb470XdHiAuALDAHwzGHnJX6Nm4ykO4U0DkESK/AapXTTeODMVBzdQphv41W
         QcYRRAzaM9ohGjxjW/Xegc+XiUVGVMjCswiiFaDUVJhdfiiBKmSoFvPH/uwKZZ0FKa
         B3eAheBUcYhtrsdiWcAcYfvERWHuo53emenIsIZPcKEVEj/TwuMJdYk1tSs/6gKhn+
         ErTG7DWosWJ2PW/B6zZN3+r3VUEB1+QF5aedyXjJ4utxu9qZXvAGz5lWAa10zTryRN
         roJ+0/NHIsTRZfd0gQQN1UwSUDoLxLQpaNV7w41KuYQfFvCUKCx6/XIwqPM2GWNX8B
         ZMgFOyZQsRNFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 bpf-next tree
Message-ID: <20201214181339.621c4dcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214181121.afe9628c62c4b5de1f5fee94@linux-foundation.org>
References: <20201204202005.3fb1304f@canb.auug.org.au>
        <20201215072156.1988fabe@canb.auug.org.au>
        <20201215012943.GA3079589@carbon.DHCP.thefacebook.com>
        <20201214174021.2dfc2fbd99ca3e72b3e4eb02@linux-foundation.org>
        <20201214180629.4fee48ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201214181121.afe9628c62c4b5de1f5fee94@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 18:11:21 -0800 Andrew Morton wrote:
> On Mon, 14 Dec 2020 18:06:29 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> > Hm. The code is in net-next by now. I was thinking of sending the
> > Networking PR later today (tonight?) as well. I'm happy to hold off 
> > or do whatever you require, but I'd appreciate more explicit / noob
> > friendly instructions.  
> 
> Linus tends not to like it when tree maintainers do last-minute
> conflict fixes.

Good to know.

> > AFAIU all we can do is tell Linus about the merge issue, and point 
> > at Stephen's resolution.  
> 
> That's the way to do it - including a (tested?) copy in the email would
> be nice.

Okay, great. Will try this, thanks!
