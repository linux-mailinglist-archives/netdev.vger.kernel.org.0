Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E34A6B3522
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 09:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfIPHJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 03:09:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44296 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfIPHJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 03:09:07 -0400
Received: from localhost (unknown [85.119.46.8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECE3F15163F1A;
        Mon, 16 Sep 2019 00:09:05 -0700 (PDT)
Date:   Mon, 16 Sep 2019 09:09:04 +0200 (CEST)
Message-Id: <20190916.090904.1028775758249846734.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, u9012063@gmail.com
Subject: Re: [PATCH net] ip6_gre: fix a dst leak in ip6erspan_tunnel_xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1bfbf329c5b3649a6c6362350a0d609ff184deba.1568367947.git.lucien.xin@gmail.com>
References: <1bfbf329c5b3649a6c6362350a0d609ff184deba.1568367947.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 00:09:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 13 Sep 2019 17:45:47 +0800

> In ip6erspan_tunnel_xmit(), if the skb will not be sent out, it has to
> be freed on the tx_err path. Otherwise when deleting a netns, it would
> cause dst/dev to leak, and dmesg shows:
> 
>   unregister_netdevice: waiting for lo to become free. Usage count = 1
> 
> Fixes: ef7baf5e083c ("ip6_gre: add ip6 erspan collect_md mode")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
