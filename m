Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB39A1EADEF
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730670AbgFASt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730207AbgFAStz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:49:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB512C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:49:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 474B211D53F8B;
        Mon,  1 Jun 2020 11:49:54 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:49:53 -0700 (PDT)
Message-Id: <20200601.114953.415493454319425185.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/14] devlink: Add support for control packet
 traps
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200529183649.1602091-1-idosch@idosch.org>
References: <20200529183649.1602091-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:49:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Fri, 29 May 2020 21:36:35 +0300

> So far device drivers were only able to register drop and exception
> packet traps with devlink. These traps are used for packets that were
> either dropped by the underlying device or encountered an exception
> (e.g., missing neighbour entry) during forwarding.
> 
> However, in the steady state, the majority of the packets being trapped
> to the CPU are packets that are required for the correct functioning of
> the control plane. For example, ARP request and IGMP query packets.
> 
> This patch set allows device drivers to register such control traps with
> devlink and expose their default control plane policy to user space.
> User space can then tune the packet trap policer settings according to
> its needs, as with existing packet traps.
 ...

Series applied, thank you.
