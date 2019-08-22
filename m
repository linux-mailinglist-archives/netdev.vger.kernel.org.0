Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D05B989E1
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 05:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbfHVDfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 23:35:55 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbfHVDfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 23:35:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1456150650A7;
        Wed, 21 Aug 2019 20:35:54 -0700 (PDT)
Date:   Wed, 21 Aug 2019 20:35:54 -0700 (PDT)
Message-Id: <20190821.203554.877287230314637536.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Do not configure PHYLINK on CPU
 port
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190822000747.3036-1-f.fainelli@gmail.com>
References: <20190822000747.3036-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 Aug 2019 20:35:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Wed, 21 Aug 2019 17:07:46 -0700

> The SF2 binding does not specify that the CPU port should have
> properties mandatory for successfully instantiating a PHYLINK object. As
> such, there will be missing properties (including fixed-link) and when
> attempting to validate and later configure link modes, we will have an
> incorrect set of parameters (interface, speed, duplex).
> 
> Simply prevent the CPU port from being configured through PHYLINK since
> bcm_sf2_imp_setup() takes care of that already.
> 
> Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied, thanks Florian.
