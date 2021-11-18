Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BB14561FF
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbhKRSNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230446AbhKRSNJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 13:13:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DB33E61A52;
        Thu, 18 Nov 2021 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637259008;
        bh=od7Xk/qLwGguJl7h/Ti1c+uxmWV5zHb/1lUF701p6jU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HgzbmFRjmeek6ZhrP9o3VaBvllII0HL5vGlazgbXMhMAxanAEY4Hdsm3LQDhMOzmP
         5fqMN12FtmphxKfJhyAVR+cu245q8emRf8pBALoUhDD5Ly4++cX/tmdrOzMq2zPjkh
         LG33gf4Y1TzvQ/YhcdBJhgVQ1JePSQxU7RI9CAULh5dANj2vhylO45mETSracrKU4t
         EGZW1Ie/2w9sLXmTbshi35TazhVGvp2eEioDyLK8Aj8AJ88QfL/o52ggH/pxRDOjSQ
         nkqL92S8HAy5QAgOXDdIzFKFdcrnzm7gbPybQ2Uwxl7rA9KnQqjo61uZa3fCmZP5JL
         Hhm7OlTr2pV2g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CBF9B60A54;
        Thu, 18 Nov 2021 18:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] vdpa: align uapi headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163725900883.587.15945763914190641822.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Nov 2021 18:10:08 +0000
References: <20211118180000.30627-1-stephen@networkplumber.org>
In-Reply-To: <20211118180000.30627-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     parav@nvidia.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 18 Nov 2021 10:00:00 -0800 you wrote:
> Update vdpa headers based on 5.16.0-rc1 and remove redundant copy.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  include/uapi/linux/vdpa.h            | 47 ----------------------------
>  vdpa/include/uapi/linux/vdpa.h       |  7 +++++
>  vdpa/include/uapi/linux/virtio_ids.h | 26 +++++++++++++++
>  3 files changed, 33 insertions(+), 47 deletions(-)
>  delete mode 100644 include/uapi/linux/vdpa.h

Here is the summary with links:
  - [iproute2] vdpa: align uapi headers
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=fa58de9b0c73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


