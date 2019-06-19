Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2008B4AF49
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 03:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729641AbfFSBEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 21:04:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56056 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbfFSBEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 21:04:47 -0400
Received: from localhost (unknown [8.46.76.24])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3F42914B8D0C6;
        Tue, 18 Jun 2019 18:04:34 -0700 (PDT)
Date:   Tue, 18 Jun 2019 21:04:30 -0400 (EDT)
Message-Id: <20190618.210430.1199248693691754077.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: add sanity check to
 device_property_read_u32_array call
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190617165836.4673-1-colin.king@canonical.com>
References: <20190617165836.4673-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Jun 2019 18:04:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Mon, 17 Jun 2019 17:58:36 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the call to device_property_read_u32_array is not error checked
> leading to potential garbage values in the delays array that are then used
> in msleep delays.  Add a sanity check to the property fetching.
> 
> Addresses-Coverity: ("Uninitialized scalar variable")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied to net-next, thanks Colin.

Please make the destination tree explicit in the future by putting
something like "[PATCH net-next]" in the Subject line.

Thank you.
