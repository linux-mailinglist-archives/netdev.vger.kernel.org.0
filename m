Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93E7AC742
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 17:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394758AbfIGP1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 11:27:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46124 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389504AbfIGP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 11:27:22 -0400
Received: from localhost (unknown [88.214.184.0])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2579152EECB1;
        Sat,  7 Sep 2019 08:27:19 -0700 (PDT)
Date:   Sat, 07 Sep 2019 17:27:17 +0200 (CEST)
Message-Id: <20190907.172717.2255158302516232597.davem@davemloft.net>
To:     stefanc@marvell.com
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaulb@marvell.com,
        nadavh@marvell.com, ymarkman@marvell.com, marcin@marvell.com
Subject: Re: [PATCH] net: phylink: Fix flow control resolution
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567701978-16056-1-git-send-email-stefanc@marvell.com>
References: <1567701978-16056-1-git-send-email-stefanc@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 07 Sep 2019 08:27:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <stefanc@marvell.com>
Date: Thu, 5 Sep 2019 19:46:18 +0300

> From: Stefan Chulski <stefanc@marvell.com>
> 
> Regarding to IEEE 802.3-2015 standard section 2
> 28B.3 Priority resolution - Table 28-3 - Pause resolution
> 
> In case of Local device Pause=1 AsymDir=0, Link partner
> Pause=1 AsymDir=1, Local device resolution should be enable PAUSE
> transmit, disable PAUSE receive.
> And in case of Local device Pause=1 AsymDir=1, Link partner
> Pause=1 AsymDir=0, Local device resolution should be enable PAUSE
> receive, disable PAUSE transmit.
> 
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> Reported-by: Shaul Ben-Mayor <shaulb@marvell.com>

Applied and queued up for -stable, thanks.
