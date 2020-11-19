Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4852B8972
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbgKSBWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:48010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726243AbgKSBWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:22:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C481D22260;
        Thu, 19 Nov 2020 01:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605748920;
        bh=OgI2tWPkXlHIhy9ssxDf+dL+m5jPUuQ6JLHJJGmXZu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XmpOAtTM34zIPaC7tCvPoAW/xRcANzUQe1P0Xz/unqAtvw9X/0PYGI/VR6V4vgLNh
         h81k3+9vhelKGMA0kdgUP0GLuD9ylSi/jJAIvuytJ8Q8lB/9C6OmeJUPFvpKrDe4oG
         Lz40wEtkd8CzlhovrizZ+TA50imae78aITeQHBz4=
Date:   Wed, 18 Nov 2020 17:21:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/9] mlx5 fixes 2020-11-17
Message-ID: <20201118172158.5e7317f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 11:56:53 -0800 Saeed Mahameed wrote:
> This series introduces some fixes to mlx5 driver.
> Please pull and let me know if there is any problem.
> 
> For -stable v4.14
>  ('net/mlx5: Disable QoS when min_rates on all VFs are zero')
> 
> For -stable v4.20
>  ('net/mlx5: Add handling of port type in rule deletion')
> 
> For -stable v5.5
>  ('net/mlx5: Clear bw_share upon VF disable')
> 
> For -stable v5.7
>  ('net/mlx5: E-Switch, Fail mlx5_esw_modify_vport_rate if qos disabled')
> 
> For -stable v5.8
>  ('net/mlx5e: Fix check if netdev is bond slave')
> 
> For -stable v5.9
>  ('net/mlx5e: Fix refcount leak on kTLS RX resync')

Pulled, thanks!
