Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940F310E399
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfLAVQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:16:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55082 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfLAVQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:16:36 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3525714F99033;
        Sun,  1 Dec 2019 13:16:36 -0800 (PST)
Date:   Sun, 01 Dec 2019 13:16:35 -0800 (PST)
Message-Id: <20191201.131635.314502903939761706.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org, jhdskag3@tutanota.com
Subject: Re: [PATCH net] r8169: fix resume on cable plug-in
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5ecbf6db-f8e5-7b31-d80e-7c835eb7ae5c@gmail.com>
References: <5ecbf6db-f8e5-7b31-d80e-7c835eb7ae5c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 01 Dec 2019 13:16:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Sun, 1 Dec 2019 10:39:56 +0100

> It was reported [0] that network doesn't wake up on cable plug-in with
> certain chip versions. Reason is that on these chip versions the PHY
> doesn't detect cable plug-in when being in power-down mode. So prevent
> the PHY from powering down if WoL is enabled.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=202103
> 
> Fixes: 95fb8bb3181b ("net: phy: force phy suspend when calling phy_stop")
> Reported-by: jhdskag3 <jhdskag3@tutanota.com>
> Tested-by: jhdskag3 <jhdskag3@tutanota.com>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied and queued up for -stable.
