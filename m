Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E807C4223A3
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 12:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbhJEKg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 06:36:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52288 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhJEKg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 06:36:57 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7C5574FD527D6;
        Tue,  5 Oct 2021 03:35:05 -0700 (PDT)
Date:   Tue, 05 Oct 2021 11:35:00 +0100 (BST)
Message-Id: <20211005.113500.1906083051377472471.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, edumazet@google.com, weiwan@google.com,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211005121154.08641258@canb.auug.org.au>
References: <20211001161849.51b6deca@canb.auug.org.au>
        <20211001.144046.309542880703739165.davem@davemloft.net>
        <20211005121154.08641258@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Oct 2021 03:35:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Oct 2021 12:11:54 +1100

> Unfortunately, there is a typo in what you committed in bfaf03935f74
> ("sparc: add SO_RESERVE_MEM definition."), SO_RESEVE_MEM instead of
> SO_RESERVE_MEM ...

Thanks for catching that.  Should be fixed now.

Thanks again.
