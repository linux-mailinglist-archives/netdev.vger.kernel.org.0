Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54866198289
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgC3RlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:41:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40106 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727905AbgC3RlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:41:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B330915C1FF97;
        Mon, 30 Mar 2020 10:41:12 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:41:11 -0700 (PDT)
Message-Id: <20200330.104111.1774621700600873086.davem@davemloft.net>
To:     rohitm@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, borisp@mellanox.com,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] crypto/chcr: fix incorrect ipv6 packet length
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330161122.15314-1-rohitm@chelsio.com>
References: <20200330161122.15314-1-rohitm@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:41:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rohit Maheshwari <rohitm@chelsio.com>
Date: Mon, 30 Mar 2020 21:41:22 +0530

> IPv6 header's payload length field shouldn't include IPv6 header length.
> 
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Applied.
