Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25C6390C96
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbhEYXB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:33066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232076AbhEYXBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9265E61430;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983611;
        bh=EfjmciQOaPVxn7WEEw15t5asfesfiStyX/8amqjGBUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hBulXFKvP5+p7gdLidb4yZkuiS3QWZj2Jpg23ctLIhC/1V/a/G+BO0jU54XM4Jfh5
         uVAcYpxFp/B8d/lx++ohwgVDRfHzgCU/bWciq8DSQN1cyggtB0zN0di7wyB2yAwnX+
         EPHtA5cJwyZlogKa92IdWKIV2fxHsM/4nZu7uq9g+3iJdw7stxk11ZANb/jg7mW4Jq
         6dbdF9b6IgAUs7Nn3ctsOTih0iJoSfFHfiqEUNUebuze9Iv/3+luKr5KVZhTXTFz03
         aUSWS5gropltVRDjukHrjf0/kV85tt+TDW8f3arU/UdeU05DuoTpivDAj/V1rIge/h
         OEI3AKmY5RExw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DDAB60A56;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: core: Add WWAN device index sysfs
 attribute
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198361157.32227.17891474898547972980.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 23:00:11 +0000
References: <1621960278-7924-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1621960278-7924-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 25 May 2021 18:31:18 +0200 you wrote:
> Add index sysfs attribute for WWAN devices. This index is used to
> uniquely indentify and reference a WWAN device. 'index' is the
> attribute name that other device classes use (wireless, v4l2-dev,
> rfkill, etc...).
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: core: Add WWAN device index sysfs attribute
    https://git.kernel.org/netdev/net-next/c/e4e92ee78702

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


