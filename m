Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140971C459A
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgEDSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730118AbgEDSQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:16:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0063EC061A0E;
        Mon,  4 May 2020 11:16:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED9C611F5F61A;
        Mon,  4 May 2020 11:16:20 -0700 (PDT)
Date:   Mon, 04 May 2020 11:16:20 -0700 (PDT)
Message-Id: <20200504.111620.1983042701063972335.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH RESEND net-next] net: dsa: felix: allow the device to
 be disabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200504165228.12787-1-michael@walle.cc>
References: <20200504165228.12787-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 May 2020 11:16:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Mon,  4 May 2020 18:52:28 +0200

> If there is no specific configuration of the felix switch in the device
> tree, but only the default configuration (ie. given by the SoCs dtsi
> file), the probe fails because no CPU port has been set. On the other
> hand you cannot set a default CPU port because that depends on the
> actual board using the switch.
> 
> [    2.701300] DSA: tree 0 has no CPU port
> [    2.705167] mscc_felix 0000:00:00.5: Failed to register DSA switch: -22
> [    2.711844] mscc_felix: probe of 0000:00:00.5 failed with error -22
> 
> Thus let the device tree disable this device entirely, like it is also
> done with the enetc driver of the same SoC.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied, thank you.
