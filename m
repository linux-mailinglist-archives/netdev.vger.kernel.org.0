Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B616C281DDE
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725550AbgJBVwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:52:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBVwv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:52:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADA620719;
        Fri,  2 Oct 2020 21:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601675570;
        bh=NRGwOceQm3CTq6jeui4AH5vpK4Rj6L7u0mt6OIfVzWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Hytyh/6CscGV6rUBYY459XqhTa1taozaC8mf5QCXwI1LZTkUmHSIimZCAwRHOgIp8
         SMnzeyVOACgQ0iHPAPnbzUqILgVCbIcp1NnWA/7xh5jzCnfWt1IFyQOu8ygTxS2iau
         DWsZn3vk/xh3ogzbCAWyvHjm9unoBqH5a2Cubgs4=
Date:   Fri, 2 Oct 2020 14:52:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002145248.1a4b58ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002142205.5a16fb0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
        <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
        <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
        <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
        <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <47b6644999ce2946a262d5eac0c82e33057e7321.camel@sipsolutions.net>
        <6adbdd333e2db1ab9ac8f08e8ad3263d43bde55e.camel@sipsolutions.net>
        <20201002141701.3a30c54c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201002142205.5a16fb0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 14:22:05 -0700 Jakub Kicinski wrote:
> > > Forgot the link ...
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=genetlink-op-policy-export    
> > 
> > If it's not too late for you - do you want to merge the two series and
> > post everything together? Perhaps squashing patch 10 into something if
> > that makes sense?
> > 
> > You already seem to have it rebased.  

After double checking your tree has @policy in the wrong kdoc.

Let me post the first 9 patches and please squash patch 10 into your
series.

> FWIW earlier I said:
> 
> 	if ((op.doit && nla_put_u32(skb, CTRL_whatever_DO, idx)) ||
> 	    (op.dumpit && nla_put_u32(skb, CTRL_whatever_DUMP, idx)))
> 		goto nla_put_failure;
> 
>  - we should probably also check GENL_DONT_VALIDATE_DUMP here?

