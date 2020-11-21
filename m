Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D12BC230
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgKUVC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:02:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbgKUVC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:02:29 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0CE208C3;
        Sat, 21 Nov 2020 21:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605992549;
        bh=blnuHNQgpLeBVd6uoQB+k1nU63B4QU+xzsjn6jEeYQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y/CSRY6fNFggCxwthXDW4WTHR4HTKEOdFCWXVtgz4tNRM7uQnINYe6tOAKS7u5uoA
         fgKZBT8q7hd6CWbxt+zqckuG5iO3emIT43vZ+vwznMDa8huKyJOQiDIQAEURzVjaX1
         mTDoeWv1p2ttptXsTgzJdF7+7t8GwUjVYGq8j5+0=
Date:   Sat, 21 Nov 2020 13:02:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Florian Westphal <fw@strlen.de>, Ido Schimmel <idosch@idosch.org>,
        Aleksandr Nogikh <aleksandrnogikh@gmail.com>,
        davem@davemloft.net, edumazet@google.com, andreyknvl@google.com,
        dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        willemdebruijn.kernel@gmail.com,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH v5 2/3] net: add kcov handle to skb extensions
Message-ID: <20201121130227.5136221c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <86c6369a937c760e374c78f5252ffc67cf67b1e1.camel@sipsolutions.net>
References: <20201029173620.2121359-1-aleksandrnogikh@gmail.com>
        <20201029173620.2121359-3-aleksandrnogikh@gmail.com>
        <20201121160941.GA485907@shredder.lan>
        <20201121165227.GT15137@breakpoint.cc>
        <20201121100636.26aaaf8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bcfb0fe1b207d2f4bb52f0d1ef51207f9b5587de.camel@sipsolutions.net>
        <20201121103529.4b4acbff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <106fc65f0459bc316e89beaf6bd71e823c4c01b7.camel@sipsolutions.net>
        <20201121125508.4d526dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <86c6369a937c760e374c78f5252ffc67cf67b1e1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Nov 2020 21:58:37 +0100 Johannes Berg wrote:
> On Sat, 2020-11-21 at 12:55 -0800, Jakub Kicinski wrote:
> > It is more complicated. We can go back to an skb field if this work is
> > expected to yield results for mac80211. Would you mind sending a patch?  
> 
> I can do that, but I'm not going to be able to do it now/tonight (GMT+1
> here), so probably only Monday/Tuesday or so, sorry.

Oh yea, no worries, took someone a month to notice this is broken, 
as long as it's fixed before the merge window it's fine ;)
