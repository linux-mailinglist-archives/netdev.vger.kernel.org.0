Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331E6473B87
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 04:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhLNDaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 22:30:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37968 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhLNDaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 22:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B28B9B817DC
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 03:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78748C34606;
        Tue, 14 Dec 2021 03:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639452609;
        bh=gouMJIWXvrQPgkyNwJ/nLMEbVsNf+U0gYtITdJBKEeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jaO7geu6WcYPJiAaUArCWCz6Cg5W6p5EDg4tJB1hdOYlc532sbLXCf99FmTqoy1O6
         WXW2P0bqUnn9KFtm35Xsuthz6OxG8rHkADbxdAfjtPJCgP4JViWkDjd1pTfBRHW8Mk
         mRKKyN2zjMggO7Gkm8UjMf1NZN/gUUOCr3LlfpuqoUxcfZ1DuZiMxU+Pt3Rh7BxCxN
         bqZf7729wpy09G7eg+3gIBvC/5YtymQHHczlYXGjkXsIdDQFWzjFZhA5g9snS8lVQh
         i1hoVbnVsT/Rcg+h0coJsv+xyRmppXoDT8Cyl0WvlIADmQ6JfYYxojluohmfaUZZS5
         ro1+KVePRON3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64BB160A00;
        Tue, 14 Dec 2021 03:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v2] tc: Add support for ce_threshold_value/mask
 in fq_codel
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163945260940.26763.14177874817491545072.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Dec 2021 03:30:09 +0000
References: <20211208124517.10687-1-toke@redhat.com>
In-Reply-To: <20211208124517.10687-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  8 Dec 2021 13:45:17 +0100 you wrote:
> Commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking for subset
> of traffic") added support in fq_codel for setting a value and mask that
> will be applied to the diffserv/ECN byte to turn on the ce_threshold
> feature for a subset of traffic.
> 
> This adds support to iproute for setting these values. The parameter is
> called ce_threshold_selector and takes a value followed by a
> slash-separated mask. Some examples:
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v2] tc: Add support for ce_threshold_value/mask in fq_codel
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=4b301b87d774

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


