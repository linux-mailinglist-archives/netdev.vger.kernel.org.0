Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1F3253153
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgHZOaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgHZOaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:30:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDDFC061574;
        Wed, 26 Aug 2020 07:30:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB4F713588515;
        Wed, 26 Aug 2020 07:13:13 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:29:59 -0700 (PDT)
Message-Id: <20200826.072959.850785662944644538.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     kuba@kernel.org, masahiroy@kernel.org, bjorn@mork.no,
        miguel@det.uvigo.gal, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: cdc_ncm: Fix build error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826065231.14344-1-yuehaibing@huawei.com>
References: <20200826065231.14344-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 07:13:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Wed, 26 Aug 2020 14:52:31 +0800

> If USB_NET_CDC_NCM is y and USB_NET_CDCETHER is m, build fails:
> 
> drivers/net/usb/cdc_ncm.o:(.rodata+0x1d8): undefined reference to `usbnet_cdc_update_filter'
> 
> Select USB_NET_CDCETHER for USB_NET_CDC_NCM to fix this.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast traffic")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied, thank you.
