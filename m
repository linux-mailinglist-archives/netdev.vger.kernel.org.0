Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2078418E95C
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCVOTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbgCVOTZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 10:19:25 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CAF320658;
        Sun, 22 Mar 2020 14:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584886764;
        bh=PYi6qXN6seeuVUecqt0osowGoI7tvCtZq1qFKm+jS+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J/4Xgta8jdfyYWNF43BNujbYiDRqSbF0PLfJ+g0k17/7a7iq9wtklltA3umT1kuVo
         oKVAxgJqKIftEWUAXB+tEtb5u8lcr5pLfSJJFy86Cihz2mfzUauppwXaLsRCRGRpk9
         mHqEcmrWaMRGO+ByAUnhf02XJmZQv0R+DRzz8pN0=
Date:   Sun, 22 Mar 2020 16:19:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v4 net-next 7/8] octeontx2-af: Remove driver version and
 fix authorship
Message-ID: <20200322141920.GJ650439@unreal>
References: <1584730646-15953-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584730646-15953-8-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584730646-15953-8-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 12:27:25AM +0530, sunil.kovvuri@gmail.com wrote:
> From: Sunil Goutham <sgoutham@marvell.com>
>
> Removed MODULE_VERSION and fixed MODULE_AUTHOR.
>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c      | 4 +---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 4 +---
>  2 files changed, 2 insertions(+), 6 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
