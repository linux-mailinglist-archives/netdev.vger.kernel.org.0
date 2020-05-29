Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8601E8764
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgE2TM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgE2TM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:12:56 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF09E20723;
        Fri, 29 May 2020 19:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590779575;
        bh=0ILBMi28mcXUO2Vgh5eV2bP77e1a52JJdAHj5QAqTxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Af/4C74PqNAdKpGd4FWnGcnPMYQzgKzM4E8+5y/OnzBnKfCnRrz3FUNQWbros91kG
         c+y+ZDvOXLwAySXfX1q4giQsIJ7lv+tql9Fnjq65EoqD2UJTJiWeV1HMfuIkHNBJrl
         8yNohhu37qMFFHgIGvLr1w4Gar0xaqFIGB8G5hQg=
Date:   Fri, 29 May 2020 12:12:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Maor Dickman <maord@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [net 3/6] net/mlx5e: Remove warning "devices are not on same
 switch HW"
Message-ID: <20200529121222.4b68ce20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529065645.118386-4-saeedm@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
        <20200529065645.118386-4-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 23:56:42 -0700 Saeed Mahameed wrote:
> From: Maor Dickman <maord@mellanox.com>
> 
> On tunnel decap rule insertion, the indirect mechanism will attempt to
> offload the rule on all uplink representors which will trigger the
> "devices are not on same switch HW, can't offload forwarding" message
> for the uplink which isn't on the same switch HW as the VF representor.
> 
> The above flow is valid and shouldn't cause warning message,
> fix by removing the warning and only report this flow using extack.
> 
> Fixes: f3953003a66f ("net/mlx5e: Fix allowed tc redirect merged eswitch offload cases")
> Signed-off-by: Maor Dickman <maord@mellanox.com>
> Reviewed-by: Roi Dayan <roid@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

Fixes tag: Fixes: f3953003a66f ("net/mlx5e: Fix allowed tc redirect merged eswitch offload cases")
Has these problem(s):
	- Target SHA1 does not exist
