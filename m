Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDDC228C8A
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgGUXNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:13:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B21C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:13:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6E19C11E45906;
        Tue, 21 Jul 2020 15:56:57 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:13:41 -0700 (PDT)
Message-Id: <20200721.161341.802141980753263374.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] r8169: allow to enable ASPM on RTL8125A
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9b112086-5a2a-efad-42a8-7236a8172a7b@gmail.com>
References: <9b112086-5a2a-efad-42a8-7236a8172a7b@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:56:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Tue, 21 Jul 2020 18:22:24 +0200

> For most chip versions this has been added already. Allow also for
> RTL8125A to enable ASPM.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied.
