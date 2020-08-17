Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189222478E5
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 23:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgHQVep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 17:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 17:34:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E4BC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 14:34:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 81EAD15D4582A;
        Mon, 17 Aug 2020 14:17:56 -0700 (PDT)
Date:   Mon, 17 Aug 2020 14:34:38 -0700 (PDT)
Message-Id: <20200817.143438.857390576001965310.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     rdunlap@infradead.org, lucien.xin@gmail.com,
        netdev@vger.kernel.org, jmaloy@redhat.com, ying.xue@windriver.com,
        tipc-discussion@lists.sourceforge.net
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
References: <CAM_iQpWQ6um=-oYK4_sgY3=3PsV1GEgCfGMYXANJ-spYRcz2XQ@mail.gmail.com>
        <f46edd0e-f44c-e600-2026-2d2ca960a94b@infradead.org>
        <CAM_iQpVkDg3WKik_j98gdvVirkQdaTQ2zzg8GVzBeij6i+aNnQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Aug 2020 14:17:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 17 Aug 2020 11:55:55 -0700

> On Mon, Aug 17, 2020 at 11:49 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>>
>> It just restricts how TIPC can be built, so that
>> TIPC=y and IPV6=m cannot happen together, which causes
>> a build error.
> 
> It also disallows TIPC=m and IPV6=m, right?

That combination is allowed.

The whole "X || X=n" construct means X must be off or equal to the
value of the Kconfig entry this dependency is for.

Thus you'll see "depends IPV6 || IPV6=n" everywhere.
