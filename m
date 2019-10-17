Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA16DB7A8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 21:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437228AbfJQTi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 15:38:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41154 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437028AbfJQTi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 15:38:59 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 632F514047CE5;
        Thu, 17 Oct 2019 12:38:58 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:38:57 -0400 (EDT)
Message-Id: <20191017.153857.349274938053327657.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH net V3 1/2] net: dsa: microchip: Do not reinit mutexes
 on KSZ87xx
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191016133324.10451-1-marex@denx.de>
References: <20191016133324.10451-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 12:38:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Wed, 16 Oct 2019 15:33:23 +0200

> The KSZ87xx driver calls mutex_init() on mutexes already inited in
> ksz_common.c ksz_switch_register(). Do not do it twice, drop the
> reinitialization.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
