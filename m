Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6F1E3682
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbgE0D1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgE0D1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:27:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A73DC061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:27:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CDB612793AA3;
        Tue, 26 May 2020 20:27:41 -0700 (PDT)
Date:   Tue, 26 May 2020 20:27:40 -0700 (PDT)
Message-Id: <20200526.202740.2245046715300329611.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve rtl_remove_one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <13536518-bb67-795a-e385-fe34deec78d1@gmail.com>
References: <13536518-bb67-795a-e385-fe34deec78d1@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 20:27:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 25 May 2020 21:54:00 +0200

> Don't call netif_napi_del() manually, free_netdev() does this for us.
> In addition reorder calls to match reverse order of calls in probe().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks Heiner.
