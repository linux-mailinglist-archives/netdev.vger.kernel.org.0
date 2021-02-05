Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4FA310528
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 07:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhBEGtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 01:49:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231357AbhBEGrZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 01:47:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9452864DD6;
        Fri,  5 Feb 2021 06:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612507605;
        bh=2TyDJcUp5VVoVBrxWcSba8AppyQ93QT3hKH0MGrUe+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z0ThHxLH0VUivg7VVjHCYyK7GRdIsqn9001IVwglLDhLavmb2CXvu/tVumkWHa5Ln
         6gOKT8JxN0tJkb4kkXec+LSjjSnJp3M+97Cpbsv8DfFAqUEQ5BKvnN9epbbGNABEDR
         O6Zh/T6E3W0c6heVhPomEUDt89zpX/KAOyNVFnkGnv/a7X8otoanFZxmeeWoxZkr5n
         21wAJOi1jbs0/BhSj+AqBdjO7U6GC4At/tGQxE3OHirk/bt5IZud3Rsl60nftFeCoA
         6Kg0BkF49birZvsUfHQx2KQVfNcp8p0CGiLE5HCnI8DDR7MASi73t9zrWB85Q0Z5fr
         9RmmiZaruIzwQ==
Message-ID: <1dd5bf9ec89a753fedd767d8503f5573b75ed1e1.camel@kernel.org>
Subject: Re: [PATCH][next] net/mlx5e: Fix spelling mistake "Unknouwn" ->
 "Unknown"
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Colin King <colin.king@canonical.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 04 Feb 2021 22:46:43 -0800
In-Reply-To: <20210203145736.00005b7b@intel.com>
References: <20210203111049.18125-1-colin.king@canonical.com>
         <20210203145736.00005b7b@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-03 at 14:57 -0800, Jesse Brandeburg wrote:
> Colin King wrote:
> 
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > There is a spelling mistake in a netdev_warn message. Fix it.
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Trivial patch, looks fine!
> 
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

Applied to net-next-mlx5.

Thanks!

