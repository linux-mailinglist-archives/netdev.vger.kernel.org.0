Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71EFE24E97A
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 21:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgHVTo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 15:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728676AbgHVTo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 15:44:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56629C061573
        for <netdev@vger.kernel.org>; Sat, 22 Aug 2020 12:44:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A75B915D0BF6E;
        Sat, 22 Aug 2020 12:28:10 -0700 (PDT)
Date:   Sat, 22 Aug 2020 12:44:55 -0700 (PDT)
Message-Id: <20200822.124455.289087014160802389.davem@davemloft.net>
To:     tparkin@katalix.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net-next v2 0/9] l2tp: replace custom logging code with
 tracepoints
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200822145909.6381-1-tparkin@katalix.com>
References: <20200822145909.6381-1-tparkin@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 22 Aug 2020 12:28:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Parkin <tparkin@katalix.com>
Date: Sat, 22 Aug 2020 15:59:00 +0100

> The l2tp subsystem implemented custom logging macros for debugging
> purposes which were controlled using a set of debugging flags in each
> tunnel and session structure.
> 
> A more standard and easier-to-use approach is to use tracepoints.
> 
> This patchset refactors l2tp to:
> 
>  * remove excessive logging
>  * tweak useful log messages to use the standard pr_* calls for logging
>    rather than the l2tp wrappers
>  * replace debug-level logging with tracepoints
>  * add tracepoints for capturing tunnel and session lifetime events
> 
> I note that checkpatch.pl warns about the layout of code in the
> newly-added file net/l2tp/trace.h.  When adding this file I followed the
> example(s) of other tracepoint files in the net/ subtree since it seemed
> preferable to adhere to the prevailing style rather than follow
> checkpatch.pl's advice in this instance.  If that's the wrong
> approach please let me know.
> 
> v1 -> v2
> 
>  * Fix up a build warning found by the kernel test robot

Series applied, thanks Tom.
