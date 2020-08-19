Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A659224A9DA
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 01:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgHSXLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 19:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSXLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 19:11:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943A0C061757
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 16:11:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 599F411E4576D;
        Wed, 19 Aug 2020 15:54:31 -0700 (PDT)
Date:   Wed, 19 Aug 2020 16:11:16 -0700 (PDT)
Message-Id: <20200819.161116.1811427438684785488.davem@davemloft.net>
To:     kurt@linutronix.de
Cc:     richardcochran@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, jiri@mellanox.com,
        idosch@mellanox.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        grygorii.strashko@ti.com, zou_wei@huawei.com,
        netdev@vger.kernel.org, petrm@mellanox.com, bigeasy@linutronix.de
Subject: Re: [PATCH v4 0/9] ptp: Add generic helper functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Aug 2020 15:54:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>
Date: Tue, 18 Aug 2020 12:32:42 +0200

> in order to reduce code duplication (and cut'n'paste errors) in the ptp code of
> DSA, Ethernet and Phy drivers, create helper functions and move them to
> ptp_classify. This way all drivers can share the same implementation.
 ...

Series applied to net-next, thank you.
