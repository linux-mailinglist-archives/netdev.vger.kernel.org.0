Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DBE3713D5
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhECKxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 06:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhECKxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 06:53:48 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01794C06174A;
        Mon,  3 May 2021 03:52:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldWC1-0004ub-Qd; Mon, 03 May 2021 12:52:49 +0200
Date:   Mon, 3 May 2021 12:52:49 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] bpf-next test error: WARNING in __nf_unregister_net_hook
Message-ID: <20210503105249.GI975@breakpoint.cc>
References: <000000000000b361bf05c16429a5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b361bf05c16429a5@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9d31d233 Merge tag 'net-next-5.13' of git://git.kernel.org..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=102b70d9d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
> dashboard link: https://syzkaller.appspot.com/bug?extid=0d9ff6eeee8f4b6e2aed
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com

#syz dup: linux-next test error: WARNING in __nf_unregister_net_hook
