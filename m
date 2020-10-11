Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B7F28A962
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgJKSfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:35:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgJKSfb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 14:35:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 541B32078B;
        Sun, 11 Oct 2020 18:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602441331;
        bh=/DRGGtHPXfckTsLlCCD+VI6XdTKF9prIrulmXIksjcM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gfSyPXpGCNLf1jF5Mw8GYsTy5ecB4hx8ll21G3+NLN1oUxaPS1c/22AOm+QWhDqFn
         LQmQYrDg39qP/nya5RsBLAKyncNnr9AritU5WLDa/GowyM/Sn/5DTyUnsiembRH4g5
         BPrfiB44bc6ZDqD7JjOlGSBXcwPx3v5pjY3CDg78=
Date:   Sun, 11 Oct 2020 11:35:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next] mlx4: handle non-napi callers to napi_poll
Message-ID: <20201011113529.23a26766@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008184526.3196768-1-jonathan.lemon@gmail.com>
References: <20201008184526.3196768-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 8 Oct 2020 11:45:26 -0700 Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> netcons calls napi_poll with a budget of 0 to transmit packets.
> Handle this by:
>  - skipping RX processing
>  - do not try to recycle TX packets to the RX cache
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Tariq, Saeed - how does this look to you?
