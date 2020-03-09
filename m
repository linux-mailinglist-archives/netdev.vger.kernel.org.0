Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6B0217E563
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbgCIRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:10:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58788 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbgCIRKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:10:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79B151591360F;
        Mon,  9 Mar 2020 10:10:09 -0700 (PDT)
Date:   Mon, 09 Mar 2020 10:10:08 -0700 (PDT)
Message-Id: <20200309.101008.1933325639100013092.davem@davemloft.net>
To:     tsbogend@alpha.franken.de
Cc:     ralf@linux-mips.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sgi: ioc3-eth: Remove phy workaround
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200309123240.15035-1-tsbogend@alpha.franken.de>
References: <20200309123240.15035-1-tsbogend@alpha.franken.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 10:10:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Mon,  9 Mar 2020 13:32:40 +0100

> Commit a8d0f11ee50d ("MIPS: SGI-IP27: Enable ethernet phy on second
> Origin 200 module") fixes the root cause of not detected PHYs.
> Therefore the workaround can go away now.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Applied, thank you.
