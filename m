Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD38EF2D5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 02:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbfKEBc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 20:32:29 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728987AbfKEBc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 20:32:29 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF3DC15252E0F;
        Mon,  4 Nov 2019 17:32:28 -0800 (PST)
Date:   Mon, 04 Nov 2019 17:32:26 -0800 (PST)
Message-Id: <20191104.173226.388214102826562799.davem@davemloft.net>
To:     fugang.duan@nxp.com
Cc:     hslester96@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [EXT] Re: [PATCH] net: fec: add missed clk_disable_unprepare
 in remove
From:   David Miller <davem@davemloft.net>
In-Reply-To: <VI1PR0402MB360095D673E33032706C5BEAFF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20191104155000.8993-1-hslester96@gmail.com>
        <20191104.113601.407489006150341765.davem@davemloft.net>
        <VI1PR0402MB360095D673E33032706C5BEAFF7E0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 04 Nov 2019 17:32:29 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Duan <fugang.duan@nxp.com>
Date: Tue, 5 Nov 2019 01:27:10 +0000

> From: David Miller <davem@davemloft.net> Sent: Tuesday, November 5, 2019 3:36 AM
>> From: Chuhong Yuan <hslester96@gmail.com>
>> Date: Mon,  4 Nov 2019 23:50:00 +0800
>> 
>> > This driver forgets to disable and unprepare clks when remove.
>> > Add calls to clk_disable_unprepare to fix it.
>> >
>> > Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
>> 
>> Applied.
> 
> David, the patch introduces clock count mismatch issue, please drop it.

Please send me a revert, I'm backlogged at the moment.

Thanks.
