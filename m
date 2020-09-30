Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3D27F4D6
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 00:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731339AbgI3WHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 18:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbgI3WHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 18:07:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D38C061755;
        Wed, 30 Sep 2020 15:07:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9554013C758EA;
        Wed, 30 Sep 2020 14:51:03 -0700 (PDT)
Date:   Wed, 30 Sep 2020 15:07:50 -0700 (PDT)
Message-Id: <20200930.150750.1169178954244266928.davem@davemloft.net>
To:     gakula@marvell.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com
Subject: Re: [net PATCH v2 0/4] Fix bugs in Octeontx2 netdev driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1601482090-14906-1-git-send-email-gakula@marvell.com>
References: <1601482090-14906-1-git-send-email-gakula@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 30 Sep 2020 14:51:03 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>
Date: Wed, 30 Sep 2020 21:38:10 +0530

> In existing Octeontx2 network drivers code has issues
> like stale entries in broadcast replication list, missing
> L3TYPE for IPv6 frames, running tx queues on error and 
> race condition in mbox reset.
> This patch set fixes the above issues.

What changed since v1?  Always specify that when you post a new
version of a patch series.

Anyways, series applied.
