Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204BC2F570E
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:59:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbhANB60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:58:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729529AbhAMXmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 18:42:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7C2F23383;
        Wed, 13 Jan 2021 23:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610581317;
        bh=9MxzxcjK+m99mYUEOFea7Z5QcT8gkIQSqd4mzFSlFIQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=su6GrY59ZdNT1QVsgNi2NPSKejZAJWRN/mRFMWeCF29/kHhT8ynCAwYUTFoSbMcHT
         Utqr4T8JXHIVDuQlG+wiN3IhYSjNP4uCNuCEWXkWarLBQskJTEMDZEd3Z4PrcILRLk
         /buwxFh9fP0sJA1Lc2qP+83OggeZzXDiiioKGxRu3RyJBogT8dPe8FBe3dDmuy4IUi
         KT90xR4pVvjmvw0HMxlm3/sN/GWpV7vRa7Xrp7+CTKkLAyNxaDcEo8oURH73Gpsh9v
         P+CHRwkSXvXOwJcXvh1bsBVWuieEfM4Ht2170ADBytkpCoVnHMgIKwexCPxNg3LHEb
         5PmXNVw0vdGuw==
Date:   Wed, 13 Jan 2021 15:41:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next V2 00/11] mlx5 updates 2021-01-07
Message-ID: <20210113154155.1cfa9f0c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112070534.136841-1-saeed@kernel.org>
References: <20210112070534.136841-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 23:05:23 -0800 Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave, Jakub
> 
> This series provides misc updates for mlx5 driver. 
> v1->v2:
>   - Drop the +trk+new TC feature for now until we handle the module
>     dependency issue.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

The PR lacks sign-offs, I can apply from the list but what's the story
with the fixes tags on the patches for -next?
