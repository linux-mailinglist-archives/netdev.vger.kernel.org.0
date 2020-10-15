Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E0228F678
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389259AbgJOQMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388461AbgJOQMy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:12:54 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63B2B21D7F;
        Thu, 15 Oct 2020 16:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602778374;
        bh=8Y+ePnSqr6u28Rrd3H8UyVnvrvSOHlIqakGM9IzxsOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fk+AX8cJZbKFbvWzMu2yVZuDC3XEmAkDXf7Tef2mW5yqzMGpDUPUcJtWp2KOIoXQS
         ozKyGe5p3AguKmiiIMWV+6yZv5UevW9v20JgQoxKfBHJXJ9YLEWql34uT4QsqWVGPZ
         E1yAtUObMl6itjvSYsQ7c0j/fOCGFYjglMz3NE9Y=
Date:   Thu, 15 Oct 2020 09:12:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net] net: sched: Fix suspicious RCU usage while
 accessing tcf_tunnel_info
Message-ID: <20201015091251.425f26ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201014085642.21167-1-leon@kernel.org>
References: <20201014085642.21167-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Oct 2020 11:56:42 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The access of tcf_tunnel_info() produces the following splat, so fix it
> by dereferencing the tcf_tunnel_key_params pointer with marker that
> internal tcfa_liock is held.

Applied, queued for stable, thanks!
