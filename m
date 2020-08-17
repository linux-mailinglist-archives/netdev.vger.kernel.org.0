Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3452478F8
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgHQVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:39:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC5EC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 14:39:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 94BEE15D497DA;
        Mon, 17 Aug 2020 14:22:54 -0700 (PDT)
Date:   Mon, 17 Aug 2020 14:39:39 -0700 (PDT)
Message-Id: <20200817.143939.248108433650303983.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     rdunlap@infradead.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpUEjZzW-e=h30KZVvg02ZZMRHZn9JExxgn6E=XyWsjzNQ@mail.gmail.com>
References: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
        <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org>
        <CAM_iQpUEjZzW-e=h30KZVvg02ZZMRHZn9JExxgn6E=XyWsjzNQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:22:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 17 Aug 2020 13:59:46 -0700

> Is this a new Kconfig feature? ipv6_stub was introduced for
> VXLAN, at that time I don't remember we have such kind of
> Kconfig rules, otherwise it would not be needed.

The ipv6_stub exists in order to allow the troublesome
"ipv6=m && feature_using_ipv6=y" combination.
