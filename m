Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A816101064
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfKSA4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:56:55 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51878 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbfKSA4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:56:55 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 52067150F7665;
        Mon, 18 Nov 2019 16:56:54 -0800 (PST)
Date:   Mon, 18 Nov 2019 16:56:53 -0800 (PST)
Message-Id: <20191118.165653.2293854488302688486.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] Add support for SFPs behind PHYs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191115195339.GR25745@shell.armlinux.org.uk>
References: <20191115195339.GR25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 Nov 2019 16:56:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Fri, 15 Nov 2019 19:53:39 +0000

> This series adds partial support for SFP cages connected to PHYs,
> specifically optical SFPs.
> 
> We add core infrastructure to phylib for this, and arrange for
> minimal code in the PHY driver - currently, this is code to verify
> that the module is one that we can support for Marvell 10G PHYs.
> 
> v2: add yaml binding patch

I've applied this series to net-next.

Andrew, if you still have concerns about capability detection etc.
please keep following up in this patch #3 thread.

Thanks.
