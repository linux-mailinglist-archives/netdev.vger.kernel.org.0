Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3F3818A43B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCRUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgCRUuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:50:11 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1D2A20724;
        Wed, 18 Mar 2020 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564611;
        bh=ADpE1ayerqFhgLKHFay6BRSgTpXTDmfn1l6Iba5Yu5I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C7mzHLykb/M9iT5IFNIO99BjskGWY4qQa4nelgB/nbQJe1PW3FmRf3iMPVwHNXKq0
         D0PafYLPpqH7Xzd8JYhZ5n0vDeJBG342zRcXjg6EGjQvdVN03LdXYDlvzC9tqq7y6c
         sCfppB3O3+RZBLWm1jYIo5ceEWRlCqL7DW72EvSs=
Date:   Wed, 18 Mar 2020 13:50:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/9] mlxsw: spectrum_cnt: Expose counter
 resources
Message-ID: <20200318135008.1bea86b4@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200318134857.1003018-1-idosch@idosch.org>
References: <20200318134857.1003018-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 15:48:48 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> Capacity and utilization of existing flow and RIF counters are currently
> unavailable to be seen by the user. Use the existing devlink resources
> API to expose the information:
> 
> $ sudo devlink resource show pci/0000:00:10.0 -v
> pci/0000:00:10.0:
>   name kvd resource_path /kvd size 524288 unit entry dpipe_tables none
>   name span_agents resource_path /span_agents size 8 occ 0 unit entry dpipe_tables none
>   name counters resource_path /counters size 79872 occ 44 unit entry dpipe_tables none
>     resources:
>       name flow resource_path /counters/flow size 61440 occ 4 unit entry dpipe_tables none
>       name rif resource_path /counters/rif size 18432 occ 40 unit entry dpipe_tables none

Acked-by: Jakub Kicinski <kuba@kernel.org>

Nice!
