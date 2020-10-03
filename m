Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D2128276D
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 01:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgJCXpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 19:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgJCXpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 19:45:45 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A245FC0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 16:45:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DB2B11E3E4C6;
        Sat,  3 Oct 2020 16:28:57 -0700 (PDT)
Date:   Sat, 03 Oct 2020 16:45:43 -0700 (PDT)
Message-Id: <20201003.164543.520245983830924281.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove NETDEV_HW_ADDR_T_SLAVE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201001171250.10727-1-ap420073@gmail.com>
References: <20201001171250.10727-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 16:28:57 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  1 Oct 2020 17:12:50 +0000

> NETDEV_HW_ADDR_T_SLAVE is not used anymore, remove it.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Looks like this was never used at all.

Applied, thank you.
