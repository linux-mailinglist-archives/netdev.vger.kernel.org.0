Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB053420ABE
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbhJDMVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhJDMVA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5040613AC;
        Mon,  4 Oct 2021 12:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633349951;
        bh=uVtc/23Io3B6xyyTilD7o7cTM7pfM+IBE9IJZCjrpMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QLtAQFq+e7d1jjMZPtkQAGzUa+syyD3Ty/yCR8skjLWBbMCH6yj7wGpUZmy5jtiuU
         8d2H9XFlDEkykH3+ZP7suucs3HKSLDkj6drW4Sl3evZz2iKwPih+nUvV2z3C23let2
         xxluKb+QNTrdzSkJYY4BojjTn7LnLeX5Oc11Dm40=
Date:   Mon, 4 Oct 2021 14:19:09 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
Message-ID: <YVrxPd81zvk1C4xk@kroah.com>
References: <20211004114601.13870-1-dnlplm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004114601.13870-1-dnlplm@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 04, 2021 at 01:46:01PM +0200, Daniele Palmas wrote:
> Fix double free_netdev when mhi_prepare_for_transfer fails.
> 
> This is a back-port of upstream:
> commit 4526fe74c3c509 ("drivers: net: mhi: fix error path in mhi_net_newlink")
> 
> Fixes: 13adac032982 ("net: mhi_net: Register wwan_ops for link creation")
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
> Hello Greg,
> 
> if maintainers ack, this should go just to 5.14 branch.

Looks good to me, thanks!

greg k-h
