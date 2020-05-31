Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931971E9570
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 06:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgEaEle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 00:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgEaEld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 00:41:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A06F0C05BD43
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 21:41:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87888128FCC67;
        Sat, 30 May 2020 21:41:32 -0700 (PDT)
Date:   Sat, 30 May 2020 21:41:31 -0700 (PDT)
Message-Id: <20200530.214131.1805572294118065107.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        kuba@kernel.org
Subject: Re: [PATCH net 0/3] mptcp: a bunch of fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1590766645.git.pabeni@redhat.com>
References: <cover.1590766645.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 21:41:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 29 May 2020 17:43:28 +0200

> This patch series pulls together a few bugfixes for MPTCP bug observed while
> doing stress-test with apache bench - forced to use MPTCP and multiple
> subflows.

Series applied, and patch #1 and #3 queued up for -stable, thanks.
