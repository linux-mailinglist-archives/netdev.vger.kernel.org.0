Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343D218F369
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 12:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgCWLHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 07:07:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:45758 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgCWLHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 07:07:11 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jGKvB-00086d-6s; Mon, 23 Mar 2020 12:07:05 +0100
Date:   Mon, 23 Mar 2020 12:07:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in nf_flow_table_offload_setup
Message-ID: <20200323110705.GC3305@breakpoint.cc>
References: <000000000000b6da7b059c8110c4@google.com>
 <0000000000005fc4c505a1833ed3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005fc4c505a1833ed3@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot <syzbot+e93c1d9ae19a0236289c@syzkaller.appspotmail.com> wrote:
> If the result looks correct, please mark the bug fixed by replying with:
 
#syz fix: netfilter: flowtable: skip offload setup if disabled
