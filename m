Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5E0B418B
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732858AbfIPUIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:08:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732710AbfIPUIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:08:19 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0F11153F599D;
        Mon, 16 Sep 2019 13:08:17 -0700 (PDT)
Date:   Mon, 16 Sep 2019 22:08:15 +0200 (CEST)
Message-Id: <20190916.220815.934081024523493298.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v3 0/3] mlxsw: spectrum_buffers: Add the
 ability to query the CPU port's shared buffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190916150422.28947-1-idosch@idosch.org>
References: <20190916150422.28947-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 13:08:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 16 Sep 2019 18:04:19 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Shalom says:
> 
> While debugging packet loss towards the CPU, it is useful to be able to
> query the CPU port's shared buffer quotas and occupancy.
> 
> Patch #1 prevents changing the CPU port's threshold and binding.
> 
> Patch #2 registers the CPU port with devlink.
> 
> Patch #3 adds the ability to query the CPU port's shared buffer quotas and
> occupancy.
 ...

Series applied.
