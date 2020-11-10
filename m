Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F942ACA90
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730035AbgKJBin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:38:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729452AbgKJBin (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:38:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E1D206ED;
        Tue, 10 Nov 2020 01:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604972322;
        bh=dfKd/j0VCoBroXtl93f4KHc1QvsBLFFkNGXwoMcE9Z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A5pEFmmH8Zo5QCFhE+7Fz9cuZ/nA2nqJAZgNUqI7mGYXyYfgjnM1tRAx8gJ+frr+9
         eynbxpYUm+WGRrQofXu67Xp4FeLlfEdBC9ZFD2XvtJuwXyc94doUDabeaTceftO+N9
         Wp+2t7IXyA5tJD/GF8UxH5Ve1E68IzY3ve+V8QNA=
Date:   Mon, 9 Nov 2020 17:38:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     kaixuxia <xiakaixu1987@gmail.com>, tariqt@nvidia.com,
        tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] net/mlx4: Assign boolean values to a bool variable
Message-ID: <20201109173841.566189f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a1cd492d-80bc-80e0-d864-21fa2a770ddb@gmail.com>
References: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
        <9c8efc31-3237-ed3b-bfba-c13494b6452d@gmail.com>
        <c6901fed-d063-91be-afd6-b6eedb2b65b6@gmail.com>
        <a1cd492d-80bc-80e0-d864-21fa2a770ddb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Nov 2020 11:33:17 +0200 Tariq Toukan wrote:
> >>> ./drivers/net/ethernet/mellanox/mlx4/en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> >>>
> >>> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> >>> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>  
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Applied, thanks.
