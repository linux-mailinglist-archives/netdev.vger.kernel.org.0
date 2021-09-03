Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A08400829
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350683AbhICXOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 19:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:32866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237375AbhICXOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 19:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C4C360F42;
        Fri,  3 Sep 2021 23:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630710828;
        bh=GtzvbBZVh8VhrLCDs7Nf11vkUCJ2w8o1BgaNpKdlSYE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rXUmLrizgPXJOIIYwN9FsSES4CmmtWohpLkj9usKJThylLVBrfjHezfaekCuKNvIs
         CAQtDWT54FPfcbmnU0a6nnwmm1aplek8T38IAjRR10DHUbGE/0VIcP8lVJvhJMiiEs
         APRI7PotWBYrcPUGWT01Av87e4oADjSBCsEDKg8VAFok0akWcKTHpbnXWFIvimcgxH
         JZkXgS1/HsCxPUXz53xbU/rcydamOBJVYBhIhg2XsOyqF8JgptEOpHfmIQ/Firo0Z1
         6fbWeAEVQWeLB2IDaPu1SajYjVg4yM/abbDBfxIkYtqxCWBDYYmFK+ZGhK/2CTNQKb
         j3CqM6XszhVKw==
Date:   Fri, 3 Sep 2021 16:13:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] skbuff: inline page_frag_alloc_align()
Message-ID: <20210903161347.27211050@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210903024926.4221-1-yajun.deng@linux.dev>
References: <20210903024926.4221-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Sep 2021 10:49:26 +0800 Yajun Deng wrote:
> The __alloc_frag_align() is short, and only called by __napi_alloc_...
> and __netdev_alloc_frag_align(). so inline page_frag_alloc_align()
> for reduce the overhead of calls.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

# Form letter - net-next is closed

We have already sent the networking pull request for 5.15
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html

RFC patches sent for review only are obviously welcome at any time.
