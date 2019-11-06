Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E694BF0BCC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 02:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbfKFBzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 20:55:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfKFBzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 20:55:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5D3E4150FEF46;
        Tue,  5 Nov 2019 17:55:17 -0800 (PST)
Date:   Tue, 05 Nov 2019 17:55:16 -0800 (PST)
Message-Id: <20191105.175516.1095237130960059082.davem@davemloft.net>
To:     f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Fix driver removal
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191103031739.27157-1-f.fainelli@gmail.com>
References: <20191103031739.27157-1-f.fainelli@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Nov 2019 17:55:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>
Date: Sat,  2 Nov 2019 20:17:39 -0700

> With the DSA core doing the call to dsa_port_disable() we do not need to
> do that within the driver itself. This could cause an use after free
> since past dsa_unregister_switch() we should not be accessing any
> dsa_switch internal structures.
> 
> Fixes: 0394a63acfe2 ("net: dsa: enable and disable all ports")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Applied.
