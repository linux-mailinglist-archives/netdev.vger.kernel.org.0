Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18F020A64A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406875AbgFYUAy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 16:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406569AbgFYUAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 16:00:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5109C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 13:00:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E0FE13FAD9DB;
        Thu, 25 Jun 2020 13:00:53 -0700 (PDT)
Date:   Thu, 25 Jun 2020 13:00:52 -0700 (PDT)
Message-Id: <20200625.130052.925991356126527167.davem@davemloft.net>
To:     toke@redhat.com
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the
 presence of VLAN tags
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87k0zuj50u.fsf@toke.dk>
References: <159308610390.190211.17831843954243284203.stgit@toke.dk>
        <20200625.122945.321093402617646704.davem@davemloft.net>
        <87k0zuj50u.fsf@toke.dk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 13:00:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>
Date: Thu, 25 Jun 2020 21:53:53 +0200

> I think it depends a little on the use case; some callers actually care
> about the VLAN tags themselves and handle that specially (e.g.,
> act_csum). Whereas others (e.g., sch_dsmark) probably will have the same
> issue. I guess I can trying going through them all and figuring out if
> there's a more generic solution.

That makes sense.

> I'll split out the diffserv parsing fixes and send those for your net
> tree straight away, then circle back to this one...

Great, thank you.
