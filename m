Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F5E1010A3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKSBXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:23:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52208 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbfKSBXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:23:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71099150FAE71;
        Mon, 18 Nov 2019 17:23:02 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:23:01 -0800 (PST)
Message-Id: <20191118.172301.1298479853205739098.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        mripard@kernel.org, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] phy: mdio-sun4i: add missed regulator_disable in remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191118114115.25608-1-hslester96@gmail.com>
References: <20191118114115.25608-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 17:23:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Mon, 18 Nov 2019 19:41:15 +0800

> The driver forgets to disable the regulator in remove like what is done
> in probe failure.
> Add the missed call to fix it.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied, thanks.
