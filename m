Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F3E403DB2
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbhIHQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 12:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349390AbhIHQlI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 12:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F34D610A3;
        Wed,  8 Sep 2021 16:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631119200;
        bh=KEWNtKA7VMqaiJhGGOigNvNnkRw/QDb1VKK+BNY+jJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dE3hyrb6eGc9B5WTYEVmDBx4KpjZvV95VLdePnoNJVUi+//+wjyZT4kJbZoas8yAf
         3zuBPLCzEtD5s+V0cVTIk1DnOEiI+smDWq65Oze+433z2P5uaoPjVS48eIpFumtuj6
         +hT6c2XBfAZcw74fQIhjzDp6zPNrn9OtrmiNbrvoB/Q8JjpJ+9fT1OyIFGKpyD6u+0
         w30ZX44vBnbj9vYDmDwRIR9D8G7m3d80ikgbQPvlp+qNdVA5H8uPpjMXp/cxKNWciA
         vRRVUzn+O0tSe4qHzDzv8/YKYVCUOf5xWadusfqID1DPoHDi4T4XnJzR2+X+R2vPd5
         ysZmGJzw+hArA==
Date:   Wed, 8 Sep 2021 09:39:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 7/7] net/mlx5e: Fix condition when retrieving PTP-rqn
Message-ID: <20210908093959.59e40d36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210907212420.28529-8-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
        <20210907212420.28529-8-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Sep 2021 14:24:20 -0700 Saeed Mahameed wrote:
> From: Aya Levin <ayal@nvidia.com>
> 
> When activating the PTP-RQ, redirect the RQT from drop-RQ to PTP-RQ.
> Use mlx5e_channels_get_ptp_rqn to retrieve the rqn. This helper returns
> a boolean (not status), hence caller should consider return value 0 as a
> fail. Change the caller interpretation of the return value.

It would be really great to turn down the dial on the abbreviations and
add some user-visible impact, as is best practice (some would say a
requirement) for fixes.

I've been following the PTP work in mlx5 a little bit but I have no idea
what a RQT is and what kind of issues to expect without this patch.
