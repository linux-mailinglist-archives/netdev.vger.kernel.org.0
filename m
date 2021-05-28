Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA9394820
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhE1VI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 17:08:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229563AbhE1VIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 17:08:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5C2161378;
        Fri, 28 May 2021 21:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622236040;
        bh=Fev0AQ+jWktf8MDkh6yOAVN3mpPxLd0V3Ssi05045aI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eXy1nWbOnTE+LFeAptX66USCR3WqkCDyx85VtPoeP0nIXrhQbB4Xzctdnfff9Nv5u
         mAqBAXeq1qkyF5KCVdfzYCpAIiOCA7AFo9/R3BxRsjT5mdSQ6gR0pr1OYfmSHIytOB
         P9WA/bStOnLRY18ExG4iiUycnQL/mSgP5HKWhco9OLZzS9tX4hgAlA6L2U4kxh+fW5
         BoWEsDZxpSTHn6VYqroZdqNwoLG8hWiJz1omKaF5DKpjrl83jiL8UQ2qUhYfSQE2UN
         QBMMClH4YlC0LDfkvxAnyJLyaJIq1iDYlMpIPE5PrdaSVwSRExN6/HhMuvWTf6AVcU
         yOp0R+1Z9D1JA==
Date:   Fri, 28 May 2021 14:07:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 0/7] mptcp: Miscellaneous cleanup
Message-ID: <20210528140719.0e18900f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
References: <20210527235430.183465-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 16:54:23 -0700 Mat Martineau wrote:
> Here are some cleanup patches we've collected in the MPTCP tree.
> 
> Patches 1-4 do some general tidying.
> 
> Patch 5 adds an explicit check at netlink command parsing time to
> require a port number when the 'signal' flag is set, to catch the error
> earlier.
> 
> Patches 6 & 7 fix up the MPTCP 'enabled' sysctl, enforcing it as a
> boolean value, and ensuring that the !CONFIG_SYSCTL build still works
> after the boolean change.

Pulled, thanks!

Would you mind making sure that all maintainers and authors of commits
pointed to by Fixes tags are always CCed? I assume that those folks
usually see the patches on mptcp@ ML before they hit netdev but I'd
rather not have to assume..
