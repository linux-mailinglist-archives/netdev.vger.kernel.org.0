Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950141F5F03
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 02:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgFKADO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 20:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgFKADN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 20:03:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1271C08C5C1;
        Wed, 10 Jun 2020 17:03:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 955CC11F5F667;
        Wed, 10 Jun 2020 17:03:12 -0700 (PDT)
Date:   Wed, 10 Jun 2020 17:03:09 -0700 (PDT)
Message-Id: <20200610.170309.928494814671626769.davem@davemloft.net>
To:     heiko@sntech.de
Cc:     kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com,
        heiko.stuebner@theobroma-systems.com
Subject: Re: [PATCH v2 2/2] net: phy: mscc: handle the clkout control on
 some phy variants
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200609133140.1421109-2-heiko@sntech.de>
References: <20200609133140.1421109-1-heiko@sntech.de>
        <20200609133140.1421109-2-heiko@sntech.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Jun 2020 17:03:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiko Stuebner <heiko@sntech.de>
Date: Tue,  9 Jun 2020 15:31:40 +0200

> From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> 
> At least VSC8530/8531/8540/8541 contain a clock output that can emit
> a predefined rate of 25, 50 or 125MHz.
> 
> This may then feed back into the network interface as source clock.
> So follow the example the at803x already set and introduce a
> vsc8531,clk-out-frequency property to set that output.
> 
> Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> ---
> Hi Andrew,
> 
> I didn't change the property yet, do you have a suggestion on
> how to name it though? Going by the other examples in the
> ethernet-phy.yamls, something like enet-phy-clock-out-frequency ?

Andrew, please help Heiko out with the naming here so we can move
forward on this patch series.

Thank you.
