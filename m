Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BCF3713CC
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 12:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhECKvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 06:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhECKvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 06:51:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E867C06174A;
        Mon,  3 May 2021 03:50:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ldW9p-0004tt-DN; Mon, 03 May 2021 12:50:33 +0200
Date:   Mon, 3 May 2021 12:50:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] linux-next test error: WARNING in
 __nf_unregister_net_hook
Message-ID: <20210503105033.GH975@breakpoint.cc>
References: <0000000000003a5d4c05c140175f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000003a5d4c05c140175f@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    74f961f4 Add linux-next specific files for 20210430
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=156e6f15d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=acf3aa1c9f3e62f8
> dashboard link: https://syzkaller.appspot.com/bug?extid=dcccba8a1e41a38cb9df
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dcccba8a1e41a38cb9df@syzkaller.appspotmail.com

Can reproduce this & will look at it later today.
