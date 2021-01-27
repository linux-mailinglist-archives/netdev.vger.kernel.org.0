Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24AF306794
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:14:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbhA0XMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:12:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234859AbhA0XKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:10:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5FA61601;
        Wed, 27 Jan 2021 23:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788914;
        bh=fP4pAWO8r6KXAvF8x7AMoGAXUIxefxrvtkXZzK5CyFg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qkD8wS9fM0Xc3q6gSu/9bJKEJjCeTUIMC401xCoCgZsSSt80PWHKQdIsrGx3owLJd
         5ZTQ3+iGImo8oZXYvCN1XZiwFV/XdC67sSt8pfIbjtZh/0RAek5LeUFyh7Kyoa7qUA
         t4Vyw5vSCVgy/f4SRYv1cAK/jhzxW+WtsbW/Tg+c5dVjcfY/4pF5nenA9bmsf8p9E9
         00htEvwX3cw9VsURcm4T9Rno8cIdoXsdVFiQsLtVQb6biMt6XCZzJZNtlTU7gz9Q7K
         jvb4Rbgk1DO15hp+lenJwQ+nrarudY70aQSODUzC4IRlvsgHfVSOmALqaKo0bcQma7
         T77QxiDgDs3eg==
Message-ID: <60b15846db82c2ff50bcb90aa2646d5baf9247b8.camel@kernel.org>
Subject: Re: [pull request][net 00/12] mlx5 fixes 2021-01-26
From:   Saeed Mahameed <saeed@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Date:   Wed, 27 Jan 2021 15:08:33 -0800
In-Reply-To: <CAF=yD-+85F+9Mzosv3+7WKKUk5r5GM+nRthCQx0UX4ux0LMCsQ@mail.gmail.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
         <CAF=yD-+85F+9Mzosv3+7WKKUk5r5GM+nRthCQx0UX4ux0LMCsQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-27 at 15:03 -0500, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 2:36 AM Saeed Mahameed <saeedm@nvidia.com>
> wrote:
> > 
> > Hi Jakub, Dave
> > 
> > This series introduces some fixes to mlx5 driver.
> > Please pull and let me know if there is any problem.
> > 
> > Thanks,
> > Saeed.
> > 
> > ---
> > The following changes since commit
> > c5e9e8d48acdf3b863282af7f6f6931d39526245:
> > 
> >   Merge tag 'mac80211-for-net-2021-01-26' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211 (2021-
> > 01-26 15:23:18 -0800)
> > 
> > are available in the Git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git
> > tags/mlx5-fixes-2021-01-26
> > 
> > for you to fetch changes up to
> > e2194a1744e8594e82a861687808c1adca419b85:
> > 
> >   net/mlx5: CT: Fix incorrect removal of tuple_nat_node from nat
> > rhashtable (2021-01-26 15:39:04 -0800)
> > 
> > ----------------------------------------------------------------
> > mlx5-fixes-2021-01-26
> > 
> > ----------------------------------------------------------------
> > Daniel Jurgens (1):
> >       net/mlx5: Maintain separate page trees for ECPF and PF
> > functions
> > 
> > Maor Dickman (2):
> >       net/mlx5e: Reduce tc unsupported key print level
> >       net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is
> > disabled
> > 
> > Maxim Mikityanskiy (4):
> >       net/mlx5e: Fix IPSEC stats
> >       net/mlx5e: Correctly handle changing the number of queues
> > when the interface is down
> >       net/mlx5e: Revert parameters on errors when changing trust
> > state without reset
> >       net/mlx5e: Revert parameters on errors when changing MTU and
> > LRO state without reset
> > 
> > Pan Bian (1):
> >       net/mlx5e: free page before return
> > 
> > Parav Pandit (1):
> >       net/mlx5e: E-switch, Fix rate calculation for overflow
> > 
> > Paul Blakey (2):
> >       net/mlx5e: Fix CT rule + encap slow path offload and deletion
> >       net/mlx5: CT: Fix incorrect removal of tuple_nat_node from
> > nat rhashtable
> > 
> > Roi Dayan (1):
> >       net/mlx5: Fix memory leak on flow table creation error flow
> > 
> >  .../net/ethernet/mellanox/mlx5/core/en/health.c    |  2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 20 +++++---
> >  .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |  4 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 13 +++--
> >  .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  8 ++-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 39
> > +++++++++++----
> >  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  2 +
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 22 ++++++--
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  1 +
> >  .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 58
> > +++++++++++++---------
> >  10 files changed, 114 insertions(+), 55 deletions(-)
> 
> For netdrv:
> 
> Acked-by: Willem de Bruijn <willemb@google.com>
> 
> I left a small comment in patch 11/12, but no need to change that.
> 
> In patch 12/12, the removal of branch if (entry->tuple_node.next) is
> not entirely obvious to me, but based on the commit message I assume
> that it was intentional. Pointing it out only in the unlikely case
> that it wasn't.

it was intentional as the check was redundant. 

Thanks for the review!



