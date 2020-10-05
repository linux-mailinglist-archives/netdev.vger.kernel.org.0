Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A091E28364E
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 15:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgJENMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 09:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgJENMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 09:12:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EF8C0613CE;
        Mon,  5 Oct 2020 06:12:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0D3711E3E4CA;
        Mon,  5 Oct 2020 05:55:45 -0700 (PDT)
Date:   Mon, 05 Oct 2020 06:12:32 -0700 (PDT)
Message-Id: <20201005.061232.1000752164995010395.davem@davemloft.net>
To:     Jisheng.Zhang@synaptics.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: marvell: Use phy_read_paged() instead of
 open coding it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005171804.735de777@xhacker.debian>
References: <20201005171804.735de777@xhacker.debian>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 05 Oct 2020 05:55:46 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Date: Mon, 5 Oct 2020 17:19:50 +0800

> Convert m88e1318_get_wol() to use the well implemented phy_read_paged()
> instead of open coding it.
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Applied, thanks!
