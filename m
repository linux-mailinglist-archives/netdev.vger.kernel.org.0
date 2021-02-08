Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86467313F61
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbhBHTop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:44:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235506AbhBHTne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:43:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45BA0601FE;
        Mon,  8 Feb 2021 19:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612813371;
        bh=d661Gkj5uDPyjiuPmo7dVeApop9R+vb1Lt40RdJVELI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bX2v72YYQwKc0W7ftrMUwQ+VQpURy2RKP1n0d5tSAblQjAybzitS42mN5JO9RFOMT
         0+3xBGTuJs0gdLUhF02+FWXX/fcra+8rySqVQfo+zF0eUEarz0HqlW30pcdG57+MqT
         O+yg1bCatEG7O8/N9M8FWjs1r1TSuFICNcwUVypMS85okvGXPZU/i9oU1jvUtei7d6
         6KpoVzFPKRuF3VxqBeRDCatCIFobJ7V9qVLCOMhFHuezANrI2ytArtOQkqkGKdlkGG
         2emhmcbifLfVOkqzxpIzWPa4FGbCM5fx8EneEJ8RK3vpBZzAtXeKoNRL9k0QhyP0TI
         XE+/6MtoB1ZGQ==
Date:   Mon, 8 Feb 2021 11:42:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     NeilBrown <neilb@suse.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix some seq_file users that were recently broken
Message-ID: <20210208114249.6c7e04e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210207131145.ea12b9944c54ad2f10932bc3@linux-foundation.org>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
        <20210205143550.58d3530918459eafa918ad0c@linux-foundation.org>
        <20210206142924.2bfc3cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210207131145.ea12b9944c54ad2f10932bc3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 7 Feb 2021 13:11:45 -0800 Andrew Morton wrote:
> On Sat, 6 Feb 2021 14:29:24 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 5 Feb 2021 14:35:50 -0800 Andrew Morton wrote:  
> > > On Fri, 05 Feb 2021 11:36:30 +1100 NeilBrown <neilb@suse.de> wrote:
> > > 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and
> > > interface") was August 2018, so I don't think "recent" applies here?
> > > 
> > > I didn't look closely, but it appears that the sctp procfs file is
> > > world-readable.  So we gave unprivileged userspace the ability to leak
> > > kernel memory?
> > > 
> > > So I'm thinking that we aim for 5.12-rc1 on all three patches with a cc:stable?  
> > 
> > I'd rather take the sctp patch sooner, we'll send another batch 
> > of networking fixes for 5.11, anyway. Would that be okay with you?  
> 
> Sure.

Applied patch 3 to net, thanks everyone!
