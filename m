Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A742854ED
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 01:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgJFXWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 19:22:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgJFXWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 19:22:14 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D29206F4;
        Tue,  6 Oct 2020 23:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602026533;
        bh=eqSLb2vbDKPtUDNXvpxALDhG11dFkdTV/JbQezv/FZU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bq6leZzmdpX/zka7S2MXfKPIedCG/mFV1b9h6DOZvvFAjsqqpF1tqyiiMzYQxjvzU
         IbrXkD6pvTXyeGJnMZyvUcQi6tm/bPE9SjSPqqz3oxbFX2WQeqlqSASjrcLYGXY1cr
         7OBksVnca54rQ9pwBmY06t5Pi7H0jWbhCjmYtrnw=
Message-ID: <80cb7391f0feb838cc61a608efe0c24dcef41115.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix freeing of unassigned pointer
From:   Saeed Mahameed <saeed@kernel.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 06 Oct 2020 16:22:12 -0700
In-Reply-To: <20201003111050.25130-1-alex.dewar90@gmail.com>
References: <20201003111050.25130-1-alex.dewar90@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-03 at 12:10 +0100, Alex Dewar wrote:
> Commit ff7ea04ad579 ("net/mlx5e: Fix potential null pointer
> dereference")
> added some missing null checks but the error handling in
> mlx5e_alloc_flow() was left broken: the variable attr is passed to
> kfree
> although it is never assigned to and never needs to be freed in this
> function. Fix this.
> 
> Addresses-Coverity-ID: 1497536 ("Memory - illegal accesses")
> Fixes: ff7ea04ad579 ("net/mlx5e: Fix potential null pointer
> dereference")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 17 +++++++++----
> ----
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 

Hi Alex, thanks for the patch, 
Colin submitted a one liner patch that I already picked up.

I hope you are ok with this.

Thanks,
Saeed.

