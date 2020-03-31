Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D32119891B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 02:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgCaAz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 20:55:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729019AbgCaAz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 20:55:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B628215D06CE6;
        Mon, 30 Mar 2020 17:55:24 -0700 (PDT)
Date:   Mon, 30 Mar 2020 17:55:23 -0700 (PDT)
Message-Id: <20200330.175523.1580408290614810850.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v3 00/15] Add packet trap policers support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 17:55:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 30 Mar 2020 22:38:17 +0300

> This patch set allows capable device drivers to register their supported
> packet trap policers with devlink. User space can then tune the
> parameters of these policers (currently, rate and burst size) and read
> from the device the number of packets that were dropped by the policer,
> if supported.
> 
> These packet trap policers can then be bound to existing packet trap
> groups, which are used to aggregate logically related packet traps. As a
> result, trapped packets are policed to rates that can be handled the
> host CPU.
 ...

Series applied, thank you.
