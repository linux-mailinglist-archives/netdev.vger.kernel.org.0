Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F90C372122
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhECUN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhECUN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 16:13:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE7AC06174A;
        Mon,  3 May 2021 13:13:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldew9-0008Cq-BQ; Mon, 03 May 2021 22:13:01 +0200
Date:   Mon, 3 May 2021 22:13:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+33d023f240aa788eb7fe@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] net test error: WARNING in __nf_unregister_net_hook
Message-ID: <20210503201301.GL975@breakpoint.cc>
References: <0000000000000032b105c170317c@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000000032b105c170317c@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+33d023f240aa788eb7fe@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    f18c51b6 net: stmmac: Remove duplicate declaration of stmm..
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=160a1da5d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
> dashboard link: https://syzkaller.appspot.com/bug?extid=33d023f240aa788eb7fe
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+33d023f240aa788eb7fe@syzkaller.appspotmail.com

#syz dup: linux-next test error: WARNING in __nf_unregister_net_hook
