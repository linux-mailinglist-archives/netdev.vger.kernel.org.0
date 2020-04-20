Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82641B168A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgDTUCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbgDTUCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:02:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBF1C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 13:02:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 32D97128042D4;
        Mon, 20 Apr 2020 13:02:17 -0700 (PDT)
Date:   Mon, 20 Apr 2020 13:02:15 -0700 (PDT)
Message-Id: <20200420.130215.721617466987117194.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuba@kernel.org, cpaasch@apple.com,
        fw@strlen.de
Subject: Re: [PATCH net 0/3] mptcp: fix races on accept()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1587389294.git.pabeni@redhat.com>
References: <cover.1587389294.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Apr 2020 13:02:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Mon, 20 Apr 2020 16:25:03 +0200

> This series includes some fixes for accept() races which may cause inconsistent
> MPTCP socket status and oops. Please see the individual patches for the
> technical details.

Series applied, thanks.

It seems like patch #3 might be relevant for v5.6 -stable, what's the
story here?
