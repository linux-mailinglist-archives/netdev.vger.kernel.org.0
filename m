Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76818AE52F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 10:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbfIJINb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 04:13:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53090 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730510AbfIJINb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 04:13:31 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E5AD8154B1F3B;
        Tue, 10 Sep 2019 01:13:29 -0700 (PDT)
Date:   Tue, 10 Sep 2019 10:13:28 +0200 (CEST)
Message-Id: <20190910.101328.1956638594556147157.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com
Subject: Re: [PATCH net v2] bridge/mdb: remove wrong use of NLM_F_MULTI
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906094703.21300-1-nicolas.dichtel@6wind.com>
References: <20190906094703.21300-1-nicolas.dichtel@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Sep 2019 01:13:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Fri,  6 Sep 2019 11:47:02 +0200

> NLM_F_MULTI must be used only when a NLMSG_DONE message is sent at the end.
> In fact, NLMSG_DONE is sent only at the end of a dump.
> 
> Libraries like libnl will wait forever for NLMSG_DONE.
> 
> Fixes: 949f1e39a617 ("bridge: mdb: notify on router port add and del")
> CC: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Applied and queued up for -stable.
