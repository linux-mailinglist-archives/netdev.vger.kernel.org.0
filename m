Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9C92C29CE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389174AbgKXOhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 09:37:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388792AbgKXOhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 09:37:12 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E78CD206E5;
        Tue, 24 Nov 2020 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606228632;
        bh=j6IRcpY/mH7hDXjSRNBButpni1cVNHy28e8sREGEoMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=raJ39DqRvPH/LKTjquQvylhcM0i+gqB59F5EdMr/N/JgTKIAjsmWUudZCkXtQSVf5
         h3xB5yvMWALeNm11pdR60ywssktVRLdq7wxSQjJLQP344uW7YiO+4MKScviLRx6rG1
         KkXjD2gOSSRJcHGjAhhcmW2fX26FVwmekwerwpL0=
Date:   Tue, 24 Nov 2020 08:37:27 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 108/141] netfilter: ipt_REJECT: Fix fall-through warnings
 for Clang
Message-ID: <20201124143727.GF16084@embeddedor>
References: <cover.1605896059.git.gustavoars@kernel.org>
 <ff4cbf9ab833a9d17306674850116693a17f2780.1605896060.git.gustavoars@kernel.org>
 <20201120224905.GS15137@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201120224905.GS15137@breakpoint.cc>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 11:49:05PM +0100, Florian Westphal wrote:
> Gustavo A. R. Silva <gustavoars@kernel.org> wrote:
> > In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
> > by explicitly adding a break statement instead of letting the code fall
> > through to the next case.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Thanks, Florian.
--
Gustavo
