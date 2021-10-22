Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1938437C77
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhJVSLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhJVSLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:11:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2EB16121F;
        Fri, 22 Oct 2021 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634926136;
        bh=eYLngKSPURUDML+RIot02taVOlnlw8aBJ0T8T4nQCs8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r8sbX8Q+WGwU/zTOzYgQjKNQKRBT5ZS0ypExfA4G8hgKIyVQxNmDqf/MSrmGDlswL
         ITMxA0DwSjFaWwcMs8lKtcEfoxPaM2BMnlIz8lW+4EQQb3f6thwfXDfo1HJ7tDQsvw
         0dmHG+ht1sXCAdl+oS86hMWYSP93uMYaPd5vAU9oZAIQRng8i90nG9F+CZODJoiAg+
         +BPwrzRKigoDAOQIfTjGhH8MlKURXauinnEm5cH9leeoVtJ8OQjYFCMZzslDQuACGh
         9MY+D3oERS8YoJRe2Tcy8T66QgSXWVCxnuq0Z5eZXeHsVw/halv8H6DmlL/0DzG0/s
         1N4bYdBMI5DTA==
Date:   Fri, 22 Oct 2021 11:08:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     SimonHorman <horms@kernel.org>,
        Mirko Lindner <mlindner@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] octeontx2-af: Remove redundant assignment
 operations
Message-ID: <20211022110854.21052cb6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211021065019.1047768-1-luo.penghao@zte.com.cn>
References: <20211021065019.1047768-1-luo.penghao@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 06:50:19 +0000 luo penghao wrote:
> The variable err will be reassigned on subsequent branches, and this
> assignment does not perform related value operations.
> 
> clang_analyzer complains as follows:
> 
> drivers/net/ethernet/marvell/sky2.c:4988: warning:
> 
> Although the value stored to 'err' is used in the enclosing expression,
> the value is never actually read from 'err'.

Oh you did CC Mirko on this version.. Do you not have the CCs automated?
scripts/get_maintainer.pl is your friend.

If you're posting a new version of the patch please put [PATCH v2] as
the subject prefix. And stop putting the pointless linux-next there.

Thanks.
