Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6435D145990
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 17:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAVQN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 11:13:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgAVQN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jan 2020 11:13:58 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BC8B2071E;
        Wed, 22 Jan 2020 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579709638;
        bh=DQc/yT+88JWQ9VkGp2MIgDL8r3UV+tXsPz9FyrTJsqA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K7w++ptTjM+5gXZKH0cd5Pib9TYXkx6jWruW3flcU7HClnPKF1zP81103ksHEICN5
         aA32rE8qNIamPSwo+3ANAuhXUVMfrcBbUk03QFPSUEIHZtABXYZds1ZTUMadSg5qRl
         sm881rp7QyJdjCbmMkwDU1CJ8D3PVK/kMCOPBMHw=
Date:   Wed, 22 Jan 2020 18:13:53 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next 14/14] qed: bump driver version
Message-ID: <20200122161353.GG7018@unreal>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-15-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122152627.14903-15-michal.kalderon@marvell.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 05:26:27PM +0200, Michal Kalderon wrote:
> The FW brings along a large set of fixes and features which will be added
> at a later phase. This is an adaquete point to bump the driver version.
>
> Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

We discussed this a lot, those driver version bumps are stupid and
have nothing close to the reality. Distro kernels are based on some
kernel version with extra patches on top, in RedHat world this "extra"
is a lot. For them your driver version say nothing. For users who
run vanilla kernel, those versions are not relevant too, because
running such kernels requires knowledge and understanding.

You definitely should stop this enterprise cargo cult of "releasing
software" by updating versions in non-controlled by you distribution
chain.

Thanks
