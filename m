Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE32C39F0
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733184AbfJAQGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:06:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfJAQGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:06:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02A5B154925AE;
        Tue,  1 Oct 2019 09:06:51 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:06:51 -0700 (PDT)
Message-Id: <20191001.090651.796983023328992596.davem@davemloft.net>
To:     icenowy@aosc.io
Cc:     robh+dt@kernel.org, mark.rutland@arm.com, mripard@kernel.org,
        wens@csie.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 0/3] Pine64+ specific hacks for RTL8211E Ethernet PHY
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001082912.12905-1-icenowy@aosc.io>
References: <20191001082912.12905-1-icenowy@aosc.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:06:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>
Date: Tue,  1 Oct 2019 16:29:09 +0800

> There're some Pine64+ boards known to have broken RTL8211E chips, and
> a hack is given by Pine64+, which is said to be from Realtek.
> 
> This patchset adds the hack.
> 
> The hack is taken from U-Boot, and it contains magic numbers without
> any document.

Please contact Realtek and try to get an explanation about this.

I understand that eventually we may not get a proper explanation
but I really want you to put forth real effort to nail down whats
going on here before I even consider these patches seriously.

Thank you.
