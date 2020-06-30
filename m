Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE7020EA74
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 02:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728767AbgF3Apb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 20:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbgF3Apa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 20:45:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83330C061755
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 17:45:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 346FE127C677C;
        Mon, 29 Jun 2020 17:45:29 -0700 (PDT)
Date:   Mon, 29 Jun 2020 17:45:28 -0700 (PDT)
Message-Id: <20200629.174528.571734753348393817.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/10] Add ethtool extended link state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jun 2020 17:45:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 29 Jun 2020 23:46:11 +0300

 ...
> Amit says:
> 
> Currently, device drivers can only indicate to user space if the network
> link is up or down, without additional information.
> 
> This patch set provides an infrastructure that allows these drivers to
> expose more information to user space about the link state. The
> information can save users' time when trying to understand why a link is
> not operationally up, for example.
> 
> The above is achieved by extending the existing ethtool LINKSTATE_GET
> command with attributes that carry the extended state.
 ...

Series applied, thank everyone.
