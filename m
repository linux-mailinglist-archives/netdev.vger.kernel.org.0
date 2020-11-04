Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96FD2A7023
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 23:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732247AbgKDWEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 17:04:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731964AbgKDWD5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 17:03:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31BA4206FB;
        Wed,  4 Nov 2020 22:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604527436;
        bh=h/BBc4SAewpl54EkPOpoOOGHO7CEa5BiXr/RzG6Gicg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UIiQeiXaVo6ymxFDL+Q0TxurdMICOj9bEcheojYSLgfVBRD8MHdgLeUVcCFZgqvWy
         64UN7fOoj5AEtKaIFOQgxp2C/ZhUDClOKIGHbcrgoyI24cwUdYSeKyv+yNLTHrq5CG
         J1vOuN+Gjq+DyRDqfWzCKlBwx7sBra8Vo6i4sGb4=
Date:   Wed, 4 Nov 2020 14:03:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maor Dickman" <maord@nvidia.com>, Paul Blakey <paulb@nvidia.com>
Subject: Re: [net 1/9] net/mlx5e: Fix modify header actions memory leak
Message-ID: <20201104140355.14c529d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103191830.60151-2-saeedm@nvidia.com>
References: <20201103191830.60151-1-saeedm@nvidia.com>
        <20201103191830.60151-2-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Nov 2020 11:18:22 -0800 Saeed Mahameed wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> Modify header actions are allocated during parse tc actions and only
> freed during the flow creation, however, on error flow the allocated
> memory is wrongly unfreed.
> 
> Fix this by calling dealloc_mod_hdr_actions in __mlx5e_add_fdb_flow
> and mlx5e_add_nic_flow error flow.
> 
> Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) action"')
> Fixes: 2f4fe4cab073 ("net/mlx5e: Add offloading of NIC TC pedit (header re-write) actions")
> Signed-off-by: Maor Dickman <maord@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Sorry, I didn't look at the warnings for you patches yesterday.

Fixes tag: Fixes: d7e75a325cb2 ("net/mlx5e: Add offloading of E-Switch TC pedit (header re-write) action"')
Has these problem(s):
	- Subject has leading but no trailing quotes
	- Subject does not match target commit subject
	  Just use
		git log -1 --format='Fixes: %h ("%s")'
