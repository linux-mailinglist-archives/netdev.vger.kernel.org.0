Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B894719829E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgC3Roa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:44:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40152 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgC3Ro3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:44:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FE2415C27CD6;
        Mon, 30 Mar 2020 10:44:29 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:44:28 -0700 (PDT)
Message-Id: <20200330.104428.1656908023932174885.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, borisp@mellanox.com,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] crypto/chtls: Fix chtls crash in connection
 cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330165555.17521-1-rohitm@chelsio.com>
References: <20200330165555.17521-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:44:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Mon, 30 Mar 2020 22:25:55 +0530

> There is a possibility that cdev is removed before CPL_ABORT_REQ_RSS
> is fully processed, so it's better to save it in skb.
> 
> Added checks in handling the flow correctly, which suggests connection reset
> request is sent to HW, wait for HW to respond.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied, thanks.
