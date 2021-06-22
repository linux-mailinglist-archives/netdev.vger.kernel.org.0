Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE1E3B0F90
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbhFVVmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:42:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230102AbhFVVmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3389611CE;
        Tue, 22 Jun 2021 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624397992;
        bh=kommuqBjiKEJ9MZCZd8KbLWec9n4TlQInYNyu0qeQe8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sp3FKCfwuOwoK/czFSrMZqIplj6nJGyUlQeLnlZEv3Ispw8iQp241mQ7Q4gqXzcQ5
         GNIJY1TBFRpYQySHW7k9jejLH9cY1mMWrTPRZRdbiWRU+37i2mIQpMPRR29VWSqfwr
         nYseeMGFWQAZGRTEr2gMTQBncX8gHwfad8bhKyHyBwmHBFRCeSenyyp2A3tDlPpxEZ
         NGzch9NAvahLtNkRbVZsjV8zEXw3XGwJPCt8pdOkvIecmlen03rnoFpKZw5ODOsjAQ
         37Pq89vkF7cwJGEZImJ/0yKOnnLJ1C6iA9NlD/xVX6QtBpZjhlAlHi17VO+lD8CLM7
         mLFX5izRxVMIw==
Message-ID: <34371cac54608e0b4e1ffc00a0e2af4b2b6809e4.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5: Fix spelling mistake "enught" ->
 "enough"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Colin King <colin.king@canonical.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 14:39:51 -0700
In-Reply-To: <20210616141950.12389-1-colin.king@canonical.com>
References: <20210616141950.12389-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-06-16 at 15:19 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a mlx5_core_err error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>


Applied to net-next-mlx5
Thanks!

