Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC94930B682
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhBBEay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhBBEas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EDC9564EE2;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612240208;
        bh=ozwm4llk+Fjt+o951/1b8Ui3NiNIYmpX1igAU6OwU9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQNoKJcX5FJoT1LISSDlBdLFX96ziQVtyRAPmo5SmgSk71KWM+0z9hyoMnE6yTbpX
         srVzfflNVD2IpamhLwWwDX2I+5eTJPOVX+z/7ILWBcrs/o845QN3Im++aM+6kCBU8N
         iagAs/hqdlCF0fJgQtNtacRcAK2neESveEcYB37sGVoDt0DgZXXEClCjmfCtYwSRjO
         grETiXXPwlFaiSK0oaZxsEr6uIA8ZEtk57s+uX1MM8iIJMbi85Nl7DSGX/Lyq8CRjN
         OzspsUMr893bal4iI+li2DjtyjPaFIfnNJqXnuamPJ68WCa+LmLLMBqVzOP3003/rD
         W4KCyhL05Hb4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E6A8C609D9;
        Tue,  2 Feb 2021 04:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] rework the memory barrier for SCRQ entry 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161224020794.9509.11960411803239623836.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:30:07 +0000
References: <20210130011905.1485-1-ljp@linux.ibm.com>
In-Reply-To: <20210130011905.1485-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com,
        brking@linux.vnet.ibm.com, dnbanerg@us.ibm.com,
        tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 29 Jan 2021 19:19:03 -0600 you wrote:
> This series rework the memory barrier for SCRQ (Sub-Command-Response
> Queue) entry.
> 
> v2: send to net-next.
> 
> Lijun Pan (2):
>   ibmvnic: rework to ensure SCRQ entry reads are properly ordered
>   ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ibmvnic: rework to ensure SCRQ entry reads are properly ordered
    https://git.kernel.org/netdev/net-next/c/665ab1eb18d7
  - [net-next,v2,2/2] ibmvnic: remove unnecessary rmb() inside ibmvnic_poll
    https://git.kernel.org/netdev/net-next/c/2719cb445da5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


