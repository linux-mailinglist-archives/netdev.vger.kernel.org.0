Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92472826D9
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgJCVcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 17:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbgJCVcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 17:32:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4B2C0613D0;
        Sat,  3 Oct 2020 14:32:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EDD4911E3E4C0;
        Sat,  3 Oct 2020 14:16:05 -0700 (PDT)
Date:   Sat, 03 Oct 2020 14:32:52 -0700 (PDT)
Message-Id: <20201003.143252.1162624907281801666.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 00/23] rxrpc: Fixes and preparation for RxGK
From:   David Miller <davem@davemloft.net>
In-Reply-To: <2450213.1601760295@warthog.procyon.org.uk>
References: <160156420377.1728886.5309670328610130816.stgit@warthog.procyon.org.uk>
        <2438800.1601755309@warthog.procyon.org.uk>
        <2450213.1601760295@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 03 Oct 2020 14:16:06 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Sat, 03 Oct 2020 22:24:55 +0100

> David Miller <davem@davemloft.net> wrote:
> 
>> > Since the fixes in the set need to go after the patches in net-next, should I
>> > resubmit just those for net-next, or sit on them till -rc1?
>> 
>> My 'net' tree is always open for bug fixes, and that's where bug fixes
>> belong.  Not 'net-next'.
> 
> "Need to go after the patches in net-next" - ie. there's a dependency.

If the bugs exist before your net-next changes, that doesn't make any
sense.  The fixes have to be against whatever is in 'net'.

If the fixes are introduced by your net-next changes, you should
integrate them into your net-next changes.
