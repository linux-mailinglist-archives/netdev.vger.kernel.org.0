Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B211D8C86
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 02:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgESAql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 20:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbgESAql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 20:46:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B3CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 17:46:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA94212736953;
        Mon, 18 May 2020 17:46:40 -0700 (PDT)
Date:   Mon, 18 May 2020 17:46:39 -0700 (PDT)
Message-Id: <20200518.174639.1344325582446445189.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: improve rtl8169_mark_to_asic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <25184433-dca6-f43f-ccc5-daf0ed0f17ee@gmail.com>
References: <25184433-dca6-f43f-ccc5-daf0ed0f17ee@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 18 May 2020 17:46:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 18 May 2020 22:22:09 +0200

> Let the compiler decide about inlining, and as confirmed by Eric it's
> better to use WRITE_ONCE here to ensure that the descriptor ownership
> is transferred to NIC immediately.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
