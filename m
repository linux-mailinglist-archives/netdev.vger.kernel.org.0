Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5B424EAE3
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 04:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHWCRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 22:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbgHWCQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 22:16:57 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA7BC061573;
        Sat, 22 Aug 2020 19:16:56 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1k9fYz-0002ur-9h; Sun, 23 Aug 2020 04:16:53 +0200
Date:   Sun, 23 Aug 2020 04:16:53 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] net: netfilter: delete repeated words
Message-ID: <20200823021653.GI15804@breakpoint.cc>
References: <20200823010727.4786-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200823010727.4786-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:
> Drop duplicated words in net/netfilter/ and net/ipv4/netfilter/.

Reviewed-by: Florian Westphal <fw@strlen.de>
