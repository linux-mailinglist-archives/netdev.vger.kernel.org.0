Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B601CC4E1
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgEIWNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgEIWNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 18:13:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A3E920661;
        Sat,  9 May 2020 22:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589062419;
        bh=cgmznIXojE5009tF0Vd1UEF0EhRFc2Ym5BsKzPLMGz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cq3qXJGqxuDOzpUltcK7IWtfN34Fw9hq1CFuKoeE0yHJuKZXj4xDqt7OfaD0bClds
         QdlNVEdmAAO/XY2clZ8m1EKAwH1wySK3QPLNX9XeCW1T2CNqnEikrvKMsbcjEXt/CJ
         tnXtUvR2WFP3afD0v927cRhvVNc+tslwkXlGgiPg=
Date:   Sat, 9 May 2020 15:13:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/13] Mellanox, mlx5 and bonding
 updates 2020-05-09
Message-ID: <20200509151338.17169621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200509082856.97337-1-saeedm@mellanox.com>
References: <20200509082856.97337-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  9 May 2020 01:28:43 -0700 Saeed Mahameed wrote:
> Hi Dave,
> 
> This series includes updates to mlx5 driver and a merge commit to the
> earlier bonding series which was submitted by Maor to mlx5-next branch.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> A minor conflict between Maor's bonding series [1] and Eric's [2] is
> already handled in this merge commit.
> 
> [1] bonding: Add support to get xmit slave
> [2] bonding: report transmit status to callers

Pulled, thank you!
