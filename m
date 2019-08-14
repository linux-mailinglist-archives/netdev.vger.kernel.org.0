Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1C7C8DA88
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731071AbfHNRSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:18:30 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:35636 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729862AbfHNRS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:18:27 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hxwuk-0004eT-4V; Wed, 14 Aug 2019 19:18:22 +0200
Date:   Wed, 14 Aug 2019 19:18:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: fallout from net-next netfilter changes
Message-ID: <20190814171822.7yuem4ji3od4zu3d@breakpoint.cc>
References: <20190814.125330.1934256694306164517.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814.125330.1934256694306164517.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> This started happening after Jakub's pull of your net-next changes
> yesterday:
> 
> ./include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
>  #warning "Please update iptables, this file will be removed soon!"
>   ^~~~~~~
> In file included from <command-line>:
> ./include/uapi/linux/netfilter_ipv4/ipt_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
>  #warning "Please update iptables, this file will be removed soon!"
>   ^~~~~~~
> 
> It's probaly from the standard kernel build UAPI header checks.

A patch that removes those #warning from the kernel is sitting in
the netfilter patchwork queue already.
