Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0F0455E7A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhKROtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:49:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:52338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKROtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:49:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D93B613D0;
        Thu, 18 Nov 2021 14:46:30 +0000 (UTC)
Date:   Thu, 18 Nov 2021 09:46:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, davem@davemloft.net, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        ycheng@google.com, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Message-ID: <20211118094628.4e445ef6@gandalf.local.home>
In-Reply-To: <20211118124812.106538-1-imagedong@tencent.com>
References: <20211118124812.106538-1-imagedong@tencent.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 20:48:10 +0800
menglong8.dong@gmail.com wrote:

>               nc-171     [000] ..s1.    35.952997: snmp: skbaddr=(____ptrval____), type=9, field=2, val=1
>               nc-171     [000] .N...    35.957006: snmp: skbaddr=(____ptrval____), type=9, field=4, val=1
>               nc-171     [000] ..s1.    35.957822: snmp: skbaddr=(____ptrval____), type=9, field=2, val=1
>               nc-171     [000] .....    35.957893: snmp: skbaddr=(____ptrval____), type=9, field=4, val=1
> 
> 'type=9' means that the event is triggered by udp statistics and 'field=2'
> means that this is triggered by 'NoPorts'. 'val=1' means that increases
> of statistics (decrease can happen on tcp).

Instead of printing numbers, why not print the meanings?

I'll reply to the other patches to explain that.

-- Steve
