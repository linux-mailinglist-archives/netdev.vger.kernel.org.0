Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4175137C25
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 08:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgAKHdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 02:33:25 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44320 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbgAKHdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 02:33:24 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E971159A8856;
        Fri, 10 Jan 2020 23:33:23 -0800 (PST)
Date:   Fri, 10 Jan 2020 23:33:22 -0800 (PST)
Message-Id: <20200110.233322.196190530597547272.davem@davemloft.net>
To:     dmurphy@ti.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH netdev v2 0/2] DP83822 and DP83TC811 Fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200110200357.26232-1-dmurphy@ti.com>
References: <20200110200357.26232-1-dmurphy@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 23:33:23 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>
Date: Fri, 10 Jan 2020 14:03:55 -0600

> Two fixes on net/phy/Kconfig for the TI ethernet PHYs.
> First fixed the typo in the Kconfig for the DP83TC811 where it incorretly stated
> that the support was for a DP83TC822 which does not exist.
> 
> Second fix was to update the DP83822 Kconfig entry to indicate support for the
> DP83825 devices in the description and the prompt.

Series applied, thanks.
