Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92FEF1DF304
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbgEVXdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgEVXdN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:33:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9382C061A0E;
        Fri, 22 May 2020 16:33:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4D11712751C5A;
        Fri, 22 May 2020 16:33:11 -0700 (PDT)
Date:   Fri, 22 May 2020 16:33:10 -0700 (PDT)
Message-Id: <20200522.163310.591969005159684961.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/3] rxrpc: Fix retransmission timeout and ACK
 discard
From:   David Miller <davem@davemloft.net>
In-Reply-To: <997165.1590190006@warthog.procyon.org.uk>
References: <20200522.155418.406408375053374516.davem@davemloft.net>
        <159001690181.18663.663730118645460940.stgit@warthog.procyon.org.uk>
        <997165.1590190006@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 16:33:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Sat, 23 May 2020 00:26:46 +0100

> David Miller <davem@davemloft.net> wrote:
> 
>> Pulled, thanks David.
> 
> Thanks.  I'll rebase my two extra patches I've just sent you a pull request
> for when you've updated the branch.

Please respin and fix the Subject line of patch #2 to have a correct
rxrpc: prefix.

Thanks.
