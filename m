Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A381A1B8284
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 01:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgDXXpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 19:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbgDXXpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 19:45:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F018C09B049
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 16:45:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 04FDB14F46646;
        Fri, 24 Apr 2020 16:45:49 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:45:49 -0700 (PDT)
Message-Id: <20200424.164549.1788562235455830608.davem@davemloft.net>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next] net: phylink, dsa: eliminate
 phylink_fixed_state_cb()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <E1jReJU-0008Mi-N1@rmk-PC.armlinux.org.uk>
References: <E1jReJU-0008Mi-N1@rmk-PC.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Apr 2020 16:45:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Thu, 23 Apr 2020 17:02:56 +0100

> Move the callback into the phylink_config structure, rather than
> providing a callback to set this up.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thanks.
