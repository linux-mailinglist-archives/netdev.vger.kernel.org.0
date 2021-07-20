Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723EE3CFAA3
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbhGTMx6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239095AbhGTMtl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 08:49:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8518361186;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626787810;
        bh=/vyMhU2JoyZUyC/NWuuWTkEILGd0pKqI8larbg8vjrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P47DoDVU93gUpwHFwBMq6y7XLPDN9tZ8tiwn37lnZPU5AYzEHl0EsTDgKC2T9Nb7g
         UTsswmC6a3u7zmq9PwlYxnTE5EzP9DEHOlxIqk7Gq/hXXHvjgdf9+3fp4ShDJpoWdv
         tom4vI0N5kwymDYRhTYsXp0EVoltPLwKi7IYoU78GfwKFoVqFj5gu4jhrNPl7xAzSg
         Vh04APOHO2vne0M1plFv9iHIJEkVdSlXDea9pspe5zYVTP2K8wlzT/w+wDCxVd4q9v
         4B7qcR1407IRlTuBo/EwPsMMpk8aOgUrdD5VWfZ7QWF7Pfu7IJKppf5wDyibvIYS0W
         mtWjNwzHwgDJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7446260D2F;
        Tue, 20 Jul 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] s390/qeth: updates 2021-07-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678781047.19709.13716919959471345433.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 13:30:10 +0000
References: <20210720063849.2646776-1-jwi@linux.ibm.com>
In-Reply-To: <20210720063849.2646776-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 08:38:46 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This removes the deprecated support for OSN-mode devices, and does some
> follow-on cleanups.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] s390/qeth: remove OSN support
    https://git.kernel.org/netdev/net-next/c/a8c7629c622b
  - [net-next,2/3] s390/qeth: clean up QETH_PROT_* naming
    https://git.kernel.org/netdev/net-next/c/a37cfa28ebdc
  - [net-next,3/3] s390/qeth: clean up device_type management
    https://git.kernel.org/netdev/net-next/c/ae57ea7a19b7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


