Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02258440D7A
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 08:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhJaH5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 03:57:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhJaH5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 Oct 2021 03:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DF7660ED5;
        Sun, 31 Oct 2021 07:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635666915;
        bh=6iAWdQYQqFwEhSa/Y0iLzLe6WINGFi0gcWJq1XuQqRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uaNQdiNIR+2m6bsAyaXdMn9r8lKLMvZvQW5NgIeykunZSeWI1PHdYMHisWZNoPp2v
         lr5mDE//CGyZUwbH8BA7q+KBRPZ4bIAO3Ovd68dHUgfF/2XynNzXWoHtzd+qZ77eNM
         lW6E7v25XTkmINN5vOAP55kCmjDZL43OF8N8gJKYmxGt7V6gsOBNRtvNdPfENZwV7C
         /ElCQYZx2pIxLrVh/P3kMsCEqiH1n8GB5+zUbAVKxKvBK1WaHBGxGx1iFjFhskjAwb
         5858zM3si9IwjcdblM/ZRtpqJAr7rrobpm/3ceB0b40sSajUpbItF1k6ISeDgUBLCV
         kScnteTSmqWXQ==
Date:   Sun, 31 Oct 2021 09:55:11 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: remove max_vfs dentry
Message-ID: <YX5L31YA+7JRBKon@unreal>
References: <20211028211753.22612-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211028211753.22612-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 02:17:53PM -0700, Jakub Kicinski wrote:
> Commit d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
> added this file and saved the dentry for no apparent reason.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/netdevsim/dev.c       | 8 +++-----
>  drivers/net/netdevsim/netdevsim.h | 1 -
>  2 files changed, 3 insertions(+), 6 deletions(-)

I think that "debugfs_create_file("ipsec", 0400, ..." can be cleaned
too. It is connected to ddir, which is removed recursively.

Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Thanks
