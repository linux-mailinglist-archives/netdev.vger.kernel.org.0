Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDC20A6C1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405998AbgFYU1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:27:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389406AbgFYU1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:27:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A80BE2072E;
        Thu, 25 Jun 2020 20:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593116844;
        bh=kjMgc2MLPbdOlvM8OXUQw4puq+UMWVPcpSOSKwv/3jY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cPEV5TWBiSK8IYwDitGu1aEr/CLkSVCNnWBLuaIFHOCcnN1gbUPtJ5peZLaM1Zbio
         qhMxkzoDCCHsNTxDFlY7/cI1aPfz/iuKy62qvXwMd6nfVAL1uiJ2pv1dKFCELdWpIj
         NnTqIYCzJ9cVDv8HAcd9xe43ystIDfNHDLfzgNAM=
Date:   Thu, 25 Jun 2020 13:27:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V4 0/8] mlx5 updates 2020-06-23
Message-ID: <20200625132723.12ece0af@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jun 2020 13:13:21 -0700 Saeed Mahameed wrote:
> Hi Dave, Jakub
> 
> This series adds misc cleanup and updates to mlx5 driver.
> 
> v1->v2:
>  - Removed unnecessary Fixes Tags 
> 
> v2->v3:
>  - Drop "macro undefine" patch, it has no value
> 
> v3->v4:
>  - Drop the Relaxed ordering patch.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
