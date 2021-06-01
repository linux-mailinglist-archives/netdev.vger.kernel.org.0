Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2255396CA9
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbhFAFLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhFAFLn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E5D3E6136E;
        Tue,  1 Jun 2021 05:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622524202;
        bh=OV3I7wZLy6UjImubRGjILKJFaotqC9/R+1ZbqvUcQ8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E0PHPhbrGXJruTrv0In/Oh7B00QHLhUP4OOjKd0PvkWSLBI3rMxCKevNoMpnkKfw0
         Jrj4rBHIHfdhc/nDKJQHSkkbmyySQLRUpXm/65cutfiE8IL6OxQ+jVUbv3NefYfOVu
         vebXb+lYaE1bp5I+1g3IpLM8/FPsSmzxig0OwRA4ySowzLV0AcpPcvNzYmueWAgKlx
         QPGY5SWok59oGtx8LZzwxNdx+6LvdWRQNJoFbURnI4GYZ7iY0Kz9Z5yVDJJPmPne9Z
         Q9T+zC5QAc+/O/Edy1P4DyvkIp7rYfhQEs9lOcksQjdb3Tv/zNvImRDzewPGaWu06l
         uY6emC++gdyBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D91B2609D9;
        Tue,  1 Jun 2021 05:10:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] virtio-net: Add validation for used length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252420288.18850.7219662160775523421.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:10:02 +0000
References: <20210531135852.113-1-xieyongji@bytedance.com>
In-Reply-To: <20210531135852.113-1-xieyongji@bytedance.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 21:58:52 +0800 you wrote:
> This adds validation for used length (might come
> from an untrusted device) to avoid data corruption
> or loss.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>  drivers/net/virtio_net.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [v4] virtio-net: Add validation for used length
    https://git.kernel.org/netdev/net-next/c/ad993a95c508

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


