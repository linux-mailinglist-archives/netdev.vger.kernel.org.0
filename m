Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540021BA93
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbfEMQFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:05:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39162 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730565AbfEMQFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:05:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C4F614E14FF4;
        Mon, 13 May 2019 09:04:59 -0700 (PDT)
Date:   Mon, 13 May 2019 09:04:58 -0700 (PDT)
Message-Id: <20190513.090458.111530651468733326.davem@davemloft.net>
To:     tbogendoerfer@suse.de
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: seeq: fix crash caused by not set dev.parent
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513111517.14780-1-tbogendoerfer@suse.de>
References: <20190513111517.14780-1-tbogendoerfer@suse.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:04:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Date: Mon, 13 May 2019 13:15:17 +0200

> The old MIPS implementation of dma_cache_sync() didn't use the dev argument,
> but commit c9eb6172c328 ("dma-mapping: turn dma_cache_sync into a
> dma_map_ops method") changed that, so we now need to set dev.parent.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

Applied and queued up for -stable.
