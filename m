Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C6833E0BF
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhCPVox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhCPVo0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5D5064F37;
        Tue, 16 Mar 2021 21:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615931066;
        bh=BOueYVJGvKEVEo7tUoNmPky7XRZNuIHJ4x/ctjbsU8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oAuA2vuxV2OSvWJcv3iZSF1v1at/7gIM/36AZi+TF8KYDxnB+RSphydynpdC1m49P
         G83wkBnEv9+7HS6wNvx9BoQESE/A7h8q/nUccBfgai/zWFeA0Z6+wpsi5gkh1W3wqv
         JmPjhom7/91TVoMn00jkXlnWwpPoDw250MgIT4YQxC/iOoDxv550JI03+pRVSnO51g
         /+QIeK+wZ0O2kNSJcPbvQU6fIYvzbgp/ilRpcytc+SHDtsM1GWCAHb4HtiRaMlo3Pr
         JdcsA99ewwJ3G3Zp/g/vwzSLHqSSEAx5zl111TOclBt1iV/cC8t6zcmYkSOdLXIp7L
         EkrTHRsyEdFgw==
Date:   Tue, 16 Mar 2021 14:44:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Louis Peens <louis.peens@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@netronome.com
Subject: Re: [PATCH net 0/3] Fixes for nfp pre_tunnel code
Message-ID: <20210316144425.16158dbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316181310.12199-1-simon.horman@netronome.com>
References: <20210316181310.12199-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 19:13:07 +0100 Simon Horman wrote:
> Louis Peens says:
> 
> The following set of patches fixes up a few bugs in the pre_tun
> decap code paths which has been hiding for a while.

Acked-by: Jakub Kicinski <kuba@kernel.org>
