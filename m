Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1D014F448
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 23:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgAaWJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 17:09:19 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52810 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726163AbgAaWJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 17:09:19 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ixeTV-00065Y-Bi; Fri, 31 Jan 2020 23:09:17 +0100
Date:   Fri, 31 Jan 2020 23:09:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [Patch nf 2/3] xt_hashlimit: reduce hashlimit_mutex scope for
 htable_put()
Message-ID: <20200131220917.GL795@breakpoint.cc>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-3-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131205216.22213-3-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> It is unnecessary to hold hashlimit_mutex for htable_destroy()
> as it is already removed from the global hashtable and its
> refcount is already zero.
> 
> Also, switch hinfo->use to refcount_t so that we don't have
> to hold the mutex until it reaches zero in htable_put().

LGTM, thanks!

Acked-by: Florian Westphal <fw@strlen.de>
