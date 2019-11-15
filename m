Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EADE8FE648
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 21:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfKOUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 15:14:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfKOUOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 15:14:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DF9F14E0DA7D;
        Fri, 15 Nov 2019 12:14:50 -0800 (PST)
Date:   Fri, 15 Nov 2019 12:14:49 -0800 (PST)
Message-Id: <20191115.121449.648938480846198792.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, ap420073@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] selftests: mlxsw: Adjust test to recent changes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191114095057.27335-1-idosch@idosch.org>
References: <20191114095057.27335-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 15 Nov 2019 12:14:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 14 Nov 2019 11:50:57 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> mlxsw does not support VXLAN devices with a physical device attached and
> vetoes such configurations upon enslavement to an offloaded bridge.
> 
> Commit 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
> changed the VXLAN device to be an upper of the physical device which
> causes mlxsw to veto the creation of the VXLAN device with "Unknown
> upper device type".
> 
> This is OK as this configuration is not supported, but it prevents us
> from testing bad flows involving the enslavement of VXLAN devices with a
> physical device to a bridge, regardless if the physical device is an
> mlxsw netdev or not.
> 
> Adjust the test to use a dummy device as a physical device instead of a
> mlxsw netdev.
> 
> Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Applied.
