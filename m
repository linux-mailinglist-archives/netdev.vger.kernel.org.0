Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8B1505DF
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 13:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbgBCMGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 07:06:35 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57890 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbgBCMGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 07:06:35 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iyaUr-0003tF-Ih; Mon, 03 Feb 2020 13:06:33 +0100
Date:   Mon, 3 Feb 2020 13:06:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf v2 3/3] xt_hashlimit: limit the max size of hashtable
Message-ID: <20200203120633.GQ795@breakpoint.cc>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
 <20200203043053.19192-4-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203043053.19192-4-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> The user-specified hashtable size is unbound, this could
> easily lead to an OOM or a hung task as we hold the global
> mutex while allocating and initializing the new hashtable.

Reviewed-by: Florian Westphal <fw@strlen.de>
