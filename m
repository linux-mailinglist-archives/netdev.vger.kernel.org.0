Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70044218FA9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgGHSZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 14:25:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGHSZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 14:25:06 -0400
Received: from embeddedor (unknown [201.162.240.161])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F4362078D;
        Wed,  8 Jul 2020 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594232706;
        bh=M9MY+fWX6+x29R7/l42mVKrvKcjn7f0nCowboASuXE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bMhYtMoFpRSCBD1jPT24LCNWTQrQSw+82QgcYiQLI0gRA70YcJQT+Ju4VSHdQ0pLI
         FyLQwsk0fX///QKIxb5z1OCMSBawvXXEW2wcLBbF+Rw0LpmEDMbj/AH/vb0He6Q2Af
         LdZjwrsMDsGuqOniiyvSdo7GcDQayAzsr8JhGWn0=
Date:   Wed, 8 Jul 2020 13:30:33 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH][next] netfilter: nf_tables: Use fallthrough
 pseudo-keyword
Message-ID: <20200708183033.GG11533@embeddedor>
References: <20200707194717.GA3596@embeddedor>
 <20200708160931.GA14715@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708160931.GA14715@salvia>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 06:09:31PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 07, 2020 at 02:47:17PM -0500, Gustavo A. R. Silva wrote:
> > Replace the existing /* fall through */ comments and its variants with
> > the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> > fall-through markings when it is the case.
> 
> I suggest:
> 
>         netfilter: Use fallthrough pseudo-keyword
> 
> instead, since this is also updating iptables and ipset codebase.
> 

Yep; I noticed that, but forgot to change the subject before submitting
the patch.

I will address the rest of the comments and send v2, shortly.

Thanks
--
Gustavo

