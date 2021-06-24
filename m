Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798313B35BE
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhFXScb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhFXScY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2763F6128A;
        Thu, 24 Jun 2021 18:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624559405;
        bh=yfmcDQfvAVodEIN9sfqgug2rzVD9YV7bhtA15JXnTVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PX8HGy+brybLYMGEU8S8onC8ogIv2rQjcdkVK1OtrMTeG/A8Uy/+eUOhDnUB0NlTo
         v+P1NP9F5E8eNEp6Acuh/CLt9ozwOutSHWffMhw4pDsO36qKws1H4cn2HbjBpoZHNF
         /zM6EKRHvyINKukufZSpWYZt4YC32tM1ZDCJt6WltVcoc0Z8orcGJ1O3rijl7xHyPE
         9JX5wD+FBhJ/1N6GwGWk5GLKt5O3w57pnI9M0pFZ6O/Nv2hJLFLm0nYNNcEnxfkNZl
         er5WkFEwfrqNhbfAxTLSe6HECLATWcBB4MT/2kwD/Er+WW3Q76EsdpOEtlvHimh1Mp
         hAuapWb9H93Kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19A4960A71;
        Thu, 24 Jun 2021 18:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] ibmvnic: Assorted bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162455940510.3292.11989899239722581171.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:30:05 +0000
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
In-Reply-To: <20210624041316.567622-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ricklind@linux.ibm.com,
        brking@linux.ibm.com, cforno12@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 23 Jun 2021 21:13:09 -0700 you wrote:
> Assorted bug fixes that we tested over the last several weeks.
> 
> Thanks to Brian King, Cris Forno, Dany Madden and Rick Lindsley for
> reviews and help with testing.
> 
> Dany Madden (1):
>   Revert "ibmvnic: remove duplicate napi_schedule call in open function"
> 
> [...]

Here is the summary with links:
  - [net,1/7] Revert "ibmvnic: simplify reset_long_term_buff function"
    https://git.kernel.org/netdev/net/c/0ec13aff058a
  - [net,2/7] Revert "ibmvnic: remove duplicate napi_schedule call in open function"
    https://git.kernel.org/netdev/net/c/2ca220f92878
  - [net,3/7] ibmvnic: clean pending indirect buffs during reset
    https://git.kernel.org/netdev/net/c/65d6470d139a
  - [net,4/7] ibmvnic: account for bufs already saved in indir_buf
    https://git.kernel.org/netdev/net/c/72368f8b2b9e
  - [net,5/7] ibmvnic: set ltb->buff to NULL after freeing
    https://git.kernel.org/netdev/net/c/552a33729f1a
  - [net,6/7] ibmvnic: free tx_pool if tso_pool alloc fails
    https://git.kernel.org/netdev/net/c/f6ebca8efa52
  - [net,7/7] ibmvnic: parenthesize a check
    https://git.kernel.org/netdev/net/c/154b3b2a6ffc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


