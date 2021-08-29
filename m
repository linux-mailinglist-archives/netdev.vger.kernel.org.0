Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F023FAD5A
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 19:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhH2RCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 13:02:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51570 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229467AbhH2RCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 13:02:06 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id A8B7F4D0F3490;
        Sun, 29 Aug 2021 10:01:12 -0700 (PDT)
Date:   Sun, 29 Aug 2021 18:01:06 +0100 (BST)
Message-Id: <20210829.180106.1562823752050321630.davem@davemloft.net>
To:     jiwonaid0@gmail.com
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ipv6: add spaces for accept_ra_min_hop_limit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210829053544.51149-1-jiwonaid0@gmail.com>
References: <20210829053544.51149-1-jiwonaid0@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 29 Aug 2021 10:01:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jiwonaid0@gmail.com
Date: Sun, 29 Aug 2021 14:35:44 +0900

> From: Jiwon Kim <jiwonaid0@gmail.com>
> 
> The checkpatch reported
> ERROR: spaces required around that '=' (ctx:VxW)
> from the net/ipv6/addrconf.c.
> 
> So, spaces are added for accept_ra_min_hop_limit.
> 
> Signed-off-by: Jiwon Kim <jiwonaid0@gmail.com>

Please don't do this it breaks the vertical alignbment of the right hand side of
the assignments.

Thanks.

