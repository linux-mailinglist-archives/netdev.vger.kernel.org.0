Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B3121BF39
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGJV34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgGJV34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 17:29:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852F1C08C5DC;
        Fri, 10 Jul 2020 14:29:56 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9CC9F12868181;
        Fri, 10 Jul 2020 14:29:55 -0700 (PDT)
Date:   Fri, 10 Jul 2020 14:29:54 -0700 (PDT)
Message-Id: <20200710.142954.2054912040852837453.davem@davemloft.net>
To:     nicolas.ferre@microchip.com
Cc:     linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, claudiu.beznea@microchip.com,
        harini.katakam@xilinx.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH v5 0/5] net: macb: Wake-on-Lan magic packet fixes and
 GEM handling
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1594384335.git.nicolas.ferre@microchip.com>
References: <cover.1594384335.git.nicolas.ferre@microchip.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jul 2020 14:29:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <nicolas.ferre@microchip.com>
Date: Fri, 10 Jul 2020 14:46:40 +0200

> Here is a split series to fix WoL magic-packet on the current macb driver. Only
> fixes in this one based on current net/master.

Series applied, thank you.
