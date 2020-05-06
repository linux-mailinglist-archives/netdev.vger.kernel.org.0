Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F27421C7E3D
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 01:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgEFX5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 19:57:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46128 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728654AbgEFX5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 19:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEWEs+ukKDsojRVJdWTnkjynvgK7J8lYiVSN0gJjYfM=; b=Kry8djJj7zUGnIr2/zRmS94A5H
        9ZFd9Cw+/yslCcWroS5Q0o6B7mKl9ounxz5/LGDKsxmBo4oqT7AQafQ1AEsCtLoYVeaS/dq/KxydS
        l9O2CFITqmCDNkwU/NWqZKsrDd6j+xmtV6VIOUhrmyaVMXo4sJSI7yOUGd6+wv7roGOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jWTuv-0019Qc-3H; Thu, 07 May 2020 01:57:33 +0200
Date:   Thu, 7 May 2020 01:57:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sriram Chadalavada <sriram.chadalavada@mindleap.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: Kernel crash in DSA/Marvell 6176 switch in 5.4.36
Message-ID: <20200506235733.GN224913@lunn.ch>
References: <CAOK2joE-4AWxvT5YWoCFTUb6WhwpSST2bLavKvL8SZi1D3_2VQ@mail.gmail.com>
 <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOK2joEA_9eP3rLzV39dxwiEN8ns+QQA5G8gXtr0KgqHLri5aw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 07:35:50PM -0400, Sriram Chadalavada wrote:
> For this device tree with new binding, there was no crash with 4.19.16
> kernel on an NXP imx6 device but there is with 5.4.36.
>          eth0: igb0 {
>                          compatible = "intel,igb";
>                         /* SC: New binding for the Marvell 6176 switch
> attached to the Intel Gigabit Ethernet Controller via SERDES link */
>                           mdio1: mdio@0 {
>                               #address-cells = <2>;
>                               #size-cells = <0>;
>                               status = "okay";
>                               switch0: switch0@0 {
> 
>                                 compatible = "marvell,mv88e6085";
>                                 reg = <0 0>;
>                                 interrupt-parent = <&gpio2>;
>                                 interrupts = <31 IRQ_TYPE_LEVEL_LOW>;
>                                 dsa,member = <0 0>;
>                                 mdio2: mdio@1{
>                                  ports
>                                  {

Err, what? This would never work for 4.19.16, or any kernel version.

     Andrew
