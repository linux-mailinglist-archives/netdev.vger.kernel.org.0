Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EA21AB429
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388961AbgDOXVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388747AbgDOXV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 19:21:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BE6C061A0C;
        Wed, 15 Apr 2020 16:21:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C67E120ED569;
        Wed, 15 Apr 2020 16:21:26 -0700 (PDT)
Date:   Wed, 15 Apr 2020 16:21:25 -0700 (PDT)
Message-Id: <20200415.162125.2094896562695820757.davem@davemloft.net>
To:     jbx6244@gmail.com
Cc:     heiko@sntech.de, robh+dt@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ethernet-phy: add desciption for
 ethernet-phy-id1234.d400
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200415200149.16986-1-jbx6244@gmail.com>
References: <20200415200149.16986-1-jbx6244@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 15 Apr 2020 16:21:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>
Date: Wed, 15 Apr 2020 22:01:49 +0200

> The description below is already in use in
> 'rk3228-evb.dts', 'rk3229-xms6.dts' and 'rk3328.dtsi'
> but somehow never added to a document, so add
> "ethernet-phy-id1234.d400", "ethernet-phy-ieee802.3-c22"
> for ethernet-phy nodes on Rockchip platforms to
> 'ethernet-phy.yaml'.
> 
> Signed-off-by: Johan Jonker <jbx6244@gmail.com>

I'll take this via my net tree, thanks.
