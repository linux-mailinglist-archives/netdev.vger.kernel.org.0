Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C4320670B
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 00:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389581AbgFWWOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 18:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387609AbgFWWOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 18:14:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E028C061573
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 15:14:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1C8571294B1D4;
        Tue, 23 Jun 2020 15:14:31 -0700 (PDT)
Date:   Tue, 23 Jun 2020 15:14:30 -0700 (PDT)
Message-Id: <20200623.151430.1877025825367058014.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, petrm@mellanox.com,
        jiri@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/2] mlxsw: Bump firmware version to
 XX.2007.1168
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200623191346.75121-1-idosch@idosch.org>
References: <20200623191346.75121-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jun 2020 15:14:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 23 Jun 2020 22:13:44 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> In patch #1, bump the firmware version required by the driver to
> XX.2007.1168. This version fixes several issues observed in the
> offloaded datapath.
> 
> In patch #2, add support for requiring FW version on Spectrum-3 (so far
> only Spectrum-1 and Spectrum-2 have had this requirement). Demand the
> same version as mentioned above.

Series applied, thanks.
