Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EC72B3049
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 20:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgKNTuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 14:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgKNTuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 14:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605383405;
        bh=LsDqP9L8qCxW9cT1ZQMKYy8SPHsCg6AvpaSMLTStF7A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N6AoX5C0jQI6O97QyHZjMVgbUZOCMugko4mz4dt4pzQxqDAQQE62t9D7RncZ55gpH
         e2vRWt3e9+jevTUpMIABH2qJ2ZdfVRZz9d7iSZp7ZO2PQRge2WMTeFGe+xDMW5N4NX
         pGlLW2KLsLZI767D7tPS9uc6fUVKtxxFTzCvSmXE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vsock: forward all packets to the host when no H2G is
 registered
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160538340528.29327.2961179379966892214.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 19:50:05 +0000
References: <20201112133837.34183-1-sgarzare@redhat.com>
In-Reply-To: <20201112133837.34183-1-sgarzare@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, jhansen@vmware.com, davem@davemloft.net,
        decui@microsoft.com, aliguori@amazon.com, davdunc@amazon.com,
        andraprs@amazon.com, vkuznets@redhat.com, kuba@kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org, graf@amazon.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 12 Nov 2020 14:38:37 +0100 you wrote:
> Before commit c0cfa2d8a788 ("vsock: add multi-transports support"),
> if a G2H transport was loaded (e.g. virtio transport), every packets
> was forwarded to the host, regardless of the destination CID.
> The H2G transports implemented until then (vhost-vsock, VMCI) always
> responded with an error, if the destination CID was not
> VMADDR_CID_HOST.
> 
> [...]

Here is the summary with links:
  - [net] vsock: forward all packets to the host when no H2G is registered
    https://git.kernel.org/netdev/net/c/65b422d9b61b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


