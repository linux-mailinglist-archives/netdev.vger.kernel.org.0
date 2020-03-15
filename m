Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFCC1859CB
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgCODpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:45:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgCODpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:45:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B182215B7513F;
        Sat, 14 Mar 2020 20:45:11 -0700 (PDT)
Date:   Sat, 14 Mar 2020 20:45:11 -0700 (PDT)
Message-Id: <20200314.204511.1992785097435701096.davem@davemloft.net>
To:     shahjada@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: update T5/T6 adapter register ranges
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312114240.12862-1-shahjada@chelsio.com>
References: <20200312114240.12862-1-shahjada@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 20:45:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahjada Abul Husain <shahjada@chelsio.com>
Date: Thu, 12 Mar 2020 17:12:40 +0530

> Add more T5/T6 registers to be collected in register dump:
> 
> 1. MPS register range 0x9810 to 0x9864 and 0xd000 to 0xd004.
> 2. NCSI register range 0x1a114 to 0x1a130 and 0x1a138 to 0x1a1c4.
> 
> Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>

Applied to net-next, thanks.
