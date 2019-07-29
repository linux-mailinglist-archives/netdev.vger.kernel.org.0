Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3605792B5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 19:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfG2R5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 13:57:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:36792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfG2R5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 13:57:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6124B14015B10;
        Mon, 29 Jul 2019 10:57:32 -0700 (PDT)
Date:   Mon, 29 Jul 2019 10:57:31 -0700 (PDT)
Message-Id: <20190729.105731.2008954478313187190.davem@davemloft.net>
To:     martin.blumenstingl@googlemail.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH] net: stmmac: manage errors returned by
 of_get_mac_address()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190727192137.27881-1-martin.blumenstingl@googlemail.com>
References: <20190727192137.27881-1-martin.blumenstingl@googlemail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 10:57:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Sat, 27 Jul 2019 21:21:37 +0200

> Commit d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> added support for reading the MAC address from an nvmem-cell. This
> required changing the logic to return an error pointer upon failure.
> 
> If stmmac is loaded before the nvmem provider driver then
> of_get_mac_address() return an error pointer with -EPROBE_DEFER.
> 
> Propagate this error so the stmmac driver will be probed again after the
> nvmem provider driver is loaded.
> Default to a random generated MAC address in case of any other error,
> instead of using the error pointer as MAC address.
> 
> Fixes: d01f449c008a ("of_net: add NVMEM support to of_get_mac_address")
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Applied, thanks.
