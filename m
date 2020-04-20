Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7815B1B1418
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgDTSMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgDTSMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:12:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D68C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:12:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A33A127D6215;
        Mon, 20 Apr 2020 11:12:44 -0700 (PDT)
Date:   Mon, 20 Apr 2020 11:12:43 -0700 (PDT)
Message-Id: <20200420.111243.500488506333434534.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: realtek: move PHY resume delay
 from MAC to PHY driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
References: <c4e18f15-7c37-13a2-4e26-1203da318f67@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 11:12:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sat, 18 Apr 2020 22:07:48 +0200

> Internal PHY's from RTL8168h up may not be instantly ready after calling
> genphy_resume(). So far r8169 network driver adds the needed delay, but
> better handle this in the PHY driver. The network driver may miss other
> places where the PHY is resumed.

Series applied, thanks.
