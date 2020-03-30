Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D401B198864
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgC3Xik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgC3Xik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:38:40 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5F7720771;
        Mon, 30 Mar 2020 23:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585611519;
        bh=+OFlLNu/grskP8iBTBP+fhCdp1c+7T8V1lcUwU+JgyU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pg7IgHevEdCrQvBAMlumIitSBSD20/3bpI23lHOA09b8m6m7XLX93tTMj6QjfjKJN
         AmAqhmbmRUT62RS9kz1uqri70Nb1OYT3g+kk8zGqG4k2zegEjdnxGqLK3lDvICDNo+
         wvw1UwHH98iZilq9a7RCcE67K+6YvmhitYyHJXJk=
Date:   Mon, 30 Mar 2020 16:38:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netdevsim: dev: Fix memory leak in
 nsim_dev_take_snapshot_write
Message-ID: <20200330163838.122266d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330232702.GA3212@embeddedor.com>
References: <20200330232702.GA3212@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 18:27:02 -0500 Gustavo A. R. Silva wrote:
> In case memory resources for dummy_data were allocated, release them
> before return.
> 
> Addresses-Coverity-ID: 1491997 ("Resource leak")
> Fixes: 7ef19d3b1d5e ("devlink: report error once U32_MAX snapshot ids have been used")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
