Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2AA20A8CA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407809AbgFYXZX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 19:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406798AbgFYXZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:25:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32521C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:25:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BB294154B29C4;
        Thu, 25 Jun 2020 16:25:22 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:25:21 -0700 (PDT)
Message-Id: <20200625.162521.1969089330932064146.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net 0/3] sched: A couple of fixes for sch_cake
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159311592607.207748.5904268231642411759.stgit@toke.dk>
References: <159311592607.207748.5904268231642411759.stgit@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:25:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 25 Jun 2020 22:12:06 +0200

> This series contains a couple of fixes for diffserv handling in sch_cake that
> provide a nice speedup (with a somewhat pedantic nit fix tacked on to the end).
> 
> Not quite sure about whether this should go to stable; it does provide a nice
> speedup, but it's not strictly a fix in the "correctness" sense. I lean towards
> including this in stable as well, since our most important consumer of that
> (OpenWrt) is likely to backport the series anyway.

Series applied and queued up for -stable, thanks.
