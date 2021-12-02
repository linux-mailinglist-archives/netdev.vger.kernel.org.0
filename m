Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283FC46636D
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357863AbhLBMXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:23:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53572 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357815AbhLBMXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:23:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E200B8234A;
        Thu,  2 Dec 2021 12:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11B9DC56748;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638447611;
        bh=8T5wuJKKOsI+hDzJMoI5NTi4kgrP9ZOkFDEEXAnMkHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NuQJTyiZDj1cqA43f3snVKFcx2y85kdUidb8xTl8Pm8RWbZS5wpXDgR31fQrHWDwW
         k6rWDRIs8RX/6gDt2rFRKUeaZev8xOD55xGQlF0dvfOV6dFwoiPtPwgyjNWtz2GiY+
         Wryi+SDmkgl6i1y3KCRz2mBHCtMU0ZrZ4EM2jmJAzTl98NbT3YcHCagcKAts/cGjLm
         tYebetI5ehoD9/mfcjVmppdkiPJ55mkxhd/hKJwoCS0Kk7uIVclKd3+XjrrtfgPGT/
         PP3D+UVTZ8hP86sTCjZCHp/zsbJg1jRkyz/1GMmWu69OJ0IvH9ZLk2nfFFzUrvLjwm
         z0fKGW/hnYQzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01EAD609EF;
        Thu,  2 Dec 2021 12:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] selftests: net: Correct case name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844761100.9736.9076392974880745991.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:20:11 +0000
References: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
In-Reply-To: <20211202022841.23248-1-lizhijian@cn.fujitsu.com>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        dsahern@gmail.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 2 Dec 2021 10:28:41 +0800 you wrote:
> ipv6_addr_bind/ipv4_addr_bind are function names. Previously, bind test
> would not be run by default due to the wrong case names
> 
> Fixes: 34d0302ab861 ("selftests: Add ipv6 address bind tests to fcnal-test")
> Fixes: 75b2b2b3db4c ("selftests: Add ipv4 address bind tests to fcnal-test")
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
> 
> [...]

Here is the summary with links:
  - [v2] selftests: net: Correct case name
    https://git.kernel.org/netdev/net/c/a05431b22be8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


