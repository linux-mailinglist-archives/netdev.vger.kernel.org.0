Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCBA145CFB
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbgAVURs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:17:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVURr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:17:47 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BC4D9140B6C76;
        Wed, 22 Jan 2020 12:17:45 -0800 (PST)
Date:   Wed, 22 Jan 2020 21:17:44 +0100 (CET)
Message-Id: <20200122.211744.1921768107399638285.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, bh74.an@samsung.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: convert additional drivers to use
 phy_do_ioctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cc7396fa-81c6-6a13-0e94-9ac2ca2cab08@gmail.com>
References: <cc7396fa-81c6-6a13-0e94-9ac2ca2cab08@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 12:17:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 21 Jan 2020 22:05:14 +0100

> The first batch of driver conversions missed a few cases where we can
> use phy_do_ioctl too.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
