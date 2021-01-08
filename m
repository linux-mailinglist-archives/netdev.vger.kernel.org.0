Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AE42EEBD0
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 04:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAHDSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 22:18:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbhAHDSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 22:18:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6C3B236F9;
        Fri,  8 Jan 2021 03:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610075883;
        bh=6uECfVXoU2Mwy4AZhWqD9lJZ7Qk51mOqdoEmvkgba2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lrTRwfHun7SMzrkl/TMkgSQiHXxlrD3zQz8fg9smwDqkeNR72pSzX/uKIE5rLiI5r
         wqqQtTwOKFbboK+o7sCWCYcnihHP0Y9uLUZ7XeCEzCnkk+SRBmuepnUqMoJhL4zLI3
         Ze/LhDylrB3ybh8iXH9Sx4qqVIEHY5/Lzpsay4HXhF2izoMZmztPLQspfHzbMKTd2k
         I0QIXB/PquC6EdBzmO8tmmSKaAx3255UTrXM99/Rg3cjKq0yir3vaD4Kh3nSkfQ/1w
         TTMmbbHn1lP/RIDcBTXAIWROH1pfmukErak8ehzVOQWQoXFlqgxFpB8Wc00+ujpOyx
         PFul4esR6SDqw==
Date:   Thu, 7 Jan 2021 19:18:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net 00/11] mlx5 fixes 2021-01-07
Message-ID: <20210107191801.3ba6a98f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jan 2021 12:28:34 -0800 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Jakub,
> 
> This series provides some fixes to mlx5 driver.
> Please pull and let me know if there is any problem.

Pulled, thanks!
