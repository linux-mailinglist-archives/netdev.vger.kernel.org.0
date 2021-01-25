Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85CB303074
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732565AbhAYXrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:47:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732580AbhAYVPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 16:15:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0E7220679;
        Mon, 25 Jan 2021 21:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611609274;
        bh=nggAbuKO5ORKH4Jcf6JPTvHMhNfSC0FyOp8dxerETkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xi/Gx70cDbxNELrCP1aS8XU+lL7K9NrvB7rBNcLvqEg7DcgpM9E05+51+7zyFs9gq
         FHUM41uBdCyfIQNhEp3GoIOrlYD8/Prmi7w0vAkkuL4TPJH4ncwBBWMFmV9lc6pBBD
         H+CZtyzbETgoujgEjN9cDhOluaagWmCikhYqqGql/bQS210aYnJXeeKEgEVFKQG4zV
         4JMccc051FrcAiyHm7eCcQQsWqdAeCnsccIeEbHH3YG5NNSvARc7jBgdTkb0IyvUID
         ZLr2eEE/NbhdQu+Av7ZA0QPxzl+KeNrRRZLPpeIzPtYY0H+YvmoRBcacDRpx0R05ki
         f/Sz/cQPWBvDQ==
Date:   Mon, 25 Jan 2021 13:14:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Li <abaci-bugfix@linux.alibaba.com>
Cc:     davem@davemloft.net, rajur@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cxgb4: remove redundant NULL check
Message-ID: <20210125131433.0592afaf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611568045-121839-1-git-send-email-abaci-bugfix@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 17:47:22 +0800 Yang Li wrote:
> Fix below warnings reported by coccicheck:
> ./drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c:327:3-9: WARNING: NULL
> check before some freeing functions is not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>

These 4 patches change the same driver in the same way, please squash
them all into a single patch and resend.

Please use [PATCH net-next] as the subject tag.
