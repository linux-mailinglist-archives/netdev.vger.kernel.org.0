Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701AD488CC5
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 23:08:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbiAIWII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 17:08:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58088 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234756AbiAIWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 17:08:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47192B80E33
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 22:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55DC36AE3;
        Sun,  9 Jan 2022 22:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641766086;
        bh=N2NDr9rGhWw6qRiqUrOqowvH1REDCXFtDVPgCYpRQjI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OD83J0jkBPe8wmU+ojWyCX4BmHiOaEeC8U2QY0HxojjiWyHxVY8Yr2WRbaMD5cON4
         rG0z4KWkJfv8EPVATz+dJ3/ySgAGLz2QYWalPq4n30mjkLOyWA7CuURYLmMdP5E1/y
         R2nSWfcXdz/RltLOchG4oRv1VZ0lgjhph0sXo9IRmRyuQyJraV0hB0nRJwTTEkYm5z
         qckg52vw5p9UKy/VRw30/52rXqcD1k3IwuXivAmR7T/jOiMyiIx26tBGhRHfGbo/z2
         JZL+rCph8SMSlw/0tCpKK4sVYZEnS6fuOUm9HmVtRO4HugK/33dSCmXRtorH7MzkZm
         ayuBCCvQd1qtA==
Date:   Sun, 9 Jan 2022 14:08:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx5: fix devlink documentation table warning
Message-ID: <20220109140805.75adfefd@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220109061845.11635-1-rdunlap@infradead.org>
References: <20220109061845.11635-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  8 Jan 2022 22:18:45 -0800 Randy Dunlap wrote:
> Fix a table format warning in networking/devlink/mlx5 by adding
> another column data entry:
> 
> Documentation/networking/devlink/mlx5.rst:13: WARNING: Error parsing content block for the "list-table" directive: uniform two-level bullet list expected, but row 2 does not contain the same number of items as row 1 (2 vs 3).
> 
> Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Shay Drory <shayd@nvidia.com>
> Cc: Saeed Mahameed <saeedm@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/devlink/mlx5.rst |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20220107.orig/Documentation/networking/devlink/mlx5.rst
> +++ linux-next-20220107/Documentation/networking/devlink/mlx5.rst
> @@ -17,6 +17,7 @@ Parameters
>       - Validation
>     * - ``enable_roce``
>       - driverinit
> +     - This is a boolean value (0 or 1, false or true).
>     * - ``io_eq_size``
>       - driverinit
>       - The range is between 64 and 4096.

We got:

745a13061aa0 ("Documentation: devlink: mlx5.rst: Fix htmldoc build warning")

in net-next already. Thanks, tho!
