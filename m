Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220D840BDF6
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbhIODC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:02:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234811AbhIODCy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 23:02:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EFA660F11;
        Wed, 15 Sep 2021 03:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631674896;
        bh=btPzhwmCtuY8+FwOQYXR67Lr00QwnapaYCM5CT7aNOA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iv7bniIpBShceUyOBh/ucvbgx88A3iex8WWnSxZ5LXg1k3S52WGBaLYyErL+wTY2z
         I+v1ey5pCh57aWI6QqYnf9TlbIhzPSstOz54KIxYEO6DWRwP1FLw6bIyJmMvE0ZU50
         juKrZ6rpzAmz6HTsaZsoebtp5ZQ1RiAJL6N7p1AiQbuHiiHjs+wRa/fHX7LI4LLiAB
         e+drtbN5Y4o9tkA84sXkh1/qAdQ34er0S+amHIvgEOHe4uSXOGehlGOL+fLxYbH5G4
         R234kj1X40OGaPxIwiTDZHLv8F7M5O600gCM4jTqndg4wXu/Upawv3Kn1G87vP8oKC
         Rhmsv1XJGfqNA==
Date:   Tue, 14 Sep 2021 20:01:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 2/2] devlink: Delete not-used single parameter
 notification APIs
Message-ID: <20210914200135.3756715c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1403fe624b0ece5ce989dbb9ced77a02f0ac5db7.1631623748.git.leonro@nvidia.com>
References: <cover.1631623748.git.leonro@nvidia.com>
        <1403fe624b0ece5ce989dbb9ced77a02f0ac5db7.1631623748.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Sep 2021 15:58:29 +0300 Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> There is no need in specific devlink_param_*publish(), because same
> output can be achieved by using devlink_params_*publish() in correct
> places.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
