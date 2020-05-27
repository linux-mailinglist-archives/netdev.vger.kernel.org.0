Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579851E40E7
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 13:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729451AbgE0Lz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 07:55:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51116 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387857AbgE0Lzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 07:55:52 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jduev-0006U9-E8; Wed, 27 May 2020 13:55:45 +0200
Date:   Wed, 27 May 2020 13:55:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, netdev@vger.kernel.org, matthieu.baerts@tessares.net,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com
Subject: Re: [PATCH v2 net-next 0/2] mptcp: adjust tcp rcvspace on rx
Message-ID: <20200527115545.GH2915@breakpoint.cc>
References: <20200525181508.13492-1-fw@strlen.de>
 <20200526.202812.2041217173134298145.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526.202812.2041217173134298145.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Florian Westphal <fw@strlen.de>
> Date: Mon, 25 May 2020 20:15:06 +0200
> 
> > These two patches improve mptcp throughput by making sure tcp grows
> > the receive buffer when we move skbs from subflow socket to the
> > mptcp socket.
> > 
> > The second patch moves mptcp receive buffer increase to the recvmsg
> > path, i.e. we only change its size when userspace processes/consumes
> > the data.  This is done by using the largest rcvbuf size of the active
> > subflows.
> 
> What's the follow-up wrt. Christoph's feedback on patch #2?

Please drop these patches, I have no idea (yet?) how to address it.
