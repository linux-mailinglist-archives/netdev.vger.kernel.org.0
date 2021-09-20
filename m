Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA7412128
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350374AbhITSCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356595AbhITSAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 14:00:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B95363221;
        Mon, 20 Sep 2021 17:15:51 +0000 (UTC)
Date:   Mon, 20 Sep 2021 13:15:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Yonghong Song <yhs@fb.com>, 2228598786@qq.com
Subject: Re: [PATCH] tcp: tcp_drop adds `SNMP` and `reason` parameter for
 tracing
Message-ID: <20210920131550.658eda95@oasis.local.home>
In-Reply-To: <CAM_iQpWLPvSmZD4CTmzSoor04xfdkvZuDhF=_CCaumT7XiaN7g@mail.gmail.com>
References: <20210914143515.106394-1-yan2228598786@gmail.com>
        <CAM_iQpWLPvSmZD4CTmzSoor04xfdkvZuDhF=_CCaumT7XiaN7g@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Sep 2021 09:54:02 -0700
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> Also, kernel does not have to explain it in strings, those SNMP
> counters are already available for user-space, so kernel could
> just use SNMP enums and let user-space interpret them. In many
> cases, you are just adding strings for those SNMP enums.

The strings were requested by the networking maintainers.

  https://lore.kernel.org/all/CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com/

-- Steve
