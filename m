Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0093BB0D11
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfILKjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:39:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730023AbfILKjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:39:41 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91EC5126655B3;
        Thu, 12 Sep 2019 03:39:39 -0700 (PDT)
Date:   Thu, 12 Sep 2019 12:39:38 +0200 (CEST)
Message-Id: <20190912.123938.494358183342867915.davem@davemloft.net>
To:     george.mccollister@gmail.com
Cc:     netdev@vger.kernel.org, woojung.huh@microchip.com, andrew@lunn.ch,
        f.fainelli@gmail.com, Tristram.Ha@microchip.com, marex@denx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/3] add ksz9567 with I2C support to
 ksz9477 driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190910131836.114058-1-george.mccollister@gmail.com>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 03:39:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George McCollister <george.mccollister@gmail.com>
Date: Tue, 10 Sep 2019 08:18:33 -0500

> Resurrect KSZ9477 I2C driver support patch originally sent to the list
> by Tristram Ha and resolve outstanding issues. It now works as similarly to
> the ksz9477 SPI driver as possible, using the same regmap macros.
> 
> Add support for ksz9567 to the ksz9477 driver (tested on a board with
> ksz9567 connected via I2C).
> 
> Remove NET_DSA_TAG_KSZ_COMMON since it's not needed.
> 
> Changes since v1:
> Put ksz9477_i2c.c includes in alphabetical order.
> Added Reviewed-Bys.

Series applied.

Please follow up with Andrew about the macros.

Thanks.
