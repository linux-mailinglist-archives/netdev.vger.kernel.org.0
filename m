Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62B03064C1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 21:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhA0UGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 15:06:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232413AbhA0UEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 15:04:40 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D0EC061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:03:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id bx12so3960032edb.8
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 12:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kcmxaSl9Qfhr6SmF+BYpId44K9Mu0U8o9XCHTxeKgWo=;
        b=vDjkmSEYXvLzX0V+JKVjte4M5PKVIBUgFQt+TcH5P64zRvCZ1MpuNk/FRog9CV2doF
         XNmbAFrsUm7doiGnBrctcRXJyTSTwD2JALG26Tj1dlLwo5zLczL4M2irimqHShPzUrjD
         D118RLla0e4N5+wicbpBI4v7ahKCfs3YKEu+WyDUpvfgBW2AUi70EO+r4yw6vt56muX8
         7hoDGkCAPinq9Gw52qPHUVEcbsHqI0Rvz/wfC8iGuLRHMwetGY2E5QDyXdZaF1d4dMmW
         Q7qgzy5UXE6s4Y+xZwZqz7CVxBW84eQ7fdF1YGryVEpI0xMIvA/SR7LQ7THZ5oX2nXq1
         /lNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kcmxaSl9Qfhr6SmF+BYpId44K9Mu0U8o9XCHTxeKgWo=;
        b=PnEKCwsFEEuLMzhQmoE6iaWwTxYb7OzSYIfzhXJVg7Kod3xJZ3gmxibDVKbmkUNP0V
         pXBbytnZ8gdcQ9Rzqg97hRvHvTk5Rcb7mZGTJ1iPwon04hx34wgzNQ7nfwMPz81Q0Fxe
         k03cBsiFJN0PpDbxdjJac9dfPqnlMiqbpma4+veMVbdkwScK0ZaF+xeDAPtVBKembaaT
         ZtHI2oQ/vv9QLoR6mp7wLTJzfSyVoVjo/8VP/yNt+m94HvmA9SJDUE4mXbk/wef/J19j
         EOhS7iexvQR9i4YasEIcPRNz4AveKqCh9A4BCZoiDIQybCd8uCQq8/qCHLkysD1vTI/a
         hPJg==
X-Gm-Message-State: AOAM5304sGPa5UM2JIrFSs7H2fbtHQ/+rTnsIMgHWAyyhUInyjB2aFZA
        LwHHpB+qqGclZrPHd9EjQkTyEgJ94aroMAGJqHomt1jQyKw=
X-Google-Smtp-Source: ABdhPJwSbjnl+UVoMpZY7vcBbFEpYNkLxNY/bmEqQZ5im0Qk9sQ3fYUNXBc1AjuKd6oNcE1OH5Oo0sllAU8xx0C38Wk=
X-Received: by 2002:a05:6402:31bb:: with SMTP id dj27mr10640301edb.285.1611777836451;
 Wed, 27 Jan 2021 12:03:56 -0800 (PST)
MIME-Version: 1.0
References: <20210126234345.202096-1-saeedm@nvidia.com>
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 15:03:19 -0500
Message-ID: <CAF=yD-+85F+9Mzosv3+7WKKUk5r5GM+nRthCQx0UX4ux0LMCsQ@mail.gmail.com>
Subject: Re: [pull request][net 00/12] mlx5 fixes 2021-01-26
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 2:36 AM Saeed Mahameed <saeedm@nvidia.com> wrote:
>
> Hi Jakub, Dave
>
> This series introduces some fixes to mlx5 driver.
> Please pull and let me know if there is any problem.
>
> Thanks,
> Saeed.
>
> ---
> The following changes since commit c5e9e8d48acdf3b863282af7f6f6931d39526245:
>
>   Merge tag 'mac80211-for-net-2021-01-26' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2021-01-26 15:23:18 -0800)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2021-01-26
>
> for you to fetch changes up to e2194a1744e8594e82a861687808c1adca419b85:
>
>   net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable (2021-01-26 15:39:04 -0800)
>
> ----------------------------------------------------------------
> mlx5-fixes-2021-01-26
>
> ----------------------------------------------------------------
> Daniel Jurgens (1):
>       net/mlx5: Maintain separate page trees for ECPF and PF functions
>
> Maor Dickman (2):
>       net/mlx5e: Reduce tc unsupported key print level
>       net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled
>
> Maxim Mikityanskiy (4):
>       net/mlx5e: Fix IPSEC stats
>       net/mlx5e: Correctly handle changing the number of queues when the interface is down
>       net/mlx5e: Revert parameters on errors when changing trust state without reset
>       net/mlx5e: Revert parameters on errors when changing MTU and LRO state without reset
>
> Pan Bian (1):
>       net/mlx5e: free page before return
>
> Parav Pandit (1):
>       net/mlx5e: E-switch, Fix rate calculation for overflow
>
> Paul Blakey (2):
>       net/mlx5e: Fix CT rule + encap slow path offload and deletion
>       net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat rhashtable
>
> Roi Dayan (1):
>       net/mlx5: Fix memory leak on flow table creation error flow
>
>  .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 20 +++++---
>  .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |  4 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 +++--
>  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 ++-
>  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 39 +++++++++++----
>  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 22 ++++++--
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 +
>  .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 58 +++++++++++++---------
>  10 files changed, 114 insertions(+), 55 deletions(-)

For netdrv:

Acked-by: Willem de Bruijn <willemb@google.com>

I left a small comment in patch 11/12, but no need to change that.

In patch 12/12, the removal of branch if (entry->tuple_node.next) is
not entirely obvious to me, but based on the commit message I assume
that it was intentional. Pointing it out only in the unlikely case
that it wasn't.
