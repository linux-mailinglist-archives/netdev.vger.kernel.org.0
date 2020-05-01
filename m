Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284571C0CA4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgEADdU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Apr 2020 23:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:33:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECB7C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:33:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0CB8C12773F36;
        Thu, 30 Apr 2020 20:33:19 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:33:19 -0700 (PDT)
Message-Id: <20200430.203319.977198547891023040.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, ietf@bobbriscoe.net,
        olivier.tilmans@nokia-bell-labs.com, dave.taht@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH net] tunnel: Propagate ECT(1) when decapsulating as
 recommended by RFC6040
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427141105.555251-1-toke@redhat.com>
References: <20200427141105.555251-1-toke@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:33:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Mon, 27 Apr 2020 16:11:05 +0200

> RFC 6040 recommends propagating an ECT(1) mark from an outer tunnel header
> to the inner header if that inner header is already marked as ECT(0). When
> RFC 6040 decapsulation was implemented, this case of propagation was not
> added. This simply appears to be an oversight, so let's fix that.
> 
> Fixes: eccc1bb8d4b4 ("tunnel: drop packet if ECN present with not-ECT")
> Reported-by: Bob Briscoe <ietf@bobbriscoe.net>
> Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
> Cc: Dave Taht <dave.taht@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>

Applied and queued up for -stable, thanks.
