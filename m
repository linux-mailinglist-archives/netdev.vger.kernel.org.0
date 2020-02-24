Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56686169B24
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 01:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727167AbgBXAP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 19:15:28 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgBXAP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 19:15:28 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1113A158D8DF9;
        Sun, 23 Feb 2020 16:15:28 -0800 (PST)
Date:   Sun, 23 Feb 2020 16:15:27 -0800 (PST)
Message-Id: <20200223.161527.1752185646569467874.davem@davemloft.net>
To:     dnlplm@gmail.com
Cc:     bjorn@mork.no, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: restore mtu min/max values
 after raw_ip switch
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200221131705.26053-1-dnlplm@gmail.com>
References: <20200221131705.26053-1-dnlplm@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 16:15:28 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniele Palmas <dnlplm@gmail.com>
Date: Fri, 21 Feb 2020 14:17:05 +0100

> usbnet creates network interfaces with min_mtu = 0 and
> max_mtu = ETH_MAX_MTU.
> 
> These values are not modified by qmi_wwan when the network interface
> is created initially, allowing, for example, to set mtu greater than 1500.
> 
> When a raw_ip switch is done (raw_ip set to 'Y', then set to 'N') the mtu
> values for the network interface are set through ether_setup, with
> min_mtu = ETH_MIN_MTU and max_mtu = ETH_DATA_LEN, not allowing anymore to
> set mtu greater than 1500 (error: mtu greater than device maximum).
> 
> The patch restores the original min/max mtu values set by usbnet after a
> raw_ip switch.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>

Applied and queued up for -stable.
