Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB973A64C3
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhFNL2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235487AbhFNL0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 07:26:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4144061241;
        Mon, 14 Jun 2021 11:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623668714;
        bh=geaHpEsX7suWp6lWKB0/fPGDUdSFf8ykCEssPlUGhDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tIq2/pvce0Av/P+agyDUQ3piNTFCuv3R5f1a4hjFIHgj+jR7vYsfd7vgQaRJognkY
         OBidyuANhajpMGK1VH2ua671M8ErtbqXGuA+nF5D6CBV99GhK1NB5g06LpRAOASuYb
         2cxYkLlyicwOoR6gpaZcEqba4GWezX9BwRY8blK9EZ4SBcxDlfioRfm/9yxbUXxyCx
         MnThI24PWnEjU+jDHrzaNiiArRaAJJGzTgQHy8tfzCfuXK8WqjjeUIMLIA6VycEI6j
         5BgajKGd24wET0FsZ2XSHH4PYw4fUAH7BCE3TBtw1b1cFHEHhCaXXhEFvrvQ2jLGy/
         NmJqlFjOLgu1Q==
Date:   Mon, 14 Jun 2021 14:05:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com
Subject: Re: [PATCH] net: wwan: iosm: Remove DEBUG flag
Message-ID: <YMc35MS3kN4WiA+D@unreal>
References: <1623658600-21100-1-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623658600-21100-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 10:16:40AM +0200, Loic Poulain wrote:
> Author forgot to remove that flag.
> 
> Fixes: f7af616c632e ("net: iosm: infrastructure")
> Reported-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> ---
>  drivers/net/wwan/iosm/Makefile | 3 ---
>  1 file changed, 3 deletions(-)
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
