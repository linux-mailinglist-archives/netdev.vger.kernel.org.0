Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B93146B4C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgAWO3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 09:29:42 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44904 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726231AbgAWO3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 09:29:41 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iudU9-0007vD-Dk; Thu, 23 Jan 2020 15:29:29 +0100
Date:   Thu, 23 Jan 2020 15:29:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Florian Westphal <fw@strlen.de>,
        Praveen Chaudhary <praveen5582@gmail.com>, pablo@netfilter.org,
        davem@davemloft.net, kadlec@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zhenggen Xu <zxu@linkedin.com>,
        Andy Stracner <astracner@linkedin.com>
Subject: Re: [PATCH v3] [net]: Fix skb->csum update in
 inet_proto_csum_replace16().
Message-ID: <20200123142929.GV795@breakpoint.cc>
References: <1573080729-3102-1-git-send-email-pchaudhary@linkedin.com>
 <1573080729-3102-2-git-send-email-pchaudhary@linkedin.com>
 <16d56ee6-53bc-1124-3700-bc0a78f927d6@iogearbox.net>
 <20200122114333.GQ795@breakpoint.cc>
 <daf995db-37c6-a2f7-4d12-5c1a29e1c59b@iogearbox.net>
 <20200123082106.GT795@breakpoint.cc>
 <1c1fc75d-e69c-f2f6-78ce-de9dc8aa89ca@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c1fc75d-e69c-f2f6-78ce-de9dc8aa89ca@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 1/23/20 9:21 AM, Florian Westphal wrote:
> > So, AFAIU from what you're saying above the patch seems fine as-is and
> > just needs a more verbose commit message explaining why replace16()
> > doesn't update skb->csum while all the other ones do.
> > 
> > Is that correct?
> 
> Probably better a comment in the code to avoid confusion on why it's not done in
> inet_proto_csum_replace16() but all the other cases; mainly to avoid some folks
> in future sending random cleanup patches w/ removal attempts.

Makes sense, thanks!

Praveen, can you spin a v4 with a comment in replace16 that it
intentionally elides the skb->csum update because the function is
only used by ipv6?

Thanks!
