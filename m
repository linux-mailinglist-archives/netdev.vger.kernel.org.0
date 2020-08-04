Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F57423C21C
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgHDXPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgHDXPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:15:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B5DC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:15:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 60ADD12896E97;
        Tue,  4 Aug 2020 15:59:09 -0700 (PDT)
Date:   Tue, 04 Aug 2020 16:15:54 -0700 (PDT)
Message-Id: <20200804.161554.2165553573160523282.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     haiyangz@microsoft.com, kuba@kernel.org, netdev@vger.kernel.org,
        wei.liu@kernel.org, ashish.n.shah@intel.com
Subject: Re: [PATCH] hv_netvsc: do not use VF device if link is down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200804165415.7631-1-stephen@networkplumber.org>
References: <20200804165415.7631-1-stephen@networkplumber.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Aug 2020 15:59:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue,  4 Aug 2020 09:54:15 -0700

> If the accelerated networking SRIOV VF device has lost carrier
> use the synthetic network device which is available as backup
> path. This is a rare case since if VF link goes down, normally
> the VMBus device will also loose external connectivity as well.
> But if the communication is between two VM's on the same host
> the VMBus device will still work.
> 
> Reported-by: "Shah, Ashish N" <ashish.n.shah@intel.com>
> Fixes: 0c195567a8f6 ("netvsc: transparent VF management")
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied and queued up for -stable, thanks.
