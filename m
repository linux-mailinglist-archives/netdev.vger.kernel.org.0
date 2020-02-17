Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 798B0160926
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgBQDo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:44:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:44:59 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 923E8157D1C8C;
        Sun, 16 Feb 2020 19:44:58 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:44:58 -0800 (PST)
Message-Id: <20200216.194458.176458314325918369.davem@davemloft.net>
To:     sergei.shtylyov@cogentembedded.com
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] sh_eth: get rid of the dedicated
 regiseter mapping for RZ/A1 (R7S72100)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:44:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Sat, 15 Feb 2020 23:06:27 +0300

> Here's a set of 5 patches against DaveM's 'net-next.git' repo.
> 
> I changed my mind about the RZ/A1 SoC needing its own register
> map -- now that we don't depend on the register map array in order
> to determine whether a given register exists any more, we can add
> a new flag to determine if the GECMR exists (this register is
> present only on true GEther chips, not RZ/A1). We also need to
> add the sh_eth_cpu_data::* flag checks where they were missing
> so far: in the ethtool API for the register dump.

Series applied, thanks Sergei.
