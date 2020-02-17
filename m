Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C355160939
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 04:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgBQDtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 22:49:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:48462 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgBQDtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 22:49:03 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADF51157D8A42;
        Sun, 16 Feb 2020 19:49:02 -0800 (PST)
Date:   Sun, 16 Feb 2020 19:49:02 -0800 (PST)
Message-Id: <20200216.194902.108594610616498832.davem@davemloft.net>
To:     fthain@telegraphics.com.au
Cc:     tsbogend@alpha.franken.de, chris@zankel.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/7] Improvements for SONIC ethernet drivers
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1581800613.git.fthain@telegraphics.com.au>
References: <cover.1581800613.git.fthain@telegraphics.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Feb 2020 19:49:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Sun, 16 Feb 2020 08:03:32 +1100

> Now that the necessary sonic driver fixes have been merged, and the merge
> window has closed again, I'm sending the remainder of my sonic driver
> patch queue.
> 
> A couple of these patches will have to be applied in sequence to avoid
> 'git am' rejects. The others are independent and could have been submitted
> individually. Please let me know if I should do that.
> 
> The complete sonic driver patch queue was tested on National Semiconductor
> hardware (macsonic), qemu-system-m68k (macsonic) and qemu-system-mips64el
> (jazzsonic).

Series applied, thanks.
