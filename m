Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C269A372127
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 22:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhECUO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 16:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhECUO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 16:14:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586C1C06174A;
        Mon,  3 May 2021 13:13:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldewe-0008DW-BA; Mon, 03 May 2021 22:13:32 +0200
Date:   Mon, 3 May 2021 22:13:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] upstream test error: WARNING in __nf_unregister_net_hook
Message-ID: <20210503201332.GM975@breakpoint.cc>
References: <00000000000021665f05c1702dd1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000021665f05c1702dd1@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9ccce092 Merge tag 'for-linus-5.13-ofs-1' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15303b33d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=27df24136354948b
> dashboard link: https://syzkaller.appspot.com/bug?extid=7ad5cd1615f2d89c6e7e
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com

#syz dup: linux-next test error: WARNING in __nf_unregister_net_hook
