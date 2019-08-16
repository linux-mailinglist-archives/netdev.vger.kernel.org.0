Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE7090907
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbfHPT4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:56:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38826 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727542AbfHPT4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:56:03 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A21A913E2E200;
        Fri, 16 Aug 2019 12:56:02 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:55:59 -0700 (PDT)
Message-Id: <20190816.125559.209860777726370229.davem@davemloft.net>
To:     efremov@linux.com
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, joe@perches.com,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: PHY LIBRARY: Update files in the record
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190814125800.23729-1-efremov@linux.com>
References: <039d86b5-6897-0176-bf15-6f58e9d26b89@gmail.com>
        <20190814125800.23729-1-efremov@linux.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 Aug 2019 12:56:03 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>
Date: Wed, 14 Aug 2019 15:58:00 +0300

> Update MAINTAINERS to reflect that sysfs-bus-mdio was removed in
> commit a6cd0d2d493a ("Documentation: net-sysfs: Remove duplicate
> PHY device documentation") and sysfs-class-net-phydev was added in
> commit 86f22d04dfb5 ("net: sysfs: Document PHY device sysfs
> attributes").
> 
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>

Applied.
