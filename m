Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46F8280B50
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 01:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733237AbgJAXZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 19:25:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731525AbgJAXZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 19:25:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4893920706;
        Thu,  1 Oct 2020 23:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601594700;
        bh=PvJ/A0w0H3SCTRVP8BzfxuN35erLJQbvgm4eM3YDrZs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ghb5SjWHBGnd5/xCieYJo96tq5tCr18yPJ2NowYYNMnZ5h0Iheup7Xv6gu84cYTdz
         Hy4yvpZy4e8GmQMhtwftD1yjUgWaXP+++2Z30HLZaieRBeTMGBP8P5w/fxpu8wX0fe
         G0ZHLNmYiYqLWoWUmtnxgOiVuRRWWMD9VvPXblJE=
Date:   Thu, 1 Oct 2020 16:24:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeed@kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net V2 07/15] net/mlx5: Fix request_irqs error flow
Message-ID: <20201001162459.7214ed69@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201001195247.66636-8-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
        <20201001195247.66636-8-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 12:52:39 -0700 saeed@kernel.org wrote:
> -	for (; i >= 0; i--) {
> +	for (--i; i >= 0; i--) {

while (i--)
