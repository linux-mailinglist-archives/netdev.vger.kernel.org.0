Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8101F1092
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgFHAAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbgFHAAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:00:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3645DC061A0E
        for <netdev@vger.kernel.org>; Sun,  7 Jun 2020 17:00:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69E501273D6CC;
        Sun,  7 Jun 2020 17:00:32 -0700 (PDT)
Date:   Sun, 07 Jun 2020 17:00:31 -0700 (PDT)
Message-Id: <20200607.170031.441322781685186952.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: core: Use different get_trend() callbacks
 for different thermal zones
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200607081027.2018361-1-idosch@idosch.org>
References: <20200607081027.2018361-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jun 2020 17:00:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun,  7 Jun 2020 11:10:27 +0300

> From: Vadim Pasternak <vadimp@mellanox.com>
> 
> The driver registers three different types of thermal zones: For the
> ASIC itself, for port modules and for gearboxes.
> 
> Currently, all three types use the same get_trend() callback which does
> not work correctly for the ASIC thermal zone. The callback assumes that
> the device data is of type 'struct mlxsw_thermal_module', whereas for
> the ASIC thermal zone 'struct mlxsw_thermal' is passed as device data.
> 
> Fix this by using one get_trend() callback for the ASIC thermal zone and
> another for the other two types.
> 
> Fixes: 6f73862fabd9 ("mlxsw: core: Add the hottest thermal zone detection")
> Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied and queued up for -stable, thanks.
