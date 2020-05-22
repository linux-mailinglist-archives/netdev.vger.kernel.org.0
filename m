Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C50D1DF101
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbgEVVWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730976AbgEVVWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:22:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C40C061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:22:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87AA5126390D8;
        Fri, 22 May 2020 14:22:12 -0700 (PDT)
Date:   Fri, 22 May 2020 14:22:11 -0700 (PDT)
Message-Id: <20200522.142211.889204416624218899.davem@davemloft.net>
To:     todd.malsbary@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, cpaasch@apple.com,
        mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net] mptcp: use untruncated hash in ADD_ADDR HMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200522021049.361606-1-todd.malsbary@linux.intel.com>
References: <20200522021049.361606-1-todd.malsbary@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 14:22:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Malsbary <todd.malsbary@linux.intel.com>
Date: Thu, 21 May 2020 19:10:49 -0700

> There is some ambiguity in the RFC as to whether the ADD_ADDR HMAC is
> the rightmost 64 bits of the entire hash or of the leftmost 160 bits
> of the hash.  The intention, as clarified with the author of the RFC,
> is the entire hash.
> 
> This change returns the entire hash from
> mptcp_crypto_hmac_sha (instead of only the first 160 bits), and moves
> any truncation/selection operation on the hash to the caller.
> 
> Fixes: 12555a2d97e5 ("mptcp: use rightmost 64 bits in ADD_ADDR HMAC")
> Reviewed-by: Christoph Paasch <cpaasch@apple.com>
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Todd Malsbary <todd.malsbary@linux.intel.com>

Applied, thank you.
