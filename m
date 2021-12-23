Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3B8247E6A1
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349389AbhLWRFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244295AbhLWRFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:05:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9E6C061401
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 09:05:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 133BAB8211D
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 17:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AE4C36AE9;
        Thu, 23 Dec 2021 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640279116;
        bh=K+KLcmFA7MejMfppKeiZeWv/T3qN2HsoKfGEwQeBzcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AUWnmU+TV+/MaoDhCwH+n0OUBYIfkOv7Xq5ZIGt8VKjGz4y13V09uIh54rjxiB5Le
         ugNe2N3gs0u7U5ts3/WgKqOoFP8Y3gjFSINpe+/z/lN9mk+0e+QsUTc1Gf1Nrjs7pW
         vOLM/XK4UMffoVAsBZi+uEi5dWNnj6/Nfhgx4oHD265QRVU1M84o4LdjhznuLzOr6H
         nYuUT5MLG6BSe71SFVuLXb+2ELZ59JKlK7BGMyI/ijNJerkT7CDOsJ4/Gd6DeGkpT7
         p0pMCIm0xwDNDoyXvz5tTRpYgpCXWF3V2Pyb6YRLkl799t3yRVJRgEF6tN6Zxg748J
         LTstIUHdwPb+A==
Date:   Thu, 23 Dec 2021 09:05:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     conleylee@foxmail.com
Cc:     davem@davemloft.net, mripard@kernel.org, wens@csie.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] sun4i-emac.c: add dma support
Message-ID: <20211223090515.3b9a8417@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <tencent_4535911418B2B9790CBC57166C94A26F650A@qq.com>
References: <tencent_4535911418B2B9790CBC57166C94A26F650A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Dec 2021 14:11:22 +0800 conleylee@foxmail.com wrote:
> From: Conley Lee <conleylee@foxmail.com>
> 
> This patch adds support for the emac rx dma present on sun4i.
> The emac is able to move packets from rx fifo to RAM by using dma.
> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>

Much better, thanks! It still doesn't apply cleanly, please rebase on
top of this tree and repost:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/
