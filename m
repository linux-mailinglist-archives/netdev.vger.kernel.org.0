Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99C881894D8
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 05:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgCREXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 00:23:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgCREXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 00:23:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA6031475D4D7;
        Tue, 17 Mar 2020 21:23:08 -0700 (PDT)
Date:   Tue, 17 Mar 2020 21:23:07 -0700 (PDT)
Message-Id: <20200317.212307.1874233849204792506.davem@davemloft.net>
To:     rayagonda.kokatanur@broadcom.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com,
        arun.parameswaran@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] net: phy: mdio-mux-bcm-iproc: check
 clk_prepare_enable() return value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200317.212127.2045455292795972153.davem@davemloft.net>
References: <20200317045435.29975-1-rayagonda.kokatanur@broadcom.com>
        <20200317.212127.2045455292795972153.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Mar 2020 21:23:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 17 Mar 2020 21:21:27 -0700 (PDT)

> From: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
> Date: Tue, 17 Mar 2020 10:24:35 +0530
> 
>> Check clk_prepare_enable() return value.
>> 
>> Fixes: 2c7230446bc9 ("net: phy: Add pm support to Broadcom iProc mdio mux driver")
>> Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
> 
> Applied.

I also queued this up for -stable as well.
