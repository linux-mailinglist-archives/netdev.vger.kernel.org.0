Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50637217884
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 22:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgGGUCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 16:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728067AbgGGUCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 16:02:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83836C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 13:02:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3154A120F93E2;
        Tue,  7 Jul 2020 13:02:46 -0700 (PDT)
Date:   Tue, 07 Jul 2020 13:02:45 -0700 (PDT)
Message-Id: <20200707.130245.588905720666199302.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] mptcp: use mptcp worker for path management
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200707124048.2403-1-fw@strlen.de>
References: <20200707124048.2403-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 13:02:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Tue,  7 Jul 2020 14:40:48 +0200

> We can re-use the existing work queue to handle path management
> instead of a dedicated work queue.  Just move pm_worker to protocol.c,
> call it from the mptcp worker and get rid of the msk lock (already held).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks.
