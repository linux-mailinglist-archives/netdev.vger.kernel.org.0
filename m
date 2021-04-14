Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF40735FC7A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349369AbhDNUUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 16:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhDNUUb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 16:20:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1539608FC;
        Wed, 14 Apr 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618431610;
        bh=xsRlDFDPKJ+4jfdKoAYZ94XhTVzcq2FSuwmw43ambm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eo0M2jgvzF1aeOBoVEy0EwmPuKMNxjL/OxIob+ZYwKdsEM+ydz6BqzuwQ9piUI1m+
         6hFcjcj+T2b/emzm1WFDsF8kqo309NbfyjjYLTYoVHql0NHadRHZl1puu5P2tUmm2g
         QWNIpbujqBhdzphklgubpqz9QdpDxIBoGuBI0Zm+r02qWrEIzalOmDEpQbo7DW2T88
         4qfReJAI5vAGJEG5xwK3PuFlOdlzGuUem3GzdydzfVlojN+KXho4TllHJa6JDb8EPN
         lh1YAP+WDBWo2CVGN5h6NwHx3K9x84HBxZbfHJS1Jg6kaOCgSHix2F7p538hTP72KO
         l/mych9J7Vr6Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E675A609B9;
        Wed, 14 Apr 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ibmvnic: correctly call NAPI APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843160993.15230.14853895155691811365.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 20:20:09 +0000
References: <20210414074616.11299-1-lijunp213@gmail.com>
In-Reply-To: <20210414074616.11299-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Apr 2021 02:46:13 -0500 you wrote:
> This series correct some misuse of NAPI APIs in the driver.
> 
> Lijun Pan (3):
>   ibmvnic: avoid calling napi_disable() twice
>   ibmvnic: remove duplicate napi_schedule call in do_reset function
>   ibmvnic: remove duplicate napi_schedule call in open function
> 
> [...]

Here is the summary with links:
  - [net,1/3] ibmvnic: avoid calling napi_disable() twice
    https://git.kernel.org/netdev/net/c/0775ebc4cf85
  - [net,2/3] ibmvnic: remove duplicate napi_schedule call in do_reset function
    https://git.kernel.org/netdev/net/c/d3a6abccbd27
  - [net,3/3] ibmvnic: remove duplicate napi_schedule call in open function
    https://git.kernel.org/netdev/net/c/7c451f3ef676

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


