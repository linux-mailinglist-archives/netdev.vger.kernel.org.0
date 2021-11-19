Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA3456E22
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 12:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhKSLXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 06:23:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235035AbhKSLXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 06:23:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6153961B31;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637320829;
        bh=/4zjtA41s5r/qlgNiqVXr4XUX2i9dkQW8cGbYYmEgMQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eWZazZDeDcPhwi83aSP23A+TViMnCyQuIUfVzR0tInkECS33jKAyHBqS1x11fuidy
         qmgVQJOhuf4zqhg6EZyJZszCVhEZVeKHGJ1zsRjKink6JfhB/Rd74X/h+eDS3Kg0vA
         /5kCzIjzhxw1Uz5nqj9YLxOBa7SKyzufinizwyBuGWkvx24s8t3OwHkPE6uD/fQSk0
         sCVwLOPkTEGD8u5qp4500PDjgSnosV4kFPJZ6yDitIVK443DnHstciT2a3Hk3dWIsS
         bWbUbGo09DFB3/m90wzORSHv1URDkVRwYJ2hQk7VZ40s3U/IyQsRoN55ZbPMlz0AAE
         rW9ryfyoEwIbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5809560A0F;
        Fri, 19 Nov 2021 11:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] s390/net: updates 2021-11-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163732082935.28994.17556228549541999346.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 11:20:29 +0000
References: <20211118160607.2245947-1-kgraul@linux.ibm.com>
In-Reply-To: <20211118160607.2245947-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Nov 2021 17:06:01 +0100 you wrote:
> Please apply the following patches to netdev's net-next tree.
> 
> Heiko provided fixes for kernel doc comments and solved some
> other compiler warnings.
> Julians qeth patch simplifies the rx queue handling in the code.
> 
> Heiko Carstens (5):
>   net/iucv: fix kernel doc comments
>   net/af_iucv: fix kernel doc comments
>   s390/ctcm: fix format string
>   s390/ctcm: add __printf format attribute to ctcm_dbf_longtext
>   s390/lcs: add braces around empty function body
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] s390/qeth: allocate RX queue at probe time
    https://git.kernel.org/netdev/net-next/c/832585d2172f
  - [net-next,2/6] net/iucv: fix kernel doc comments
    https://git.kernel.org/netdev/net-next/c/682026a5e934
  - [net-next,3/6] net/af_iucv: fix kernel doc comments
    https://git.kernel.org/netdev/net-next/c/7c8e1a9155ef
  - [net-next,4/6] s390/ctcm: fix format string
    https://git.kernel.org/netdev/net-next/c/9961d6d50b7f
  - [net-next,5/6] s390/ctcm: add __printf format attribute to ctcm_dbf_longtext
    https://git.kernel.org/netdev/net-next/c/dddbf91387a0
  - [net-next,6/6] s390/lcs: add braces around empty function body
    https://git.kernel.org/netdev/net-next/c/09ae598271f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


