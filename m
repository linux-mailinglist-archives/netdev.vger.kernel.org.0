Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020B91CBB4C
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgEHXgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:36:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgEHXgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 19:36:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1E8021974;
        Fri,  8 May 2020 23:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588981003;
        bh=y2uMkUrjYNx1AQkK9Ti095ohWKHAeRgfxh0qp2vEiGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MiP2WKM85nKozLbjRSfJLvBbuWTvCLBWnT26m9F+GqEK/NIJEjEae2EMdh25A08GO
         mLvEaSdPWAihl3rHKbPhybeRdJgScG/54kFyTg4xeNLGtsnuUKn8Swr4R3GO9rkqxi
         2VWTWbhhrS1ipP+vX4gHDooW4fXY9yHjJmtkcnDU=
Date:   Fri, 8 May 2020 16:36:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Replace zero-length array with flexible-array
Message-ID: <20200508163642.273bda4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200507185935.GA15169@embeddedor>
References: <20200507185935.GA15169@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 May 2020 13:59:35 -0500 Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };

Saeed, I'm expecting you to take this and the mlx4 patch via your trees.
