Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D1C30124F
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbhAWCfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:37402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726374AbhAWCfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:35:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D78B423B2F;
        Sat, 23 Jan 2021 02:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611369265;
        bh=Tn3Ljt78OWX/vk/E7IdSDzroXqvkM/ec13V1UWGX98Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZRdWVy+mwTJISPfd2P4Rih+Fh36oTCu/XAF17zixDcY+oX5zuUWVVRV2wNuUORv+
         EMKn0/tQ/MB6Pn+WzIqorqQwZWAb33Yx4qWInwPAj1sCc5IJw0NrgQGJgrfUWck2qk
         E1dRIzUmWtcZhIMrRJekO5Zh0TfpCwIG38x5t8BxJamIfkDR7IhLGRWm4bMsRy0hnj
         MAJrHSh2hLLcXEJsA71ofvVf62GFFKfpNo3AshFDlkbev/lOkHx1eBL4FY29V7N5Z5
         eNlAoLvYm65Q1ZSfo53xyZH/eLZwDM626K9Qs6gYL4pZARhp04lWqohlvpS2YfV9Mv
         +UF1WsgaOoFdQ==
Date:   Fri, 22 Jan 2021 18:34:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Enke Chen <enkechen2020@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>
Subject: Re: [PATCH net] tcp: make TCP_USER_TIMEOUT accurate for zero window
 probes
Message-ID: <20210122183424.59c716a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210123022823.GA100578@localhost.localdomain>
References: <20210122191306.GA99540@localhost.localdomain>
        <20210122174325.269ac329@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210123022823.GA100578@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 18:28:23 -0800 Enke Chen wrote:
> Hi, Jakub:
> 
> In terms of backporting, this patch should go together with:
> 
>     9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window

As in it:

Fixes: 9d9b1ee0b2d1 tcp: fix TCP_USER_TIMEOUT with zero window

or does it further fix the same issue, so:

Fixes: 9721e709fa68 ("tcp: simplify window probe aborting on USER_TIMEOUT")

?
