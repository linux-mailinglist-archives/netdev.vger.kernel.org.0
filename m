Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ECB3DF701
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhHCVkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:52426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232769AbhHCVkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 17:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8DED61029;
        Tue,  3 Aug 2021 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628026805;
        bh=YxCD1QnjAGo/1kn57KKjKdvQgiVFs1BwdQcywJc7Y7M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RH2YoDNJnp+YrLl/ead2tpdgymatXSxBedT2H33im3Ips7GFqkw66V4Ipgw5mVBLx
         lxaOd3T0cTuqgKE+8cIdqONdpsjp4RW0RVPWa8K79EUcYF0hXMqV88+hr3r90ASZ6d
         SM34FY/whhW2cPTIPCc5WRVdz7XqunoYMsg496j3Kd323pNMcEcQQAI4ZFnZhuuLja
         BX3JNtpDCxxP79tI7g07OoULKgwNXii922Q8spNVNwkVrp2kMwBZrZ+ACBSvzb7PMN
         HDcl0GA3X3wlPaUjUKKLcIMHniMDs9oH7CguBzfh56KqnlAU+/ZL+t4q6dI4mwoOIU
         EMcf7Ef0cZyDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CEDC60A49;
        Tue,  3 Aug 2021 21:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162802680563.18812.6993058675406156401.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 21:40:05 +0000
References: <20210802173506.2383-1-harshanavkis@gmail.com>
In-Reply-To: <20210802173506.2383-1-harshanavkis@gmail.com>
To:     Harshavardhan Unnibhavi <harshanavkis@gmail.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
        kuba@kernel.org, asias@redhat.com, mst@redhat.com,
        imbrenda@linux.vnet.ibm.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  2 Aug 2021 19:35:06 +0200 you wrote:
> The original implementation of the virtio-vsock driver does not
> handle a VIRTIO_VSOCK_OP_CREDIT_REQUEST as required by the
> virtio-vsock specification. The vsock device emulated by
> vhost-vsock and the virtio-vsock driver never uses this request,
> which was probably why nobody noticed it. However, another
> implementation of the device may use this request type.
> 
> [...]

Here is the summary with links:
  - [net] VSOCK: handle VIRTIO_VSOCK_OP_CREDIT_REQUEST
    https://git.kernel.org/netdev/net/c/e3ea110d6e79

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


