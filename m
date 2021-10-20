Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3C643527C
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhJTSRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:17:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230381AbhJTSRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 14:17:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C87F60EFE;
        Wed, 20 Oct 2021 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634753737;
        bh=vHv6LhMfkzatBcbM0zQVqNGSc+6vGVhqvJcWS0T303g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SF0boFGvh5iCaMuBgJFYfC9OqiRDrEA8r7ojCCphvvmu34UfEbb4xJwn0XbebG0I2
         H1zsfugH0yUYOOypb3oAfp+gnrjS1Qc1hS3tEUMwmzLQQ//MzyzqeYqiZbFrHdk02r
         wwYkGmChLAC7bHU2vzWw4OTX3W+ooxIPrIEN4/1ew0igquBIZb3KlfFqbfpe/1jfyX
         40XZI1ZsjKbYQi+ZTacOUqoXVZzlJB6F5rwAzH4VdZHa5CR5cMxmVLqOnnA4VjkE46
         c50j5yzy+n+Df2URtJZX3SEbKfBuIQufc08aSKrx5kP0jUJOOgP5CrAP8kR7AiTXkG
         FXbp7tvVWSfjw==
Date:   Wed, 20 Oct 2021 11:15:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] mlx5: don't write directly to netdev->dev_addr
Message-ID: <20211020111536.0c896900@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d11a744067a3481c37d013a1f770af9b761dd57f.camel@nvidia.com>
References: <20211013202001.311183-1-kuba@kernel.org>
        <d11a744067a3481c37d013a1f770af9b761dd57f.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021 17:54:56 +0000 Saeed Mahameed wrote:
> On Wed, 2021-10-13 at 13:20 -0700, Jakub Kicinski wrote:
> > Use a local buffer and eth_hw_addr_set().
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> > This takes care of Ethernet, mlx5/core/ipoib/ipoib.c
> > will be changed as part of all the IB conversions.
>
> the patch looks fine, i will take it directly to net-next-mlx5,

Thanks!

> I didn't get the part about IB conversions, where can i find that ?

Here:

https://lore.kernel.org/all/20211019182604.1441387-3-kuba@kernel.org/
