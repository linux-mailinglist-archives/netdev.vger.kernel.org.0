Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E61472C93
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 13:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhLMMuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 07:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhLMMuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 07:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E9CC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 04:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77F23B80EB0
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24BAEC34609;
        Mon, 13 Dec 2021 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639399810;
        bh=0Lv3twYOpxUG2QHIubNiyODmkDVLlxs3zVj7kc6WUOw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cNNZLoeVh4/IIdQzYroI5uDGciLu77J7lpef8vtebaztlkjLQ8eG+doenWKmdVX2b
         iuZfP4z7Vnu1w0L/sqwi+nC6BRtV68JPKTuLGeM768Cq9+7nq26h+ufSrkBa0aMdiV
         cEpCzOdJ85JO5Vgxm3V0T3oVlt9SkVWwOc85/mwwM6YMPnil6ezzJfsEB1Ov3q8/RM
         zlXKLa8FMmbQhq+W+MFe5tU6SmA/y9SXXuUzlnWIifHmq8ffB56YhpivSakypS4+La
         +q0+pmRaY9Ebipl8bwjICN87MRC/DG00UgwdXBNBfHCQPKU85/pB5ItE4ixKHx49L1
         PVa+6FiobBvaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 074F760A39;
        Mon, 13 Dec 2021 12:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] bareudp: Remove unused code from header file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163939981002.30215.2793574527337535525.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 12:50:10 +0000
References: <cover.1639166064.git.gnault@redhat.com>
In-Reply-To: <cover.1639166064.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        martin.varghese@nokia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Dec 2021 20:56:33 +0100 you wrote:
> Stop exporting unused functions and structures in bareudp.h. The only
> piece of bareudp.h that is actually used is netif_is_bareudp(). The
> rest can be moved to bareudp.c or even dropped entirely.
> 
> 
> Guillaume Nault (2):
>   bareudp: Remove bareudp_dev_create()
>   bareudp: Move definition of struct bareudp_conf to bareudp.c
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] bareudp: Remove bareudp_dev_create()
    https://git.kernel.org/netdev/net-next/c/614b7a1f28f4
  - [net-next,2/2] bareudp: Move definition of struct bareudp_conf to bareudp.c
    https://git.kernel.org/netdev/net-next/c/dcdd77ee55a7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


