Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F518185406
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 03:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgCNCgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 22:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCNCgq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 22:36:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FEC52074B;
        Sat, 14 Mar 2020 02:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584153405;
        bh=oGi+9sUb4yexW6HBLTkCToW5kPpwodL4GhJPFinlx2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c49m/fKKXFCfiV6vsSLxJIr5cgA5B3OZDv9on4b0b90H4xLRwEANlx6J/x6UHU45S
         Ug+qeuBYknPVjZbdqFsDaUhngIfcfj6V5x0CM3EsiewKMf9fA7HKLazBr90l4F47pd
         bNiadm+bDasWJqIDdPKiTuIq37tgJQy83xgpKSuw=
Date:   Fri, 13 Mar 2020 19:36:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [net-next 13/14] net/mlx5: DR, Add support for flow table id
 destination action
Message-ID: <20200313193643.5186b300@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200314011622.64939-14-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
        <20200314011622.64939-14-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Mar 2020 18:16:21 -0700 Saeed Mahameed wrote:
> From: Alex Vesker <valex@mellanox.com>
> 
> This action allows to go to a flow table based on the table id.
> Goto flow table id is required for supporting user space SW.

What's user space SW?
