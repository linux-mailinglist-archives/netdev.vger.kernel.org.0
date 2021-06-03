Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1945839AE0C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFCWbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:31:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231163AbhFCWbu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B93FE61404;
        Thu,  3 Jun 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759404;
        bh=H7RaTuUf7xplDuyuPGhUiyoZ3DbSPZEd517UwCMkeMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QaAURVgftiF+fR8qwaNpVjDfluTPlMmQ2wgB5JLodO/FdBvB3WwBYYbHGy+RXNlRE
         A1kl6ZzIdNfLp90AnEdX8gvKYKgla61U+kQ+UAzoA3QlxAXawwkTcwqUtkq/3YaRac
         0rwOAPqUvJoTB1ZKKl578j+0CoYsLDpqRvOA/eMnu2r5WlEdnc2K1NuJ8O+eBsBBc0
         Bdnfp2+lNwAQPf5kH8eVrJQoJ7e8fUBjN00P4qpI/6bTaKHaxOEK8xkuaaD2Rwb7Bu
         lrwm4WG/6YYj9Mg20H20aN/zhqWwvZxbl/Eiu6radPul493uOfKtLyRVrKkdSm770w
         qimlGUfB/TmYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A386E60A6C;
        Thu,  3 Jun 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940466.8870.5883654977596965138.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:04 +0000
References: <20210603170901.66504-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20210603170901.66504-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org,
        corentin.noel@collabora.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  4 Jun 2021 01:09:01 +0800 you wrote:
> In virtio-net's large packet mode, there is a hole in the space behind
> buf.
> 
>     hdr_padded_len - hdr_len
> 
> We must take this into account when calculating tailroom.
> 
> [...]

Here is the summary with links:
  - [net] virtio-net: fix for skb_over_panic inside big mode
    https://git.kernel.org/netdev/net/c/1a8024239dac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


