Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40E4919042F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 05:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgCXEKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 00:10:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56004 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgCXEKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 00:10:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D2EC7155B5F90;
        Mon, 23 Mar 2020 21:10:05 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:10:04 -0700 (PDT)
Message-Id: <20200323.211004.657670862190579071.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] net: phy: add and use
 phy_check_downshift
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
References: <6e451e53-803f-d277-800a-ff042fb8a858@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 21:10:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Fri, 20 Mar 2020 17:50:12 +0100

> So far PHY drivers have to check whether a downshift occurred to be
> able to notify the user. To make life of drivers authors a little bit
> easier move the downshift notification to phylib. phy_check_downshift()
> compares the highest mutually advertised speed with the actual value
> of phydev->speed (typically read by the PHY driver from a
> vendor-specific register) to detect a downshift.
> 
> v2: Add downshift hint to phy_print_status().

This honestly looks good to me, series applied, thanks Heiner.
