Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADFE8E80
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 18:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbfJ2RmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 13:42:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727239AbfJ2RmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 13:42:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59CE514CDDCFF;
        Tue, 29 Oct 2019 10:42:15 -0700 (PDT)
Date:   Tue, 29 Oct 2019 10:42:12 -0700 (PDT)
Message-Id: <20191029.104212.1114755402526419547.davem@davemloft.net>
To:     will@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@semmle.com
Subject: Re: [PATCH] fjes: Handle workqueue allocation failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025110602.10615-1-will@kernel.org>
References: <20191025110602.10615-1-will@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 10:42:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Will Deacon <will@kernel.org>
Date: Fri, 25 Oct 2019 12:06:02 +0100

> In the highly unlikely event that we fail to allocate either of the
> "/txrx" or "/control" workqueues, we should bail cleanly rather than
> blindly march on with NULL queue pointer(s) installed in the
> 'fjes_adapter' instance.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Link: https://lore.kernel.org/lkml/CADJ_3a8WFrs5NouXNqS5WYe7rebFP+_A5CheeqAyD_p7DFJJcg@mail.gmail.com/
> Signed-off-by: Will Deacon <will@kernel.org>

Applied, thanks Will.
