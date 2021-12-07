Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703C846AF31
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353037AbhLGAh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:37:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42250 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350868AbhLGAh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:37:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 95854CE13D5;
        Tue,  7 Dec 2021 00:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F1FC004DD;
        Tue,  7 Dec 2021 00:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638837263;
        bh=6KaqsLuA41Mjwg/PBX0JoT9b+z2vvF7u56roR3Ghygg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XW583nLgiCSys6GPPOI94PCd7KOpeEpo4KlFMvQicSwlM8q60KENMRef+HW2EFAIx
         /GZQUp0bkqoLmqnUFI/qHAYtZAvIRrH+xHAlawqK0mYD2SAIBuLu8sh9vz56+pEjLu
         jj1fbwJ7CBeGdqDF3adfFHCmrpWt78eYHJMh0jKbGi/o2HSDMYh3/E39YeFFNexBCn
         kX5mY6iR7YggtSJSKr+1avSvv+pXZBnBLDc/VrnmBld+rUs+BcA0fzXyb8mbqXee60
         iPqMl3N9GH39iNCbMmYsa8w7kZRQP6ThYYwq9E9lLkEpFATlLz9ANOqbVepOj49YyR
         VkJn5wRMAW/2g==
Date:   Mon, 6 Dec 2021 16:34:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Guangbin Huang <huangguangbin2@huawei.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>
Subject: Re: [PATCH net-next] Revert "net: hns3: add void before function
 which don't receive ret"
Message-ID: <20211206163422.0055f67b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YayuDSbYTEdLdeMG@unreal>
References: <ec8b4004475049060d03fd71b916cbf32858559d.1638705082.git.leonro@nvidia.com>
        <YayuDSbYTEdLdeMG@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Dec 2021 14:18:21 +0200 Leon Romanovsky wrote:
> On Sun, Dec 05, 2021 at 01:51:37PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > There are two issues with this patch:
> > 1. devlink_register() doesn't return any value. It is already void.
> > 2. It is not kernel coding at all to cast return type to void.
> > 
> > This reverts commit 5ac4f180bd07116c1e57858bc3f6741adbca3eb6.
> > 
> > Link: https://lore.kernel.org/all/Yan8VDXC0BtBRVGz@unreal
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c   | 2 +-
> >  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_devlink.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)  
> 
> It was already sent, but not merged yet.
> https://lore.kernel.org/all/20211204012448.51360-1-huangguangbin2@huawei.com

Indeed, Guangbin in the future please make sure to CC the person whose
feedback the patches are based on.
