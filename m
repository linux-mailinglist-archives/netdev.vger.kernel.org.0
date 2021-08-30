Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BF23FBAB6
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 19:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhH3RPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 13:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238036AbhH3RPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 13:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A7C960F57;
        Mon, 30 Aug 2021 17:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630343698;
        bh=n/RczJltHq3DJvuVrlDp0ujs3aqIP1fmrLWiGpcRjdA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aKQf46+VGljehCLkLpSCf0wndlqndajfGr4BL4Z5295K9nyBhh4rGssuOjrottkJO
         QfkuHWD9WvUKLbPCAcu3KSnMuF6BQlxE+wBRt2B9LBEsHw72LcNPJgirUbYT74f92+
         +dG/SX7RQUQNOJOSq2WEH4/xknEXVn822tU0plkBO6RNFfKxMVLVwF0Pn/RtUP4Z0N
         m9TaV1SfohlgE5c5JIXvLXW3bjnIEaT08/7GJufq9APKWEBiqVTiKXBmVHVsk8tN+W
         zlf8fh3Y/q/7KA1HsoSuwqCrZe/TZbjvKxRyrimNyegrYyfIyzRNsi0GVaSipo6kxy
         KoOhgFOeMRd8A==
Date:   Mon, 30 Aug 2021 10:14:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tcs_kernel@tencent.com
Subject: Re: [PATCH V2] fix array-index-out-of-bounds in taprio_change
Message-ID: <20210830101456.21944dfe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <163032300695.3135.11373235819151215482.git-patchwork-notify@kernel.org>
References: <1630295221-9859-1-git-send-email-tcs_kernel@tencent.com>
        <163032300695.3135.11373235819151215482.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 11:30:06 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Mon, 30 Aug 2021 11:47:01 +0800 you wrote:
> > From: Haimin Zhang <tcs_kernel@tencent.com>
> > 
> > syzbot report an array-index-out-of-bounds in taprio_change
> > index 16 is out of range for type '__u16 [16]'
> > that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
> > the return value of netdev_set_num_tc.
> > 
> > [...]  
> 
> Here is the summary with links:
>   - [V2] fix array-index-out-of-bounds in taprio_change
>     https://git.kernel.org/netdev/net-next/c/efe487fce306
> 
> You are awesome, thank you!

https://lore.kernel.org/netdev/20210830091046.610ceb1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com/

Oh, well...
