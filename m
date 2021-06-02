Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A13A397D95
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhFBAMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235247AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E8AA613D1;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=k/R3M+Z0gY5AxBgS0EmJ/2I47IB9GAN9JHVTlj8MpVQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NDDI8qBZB1pfEOKXoMqmH3O7OEScRxd6wIDazqKmRGEfEf1v8glNnt6mFPu4ivO7J
         tqFyTZVwdYBhKM9kihNOZOXzAORjwWDLURW+RZaxzSmGjYPfSjXv6IFD4aVWIChvTP
         c/F4nvtkGcPCEN0k83hF1E5+2cq9oX6S29xCSbafA5FyHXR32GmrL8YCN5/4dp3ose
         gkV4g4PpSWjvAGxzaB8JhV9LVLiPAk/Xf135YZDpYt816KNn4Ku9gcyT3BxUUoXKI9
         sUnSeJf4JSeRmQwcyJruxfR6vXB97HT7wx1uslTjHxWkuBrM1YqUQ0xJV0ei5OCkI/
         pes1aNOt0LqgA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 24B8260A6F;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] igb: Fix -Wunused-const-variable warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260814.22595.7166722857871359129.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601140238.20712-1-yuehaibing@huawei.com>
In-Reply-To: <20210601140238.20712-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:02:38 +0800 you wrote:
> If CONFIG_IGB_HWMON is n, gcc warns:
> 
> drivers/net/ethernet/intel/igb/e1000_82575.c:2765:17:
>  warning: ‘e1000_emc_therm_limit’ defined but not used [-Wunused-const-variable=]
>  static const u8 e1000_emc_therm_limit[4] = {
>                  ^~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/intel/igb/e1000_82575.c:2759:17:
>  warning: ‘e1000_emc_temp_data’ defined but not used [-Wunused-const-variable=]
>  static const u8 e1000_emc_temp_data[4] = {
>                  ^~~~~~~~~~~~~~~~~~~
> 
> [...]

Here is the summary with links:
  - [net-next] igb: Fix -Wunused-const-variable warning
    https://git.kernel.org/netdev/net-next/c/0a206f9d9e23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


