Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9A616AFFF
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 20:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbgBXTL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 14:11:57 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51516 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726216AbgBXTL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 14:11:57 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j6J90-0003Hk-Ep; Mon, 24 Feb 2020 20:11:54 +0100
Date:   Mon, 24 Feb 2020 20:11:54 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Suryaputra <ssuryaextr@gmail.com>
Subject: Re: [PATCH nf] netfilter: ensure rcu_read_lock() in
 ipv4_find_option()
Message-ID: <20200224191154.GH19559@breakpoint.cc>
References: <20200224185529.50530-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224185529.50530-1-mcroce@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matteo Croce <mcroce@redhat.com> wrote:
> As in commit c543cb4a5f07 ("ipv4: ensure rcu_read_lock() in ipv4_link_failure()")
> and commit 3e72dfdf8227 ("ipv4: ensure rcu_read_lock() in cipso_v4_error()"),
> __ip_options_compile() must be called under rcu protection.

This is not needed, all netfilter hooks run with rcu_read_lock held.

