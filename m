Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12F3280C3B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 04:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbgJBCJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 22:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727780AbgJBCJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 22:09:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92913C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 19:09:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81331128747D7;
        Thu,  1 Oct 2020 18:52:21 -0700 (PDT)
Date:   Thu, 01 Oct 2020 19:09:08 -0700 (PDT)
Message-Id: <20201001.190908.1043805980010515960.davem@davemloft.net>
To:     W_Armin@gmx.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] lib8390: Use netif_msg_init to initialize
 msg_enable bits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200930210016.11607-1-W_Armin@gmx.de>
References: <20200930210016.11607-1-W_Armin@gmx.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:52:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>
Date: Wed, 30 Sep 2020 23:00:16 +0200

> Use netif_msg_init() to process param settings
> and use only the proper initialized value of
> ei_local->msg_enable for later processing;
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> ---
> v2 changes:
> - confused ei_local-> msg_enable with default_msg_level

Applied.
