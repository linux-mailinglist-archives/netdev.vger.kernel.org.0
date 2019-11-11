Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41511F8347
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKKXMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:12:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfKKXMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 18:12:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C512173B;
        Mon, 11 Nov 2019 23:12:29 +0000 (UTC)
Date:   Mon, 11 Nov 2019 18:12:28 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     mingo@redhat.com, sanagi.koki@jp.fujitsu.co, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] net: add missing semicolon in net_dev_template
Message-ID: <20191111181228.49396467@gandalf.local.home>
In-Reply-To: <20191111141752.31655-1-tonylu@linux.alibaba.com>
References: <20191111141752.31655-1-tonylu@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 22:17:53 +0800
Tony Lu <tonylu@linux.alibaba.com> wrote:

> This patch adds missing semicolon in the end of net_dev_template.
> 
> Fixes: cf66ba58b5cb ("netdev: Add tracepoints to netdev layer")
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> ---
>  include/trace/events/net.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/net.h b/include/trace/events/net.h
> index 2399073c3afc..3b28843652d2 100644
> --- a/include/trace/events/net.h
> +++ b/include/trace/events/net.h
> @@ -138,7 +138,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
>  
>  	TP_printk("dev=%s skbaddr=%p len=%u",
>  		__get_str(name), __entry->skbaddr, __entry->len)
> -)
> +);

Actually, we are thinking of making a sweeping patch set to remove all
these semicolons, as they are not needed, and would also allow more
flexible processing of the trace event macros.

-- Steve

>  
>  DEFINE_EVENT(net_dev_template, net_dev_queue,
>  

