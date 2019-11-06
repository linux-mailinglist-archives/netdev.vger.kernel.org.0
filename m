Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DB7F1D7C
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 19:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfKFSZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 13:25:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfKFSZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 13:25:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8A9C41537CE8F;
        Wed,  6 Nov 2019 10:25:31 -0800 (PST)
Date:   Wed, 06 Nov 2019 10:25:31 -0800 (PST)
Message-Id: <20191106.102531.2219621861695403144.davem@davemloft.net>
To:     claudiu.manoil@nxp.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] gianfar: Maximize Rx buffer size
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1572977901-31431-1-git-send-email-claudiu.manoil@nxp.com>
References: <1572977901-31431-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 10:25:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>
Date: Tue,  5 Nov 2019 20:18:21 +0200

> Until now the size of a Rx buffer was artificially limited
> to 1536B (which happens to be the default, after reset, hardware
> value for a Rx buffer). This approach however leaves unused
> memory space for Rx packets, since the driver uses a paged
> allocation scheme that reserves half a page for each Rx skb.
> There's also the inconvenience that frames around 1536 bytes
> can get scattered if the limit is slightly exceeded. This limit
> can be exceeded even for standard MTU of 1500B traffic, for common
> cases like stacked VLANs, or DSA tags.
> To address these issues, let's just compute the buffer size
> starting from the upper limit of 2KB (half a page) and
> subtract the skb overhead and alignment restrictions.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Applied, thanks.
