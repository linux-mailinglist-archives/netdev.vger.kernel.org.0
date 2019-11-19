Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0E102DD9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfKSVBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:01:15 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:44684 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSVBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 16:01:15 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6A83F14051726;
        Tue, 19 Nov 2019 13:01:14 -0800 (PST)
Date:   Tue, 19 Nov 2019 13:01:10 -0800 (PST)
Message-Id: <20191119.130110.640413441507997216.davem@davemloft.net>
To:     adisuresh@google.com
Cc:     netdev@vger.kernel.org, csully@google.com
Subject: Re: [PATCH net v4] gve: fix dma sync bug where not all pages synced
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191119160247.29158-1-adisuresh@google.com>
References: <20191119160247.29158-1-adisuresh@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 19 Nov 2019 13:01:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Adi Suresh <adisuresh@google.com>
Date: Tue, 19 Nov 2019 08:02:47 -0800

> The previous commit had a bug where the last page in the memory range
> could not be synced. This change fixes the behavior so that all the
> required pages are synced.
> 
> Fixes: 9cfeeb576d49 ("gve: Fixes DMA synchronization")
> Signed-off-by: Adi Suresh <adisuresh@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>
> ---
>  Addressed in v4:
>  - Used correct 12 digits of hash of commit in Fixes tag

Applied.
