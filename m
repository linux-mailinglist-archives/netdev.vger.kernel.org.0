Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0E33F7278
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239773AbhHYKBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:01:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237574AbhHYKA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 78B5861181;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885613;
        bh=/j7V0rHN5mvkR3PCKNqygqm9JTsHOAgX7rRf0HZfO2E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o0WmhyakyWd+GT0TLgfyHN5honhXpJ+lsSLrdO/zX8G0cLrHrhKlSI7CryVGSy6n5
         DrnJj0HDTzPpTWw9v5PVu116H0EXyZ8VJmmfoMYk1tOC84uyK/ew+JSwUdBuQ4QTuE
         qBrCbw6M7zMITEu3CXArGWYTHdYEAPJV1TMfK+MpOcNwP8eKNtyDa1b3UfJ5r8yfP/
         8YAFVXPDb0CNwy09JIqOPncaDJ8PX1EwxtU0Di4R84FVc3VOQIh4lyzeiUngapo6Xv
         2Epug1LDx7/Oyb+tKYZsXLTIaEVe0re9b9yTJx/ku0dLau49WwZGxTR0v50wK78+30
         LYo3JxTxLJfIA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6BCC460A0C;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] xen: harden netfront against malicious backends
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988561343.31154.5658614827184945239.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:00:13 +0000
References: <20210824102809.26370-1-jgross@suse.com>
In-Reply-To: <20210824102809.26370-1-jgross@suse.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 12:28:05 +0200 you wrote:
> Xen backends of para-virtualized devices can live in dom0 kernel, dom0
> user land, or in a driver domain. This means that a backend might
> reside in a less trusted environment than the Xen core components, so
> a backend should not be able to do harm to a Xen guest (it can still
> mess up I/O data, but it shouldn't be able to e.g. crash a guest by
> other means or cause a privilege escalation in the guest).
> 
> [...]

Here is the summary with links:
  - [v2,1/4] xen/netfront: read response from backend only once
    https://git.kernel.org/netdev/net-next/c/8446066bf8c1
  - [v2,2/4] xen/netfront: don't read data from request on the ring page
    https://git.kernel.org/netdev/net-next/c/162081ec33c2
  - [v2,3/4] xen/netfront: disentangle tx_skb_freelist
    https://git.kernel.org/netdev/net-next/c/21631d2d741a
  - [v2,4/4] xen/netfront: don't trust the backend response data blindly
    https://git.kernel.org/netdev/net-next/c/a884daa61a7d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


