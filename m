Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB1613D7A1
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 11:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgAPKOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 05:14:24 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:33736 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgAPKOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 05:14:24 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1is2AJ-00048J-GC; Thu, 16 Jan 2020 11:14:15 +0100
Date:   Thu, 16 Jan 2020 11:14:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        syzbot <syzbot+f9d4095107fc8749c69c@syzkaller.appspotmail.com>
Subject: Re: [PATCH] netfilter: nf_tables: fix memory leak in
 nf_tables_parse_netdev_hooks()
Message-ID: <20200116101415.GQ795@breakpoint.cc>
References: <000000000000ffbba3059c3b5352@google.com>
 <20200116100931.ot2ef4jvsw4ldye2@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116100931.ot2ef4jvsw4ldye2@kili.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Syzbot detected a leak in nf_tables_parse_netdev_hooks().  If the hook
> already exists, then the error handling doesn't free the newest "hook".

Thanks.

Reviewed-by: Florian Westphal <fw@strlen.de>
