Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496CC2DCA7B
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 02:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388986AbgLQBVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 20:21:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:33160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730913AbgLQBVP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 20:21:15 -0500
Date:   Wed, 16 Dec 2020 17:20:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608168032;
        bh=t0dfz28NoltNz8DxmiOMh1JFElSmBlA99K99Ul6PHjE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=giC8Id6uAOA3+7hqfcPi4naw3JrT4A4WObt6oyzgEsFr7Mv1AgAx/52Kaq65WSKkj
         K1BACX3/o/e+QF2/EvU4KoW9Vxgm+pvjRQ2xZH4bV3c8SgBa1Uz7+b+bDEkYBtJb1s
         OMiO4bJNkItf61XBCTHe88OX657T46l5i7s6imhrfV7bOYzNISzxS2OF6KxY/BMsYd
         TtfFFxvbPmJy3ag8Qz5zUwomm5LqovU8MBcS8gL/CR2SXqEU1r9WkZpUlIdB4WMeKw
         mc83ITXX2EnL29Xkw4kb5rURr1+z3klXKrNPxivCJBmOf8vnaM1Uypntezs1iasQ/k
         b1HDfnBIbLljw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     <jlayton@kernel.org>, <davem@davemloft.net>,
        <ceph-devel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] ceph: Delete useless kfree code
Message-ID: <20201216172031.16ef7195@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201216130239.13759-1-zhengyongjun3@huawei.com>
References: <20201216130239.13759-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 21:02:39 +0800 Zheng Yongjun wrote:
> The parameter of kfree function is NULL, so kfree code is useless, delete it.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

To be clear the subject tags is misleading we're not taking this 
into the networking tree, ceph folk please go ahead :)
