Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 305A11157EA
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 20:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbfLFTsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 14:48:19 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfLFTsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 14:48:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 967721511D779;
        Fri,  6 Dec 2019 11:48:17 -0800 (PST)
Date:   Fri, 06 Dec 2019 11:48:14 -0800 (PST)
Message-Id: <20191206.114814.1747507756122956444.davem@davemloft.net>
To:     yangbo.lu@nxp.com
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com
Subject: Re: [PATCH] enetc: disable EEE autoneg by default
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191206095335.7450-1-yangbo.lu@nxp.com>
References: <20191206095335.7450-1-yangbo.lu@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Dec 2019 11:48:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yangbo Lu <yangbo.lu@nxp.com>
Date: Fri,  6 Dec 2019 17:53:35 +0800

> The EEE support has not been enabled on ENETC, but it may connect
> to a PHY which supports EEE and advertises EEE by default, while
> its link partner also advertises EEE. If this happens, the PHY enters
> low power mode when the traffic rate is low and causes packet loss.
> This patch disables EEE advertisement by default for any PHY that
> ENETC connects to, to prevent the above unwanted outcome.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Applied, thanks.
