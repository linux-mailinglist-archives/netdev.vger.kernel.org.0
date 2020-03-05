Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86FE17B27F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCEX4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:56:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:42842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726173AbgCEX4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:56:43 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26DCF2073D;
        Thu,  5 Mar 2020 23:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583452603;
        bh=LnZPnIcg2Bei0ORc7wXCE5ofjYdWk5BjNIhdhXIXl8w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bTvdpO7K3mfuuQmAo3yo7Ez8QeAVZCaS3sgeKChrH89o2PKmpWAAuNF1LZajDykSQ
         oFsCGmZAPLXpRLt/Koe2iyO2TaEVSDS2OLqD7SCL2/OYkcCx361IYS+ROL3CBbzlkx
         WpbyRp1qugeufhqvYKWin3X/GHmH85ucWiyVlt/c=
Date:   Thu, 5 Mar 2020 15:56:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Message-ID: <20200305155641.0392c073@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Mar 2020 15:17:34 -0800 Saeed Mahameed wrote:
> Hi Dave,
> 
> This series introduces some fixes to mlx5 driver.
> 
> Please pull and let me know if there is any problem.
> 
> For -stable v5.3
>  ('net/mlx5e: kTLS, Fix wrong value in record tracker enum')

Back porting dead code feels kinda weird :S

> For -stable v5.4
>  ('net/mlx5: DR, Fix postsend actions write length')
> 
> For -stable v5.5
>  ('net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow')
>  ('net/mlx5e: Fix endianness handling in pedit mask')

I can only trust your testing on the pedit change :)

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
