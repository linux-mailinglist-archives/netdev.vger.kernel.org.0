Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1582923B068
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgHCWp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgHCWp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:45:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8F3C06174A;
        Mon,  3 Aug 2020 15:45:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F227D12777A27;
        Mon,  3 Aug 2020 15:29:10 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:45:55 -0700 (PDT)
Message-Id: <20200803.154555.158747575409420099.davem@davemloft.net>
To:     noodles@earth.li
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, kuba@kernel.org, linux@armlinux.org.uk,
        mnhagan88@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] net: dsa: qca8k: Add define for port
 VID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
References: <20200721171624.GK23489@earth.li>
        <08fd70c48668544408bdb7932ef23e13d1080ad1.1596301468.git.noodles@earth.li>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:29:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>
Date: Sat, 1 Aug 2020 18:05:54 +0100

> Rather than using a magic value of 1 when configuring the port VIDs add
> a QCA8K_PORT_VID_DEF define and use that instead. Also fix up the
> bitmask in the process; the top 4 bits are reserved so this wasn't a
> problem, but only masking 12 bits is the correct approach.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

Applied.
