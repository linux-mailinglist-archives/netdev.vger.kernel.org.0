Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB02CF281
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbgLDRAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:00:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbgLDRAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 12:00:08 -0500
Date:   Fri, 4 Dec 2020 08:59:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607101167;
        bh=gl3j6GfD/hwd+MO3p4sBQdCdAImJxQj9cePaVZD0hcc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=pE3uEVkO4dAS1eoCoZBs3gtXujuZXKjg5fh853zhRXSHl+xiTjnyJi64TetelW1XB
         xLH2uZthsDXHinh6lvFIavrMoezGIIbCffmZ/65tSqPxgSK+hOWGsuOMEiiYeUwF3h
         vyGhpO8aBgxXKi3QqjJKIwXdjeh+e/o6JgDJN7jWBxrOwUMKQVYhLF6kuuDY/jeJ6u
         zRr5r1sTZc12W3aCrldiKlDOzDnBR3JzSF39XimDmE/RXp+fei8pc4IGGzuWlooByt
         +Yzwy5jy4F10c5LVTjNfAu9aTWTMt6USTE9HYYI57WG3snm/x6kQWnLi1EnmhTHyrA
         1cTkvzcacNiNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Jianguo Wu <wujianguo106@163.com>, netdev@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, pabeni@redhat.com,
        davem@davemloft.net
Subject: Re: [PATCH] mptcp: print new line in mptcp_seq_show() if mptcp
 isn't in use
Message-ID: <20201204085926.078e5a9a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204152119.GA31101@breakpoint.cc>
References: <c1d61ab4-7626-7c97-7363-73dbc5fa3629@163.com>
        <20201204152119.GA31101@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 16:21:19 +0100 Florian Westphal wrote:
> Jianguo Wu <wujianguo106@163.com> wrote:
> > From: Jianguo Wu <wujianguo@chinatelecom.cn>  
> 
> A brief explanation would have helped.

Yes, please post a v2 with a sentence describing the problem and output
before and after the change.

> This is for net tree.

By which we mean please tag v2 as [PATCH net v2] in the subject.

> > Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>  
> 
> Fixes: fc518953bc9c8d7d ("mptcp: add and use MIB counter infrastructure")
> Acked-by: Florian Westphal <fw@strlen.de>

And please make sure to add these to your patch before posting so
Florian doesn't have to resend them.
