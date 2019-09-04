Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB51EA9651
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfIDWZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:25:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729919AbfIDWZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:25:35 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D735B15285FEA;
        Wed,  4 Sep 2019 15:25:33 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:25:32 -0700 (PDT)
Message-Id: <20190904.152532.1998977195554205249.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, hdanton@sina.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix misplaced traceline
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156742044878.3320.3639294965607016931.stgit@warthog.procyon.org.uk>
References: <156742044878.3320.3639294965607016931.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:25:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Mon, 02 Sep 2019 11:34:08 +0100

> There's a misplaced traceline in rxrpc_input_packet() which is looking at a
> packet that just got released rather than the replacement packet.
> 
> Fix this by moving the traceline after the assignment that moves the new
> packet pointer to the actual packet pointer.
> 
> Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
> Reported-by: Hillf Danton <hdanton@sina.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
