Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444B820FDD4
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgF3UiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729508AbgF3UiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:38:19 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43DF2C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:38:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBE0D1277ED7E;
        Tue, 30 Jun 2020 13:38:18 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:38:18 -0700 (PDT)
Message-Id: <20200630.133818.337808463839879472.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next] mptcp: do nonce initialization at subflow
 creation time
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cc811b8707d488492fb8e33ed651aab456de6f72.1593527763.git.pabeni@redhat.com>
References: <cc811b8707d488492fb8e33ed651aab456de6f72.1593527763.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:38:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 30 Jun 2020 16:38:26 +0200

> This clean-up the code a bit, reduces the number of
> used hooks and indirect call requested, and allow
> better error reporting from __mptcp_subflow_connect()
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks.
