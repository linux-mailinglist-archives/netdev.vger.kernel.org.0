Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4C41DEB87
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgEVPKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:10:14 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:56462 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729931AbgEVPKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:10:13 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jc9JK-0001rJ-BT; Fri, 22 May 2020 17:10:10 +0200
Date:   Fri, 22 May 2020 17:10:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next] mptcp: adjust tcp rcvspace after moving skbs
 from ssk to sk queue
Message-ID: <20200522151010.GC26949@breakpoint.cc>
References: <20200522124350.47615-1-fw@strlen.de>
 <c0f4e88f0a1b5449b341f2f7747a4aa7994089e7.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0f4e88f0a1b5449b341f2f7747a4aa7994089e7.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:
> It looks like this way ssk rcvbuf will grow up to tcp_rmem[2] even if
> there is no user-space reader - assuming the link is fast enough.
> 
> Don't we need to somehow cap that? e.g. moving mptcp rcvbuf update in
> mptcp_revmsg()?

From irc discussion it looks like you already have a patch for that.

I marked this patch as "Changes Requested" and do not plan to resend
it for the time being.
