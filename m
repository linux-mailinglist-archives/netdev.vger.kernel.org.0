Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00033374C4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbhCKN4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhCKN4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 08:56:22 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E7564F9F;
        Thu, 11 Mar 2021 13:56:20 +0000 (UTC)
Date:   Thu, 11 Mar 2021 08:56:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     eric.dumazet@gmail.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] tracing: remove holes in events
Message-ID: <20210311085619.3de5a62a@gandalf.local.home>
In-Reply-To: <20210311094414.12774-1-tonylu@linux.alibaba.com>
References: <20210311094414.12774-1-tonylu@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 17:44:15 +0800
Tony Lu <tonylu@linux.alibaba.com> wrote:

> ---
>  include/trace/events/net.h    | 42 +++++++++++++++++------------------
>  include/trace/events/qdisc.h  |  4 ++--
>  include/trace/events/sunrpc.h |  4 ++--
>  include/trace/events/tcp.h    |  2 +-
>  4 files changed, 26 insertions(+), 26 deletions(-)


If all the above are owned by networking, then this patch needs to go
through the networking tree.

-- Steve
