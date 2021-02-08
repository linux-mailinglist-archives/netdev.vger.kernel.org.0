Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DEA313F36
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhBHTha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhBHTgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:36:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D42B364E85;
        Mon,  8 Feb 2021 19:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612812935;
        bh=dKwjlNm+i5RciyQ00XGdrJFeGKcf1FLx4AW0D7t73Ck=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OKTyWXW/DPHe+OgplOgQf/rsaTUMYDTd01QhWMLXnLI6dL2/HY1mghC3l6wK0EQ/O
         TwWMbXIRW+b38ItfeVQphMPBYsW3M1Zs0Ys50r2+OSEEKcM2dGuVa3zKhKbsZ/tgQH
         RsWJBXDWyPinF3OnGJgyAsxWCA7anVv1QLa7elWq6uDjfAaHn+xqkHfUdiC1lzxEUU
         98Gj4yqOuD/QadXwCJIdLTUVQV0b9wQ9FNM3RzvDhZVcuPysTTlYtBnOugD4UE393G
         LUv2ZrYsm0JRvGFBD/MndKBmza9D+OgLefIkGjWbonSPoBkHrdBf3mFb0RPLRzFyXR
         +8CbCQR//vSRg==
Date:   Mon, 8 Feb 2021 11:35:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Simon Wunderlich <sw@simonwunderlich.de>, davem@davemloft.net,
        netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH 4/4] batman-adv: Fix names for kernel-doc blocks
Message-ID: <20210208113534.5a1a11ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <44df86a7-e7a9-246a-e941-a7ec6f4c8774@infradead.org>
References: <20210208165938.13262-1-sw@simonwunderlich.de>
        <20210208165938.13262-5-sw@simonwunderlich.de>
        <44df86a7-e7a9-246a-e941-a7ec6f4c8774@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 10:00:48 -0800 Randy Dunlap wrote:
> On 2/8/21 8:59 AM, Simon Wunderlich wrote:
> > From: Sven Eckelmann <sven@narfation.org>
> > 
> > kernel-doc can only correctly identify the documented function or struct
> > when the name in the first kernel-doc line references it. But some of the
> > kernel-doc blocks referenced a different function/struct then it actually
> > documented.
> > 
> > Signed-off-by: Sven Eckelmann <sven@narfation.org>
> > Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>  
> 
> Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

Thanks!

Just FWIW since this is a pull request I can't add tags on individual
patches in git, but it will be recorded on the list, I guess..
