Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02911D8C85
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgESAqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:46:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0968C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:46:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 31EC112736953;
        Mon, 18 May 2020 17:46:35 -0700 (PDT)
Date:   Mon, 18 May 2020 17:46:34 -0700 (PDT)
Message-Id: <20200518.174634.34669169808287047.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: make rtl_rx better readable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <bfeb7228-7d03-f7b4-98ce-3671bfa42cc5@gmail.com>
References: <bfeb7228-7d03-f7b4-98ce-3671bfa42cc5@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:46:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 18 May 2020 22:14:21 +0200

> Avoid the goto from the rx error handling branch into the else branch,
> and in general avoid having the main rx work in the else branch.
> In addition ensure proper reverse xmas tree order of variables in the
> for loop.
> 
> No functional change intended.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
