Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719A34ECA13
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349071AbiC3Q4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235540AbiC3Q4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:56:00 -0400
Received: from mail.efficios.com (mail.efficios.com [167.114.26.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE8E13DE2;
        Wed, 30 Mar 2022 09:54:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 1650A2838F5;
        Wed, 30 Mar 2022 12:54:14 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id INgx71j7V384; Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 991612837F8;
        Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 991612837F8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1648659253;
        bh=vBhdBJ7dHZ28+lgeKrRzaznue2psKCAuHmp24VjvHtM=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=khuM6+RvN2+2Xnf1a8i3R7S2FKDHzZoT9L3DKIevMYbTz1d3luWfpOT49d+ykn+8x
         cZt+2rIFSNGIaNlR/9LT3+CDLS0vujSzRxD6mY5c4vS4jBuXwTlbRT+v6F+Fznluw6
         15crOi0vMumCCR3+pIoIcMWG8oHZhAp4NZjJ0SCTzDoBZpdlGgg+vPngTz81Si6zQf
         1rvCJa36jHMUKHXPYIMSJ4YGiImxnezEcBD4IVYkis9rxeR1DUw5TyoU8hYBJ5u/Qp
         oJaT9HY4eqPjeP8+xNjFjf6RKb1B9741aqjNw6cmzqwPnQW9lEHxvbBLgsHdwCHc7M
         oiWfLwA8UgwLw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ekmNHHteiH6J; Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 8674A283B0E;
        Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
Date:   Wed, 30 Mar 2022 12:54:13 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     rostedt <rostedt@goodmis.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
In-Reply-To: <20220329222514.51af6c07@gandalf.local.home>
References: <20220329222514.51af6c07@gandalf.local.home>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_4203 (ZimbraWebClient - FF98 (Linux)/8.8.15_GA_4232)
Thread-Topic: tracing: Set user_events to BROKEN
Thread-Index: 5jQbENgLvFWNlihIx8tKdfIg6R13sQ==
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Mar 29, 2022, at 10:25 PM, rostedt rostedt@goodmis.org wrote:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> After being merged, user_events become more visible to a wider audience
> that have concerns with the current API. It is too late to fix this for
> this release, but instead of a full revert, just mark it as BROKEN (which
> prevents it from being selected in make config). Then we can work finding
> a better API. If that fails, then it will need to be completely reverted.

Hi Steven,

What are the constraints for changing a uapi header after it has been present
in a kernel release ?

If we are not ready to commit to an ABI, perhaps it would be safer to ensure
that include/uapi/linux/user_events.h is not installed with the uapi headers
until it's ready.

Thanks,

Mathieu

> 
> Link:
> https://lore.kernel.org/all/2059213643.196683.1648499088753.JavaMail.zimbra@efficios.com/
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
> kernel/trace/Kconfig | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 16a52a71732d..edc8159f63ef 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -741,6 +741,7 @@ config USER_EVENTS
> 	bool "User trace events"
> 	select TRACING
> 	select DYNAMIC_EVENTS
> +	depends on BROKEN # API needs to be straighten out
> 	help
> 	  User trace events are user-defined trace events that
> 	  can be used like an existing kernel trace event.  User trace
> --
> 2.35.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
