Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2B713B0F8B
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 23:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhFVVlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 17:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229501AbhFVVls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 17:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4056611CE;
        Tue, 22 Jun 2021 21:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624397971;
        bh=KrqQZkuc2v8UKfQtKPrmZLL9zizscgEQlptNhY4lDWo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uj+M3fhA/6rRya5rnteO8kngiKeMrUucTea1t9QyAymYsDRvCs9L4u+Y6qkkYlm5P
         AVfXDIBNsXOcvSvxw/IWpo/q5ntZn3Bt/pN3zwAeCQ/GMKA9U9fZkwvvUoVbKrdcE7
         VHcZj50ndXZeHDNBqHpA1jByySPbvpdlXAzmD8VyzPldCOKB+oRbvG8/FmtJwl02LJ
         Wgm/cIKWtLiOsY7INM66JBbndL332KhDFjq02nD7YPlhEnaemDatROK9QbXHpkwo9M
         C2+WssMczgMaSzPk0GW8YX2xL0nf6gixJacO5kTSalRVF6X/e9xcLV12OAG4w+j0bt
         0+QbMuChQpzIA==
Message-ID: <c24520cceb031b8f690c4dda815997f81a59f82c.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5: remove "default n" from Kconfig
From:   Saeed Mahameed <saeed@kernel.org>
To:     Cai Huoqing <caihuoqing@baidu.com>, leonro@nvidia.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Date:   Tue, 22 Jun 2021 14:39:31 -0700
In-Reply-To: <20210617023215.176-1-caihuoqing@baidu.com>
References: <20210617023215.176-1-caihuoqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-06-17 at 10:32 +0800, Cai Huoqing wrote:
> From: caihuoqing <caihuoqing@baidu.com>
> 
> remove "default n" and "No" is default

Applied to net-next-mlx5
Thanks!

