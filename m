Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94DB2DE667
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgLRPUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:58038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgLRPUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 10:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608304806;
        bh=rGkngiNUJl4ptxqLyCL2cs5g7Qv/3qw/qDysKjxw46c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jd1aQAQ7/+lmrht4lQKkCQ7rwST5Dt87JyKs6mZnrUeYU3DsBgj3I1n7N05LaqOKw
         RrNz8WLfBqGXBkjJeSLjR3yrTAu62wlja8OwfFwaqHs8pod/4fTqTiuhxfuaLE2MSY
         iGLuTsdYKEyBTs/ILP7UdgvAzg68KCre1SjUXpr5X/99RRxSTOL6eBDsRN0rwb1AaL
         sXB92+jYanWtSN8HH+KHb5BCvbXxUDUpKbcJ8DMKLovKQg2JJ72u8RnQ5cckRFR0Z6
         o7IRHaUQk0wCdJnG39Vx/oV692YWSDTDXsjtCjt2GNYsfQWHAvPR6iDB74d6sqVDO6
         mGIGaxbIQHHig==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] selftests/bpf: fix spelling mistake "tranmission" ->
 "transmission"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160830480683.29956.13434774651778716031.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Dec 2020 15:20:06 +0000
References: <20201214223539.83168-1-colin.king@canonical.com>
In-Reply-To: <20201214223539.83168-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        shuah@kernel.org, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Mon, 14 Dec 2020 22:35:39 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are two spelling mistakes in output messages. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [next] selftests/bpf: fix spelling mistake "tranmission" -> "transmission"
    https://git.kernel.org/bpf/bpf/c/e79bb299ccad

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


