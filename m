Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB3A457145
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhKSO64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:58:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235905AbhKSO6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:58:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFB3A615E2;
        Fri, 19 Nov 2021 14:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637333747;
        bh=JfE31ft2gzILGuVfNngDiekACTuyUn5n4lV3Kg6e24U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kzZ0QqV2WoHuBRrhtK2y+SqmiR5P02sN+7S/sVvP4kl+67zglo1jbqnzfZq6Lx4IM
         VC4hlDhhy+E7+c0kmI6FAEt9UfRnm8bg+dSK+Ivjsy2plfdAyKnJeXyUoWsxzMn9C4
         kji05jGQ3rTDB1kY/PnVi0RAtB6WT5t9KefskZKYr8A6dS5m0l3ys/aE78V4zpm3j0
         u3OWIXw+jloaBw/AEJGOMAys3Xt2d3gIu8gna6dlKdPc6BcCTmF9vVrIXqGPMIcseu
         3qqjv/VDWlvBFo+D0aJzU6Fzp5VVKQ1ujKWWH/lNlwoPce0zkp+JUAbJ66A3fvdvOP
         K9wm9cO52FJEg==
Date:   Fri, 19 Nov 2021 06:55:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>
Subject: Re: [PATCH net] nfp: checking parameter process for
 rx-usecs/tx-usecs is invalid
Message-ID: <20211119065546.7f4d0511@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119133803.28749-1-simon.horman@corigine.com>
References: <20211119133803.28749-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 14:38:03 +0100 Simon Horman wrote:
> From: Diana Wang <na.wang@corigine.com>
> 
> Use nn->tlv_caps.me_freq_mhz instead of nn->me_freq_mhz to check whether
> rx-usecs/tx-usecs is valid.
> 
> This is because nn->tlv_caps.me_freq_mhz represents the clock_freq (MHz) of
> the flow processing cores (FPC) on the NIC. While nn->me_freq_mhz is not
> be set.
> 
> Fixes: ce991ab6662a ("nfp: read ME frequency from vNIC ctrl memory")
> Signed-off-by: Diana Wang <na.wang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
