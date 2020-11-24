Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23102C3435
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgKXWuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:50:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725440AbgKXWuF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:50:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606258205;
        bh=2yESr43CsOKk3eRqhvT38PxLVf+tyKUs5fZHJtOdgmI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ujdb6m1z/Xb3KbQOUS90VHwP8E4G+/n5MqkRLeMU3AjuR74uDSAE9GC3BrC7Wvi82
         aSEwNfZVIpzTz2noPqwWC/VuNO7KZ5Y7NwY5vzMrmjTEh5CwDcV7x5CBCXw/xNmkPZ
         QikjDyeuc4j2Vy0VDA7orKhWbEdBTyEG+0TGcnU8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V2] MAINTAINERS: Update page pool entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160625820498.5085.14261744420418089748.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 22:50:04 +0000
References: <160613894639.2826716.14635284017814375894.stgit@firesoul>
In-Reply-To: <160613894639.2826716.14635284017814375894.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Nov 2020 14:42:26 +0100 you wrote:
> Add some file F: matches that is related to page_pool.
> 
> Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  MAINTAINERS |    2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next,V2] MAINTAINERS: Update page pool entry
    https://git.kernel.org/netdev/net/c/bc40a3691f15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


