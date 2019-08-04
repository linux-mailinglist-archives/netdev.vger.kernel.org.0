Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4DC80A30
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 11:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfHDJw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 05:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfHDJw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Aug 2019 05:52:27 -0400
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E29206C1;
        Sun,  4 Aug 2019 09:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564912346;
        bh=BxBijH8n5mUH+ZRRIv0nd57JTDKUhJf50pEF3ndd1+U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVmU0SaeYSku3oKCMqGAs3c2AohdGh1nBUBoDYSaFNEgNNVp48gqjMbza+CDEHNnv
         ga0ON7qSA5hd4aVuigHyRq7pBAnkKjJgwce+up5tFcWOkgyr/1StgHO7S80pWmnj0L
         B9SPNfZhd9gpo4BA/k4WdwmnVcld13iXCzHoXPFY=
Date:   Sun, 4 Aug 2019 12:52:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH iproute2-next] rdma: Add driver QP type string
Message-ID: <20190804095222.GG4832@mtr-leonro.mtl.com>
References: <20190804080756.58364-1-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190804080756.58364-1-galpress@amazon.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 04, 2019 at 11:07:56AM +0300, Gal Pressman wrote:
> RDMA resource tracker now tracks driver QPs as well, add driver QP type
> string to qp_types_to_str function.
>
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/res.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
