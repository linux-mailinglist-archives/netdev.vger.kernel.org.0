Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E331141ED8
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgASPZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:25:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgASPZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:25:41 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03F9514EF485C;
        Sun, 19 Jan 2020 07:25:39 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:25:38 +0100 (CET)
Message-Id: <20200119.162538.692635075813536925.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, amitc@mellanox.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 00/15] mlxsw: Add tunnel devlink-trap support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200119130100.3179857-1-idosch@idosch.org>
References: <20200119130100.3179857-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:25:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 19 Jan 2020 15:00:45 +0200

> This patch set from Amit adds support in mlxsw for tunnel traps and a
> few additional layer 3 traps that can report drops and exceptions via
> devlink-trap.
> 
> These traps allow the user to more quickly diagnose problems relating to
> tunnel decapsulation errors, such as packet being too short to
> decapsulate or a packet containing wrong GRE key in its GRE header.
> 
> Patch set overview:
> 
> Patches #1-#4 add three additional layer 3 traps. Two of which are
> mlxsw-specific as they relate to hardware-specific errors. The patches
> include documentation of each trap and selftests.
> 
> Patches #5-#8 are preparations. They ensure that the correct ECN bits
> are set in the outer header during IPinIP encapsulation and that packets
> with an invalid ECN combination in underlay and overlay are trapped to
> the kernel and not decapsulated in hardware.
> 
> Patches #9-#15 add support for two tunnel related traps. Each trap is
> documented and selftested using both VXLAN and IPinIP tunnels, if
> applicable.

Series applied, thanks Ido.
