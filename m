Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFC53B8E2F
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 09:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbhGAHcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 03:32:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234679AbhGAHcd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 03:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DDCF6148E;
        Thu,  1 Jul 2021 07:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625124603;
        bh=8BfNOm3oxGncfa48gnpntxjfVriFs7uI+acaGq+77XQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dLsDW5P/0SSGixHzbt71Sz0Ay5TNeV2tBoC0U+OzXy0+/6HuiLan8UVIn2/vZCzXC
         IrVQxLvuNzn2G8xMqmLpacZoWZEjI791RZRTahnDlifay0TCaKQxLlOVCdj8d0MJst
         PmOQLM6BIuks0m8gs2tvEA84wvVYwkNM1J/Kyos3oxTOU/z/tWzNjXuJRR4D8shyAQ
         BChGAQ4Bi8SB3eDJYa8ClLN8Kacz31UFesCOklj+93b0nDx4pkR90S/DCxG/Mn9Eqy
         awRpZ+FiDFP01PKYD6slZeW2c7vgrSz+JSST7pDhAJnHiJS0ZwhTqrwbdldGdVlCBZ
         0o0r3g4z5/sjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4078B60C09;
        Thu,  1 Jul 2021 07:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2] bpf/devmap: convert remaining READ_ONCE() to
 rcu_dereference_check()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162512460325.27064.13574831156459760206.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Jul 2021 07:30:03 +0000
References: <20210629093907.573598-1-toke@redhat.com>
In-Reply-To: <20210629093907.573598-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, kafai@fb.com,
        liuhangbin@gmail.com, brouer@redhat.com, magnus.karlsson@gmail.com,
        paulmck@kernel.org, kuba@kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 29 Jun 2021 11:39:07 +0200 you wrote:
> There were a couple of READ_ONCE()-invocations left-over by the devmap RCU
> conversion. Convert these to rcu_dereference_check() as well to avoid
> complaints from sparse.
> 
> v2:
>  - Use rcu_dereference_check()
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2] bpf/devmap: convert remaining READ_ONCE() to rcu_dereference_check()
    https://git.kernel.org/bpf/bpf/c/0fc4dcc13f09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


