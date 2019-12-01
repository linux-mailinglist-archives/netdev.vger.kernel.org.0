Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAC410E39A
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfLAVQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:16:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55102 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfLAVQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:16:42 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 86C4B14F99949;
        Sun,  1 Dec 2019 13:16:41 -0800 (PST)
Date:   Sun, 01 Dec 2019 13:16:41 -0800 (PST)
Message-Id: <20191201.131641.1788241788144419755.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, andrew@lunn.ch, f.fainelli@gmail.com,
        netdev@vger.kernel.org, jhdskag3@tutanota.com
Subject: Re: [PATCH net] net: phy: realtek: fix using paged operations with
 RTL8105e / RTL8208
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2c4f254c-6b17-714e-81e2-96bb6b08a12d@gmail.com>
References: <2c4f254c-6b17-714e-81e2-96bb6b08a12d@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 13:16:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Dec 2019 10:51:47 +0100

> It was reported [0] that since the referenced commit a warning is
> triggered in phylib that complains about paged operations being used
> with a PHY driver that doesn't support this. The commit isn't wrong,
> just for one chip version (RTL8105e) no dedicated PHY driver exists
> yet. So add the missing PHY driver.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=202103
> 
> Fixes: 3a129e3f9ac4 ("r8169: switch to phylib functions in more places")
> Reported-by: jhdskag3 <jhdskag3@tutanota.com>
> Tested-by: jhdskag3 <jhdskag3@tutanota.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
