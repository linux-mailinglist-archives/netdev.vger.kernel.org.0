Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 434E260DF0
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 00:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725990AbfGEWmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 18:42:01 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGEWmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 18:42:01 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0640C15042E88;
        Fri,  5 Jul 2019 15:42:00 -0700 (PDT)
Date:   Fri, 05 Jul 2019 15:42:00 -0700 (PDT)
Message-Id: <20190705.154200.2296684414980413863.davem@davemloft.net>
To:     ilias.apalodimas@linaro.org
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, arnd@arndb.de
Subject: Re: [PATCH] net: netsec: Sync dma for device on buffer allocation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562249469-14807-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562249469-14807-1-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jul 2019 15:42:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date: Thu,  4 Jul 2019 17:11:09 +0300

> Quoting Arnd,
> 
> We have to do a sync_single_for_device /somewhere/ before the
> buffer is given to the device. On a non-cache-coherent machine with
> a write-back cache, there may be dirty cache lines that get written back
> after the device DMA's data into it (e.g. from a previous memset
> from before the buffer got freed), so you absolutely need to flush any
> dirty cache lines on it first.
> 
> Since the coherency is configurable in this device make sure we cover
> all configurations by explicitly syncing the allocated buffer for the
> device before refilling it's descriptors
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Please make it explicit in your Subject lines which tree a patch is
for, in this case it should have been "[PATCH net-next] ".

Applied, thanks.
