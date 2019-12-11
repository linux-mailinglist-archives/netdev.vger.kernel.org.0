Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18B911BD83
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbfLKTyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:54:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59608 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfLKTyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:54:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DA55E1427577F;
        Wed, 11 Dec 2019 11:54:00 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:53:58 -0800 (PST)
Message-Id: <20191211.115358.2204523813741070393.davem@davemloft.net>
To:     linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 00/14] Add support for SFP+ copper modules
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Dec 2019 11:54:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Date: Wed, 11 Dec 2019 10:48:21 +0000

> This series adds support for Copper SFP+ modules with Clause 45 PHYs.
> Specifically the patches:
 ...

Series applied, thank you.
