Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87B13FEC91
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhIBLBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 07:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233504AbhIBLBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 07:01:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8461A61059;
        Thu,  2 Sep 2021 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630580405;
        bh=IRnbEKJ/4ru4j2fz2HxHNvjPtqo1sJl7HRn2BBPCpCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TrMxRZ1ak1oMIW2kINBK27fec2pYVxc57yWu/G9UHVida4Z98w3VGPRemH+DYzqoq
         w48FTtZVneQIVdodBTpUW7SyloFLFxZMuxRmOMZ0il0OD6Q/NsyFme3dxwbNVxJR7T
         OX+fyACtoFQv9dlbdZA2BJMlD+OY18Oh5BOD1bbsq0jl+S7Zg+AglNl1suF3JeGwvZ
         vO4P0tXRUA+akDQ7+btTIomgAkEMSrKgGz5LmdMZC6KpP95p8/IGlv0xOqq/vvdMK9
         L9GA1x5tPymiJ1swKgstA2Pr0DufLoFcNfIG9Jw040/QV3ehi1AHjcYgANCGW3EC+F
         aGMQxMflZda4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7798960982;
        Thu,  2 Sep 2021 11:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hso: add failure handler for add_net_device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163058040548.23746.8136394264284683610.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 11:00:05 +0000
References: <20210902083609.1679146-1-william.xuanziyang@huawei.com>
In-Reply-To: <20210902083609.1679146-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, johan@kernel.org,
        mudongliangabcd@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 2 Sep 2021 16:36:09 +0800 you wrote:
> If the network devices connected to the system beyond
> HSO_MAX_NET_DEVICES. add_net_device() in hso_create_net_device()
> will be failed for the network_table is full. It will lead to
> business failure which rely on network_table, for example,
> hso_suspend() and hso_resume(). It will also lead to memory leak
> because resource release process can not search the hso_device
> object from network_table in hso_free_interface().
> 
> [...]

Here is the summary with links:
  - [net] net: hso: add failure handler for add_net_device
    https://git.kernel.org/netdev/net/c/ecdc28defc46

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


