Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7308EDCC6D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505426AbfJRRPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:15:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55204 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2505339AbfJRRPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:15:48 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 427E214A98EF2;
        Fri, 18 Oct 2019 10:15:47 -0700 (PDT)
Date:   Fri, 18 Oct 2019 13:15:46 -0400 (EDT)
Message-Id: <20191018.131546.106406470055738848.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_trap: Push Ethernet header before
 reporting trap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191017071103.28744-1-idosch@idosch.org>
References: <20191017071103.28744-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 18 Oct 2019 10:15:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 17 Oct 2019 10:11:03 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> devlink maintains packets and bytes statistics for each trap. Since
> eth_type_trans() was called to set the skb's protocol, the data pointer
> no longer points to the start of the packet and the bytes accounting is
> off by 14 bytes.
> 
> Fix this by pushing the skb's data pointer to the start of the packet.
> 
> Fixes: b5ce611fd96e ("mlxsw: spectrum: Add devlink-trap support")
> Reported-by: Alex Kushnarov <alexanderk@mellanox.com>
> Tested-by: Alex Kushnarov <alexanderk@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied, thanks.
