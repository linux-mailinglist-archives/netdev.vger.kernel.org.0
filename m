Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBF71F4E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391500AbfGWS34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 14:29:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391499AbfGWS34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 14:29:56 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6C106153B8315;
        Tue, 23 Jul 2019 11:29:55 -0700 (PDT)
Date:   Tue, 23 Jul 2019 11:29:55 -0700 (PDT)
Message-Id: <20190723.112955.880912015924847401.davem@davemloft.net>
To:     bpoirier@suse.com
Cc:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qlge: Move drivers/net/ethernet/qlogic/qlge/
 to drivers/staging/qlge/
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190723061413.10342-1-bpoirier@suse.com>
References: <20190723061413.10342-1-bpoirier@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 11:29:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.com>
Date: Tue, 23 Jul 2019 15:14:13 +0900

> The hardware has been declared EOL by the vendor more than 5 years ago.
> What's more relevant to the Linux kernel is that the quality of this driver
> is not on par with many other mainline drivers.
> 
> Cc: Manish Chopra <manishc@marvell.com>
> Message-id: <20190617074858.32467-1-bpoirier@suse.com>
> Signed-off-by: Benjamin Poirier <bpoirier@suse.com>

Applied, thank you.
