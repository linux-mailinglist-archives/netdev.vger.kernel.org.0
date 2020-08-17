Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3592478F0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbgHQVhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:37:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8EFBC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 14:37:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B19EF15D497CF;
        Mon, 17 Aug 2020 14:20:45 -0700 (PDT)
Date:   Mon, 17 Aug 2020 14:37:31 -0700 (PDT)
Message-Id: <20200817.143731.2031150170446785853.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     rdunlap@infradead.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
References: <CAM_iQpWOTLKHsJYDsCM3Pd1fsqPxqj8cSP=nL63Dh0esiJ2QfA@mail.gmail.com>
        <98214acb-5e9f-0477-bc97-1f3b2c690f14@infradead.org>
        <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:20:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 17 Aug 2020 13:29:40 -0700

> On Mon, Aug 17, 2020 at 12:55 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> TIPC=m and IPV6=m builds just fine.
>>
>> Having tipc autoload ipv6 is a different problem. (IMO)
>>
>>
>> This Kconfig entry:
>>  menuconfig TIPC
>>         tristate "The TIPC Protocol"
>>         depends on INET
>> +       depends on IPV6 || IPV6=n
>>
>> says:
>> If IPV6=n, TIPC can be y/m/n.
>> If IPV6=y/m, TIPC is limited to whatever IPV6 is set to.
> 
> Hmm, nowadays we _do_ have IPV6=y on popular distros.
> So this means TIPC would have to be builtin after this patch??

Note the word "limited", ipv6=y allows y and m, ipv6=m (more limited)
allows only m.
