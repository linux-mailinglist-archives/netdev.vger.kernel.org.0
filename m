Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8334F2D973F
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407598AbgLNLRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgLNLQx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 06:16:53 -0500
Date:   Mon, 14 Dec 2020 13:16:08 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607944572;
        bh=NW4r1Tcxoq5gXK7oXCVu+J52nphOih0Z+rS0DjoWhmg=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5cOmZU6g+CgucBWIZXlRMJAYAQjceTR3kOjCivc5aRsLak7N4pVavLGSPd95Rv25
         FcF9owVY0eekKqSeZGPxuzgYTZLPm4j7Bh634MiJRcO65vqOcH1IxCOdJAxOFyL6bs
         2U0if1B7pbW3XvUO8F80z+3t6kpsy+nSwDY6oZmUzEEcyrGEoUg3NT+iVEVSdmeFuj
         6XaFDO5U3dQ1yMLpiJ2ejCFX2sqPYhJOrwzkHxgsDf8ImtjIWISXGLMijNYnIPUwvn
         +jEWhI2KZIRCcsjftobQir3Xco5YkXgQUxxnEpE4N+YE5r82UgZv6VGN0mqp8nyolZ
         6FAuA3kHGe1sg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Vasyl Gomonovych <gomonovych@gmail.com>
Cc:     tariqt@nvidia.com, kuba@kernel.org, joe@perches.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/mlx4: Use true,false for bool variable
Message-ID: <20201214111608.GE5005@unreal>
References: <20201212090234.0362d64f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201214103008.14783-1-gomonovych@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201214103008.14783-1-gomonovych@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 11:30:08AM +0100, Vasyl Gomonovych wrote:
> It is fix for semantic patch warning available in
> scripts/coccinelle/misc/boolinit.cocci
> Fix en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> Fix main.c:4465:5-13: WARNING: Comparison of 0/1 to bool variable
>
> Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>
> ---
>  - Add coccicheck script name
>  - Simplify if condition
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>  drivers/net/ethernet/mellanox/mlx4/main.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Please refrain from sending new version of patches as reply-to to
previous variants. It makes to appear previous patches out-of-order
while viewing in threaded mode.

Thanks
