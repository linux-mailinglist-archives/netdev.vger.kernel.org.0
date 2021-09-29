Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60C941BBB0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 02:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243398AbhI2A1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 20:27:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240715AbhI2A1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 20:27:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 244F9613BD;
        Wed, 29 Sep 2021 00:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632875120;
        bh=9xO1Lgz8aGSr/dLS5UkdR6O5RIo51DBSNABm9wa8Crc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fl0m/53FqPv/ncD/MWllwlr2GKa67geouY5B05rE8gSptBroQ1o3UoLBl9kKScdZH
         AmDZAiNN5+g91POnsVD9F1EZp2AMQxrMcr8sFCqe133BKbN8EwblZtyEwKzMUh5i3t
         2+hcGBcKvkSxPR81S+bRmwG9Ui2xhacolipx2HziV94g26uMz7/j7KrfBZ3/tKyBZ2
         XrLxTQQ2mz6h3hUvv0lpIiW7yZT9UvwDdaLsnWQp5VzmtBP6oWQ0s6GObwLjBoo7Kv
         8UjGFWy+vE9aKYRCTmHL5pVRj7uI/fQrDKKYgjLe8kp2hkvUnEMm/AAt8zF1BGT93f
         etowKjob5VYOg==
Date:   Tue, 28 Sep 2021 17:25:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6 v8] RTL8366(RB) cleanups part 1
Message-ID: <20210928172519.4655ec60@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210928144149.84612-1-linus.walleij@linaro.org>
References: <20210928144149.84612-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Sep 2021 16:41:43 +0200 Linus Walleij wrote:
> This is a first set of patches making the RTL8366RB work out of
> the box with a default OpenWrt userspace.
> 
> We achieve bridge port isolation with the first patch, and the
> next 5 patches removes the very weird VLAN set-up with one
> VLAN with PVID per port that has been in this driver in all
> vendor trees and in OpenWrt for years.
> 
> The switch is now managed the way a modern bridge/DSA switch
> shall be managed.
> 
> After these patches are merged, I will send the next set which
> adds new features, some which have circulated before.

Looks like v7 got silently applied. Would you mind converting 
to incremental fixups?
