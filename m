Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C61FC032
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 22:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgFPUrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 16:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgFPUrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 16:47:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A364C061573
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 13:47:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 883B9128D730F;
        Tue, 16 Jun 2020 13:47:07 -0700 (PDT)
Date:   Tue, 16 Jun 2020 13:47:06 -0700 (PDT)
Message-Id: <20200616.134706.855421482127630808.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum: Adjust headroom buffers for 8x
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616071458.192798-1-idosch@idosch.org>
References: <20200616071458.192798-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Jun 2020 13:47:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 16 Jun 2020 10:14:58 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> The port's headroom buffers are used to store packets while they
> traverse the device's pipeline and also to store packets that are egress
> mirrored.
> 
> On Spectrum-3, ports with eight lanes use two headroom buffers between
> which the configured headroom size is split.
> 
> In order to prevent packet loss, multiply the calculated headroom size
> by two for 8x ports.
> 
> Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thank you.
