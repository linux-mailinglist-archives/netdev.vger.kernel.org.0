Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB312F4314
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbhAMEXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbhAMEXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 23:23:33 -0500
Received: from mail.nic.cz (lists.nic.cz [IPv6:2001:1488:800:400::400])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C3CC061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 20:22:52 -0800 (PST)
Received: from localhost (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id F0ED7140BBD;
        Wed, 13 Jan 2021 05:22:48 +0100 (CET)
Date:   Wed, 13 Jan 2021 05:22:48 +0100
From:   Marek Behun <marek.behun@nic.cz>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, pavana.sharma@digi.com
Subject: Re: mv88e6xxx: 2500base-x inband AN is broken on Amethyst? what to
 do?
Message-ID: <20210113052248.53f6032c@nic.cz>
In-Reply-To: <20210113011823.3e407b31@kernel.org>
References: <20210113011823.3e407b31@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems this problem can manifest somehow with Peridot as well, at
least when in combination with 88X3310 PHY.

I will do some more experiments and try to come up with a solution.

Marek
