Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB21439CF
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUJvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:51:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgAUJvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:51:03 -0500
Received: from localhost (82-95-191-104.ip.xs4all.nl [82.95.191.104])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6076415BCFE61;
        Tue, 21 Jan 2020 01:51:01 -0800 (PST)
Date:   Tue, 21 Jan 2020 10:50:59 +0100 (CET)
Message-Id: <20200121.105059.172450319997059007.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, mark.einon@gmail.com,
        jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] net: phy: add new version of phy_do_ioctl
 and convert suitable drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 01:51:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 20 Jan 2020 22:15:11 +0100

> We just added phy_do_ioctl, but it turned out that we need another
> version of this function that doesn't check whether net_device is
> running. So rename phy_do_ioctl to phy_do_ioctl_running and add a
> new version of phy_do_ioctl. Eventually convert suitable drivers
> to use phy_do_ioctl.

Series applied, thanks.
