Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653901B164E
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 21:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgDTTys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 15:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725897AbgDTTyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 15:54:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5ACC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 12:54:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C14A6127FF359;
        Mon, 20 Apr 2020 12:54:46 -0700 (PDT)
Date:   Mon, 20 Apr 2020 12:54:46 -0700 (PDT)
Message-Id: <20200420.125446.1522818172593601877.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, manojmalviya@chelsio.com,
        nirranjan@chelsio.com, vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix large delays in PTP synchronization
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587376614-21111-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1587376614-21111-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 12:54:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Mon, 20 Apr 2020 15:26:54 +0530

> Fetching PTP sync information from mailbox is slow and can take
> up to 10 milliseconds. Reduce this unnecessary delay by directly
> reading the information from the corresponding registers.
> 
> Fixes: 9c33e4208bce ("cxgb4: Add PTP Hardware Clock (PHC) support")
> Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied, thank you.
