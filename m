Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1D682A766
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 01:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfEYXie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 19:38:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbfEYXid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 19:38:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B1CE01500AE50;
        Sat, 25 May 2019 16:38:32 -0700 (PDT)
Date:   Sat, 25 May 2019 16:38:32 -0700 (PDT)
Message-Id: <20190525.163832.291723821050525240.davem@davemloft.net>
To:     maxime.chevallier@bootlin.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 0/5] net: mvpp2: Classifier updates, RSS
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
References: <20190524100554.8606-1-maxime.chevallier@bootlin.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 May 2019 16:38:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxime Chevallier <maxime.chevallier@bootlin.com>
Date: Fri, 24 May 2019 12:05:49 +0200

> Here is a set of updates for the PPv2 classifier, the main feature being
> the support for steering to RSS contexts, to leverage all the available
> RSS tables in the controller.
> 
> The first two patches are non-critical fixes for the classifier, the
> first one prevents us from allocating too much room to store the
> classification rules, the second one configuring the C2 engine as
> suggested by the PPv2 functionnal specs.
> 
> Patches 3 to 5 introduce support for RSS contexts in mvpp2, allowing us
> to steer traffic to dedicated RSS tables.

Series applied, thanks.
