Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186B5AA9EC
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 19:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390949AbfIERXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 13:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbfIERXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 13:23:43 -0400
Received: from oasis.local.home (bl11-233-114.dsl.telepac.pt [85.244.233.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 419EF20693;
        Thu,  5 Sep 2019 17:23:41 +0000 (UTC)
Date:   Thu, 5 Sep 2019 13:23:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc:     Qian Cai <cai@lca.pw>, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190905132334.52b13d95@oasis.local.home>
In-Reply-To: <20190905113208.GA521@jagdpanzerIV>
References: <20190903185305.GA14028@dhcp22.suse.cz>
        <1567546948.5576.68.camel@lca.pw>
        <20190904061501.GB3838@dhcp22.suse.cz>
        <20190904064144.GA5487@jagdpanzerIV>
        <20190904065455.GE3838@dhcp22.suse.cz>
        <20190904071911.GB11968@jagdpanzerIV>
        <20190904074312.GA25744@jagdpanzerIV>
        <1567599263.5576.72.camel@lca.pw>
        <20190904144850.GA8296@tigerII.localdomain>
        <1567629737.5576.87.camel@lca.pw>
        <20190905113208.GA521@jagdpanzerIV>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 20:32:08 +0900
Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:

> I think we can queue significantly much less irq_work-s from printk().
> 
> Petr, Steven, what do you think?

What if we just rate limit the wake ups of klogd? I mean, really, do we
need to keep calling wake up if it probably never even executed?

-- Steve
