Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17192247FC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 04:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgGRCIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 22:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgGRCIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 22:08:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01A9C0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 19:08:04 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C98711E4590D;
        Fri, 17 Jul 2020 19:08:04 -0700 (PDT)
Date:   Fri, 17 Jul 2020 19:08:03 -0700 (PDT)
Message-Id: <20200717.190803.419652031905268571.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: core: Fix wrong SFP EEPROM reading for
 upper pages 1-3
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717190143.563235-1-idosch@idosch.org>
References: <20200717190143.563235-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 19:08:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 17 Jul 2020 22:01:43 +0300

> From: Vadim Pasternak <vadimp@mellanox.com>
> 
> Fix wrong reading of upper pages for SFP EEPROM. According to "Memory
> Organization" figure in SFF-8472 spec: When reading upper pages 1, 2 and
> 3 the offset should be set relative to zero and I2C high address 0x51
> [1010001X (A2h)] is to be used.
> 
> Fixes: a45bfb5a5070 ("mlxsw: core: Extend QSFP EEPROM size for ethtool")
> Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied and queued up for -stable.
