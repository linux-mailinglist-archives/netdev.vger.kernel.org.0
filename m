Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51372194FAA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 04:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbgC0DaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 23:30:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 23:30:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 69E5315CE9632;
        Thu, 26 Mar 2020 20:30:09 -0700 (PDT)
Date:   Thu, 26 Mar 2020 20:30:08 -0700 (PDT)
Message-Id: <20200326.203008.725583123135834564.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: don't touch suspended flag if
 there's no suspend/resume callback
From:   David Miller <davem@davemloft.net>
In-Reply-To: <313dae57-8c05-a82b-ea87-a0822e9462f0@gmail.com>
References: <313dae57-8c05-a82b-ea87-a0822e9462f0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 20:30:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Thu, 26 Mar 2020 18:58:24 +0100

> So far we set phydev->suspended to true in phy_suspend() even if the
> PHY driver doesn't implement the suspend callback. This applies
> accordingly for the resume path. The current behavior doesn't cause
> any issue I'd be aware of, but it's not logical and misleading,
> especially considering the description of the flag:
> "suspended: Set to true if this phy has been suspended successfully"
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks.
