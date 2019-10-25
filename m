Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36401E4355
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 08:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404509AbfJYGLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 02:11:55 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:38820 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404448AbfJYGLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 02:11:54 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iNsp8-0000Se-02; Fri, 25 Oct 2019 08:11:46 +0200
Date:   Fri, 25 Oct 2019 08:11:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, dhowells@redhat.com,
        fw@strlen.de, kadlec@netfilter.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in nf_ct_deliver_cached_events
Message-ID: <20191025061145.GX25052@breakpoint.cc>
References: <00000000000074bc3105958042ef@google.com>
 <000000000000aecf020595b4762f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000aecf020595b4762f@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com> wrote:
> syzbot has bisected this bug to:
> 
> commit 2341e0775747864b684abe8627f3d45b167f2940
> Author: David Howells <dhowells@redhat.com>
> Date:   Thu Jun 9 22:02:51 2016 +0000
> 
>     rxrpc: Simplify connect() implementation and simplify sendmsg() op
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12f869df600000

Looks like 5.2 and earlier crash with a different backtrace than
original.

Proposed patch for this netfilter splat is:
https://patchwork.ozlabs.org/patch/1181533/
