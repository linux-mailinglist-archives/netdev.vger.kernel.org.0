Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C27C910A5DB
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfKZVQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 16:16:59 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42378 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:16:58 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4AFF14CE21C8;
        Tue, 26 Nov 2019 13:16:57 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:16:54 -0800 (PST)
Message-Id: <20191126.131654.606125577060239139.davem@davemloft.net>
To:     axboe@kernel.dk
Cc:     johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: iwlwifi broken in current -git
From:   David Miller <davem@davemloft.net>
In-Reply-To: <49461e53-e2fe-8a7a-47a3-7de966cb1298@kernel.dk>
References: <49461e53-e2fe-8a7a-47a3-7de966cb1298@kernel.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 13:16:58 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 26 Nov 2019 14:04:01 -0700

> Just upgraded my laptop, and iwlwifi won't connect. Not specific to
> the AP, tried a few and no go. Here are the dmesg from loading and
> trying to connect, at some point it just gives up and asks me for
> a password again. v5.4 works just fine.

We know and are working on a fix, the iwlwifi driver does NAPI
completions improperly.

You can set /proc/sys/net/core/gro_normal_batch to '1' as a
temporary workaround.
