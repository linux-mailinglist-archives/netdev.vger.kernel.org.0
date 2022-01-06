Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A0448647C
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 13:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiAFMkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 07:40:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33182 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238940AbiAFMkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 07:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6928B82107
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76A8AC36AF4;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641472811;
        bh=hvMHEn1DEU/MRDgi+M4w7rgQAM+LBy8q+Lvdy7pj1TY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rJvze747WoHrAgHtrihn8szYhRZ7JuTNZC7l5NNPfy+ro20wdLaOpJr+n21LgH4z+
         VV8yDSncCvLBpNcO2FJRJEqiXn1twtoMAid/WdAzA37eLh42H/fS4ZEU+oG3ijIUfA
         Env7eqGv/tUDxX/FC3Eiulwrrc7xZEtEpPjGjdtuhsK+HpkzU6Lh8a2G/VtKpRmVwy
         w7y0dywIFPSy3XUsPARXYMbLYEP5iVgRMFO0ey6ollPlg6NEXLXO4u3fr6H+thwUzg
         Cjrp/PqyGzHQYe50LORPKTHR3ipJ7UYbXvymMsafHOah/qL908GVUtOYSWObhV59dj
         P5KyPTEcEBfug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 665B9F7940B;
        Thu,  6 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gro: add ability to control gro max packet size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164147281140.4515.16458957578263041329.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 12:40:11 +0000
References: <20220105104838.2246803-1-eric.dumazet@gmail.com>
In-Reply-To: <20220105104838.2246803-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, lixiaoyan@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 02:48:38 -0800 you wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Eric Dumazet suggested to allow users to modify max GRO packet size.
> 
> We have seen GRO being disabled by users of appliances (such as
> wifi access points) because of claimed bufferbloat issues,
> or some work arounds in sch_cake, to split GRO/GSO packets.
> 
> [...]

Here is the summary with links:
  - [net-next] gro: add ability to control gro max packet size
    https://git.kernel.org/netdev/net-next/c/eac1b93c14d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


