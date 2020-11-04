Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AC52A5C6A
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 02:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgKDBwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 20:52:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728857AbgKDBwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 20:52:45 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92E20223EA;
        Wed,  4 Nov 2020 01:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604454765;
        bh=JkmHiq4nkuyfXUuJl8udaTL/GHaEzHmbPnBpTt+PsXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DNCswvMH4ANsogUL6YnkPzaKuUieHiJw9TJn17mA+rnwW0a774rXK6U9Nvd9Baize
         bwOFhJe3LknT5j59UTOUHPbJ/V4mEJ31+a4Dy8oJgK/K67wD4NE73eXH185NSy9F1V
         5XFKa6cVWs0EmCSV91MZAxoyfO0Sw+GW5R/tP4Q8=
Date:   Tue, 3 Nov 2020 17:52:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Colin King <colin.king@canonical.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] octeontx2-pf: Fix sizeof() mismatch
Message-ID: <20201103175243.1f167807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102134601.698436-1-colin.king@canonical.com>
References: <20201102134601.698436-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 13:46:01 +0000 Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> An incorrect sizeof() is being used, sizeof(u64 *) is not correct,
> it should be sizeof(*sq->sqb_ptrs).
> 
> Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
> Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, but to net-next. The driver depends on 64BIT so this is
harmless.
