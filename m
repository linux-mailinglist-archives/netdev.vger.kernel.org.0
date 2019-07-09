Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2C062EAB
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfGIDSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:18:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34366 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIDSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:18:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C9A5B1340AFCE;
        Mon,  8 Jul 2019 20:18:30 -0700 (PDT)
Date:   Mon, 08 Jul 2019 20:18:30 -0700 (PDT)
Message-Id: <20190708.201830.1677642444055911875.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net-next] sctp: remove rcu_read_lock from
 sctp_bind_addr_state
From:   David Miller <davem@davemloft.net>
In-Reply-To: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
References: <30ff9e8a45fa0c64d1c71bc13e217f3374f6120e.1562605180.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 20:18:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  9 Jul 2019 00:59:40 +0800

> sctp_bind_addr_state() is called either in packet rcv path or
> by sctp_copy_local_addr_list(), which are under rcu_read_lock.
> So there's no need to call it again in sctp_bind_addr_state().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

This is correct, patch applied.

Thanks.
