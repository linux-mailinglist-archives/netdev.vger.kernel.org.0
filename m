Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2C9282787
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 02:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgJDAJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 20:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJDAJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 20:09:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5507C0613D0;
        Sat,  3 Oct 2020 17:09:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1805D11E3E4CA;
        Sat,  3 Oct 2020 16:52:28 -0700 (PDT)
Date:   Sat, 03 Oct 2020 17:09:14 -0700 (PDT)
Message-Id: <20201003.170914.694797784124863729.davem@davemloft.net>
To:     colin.king@canonical.com
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, kuba@kernel.org,
        dmurphy@ti.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] net: phy: dp83869: fix unsigned comparisons
 against less than zero values
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201002165422.94328-1-colin.king@canonical.com>
References: <20201002165422.94328-1-colin.king@canonical.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:52:28 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin King <colin.king@canonical.com>
Date: Fri,  2 Oct 2020 17:54:22 +0100

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the comparisons of u16 integers value and sopass_val with
> less than zero for error checking is always false because the values
> are unsigned. Fix this by making these variables int.  This does not
> affect the shift and mask operations performed on these variables
> 
> Addresses-Coverity: ("Unsigned compared against zero")
> Fixes: 49fc23018ec6 ("net: phy: dp83869: support Wake on LAN")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Applied, thank you.
