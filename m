Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BF72313DD
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 22:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgG1U20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 16:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728430AbgG1U20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 16:28:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824D5C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 13:28:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81BD2128AB516;
        Tue, 28 Jul 2020 13:11:40 -0700 (PDT)
Date:   Tue, 28 Jul 2020 13:28:24 -0700 (PDT)
Message-Id: <20200728.132824.26736374849989473.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, andrew@lunn.ch, popadrian1996@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 0/2] mlxsw: Add support for QSFP-DD
 transceiver type
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200728102016.1960193-1-idosch@idosch.org>
References: <20200728102016.1960193-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 28 Jul 2020 13:11:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue, 28 Jul 2020 13:20:14 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set from Vadim adds support for Quad Small Form Factor
> Pluggable Double Density (QSFP-DD) modules in mlxsw.
> 
> Patch #1 enables dumping of QSFP-DD module information through ethtool.
> 
> Patch #2 enables reading of temperature thresholds from QSFP-DD modules
> for hwmon and thermal zone purposes.
> 
> Changes since v1 [1]:
> 
> Only rebase on top of net-next. After discussing with Andrew and Adrian
> we agreed that current approach is OK and that in the future we can
> follow Andrew's suggestion to "make a new API where user space can
> request any pages it want, and specify the size of the page". This
> should allow us "to work around known issues when manufactures get their
> EEPROM wrong".
> 
> [1] https://lore.kernel.org/netdev/20200626144724.224372-1-idosch@idosch.org/#t

Series applied, thank you.
