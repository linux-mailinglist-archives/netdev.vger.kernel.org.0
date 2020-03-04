Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1201787A0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 02:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbgCDBiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 20:38:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38138 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728319AbgCDBiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 20:38:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F306015AD7CC5;
        Tue,  3 Mar 2020 17:38:10 -0800 (PST)
Date:   Tue, 03 Mar 2020 17:38:10 -0800 (PST)
Message-Id: <20200303.173810.1175903724933225503.davem@davemloft.net>
To:     jonas.gorski@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH] net: phy: bcm63xx: fix OOPS due to missing driver name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200302194657.14356-1-jonas.gorski@gmail.com>
References: <20200302194657.14356-1-jonas.gorski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 17:38:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Mon,  2 Mar 2020 20:46:57 +0100

> 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode
> bitmap") was a bit over-eager and also removed the second phy driver's
> name, resulting in a nasty OOPS on registration:
 ...
> Fix it by readding the name.
> 
> Fixes: 719655a14971 ("net: phy: Replace phy driver features u32 with link_mode bitmap")
> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>

Applied and queued up for -stable.
