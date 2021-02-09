Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD42315642
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhBISpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:45:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:43956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233287AbhBISaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C801C64E8A;
        Tue,  9 Feb 2021 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612895307;
        bh=EOmibL9IeRXcxFkk7Q5As4vOxtpHtOU4ZGPnnw4vzO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ku04baV2NXSHPv+1sadUnL2/i8mQySJMRwingj0FUXNvmKqQYzzM5R5G1T9aSu01/
         mDUde7eAKQ9Yzsd7Pk4s7EpD2vB3AayQxOV0dgb2TJ72rtaQgPPU6Kc1kgTv1L/Fat
         GR84AHjwDw0L/J7YkxFsDgs3/0XzOtjB6AEVI7H8Ufc8bESNVDAWTUSyLFmAjajrpI
         tnpwW6GKHcdYPPU69kETm+CPEeAHUclrkBIEKEJRozRGEyNax9LqD7GoSjAPMgxmow
         bVfmr1lUoeQ49jHCmqBJuuNWEjZ92+fRIVrih4T5dxmGkh//4cOayQna4WViWsvAcH
         9iMy7ctNnXctw==
Date:   Tue, 9 Feb 2021 10:28:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add new timestamp mode bits
Message-ID: <20210209102825.6ede1bd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210209131107.698833-2-leon@kernel.org>
References: <20210209131107.698833-1-leon@kernel.org>
        <20210209131107.698833-2-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Feb 2021 15:11:06 +0200 Leon Romanovsky wrote:
> From: Aharon Landau <aharonl@nvidia.com>
> 
> These fields declare which timestamp mode is supported by the device
> per RQ/SQ/QP.
> 
> In addiition add the ts_format field to the select the mode for
> RQ/SQ/QP.
> 
> Signed-off-by: Aharon Landau <aharonl@nvidia.com>
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

We only got patch 1 which explains very little.

You also need to CC Richard.
