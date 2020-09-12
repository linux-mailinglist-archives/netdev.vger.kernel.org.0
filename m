Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EA92676C5
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgILAXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgILAXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:23:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A812C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:23:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1ABA2120EA837;
        Fri, 11 Sep 2020 17:06:16 -0700 (PDT)
Date:   Fri, 11 Sep 2020 17:23:02 -0700 (PDT)
Message-Id: <20200911.172302.1375580850096268505.davem@davemloft.net>
To:     vinicius.gomes@intel.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@resnulli.us,
        syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com
Subject: Re: [PATCH net v1] taprio: Fix allowing too small intervals
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200910000311.521452-1-vinicius.gomes@intel.com>
References: <20200910000311.521452-1-vinicius.gomes@intel.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 17:06:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Wed,  9 Sep 2020 17:03:11 -0700

> It's possible that the user specifies an interval that couldn't allow
> any packet to be transmitted. This also avoids the issue of the
> hrtimer handler starving the other threads because it's running too
> often.
> 
> The solution is to reject interval sizes that according to the current
> link speed wouldn't allow any packet to be transmitted.
> 
> Reported-by: syzbot+8267241609ae8c23b248@syzkaller.appspotmail.com
> Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Applied and queued up for -stable, thanks.
