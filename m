Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383678393B
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfHFTAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:00:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48260 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfHFTAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:00:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E37315248DA1;
        Tue,  6 Aug 2019 12:00:00 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:59:59 -0700 (PDT)
Message-Id: <20190806.115959.2238253749150631759.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        Tristram.Ha@microchip.com, vivien.didelot@gmail.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 3/3] net: dsa: ksz: Drop NET_DSA_TAG_KSZ9477
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806130609.29686-3-marex@denx.de>
References: <20190806130609.29686-1-marex@denx.de>
        <20190806130609.29686-3-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 12:00:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Tue,  6 Aug 2019 15:06:09 +0200

> This Kconfig option is unused, drop it.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Applied.
