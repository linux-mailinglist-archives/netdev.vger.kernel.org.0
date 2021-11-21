Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939334583F4
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 15:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbhKUOGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 09:06:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:47276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233010AbhKUOGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 09:06:01 -0500
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15E6560462;
        Sun, 21 Nov 2021 14:02:55 +0000 (UTC)
Date:   Sun, 21 Nov 2021 09:02:53 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Message-ID: <20211121090253.2a3e590f@rorschach.local.home>
In-Reply-To: <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
References: <20211118124812.106538-1-imagedong@tencent.com>
        <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
        <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
        <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com>
        <CADxym3bTScvYzpUzvz62zpUvqksbfW-f=JpCUHbEJCagjY6wuQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Nov 2021 18:47:21 +0800
Menglong Dong <menglong8.dong@gmail.com> wrote:

> @Steven What do you think? I think I'm ok with both ideas, as my main target
> is to get the reason for the packet drop. As for the idea of
> 'kfree_skb_with_reason', I'm just a little worry about if we can accept the
> modification it brings in.

The use cases of trace events is really up to the subsystem
maintainers. I only make sure that the trace events are done properly.

So I'm not sure exactly what you are asking me.

-- Steve
