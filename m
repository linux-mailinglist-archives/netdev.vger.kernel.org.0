Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0114A1238A5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbfLQV0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:26:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43116 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfLQV0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 16:26:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B6951444AE3B;
        Tue, 17 Dec 2019 13:26:53 -0800 (PST)
Date:   Tue, 17 Dec 2019 13:26:52 -0800 (PST)
Message-Id: <20191217.132652.1833779697594449151.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        antoine.tenart@bootlin.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] improve clause 45 support in phylink
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191213175415.GW25745@shell.armlinux.org.uk>
References: <20191213175415.GW25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 13:26:53 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 13 Dec 2019 17:54:15 +0000

> These three patches improve the clause 45 support in phylink, fixing
> some corner cases that have been noticed with the addition of SFP+
> NBASE-T modules, but are actually a little more wisespread than I
> initially realised.
 ...

Series applied, thank you.
