Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DD52D8A2C
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 22:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408008AbgLLVlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 16:41:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbgLLVlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 16:41:31 -0500
Date:   Sat, 12 Dec 2020 13:40:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607809251;
        bh=R0jappKEJdiPR0kJJUUvmiFl6zaX/ShqIK0i4wSv7zc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GS6AYNYpV40jgDf5fN2dWz7QQJP57o/3n2j+KV6PD43e+GP4Nh1oTN3KqrFHqcUtG
         pURocGlwStb2kxQBu5F5B4HZEkuWnQIwGEEQ8J4wF06IapUBEz6palVUVPq1eQUufg
         EcGQ4ZCb6zPoOUaRIDo8tUWqbSbMBv52UFQgmmp+nOhQOxenGQOy1p9j93oesAEBQg
         VqMOni+4mfbOOdTC9bE+8xKePcTzor7ZM48FJLy5o5JsEkgsxC+MzN1wGOXmfG+zNs
         mNr8ho482RYqvFUHOdrKyH7TKCtSJKaQmIKDW+rnd2zo9gj9iaKkXDXU54Oyz60R00
         9vMIThS2Nz4dw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qlcnic: remove casting dma_alloc_coherent
Message-ID: <20201212134049.29c7a575@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201211085920.85807-1-vulab@iscas.ac.cn>
References: <20201211085920.85807-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Dec 2020 08:59:20 +0000 Xu Wang wrote:
> Remove casting the values returned by dma_alloc_coherent.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

This patch does not apply to net-next, please rebase against:

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/

if you want it to be applied to the networking tree.
