Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07E841904BE
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 06:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgCXFA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 01:00:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgCXFA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 01:00:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B37DD157D9019;
        Mon, 23 Mar 2020 22:00:27 -0700 (PDT)
Date:   Mon, 23 Mar 2020 22:00:26 -0700 (PDT)
Message-Id: <20200323.220026.1402203457473336218.davem@davemloft.net>
To:     zhengdejin5@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, corbet@lwn.net, tglx@linutronix.de,
        gregkh@linuxfoundation.org, allison@lohutok.net,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v7 00/10] introduce read_poll_timeout
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200323150600.21382-1-zhengdejin5@gmail.com>
References: <20200323150600.21382-1-zhengdejin5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 22:00:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>
Date: Mon, 23 Mar 2020 23:05:50 +0800

> This patch sets is introduce read_poll_timeout macro, it is an extension
> of readx_poll_timeout macro. the accessor function op just supports only
> one parameter in the readx_poll_timeout macro, but this macro can
> supports multiple variable parameters for it. so functions like
> phy_read(struct phy_device *phydev, u32 regnum) and
> phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
> use this poll timeout framework.
> 
> the first patch introduce read_poll_timeout macro, and the second patch
> redefined readx_poll_timeout macro by read_poll_timeout(), and the other
> patches are examples using read_poll_timeout macro.
 ...

Series applied, thanks.
