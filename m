Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB01AF583
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 00:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgDRWoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 18:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDRWoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 18:44:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E6EC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 15:44:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C41181277F51F;
        Sat, 18 Apr 2020 15:44:06 -0700 (PDT)
Date:   Sat, 18 Apr 2020 15:44:05 -0700 (PDT)
Message-Id: <20200418.154405.1415997611473050221.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] mptcp: fix 'attempt to release socket in state...'
 splats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200417072823.25864-1-fw@strlen.de>
References: <20200417072823.25864-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 18 Apr 2020 15:44:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Fri, 17 Apr 2020 09:28:21 +0200

> These two patches fix error handling corner-cases where
> inet_sock_destruct gets called for a mptcp_sk that is not in TCP_CLOSE
> state.  This results in unwanted error printks from the network stack.

Series applied, thanks Florian.
