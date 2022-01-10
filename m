Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589CA489932
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiAJNFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbiAJNF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:05:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4DBC034007;
        Mon, 10 Jan 2022 05:05:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC2E2612AC;
        Mon, 10 Jan 2022 13:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408B7C36AE5;
        Mon, 10 Jan 2022 13:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641819925;
        bh=gZ9p1057L7eGJ3nEd120WZC2QblvsEuO27VB2B1lAok=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ty4MCZ4GQKw+LUgUErV7k5IiS56HtmT721DDZ9daFcQIzQZCZNQ0hx5xM27eML/qF
         NRqOMUcNGzE9bmaVWBhm0xCJU+l1dXb7cj+LdOXbTzq7UsuPx97fmDbQjY3wAMzsrI
         xK8w4sJvKc9olHgKkURojZjMcxrL1jzodRKuP9RmAaDtq3eqDYT3ADOQmB4jiu9EQS
         yptUC9RaQVRqkNwIJMY1uKrsgHW5sW/+yY8oQ5+wxMwhJBsc8PPEg07f7vyyj8CmPO
         cogQXEbnD9RjEJ4PgZ8BKMXPHXUfA3Pp4US7o8tT+Alnx6kYObRD9T/C3iMzBduHRm
         sCow9bVZEm1gA==
Date:   Mon, 10 Jan 2022 15:05:20 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Conley Lee <conleylee@foxmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, clabbe.montjoie@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: ethernet: sun4i-emac: replace magic number with
 macro
Message-ID: <YdwvEKiKd0JKpG9T@unreal>
References: <tencent_58B12979F0BFDB1520949A6DB536ED15940A@qq.com>
 <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_AEEE0573A5455BBE4D5C05226C6C1E3AEF08@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 07:35:49PM +0800, Conley Lee wrote:
> This patch remove magic numbers in sun4i-emac.c and replace with macros
> defined in sun4i-emac.h
> 
> Change since v1
> ---------------
> - reformat
> - merge commits
> - add commit message

This changelog should be placed after "---" below your SOB.

Thanks

> 
> Signed-off-by: Conley Lee <conleylee@foxmail.com>
> ---
>  drivers/net/ethernet/allwinner/sun4i-emac.c | 30 ++++++++++++---------
>  drivers/net/ethernet/allwinner/sun4i-emac.h | 18 +++++++++++++
>  2 files changed, 35 insertions(+), 13 deletions(-)
