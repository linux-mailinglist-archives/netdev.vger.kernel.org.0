Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CA51372B
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 05:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbfEDDvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 23:51:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55514 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfEDDvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 23:51:10 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F7C214D6CFDF;
        Fri,  3 May 2019 20:51:01 -0700 (PDT)
Date:   Fri, 03 May 2019 23:50:57 -0400 (EDT)
Message-Id: <20190503.235057.2159507077297286948.davem@davemloft.net>
To:     haiyangz@microsoft.com
Cc:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH hyperv-fixes] hv_netvsc: fix race that may miss tx
 queue wakeup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1556652525-83155-1-git-send-email-haiyangz@microsoft.com>
References: <1556652525-83155-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 20:51:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Tue, 30 Apr 2019 19:29:07 +0000

> When the ring buffer is almost full due to RX completion messages, a
> TX packet may reach the "low watermark" and cause the queue stopped.
> If the TX completion arrives earlier than queue stopping, the wakeup
> may be missed.
> 
> This patch moves the check for the last pending packet to cover both
> EAGAIN and success cases, so the queue will be reliably waked up when
> necessary.
> 
> Reported-and-tested-by: Stephan Klein <stephan.klein@wegfinder.at>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Applied, thanks.
