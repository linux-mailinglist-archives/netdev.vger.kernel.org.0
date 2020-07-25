Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38EA22D422
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 05:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgGYDKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 23:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgGYDKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 23:10:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06B53C0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 20:10:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B2FA1277C1A7;
        Fri, 24 Jul 2020 19:53:53 -0700 (PDT)
Date:   Fri, 24 Jul 2020 20:10:37 -0700 (PDT)
Message-Id: <20200724.201037.91669607453014965.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALHRZupBXQqOzWhNH=qDH7w1cNLYrEWLTwt368sBJt4FiJTBWQ@mail.gmail.com>
References: <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com>
        <20200723.121345.1943051054532406842.davem@davemloft.net>
        <CALHRZupBXQqOzWhNH=qDH7w1cNLYrEWLTwt368sBJt4FiJTBWQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 19:53:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep subbaraya <sundeep.lkml@gmail.com>
Date: Fri, 24 Jul 2020 08:40:44 +0530

> On Fri, Jul 24, 2020 at 12:43 AM David Miller <davem@davemloft.net> wrote:
>>
>> If you leave interrupts on then an interrupt can arrive after the software
>> state has been released by unregister_netdev.
>>
>> Sounds like you need to resolve this some other way.
> 
> Only mailbox interrupts can arrive after unregister_netdev since
> otx2_stop disables
> the packet I/O and its interrupts as the first step.
> And mbox interrupts are turned off after unregister_neetdev.
> unregister_netdev(netdev);
> otx2vf_disable_mbox_intr(vf);

Please explain this in your commit message.

Thank you.
