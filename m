Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1614529F8BA
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 23:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgJ2W4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 18:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:53280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbgJ2W4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 18:56:10 -0400
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E5AA20639;
        Thu, 29 Oct 2020 22:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604012169;
        bh=pJ6vukBQgljcoDquE/dJKtCm3Ckdn6uNkaKN1HmoWCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bxwzRNR4JEFeMe/bWmqBUMGwRFYaboGerBEVSu365gy5K/7mMM3pKX568VtdZkmOR
         R6cfJEzgtXEjJlUJpZI7Sdpzcz40uZCaYNJ82n1FUDc92cD/Hmv19J2KPPbo893TJ2
         Ay56sXulCLwJ5o8qQ/0EMzQWyp6oD5XPqu26zcJ4=
Date:   Thu, 29 Oct 2020 23:55:58 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, pavel@ucw.cz
Subject: Re: [PATCH net-next 1/5] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <20201029235558.17740f76@kernel.org>
In-Reply-To: <20201029155348.1cb7555a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201028221427.22968-1-kabel@kernel.org>
        <20201028221427.22968-2-kabel@kernel.org>
        <20201029124141.GR1551@shell.armlinux.org.uk>
        <20201029125439.GK933237@lunn.ch>
        <20201029134107.GV1551@shell.armlinux.org.uk>
        <20201029155348.1cb7555a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 15:53:48 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> +1
> 
> Maybe we should patch checkpatch to still enforce 80 for networking.

If you do, do that for leds as well, Pavel will be glad.
