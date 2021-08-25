Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C742D3F7DF5
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhHYVsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229707AbhHYVsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 17:48:22 -0400
Received: from rorschach.local.home (unknown [24.94.146.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3430E61038;
        Wed, 25 Aug 2021 21:47:35 +0000 (UTC)
Date:   Wed, 25 Aug 2021 17:47:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing
Message-ID: <20210825174733.38a484f8@rorschach.local.home>
In-Reply-To: <CANn89iKCDkKTJxK2LuAXN7DmVMwE9zbemtKRAhrTpHR+Uc71SA@mail.gmail.com>
References: <20210824125140.190253-1-yan2228598786@gmail.com>
        <20210824112957.3a780186@oasis.local.home>
        <CALcyL7icKx5RH9UXiEqLmZtP5MViip5Pn1yNyogbADA3Xeo3xw@mail.gmail.com>
        <CANn89iKCDkKTJxK2LuAXN7DmVMwE9zbemtKRAhrTpHR+Uc71SA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 08:39:40 -0700
Eric Dumazet <edumazet@google.com> wrote:

> Since these drops are hardly hot path, why not simply use a string ?
> An ENUM will not really help grep games.

I'm more concerned with ring buffer space than hot paths. The ring
buffer is limited in size, and the bigger the events, the less there
are.

grep games shouldn't be too bad, since it would find the place that
maps the names with the enums, and then you just search for the enums.

-- Steve
