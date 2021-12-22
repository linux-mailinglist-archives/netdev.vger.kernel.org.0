Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75B947CA9D
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 02:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhLVBAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 20:00:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43618 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhLVBAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 20:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3F53B81A4C;
        Wed, 22 Dec 2021 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6F1BC36AEA;
        Wed, 22 Dec 2021 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640134809;
        bh=a+DCMgzehqEFngm2r+X/MGUR1dthzjQMa7XSOb+aSXU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=phddKuuiGDdZz3TRha4CPnxX3oGH6qDvBH9lD9bgnpBZsw1ljd7LM8QIyp9nDGV0W
         wIrEgTQI0j6neHFCNbRaOz/4+AZEvTIhLZCugX9E5qRwB3pOD2MvbbbG7S9vOWz2Qx
         O9Qic6za8qcwueairWnRhq5FV5UW5aVtPtfV3LNL2hmfzUNvtTTW6Zgni7TQwr7GO9
         qq7j70JOOs6LkT3cPUWJcssixhTF7OG6gdkm1jthakn2i7MTURtKMotfCUr1iuXPY7
         HbvJAXtvpwiED8HueYRpY5ivENzKLxfHBLnImglWiz6RXB17gkBf9cp6f3SIjdnt6n
         RhL8xJxjtn6EA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 935BD60A49;
        Wed, 22 Dec 2021 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] bonding: fix ad_actor_system option setting to default
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164013480959.19940.697653394483988773.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 01:00:09 +0000
References: <20211221111345.2462-1-ffmancera@riseup.net>
In-Reply-To: <20211221111345.2462-1-ffmancera@riseup.net>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, vfalico@gmail.com, kuba@kernel.org,
        davem@davemloft.net, andy@greyhouse.net, jay.vosburgh@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 12:13:45 +0100 you wrote:
> When 802.3ad bond mode is configured the ad_actor_system option is set to
> "00:00:00:00:00:00". But when trying to set the all-zeroes MAC as actors'
> system address it was failing with EINVAL.
> 
> An all-zeroes ethernet address is valid, only multicast addresses are not
> valid values.
> 
> [...]

Here is the summary with links:
  - [net,v4] bonding: fix ad_actor_system option setting to default
    https://git.kernel.org/netdev/net/c/1c15b05baea7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


