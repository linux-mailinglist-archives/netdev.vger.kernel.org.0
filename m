Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA9164E71
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgBSTGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:06:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbgBSTGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 14:06:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 867FA15ADF470;
        Wed, 19 Feb 2020 11:06:32 -0800 (PST)
Date:   Wed, 19 Feb 2020 11:06:32 -0800 (PST)
Message-Id: <20200219.110632.1849988114738882519.davem@davemloft.net>
To:     tzhao@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com
Subject: Re: [PATCH net-next] sfc: complete the next packet when we receive
 a timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <f84701f1-f54c-68fa-ef20-ccaabbf3beaf@solarflare.com>
References: <f84701f1-f54c-68fa-ef20-ccaabbf3beaf@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 11:06:32 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Zhao <tzhao@solarflare.com>
Date: Wed, 19 Feb 2020 14:08:37 +0000

> We now ignore the "completion" event when using tx queue timestamping, and only
> pay attention to the two (high and low) timestamp events. The NIC will send a
> pair of timestamp events for every packet transmitted. The current firmware may
> merge the completion events, and it is possible that future versions may
> reorder the completion and timestamp events. As such the completion event is
> not useful.
> 
> Without this patch in place a merged completion event on a queue with
> timestamping will cause a "spurious TX completion" error. This affects
> SFN8000-series adapters.
> 
> Signed-off-by: Tom Zhao <tzhao@solarflare.com>

This does not apply to net-next.
