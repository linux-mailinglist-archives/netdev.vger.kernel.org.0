Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 569001E1902
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 03:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgEZBVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 21:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbgEZBVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 21:21:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C97BC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 18:21:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F08A127AB6EF;
        Mon, 25 May 2020 18:21:42 -0700 (PDT)
Date:   Mon, 25 May 2020 18:21:41 -0700 (PDT)
Message-Id: <20200525.182141.1672116492083203366.davem@davemloft.net>
To:     hkallweit1@gmail.com
Cc:     nic_swsd@realtek.com, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8169: sync hw config for few chip
 versions with r8168 vendor driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
References: <e9898548-158a-12d5-4c1a-efe8cfbe3416@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 18:21:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>
Date: Mon, 25 May 2020 19:48:16 +0200

> Sync hw config for few chip versions with r8168 vendor driver.

Series applied, thanks.
