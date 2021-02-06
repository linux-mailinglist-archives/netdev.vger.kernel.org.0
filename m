Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6F4311F25
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 18:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhBFRgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 12:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhBFRgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 12:36:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B4B64E5E;
        Sat,  6 Feb 2021 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612632938;
        bh=R1pv++ethZHZTkc2F8vyjdZ2AotfuRKUHX/YvCUc3HQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jcX35cTs+qhemBITqxpmohimBVgjiwozR9liErW7teJW2p7tkDwYfjNhN330lqxJb
         6sCH0F3KXtRofHe7uk1lVHr0nyLpMwDYNPgo61ARGxIMECtkOAlqc78pY7OHqGXvCN
         zfTRXLhvXrdQ8RVLoyzWafQ4j+FvXWrqEgEVbdDzbKsNkaEr2VIR7gQs9M7iL6/+Iw
         PVhWggUvDw/jlWxAKenS9YMMd5wHl3VJOr/Lar+utyUpcWonbfxWxLsL9PrnpcqVrm
         rxaB3+qUURZbAFwTtMrcojQE/lHxkfvidxdfhNDxeVByad6nlqngT1PIZp+HLd8Amb
         +rXQvJWlGZymg==
Date:   Sat, 6 Feb 2021 09:35:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-2021-02-05
Message-ID: <20210206093537.0bfaf0db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205163434.14D94C433ED@smtp.codeaurora.org>
References: <20210205163434.14D94C433ED@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Feb 2021 16:34:34 +0000 (UTC) Kalle Valo wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.

Pulled, thanks! One thing to confirm tho..

> ath9k
> 
> * fix build regression related to LEDS_CLASS
> 
> mt76
> 
> * fix a memory leak

Lorenzo, I'm just guessing what this code does, but you're dropping a
frag without invalidating the rest of the SKB, which I presume is now
truncated? Shouldn't the skb be dropped?
