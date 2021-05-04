Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C046237272A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 10:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhEDI0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 04:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhEDI0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 04:26:10 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD0BC061574;
        Tue,  4 May 2021 01:25:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldqMe-0002nh-9T; Tue, 04 May 2021 10:25:08 +0200
Date:   Tue, 4 May 2021 10:25:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] memory leak in nf_hook_entries_grow (2)
Message-ID: <20210504082508.GA1019@breakpoint.cc>
References: <0000000000001d488205c1702d78@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000001d488205c1702d78@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    9ccce092 Merge tag 'for-linus-5.13-ofs-1' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=141aec93d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5ab124e5617a0cfa
> dashboard link: https://syzkaller.appspot.com/bug?extid=050de9f900eb45b94ef9
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14bd921ed00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+050de9f900eb45b94ef9@syzkaller.appspotmail.com

#syz dup: linux-next test error: WARNING in __nf_unregister_net_hook

(The memory leak is the consequence if the WARNING).
