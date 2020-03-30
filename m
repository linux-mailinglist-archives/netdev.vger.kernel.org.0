Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC801987F0
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 01:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729285AbgC3XSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 19:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbgC3XSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 19:18:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2870C20409;
        Mon, 30 Mar 2020 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585610323;
        bh=u3RxDXsuv82W32l/GItaHCQBBIlbv1bDD/T3a04xZk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XhN5Jfuzd/R+7j6JEr8FvW3DPslOTdYwma/xjcqXFfv1P5x+aoOx/CRJKpbMy2nxy
         HkuZ0kpQyyK+xQsbsOQtPjjW0hQg6AMPBDSRl7Ji5ZfJ+B8CrhUsfuG53RL+grORq7
         yAp91dM6nW8/6VfwVNEboBUWRgo3kKoKsT5Esbq4=
Date:   Mon, 30 Mar 2020 16:18:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next v3 04/15] devlink: Add packet trap group
 parameters support
Message-ID: <20200330161841.33269a07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200330193832.2359876-5-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
        <20200330193832.2359876-5-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 22:38:21 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Packet trap groups are used to aggregate logically related packet traps.
> Currently, these groups allow user space to batch operations such as
> setting the trap action of all member traps.
> 
> In order to prevent the CPU from being overwhelmed by too many trapped
> packets, it is desirable to bind a packet trap policer to these groups.
> For example, to limit all the packets that encountered an exception
> during routing to 10Kpps.
> 
> Allow device drivers to bind default packet trap policers to packet trap
> groups when the latter are registered with devlink.
> 
> The next patch will enable user space to change this default binding.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
