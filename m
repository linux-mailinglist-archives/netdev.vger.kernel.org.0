Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E611010AC
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfKSBX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:23:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSBX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:23:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 64C49150FAE7B;
        Mon, 18 Nov 2019 17:23:58 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:23:58 -0800 (PST)
Message-Id: <20191118.172358.1651088156867288729.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        dmurphy@ti.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: dp83869: fix return of uninitialized
 variable ret
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118114835.39494-1-colin.king@canonical.com>
References: <20191118114835.39494-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:23:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 18 Nov 2019 11:48:35 +0000

> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where the call to phy_interface_is_rgmii returns zero
> the variable ret is left uninitialized and this is returned at
> the end of the function dp83869_configure_rgmii.  Fix this by
> returning 0 instead of the uninitialized value in ret.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied.
