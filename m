Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52AA4871B3
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 05:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346034AbiAGEKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 23:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346011AbiAGEKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 23:10:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09257C061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 20:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6F7BB82511
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 04:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AAD3C36AEF;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641528612;
        bh=GzzQRMBLrICU0Rcwq7Cnssi6BL1GlR0T34tB65rB9YY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AAabwWxGq1jTjjbuD/z1/VQgkM2pOdmaGkaBnDxkSj/VNnkyI1WE80Wlp/rqLcfUj
         E4EQrNBjHbYyhszDshunu4I5FQuJPeM9qZkfXRXGURzUuEa8g8x5Z0kBNeeni4ypWU
         H/O644c5Q3ZHsiR6Qunorp+ho+pxoUOdjoot8oZU/5+E+lYcq24r15eKcEbUTUcCAo
         NmsOx34IFO54hCMWasmcFlWDBft5rJn7w36WCyCXb5k7IBxDDiOqu5gv0pcHaVGNo9
         o/yJNBEaV0YTlO2NVlg9DZn9SpqE42LRTTpne2+S3OhYM0RtyZgdvctPKHzQMAjNWt
         +mTNm3CCtYDYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7094DF7940B;
        Fri,  7 Jan 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Add Spectrum-4 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164152861245.15603.5382271255031362614.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 04:10:12 +0000
References: <20220106160652.821176-1-idosch@nvidia.com>
In-Reply-To: <20220106160652.821176-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Jan 2022 18:06:44 +0200 you wrote:
> This patchset adds Spectrum-4 support in mlxsw. It builds on top of a
> previous patchset merged in commit 10184da91666 ("Merge branch
> 'mlxsw-Spectrum-4-prep'") and makes two additional changes before adding
> Spectrum-4 support.
> 
> Patchset overview:
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: Rename virtual router flex key element
    https://git.kernel.org/netdev/net-next/c/6d5d8ebb881c
  - [net-next,2/8] mlxsw: Introduce flex key elements for Spectrum-4
    https://git.kernel.org/netdev/net-next/c/07ff135958dd
  - [net-next,3/8] mlxsw: spectrum_acl_bloom_filter: Reorder functions to make the code more aesthetic
    https://git.kernel.org/netdev/net-next/c/4711671297ec
  - [net-next,4/8] mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode() more flexible
    https://git.kernel.org/netdev/net-next/c/5d5c3ba9e412
  - [net-next,5/8] mlxsw: spectrum_acl_bloom_filter: Rename Spectrum-2 specific objects for future use
    https://git.kernel.org/netdev/net-next/c/29409f363e2d
  - [net-next,6/8] mlxsw: Add operations structure for bloom filter calculation
    https://git.kernel.org/netdev/net-next/c/58723d2f7771
  - [net-next,7/8] mlxsw: spectrum_acl_bloom_filter: Add support for Spectrum-4 calculation
    https://git.kernel.org/netdev/net-next/c/852ee4191dd2
  - [net-next,8/8] mlxsw: spectrum: Extend to support Spectrum-4 ASIC
    https://git.kernel.org/netdev/net-next/c/4735402173e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


