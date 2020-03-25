Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15691930DF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgCYTHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:07:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgCYTHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:07:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AB9BD15A07398;
        Wed, 25 Mar 2020 12:07:37 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:07:36 -0700 (PDT)
Message-Id: <20200325.120736.1056190737805711257.davem@davemloft.net>
To:     jwi@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net-next 00/11] s390/qeth: updates 2020-03-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200325093507.20831-1-jwi@linux.ibm.com>
References: <20200325093507.20831-1-jwi@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Mar 2020 12:07:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>
Date: Wed, 25 Mar 2020 10:34:56 +0100

> please apply the following patch series for qeth to netdev's net-next
> tree.
> Same series as yesterday, with one minor update to patch 1 as per
> your review.
> 
> This adds
> 1) NAPI poll support for the async-Completion Queue (with one qdio layer
>    patch acked by Heiko),
> 2) ethtool support for per-queue TX IRQ coalescing,
> 3) various cleanups.

Series applied, thank you.
