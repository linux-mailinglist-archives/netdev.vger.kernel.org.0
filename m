Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D7F312084
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 00:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbhBFXkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 18:40:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBFXkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 18:40:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A57A64E78;
        Sat,  6 Feb 2021 23:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612654805;
        bh=iyxh3beC+Bdqff0j0dZjwRRJv2hLHUgL+RxiceYqeQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQEmJ4OZBy0DMoKo1lvKl8055j1zAlCYKBlRNwa35eI5UXEq/lY08MJfmyE+9cTu9
         JetBTNPVxAopCyZcGXhCrjmfcgexykmB7IxxNvrkV7LDfc7igMQCY7cVltM221FePb
         Ko3rZqTxAYfXferTo0aehTYkdELBAfNTA0HSOv5qvu0GBh9tZh4jGRpyJsi0bwQTlN
         jAmSlTpyUTCwXbTHDA8MXrpby3yoJ/IyRDvLr55S2C0kugH39yqQkpAdjUrLF+aGWS
         tiriGyGyElncA7Rt15eRQnn7MvhmQOjIlhVRQQDW6aNFjM1pszU5K+yiA4afNGT0yQ
         wHwlQeHyu2lEw==
Date:   Sat, 6 Feb 2021 15:40:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <stefanc@marvell.com>
Cc:     <netdev@vger.kernel.org>, <thomas.petazzoni@bootlin.com>,
        <davem@davemloft.net>, <nadavh@marvell.com>,
        <ymarkman@marvell.com>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mw@semihalf.com>, <andrew@lunn.ch>,
        <rmk+kernel@armlinux.org.uk>, <atenart@kernel.org>,
        Konstantin Porotchkin <kostap@marvell.com>
Subject: Re: [PATCH v8 net-next 02/15] dts: marvell: add CM3 SRAM memory to
 cp11x ethernet device tree
Message-ID: <20210206154004.4aaa32ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1612629961-11583-3-git-send-email-stefanc@marvell.com>
References: <1612629961-11583-1-git-send-email-stefanc@marvell.com>
        <1612629961-11583-3-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 6 Feb 2021 18:45:48 +0200 stefanc@marvell.com wrote:
> From: Konstantin Porotchkin <kostap@marvell.com>
> 
> CM3 SRAM address space would be used for Flow Control configuration.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Signed-off-by: Konstantin Porotchkin <kostap@marvell.com>

Isn't there are requirement to CC the DT mailing list and Rob on all
device tree patches?  Maybe someone can clarify I know it's required
when adding bindings.. 
