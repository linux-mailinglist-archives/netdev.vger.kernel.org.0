Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A4160DD3
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbfGEW3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:29:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43540 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGEW3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:29:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99B04150420BD;
        Fri,  5 Jul 2019 15:29:20 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:29:20 -0700 (PDT)
Message-Id: <20190705.152920.738706012050254624.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        jiri@mellanox.com, petrm@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/8] mlxsw: Enable/disable PTP shapers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190704070740.302-1-idosch@idosch.org>
References: <20190704070740.302-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:29:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu,  4 Jul 2019 10:07:32 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Shalom says:
> 
> In order to get more accurate hardware time stamping in Spectrum-1, the
> driver needs to apply a shaper on the port for speeds lower than 40Gbps.
> This shaper is called a PTP shaper and it is applied on hierarchy 0,
> which is the port hierarchy. This shaper may affect the shaper rates of
> all hierarchies.
> 
> This patchset adds the ability to enable or disable the PTP shaper on
> the port in two scenarios:
>  1. When the user wants to enable/disable the hardware time stamping
>  2. When the port is brought up or down (including port speed change)
> 
> Patch #1 adds the QEEC.ptps field that is used for enabling or disabling
> the PTP shaper on a port.
> 
> Patch #2 adds a note about disabling the PTP shaper when calling to
> mlxsw_sp_port_ets_maxrate_set().
> 
> Patch #3 adds the QPSC register that is responsible for configuring the
> PTP shaper parameters per speed.
> 
> Patch #4 sets the PTP shaper parameters during the ptp_init().
> 
> Patch #5 adds new operation for getting the port's speed.
> 
> Patch #6 enables/disables the PTP shaper when turning on or off the
> hardware time stamping.
> 
> Patch #7 enables/disables the PTP shaper when the port's status has
> changed (including port speed change).
> 
> Patch #8 applies the PTP shaper enable/disable logic by filling the PTP
> shaper parameters array.

Series applied, thanks.
