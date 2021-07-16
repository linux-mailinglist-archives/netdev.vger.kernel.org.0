Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900453CBB5B
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhGPRuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229462AbhGPRuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 13:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46E88611AE;
        Fri, 16 Jul 2021 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626457623;
        bh=mqwSlXre4cM8BHsWlg1hNsT7J7ElJ/2K8n+v+keGSh8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rZvzwwzXD9MQy7JRvzBB3LSmL3S3pdzXpdeKNbjh7kvzIQlhHGBuuoFuwW5dvgagr
         59M/Zg+wmylNYmwDkvEhJyynxA1jvRgW/AFJ6FJo9y5C5O9O38speBripG6yGa8NTs
         wCa37sTDP4JvMsiVYCJwmWuuFe8KVLytKvIQc2lM=
Date:   Fri, 16 Jul 2021 19:47:01 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Varad Gautam <varad.gautam@suse.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 5.4 097/122] xfrm: policy: Read seqcount outside of
 rcu-read side in xfrm_policy_lookup_bytype
Message-ID: <YPHGFZe5gdxEj93R@kroah.com>
References: <20210715182448.393443551@linuxfoundation.org>
 <20210715182517.994942248@linuxfoundation.org>
 <20210715185447.GC9904@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715185447.GC9904@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 15, 2021 at 08:54:47PM +0200, Florian Westphal wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > From: Varad Gautam <varad.gautam@suse.com>
> > 
> > commit d7b0408934c749f546b01f2b33d07421a49b6f3e upstream.
> 
> This patch has been reverted in the ipsec tree, the problem was then
> addressed via 2580d3f40022642452dd8422bfb8c22e54cf84bb
> ("xfrm: Fix RCU vs hash_resize_mutex lock inversion").
> 
> AFAICS its not in mainline yet.

Thank you, I have now dropped this from everywhere.

greg k-h
