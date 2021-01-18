Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17882FACB2
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394438AbhARVb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388288AbhARVai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:30:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0861822CB1;
        Mon, 18 Jan 2021 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611005397;
        bh=aH/TMQfSg0E4qOWmkiFs/uZwFgxvkFamrjALj23OUug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g7mpyfXuDimv0FBrSZZWJTWDyy3TMC2DMfK4ND5k7Q1fbY81flmZKDm7p076mlkOa
         onddYBlAXrf30shVVJ6D73qf8RSExxkH3A3WkczXB8VLCIZoorUdK1cxoOJLjMPy6z
         +cFRbspmO+3VODIq/cp5T2S9Aq/+cIcBnj76AFi2cRnqcipjr1DTTb1FJVyqqC5Fuo
         68VaD0Bq2StwnkE03iLN4Sv03te43AcxCOuhlTenMG4dsCaedC3zn3nZE+Qt7nIaRQ
         Tps3FdUo3OMgceu2mQxZrGOBcTGjvlYJjDxtNG5pvfi/kz7C0h580BWdwYZEq0CcPX
         WZ2C1zcGJEY7Q==
Date:   Mon, 18 Jan 2021 13:29:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dong.menglong@zte.com.cn, daniel@iogearbox.net, gnault@redhat.com,
        ast@kernel.org, nicolas.dichtel@6wind.com, ap420073@gmail.com,
        edumazet@google.com, pabeni@redhat.com, jakub@cloudflare.com,
        bjorn.topel@intel.com, keescook@chromium.org,
        viro@zeniv.linux.org.uk, rdna@fb.com, maheshb@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default
 and sysctl_rmem_default
Message-ID: <20210118132955.2f7c86c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118131528.72e194d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210117102319.193756-1-dong.menglong@zte.com.cn>
        <20210118111518.nsrtv52xsanf7q6d@wittgenstein>
        <20210118131528.72e194d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 13:15:28 -0800 Jakub Kicinski wrote:
> On Mon, 18 Jan 2021 12:15:18 +0100 Christian Brauner wrote:
> > On Sun, Jan 17, 2021 at 06:23:19PM +0800, menglong8.dong@gmail.com wrote:  
> > > From: Menglong Dong <dong.menglong@zte.com.cn>
> > > 
> > > For now, sysctl_wmem_default and sysctl_rmem_default are globally
> > > unified. It's not convenient in some case. For example, when we
> > > use docker and try to control the default udp socket receive buffer
> > > for each container.
> > > 
> > > For that reason, make sysctl_wmem_default and sysctl_rmem_default
> > > per-namespace.
> > > 
> > > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> > > ---    
> > 
> > Hey Menglong,
> > 
> > I was about to review the two patches you sent:
> > 
> > 1. [PATCH net-next] net: core: Namespace-ify sysctl_rmem_max and sysctl_wmem_max
> >    https://lore.kernel.org/lkml/20210117104743.217194-1-dong.menglong@zte.com.cn
> > 2. [PATCH net-next] net: core: Namespace-ify sysctl_wmem_default and sysctl_rmem_default
> >    https://lore.kernel.org/lkml/20210117102319.193756-1-dong.menglong@zte.com.cn  
> 
> And perhaps
> 
>   0. [PATCH net-next] net: core: init every ctl_table in netns_core_table
> 
> ? 
> 
> I'm dropping these three from patchwork please follow Christian
> suggestions on how to repost properly, thanks!

Ah, you already did.
