Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9E81474830
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 17:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbhLNQd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 11:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbhLNQd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 11:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B84C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 08:33:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FEE3615DC
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 16:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3219FC34601;
        Tue, 14 Dec 2021 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639499636;
        bh=H+TrnayeKMZfF5HpS++etkE4Tpm4lSFgt+S8vamU2r8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ntFYEQToJnhTSG8XRVul00PFqcku5LbCHIK+SBYiNIysLx4ImTk5u/CEiA509udQU
         ppqFlBP/g7UPV9Je1+6o3Whmn+AS2hTvSXaaYuFJdWcsjdwlJ7ql2AKNojS8ZUxkVo
         j/p/wj1Ty68PJrpe14wcGMHzeqXmoHQ6DPW0bRGrybYU3oYV77CslY9DOpa36I1BAO
         Rk8dLc30vMC+9EAR8HbOfslrv3QvDred87Psu+20SgwulLzRxGu3qPJSvD5AQW2/5o
         JoSgcPdmSH0u/51AvbXn6t9aJn1mPBWOLJgrjyKPJQEsjIo0mqi3hfimWc/awHWLs6
         wOECarKdHXnqA==
Date:   Tue, 14 Dec 2021 08:33:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, davem@davemloft.net,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, oss-drivers@corigine.com, roid@nvidia.com,
        baowen.zheng@corigine.com
Subject: Re: [PATCH net] flow_offload: return EOPNOTSUPP for the unsupported
 mpls action type
Message-ID: <20211214083355.6c706658@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211214143428.GA463@corigine.com>
References: <20211213144604.23888-1-simon.horman@corigine.com>
        <163948561032.12013.18199280015544778926.git-patchwork-notify@kernel.org>
        <20211214143428.GA463@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Dec 2021 15:34:29 +0100 Simon Horman wrote:
> Could I ask for a merge of net into net-next?
> 
> The patch above will be a dependency for v7 of our metering offload
> patchset.
> 
> Ref: 
> - [PATCH v6 net-next 00/12] allow user to offload tc action to net device
>   https://lore.kernel.org/netdev/20211209092806.12336-1-simon.horman@corigine.com/

Can it wait until Thu? We send PRs and merge every Thu these days.
