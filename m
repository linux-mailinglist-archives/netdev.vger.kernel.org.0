Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244E712FDEC
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgACU2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:28:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbgACU2l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 15:28:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 654BB159768FD;
        Fri,  3 Jan 2020 12:28:40 -0800 (PST)
Date:   Fri, 03 Jan 2020 12:28:39 -0800 (PST)
Message-Id: <20200103.122839.1114563069156468082.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        brouer@redhat.com, lorenzo@kernel.org
Subject: Re: [PATCH] net: netsec: Change page pool nid to NUMA_NO_NODE
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200103114032.46444-1-ilias.apalodimas@linaro.org>
References: <20200103114032.46444-1-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 Jan 2020 12:28:40 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Fri,  3 Jan 2020 13:40:32 +0200

> The current driver only exists on a non NUMA aware machine.
> With 44768decb7c0 ("page_pool: handle page recycle for NUMA_NO_NODE condition")
> applied we can safely change that to NUMA_NO_NODE and accommodate future
> NUMA aware hardware using netsec network interface
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Applied, but please make it clear that this targets the net-next
tree in the future by stating "[PATCH net-next]" in your Subject
lines.

Thanks.
