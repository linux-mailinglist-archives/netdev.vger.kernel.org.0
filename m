Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6C34ECD97
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 21:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiC3T71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbiC3T7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 15:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB38D2AE32;
        Wed, 30 Mar 2022 12:57:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EA5F614EE;
        Wed, 30 Mar 2022 19:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A339C340F0;
        Wed, 30 Mar 2022 19:57:34 +0000 (UTC)
Date:   Wed, 30 Mar 2022 15:57:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH] tracing: Set user_events to BROKEN
Message-ID: <20220330155733.012704ee@gandalf.local.home>
In-Reply-To: <20220330153145.2d148b8c@gandalf.local.home>
References: <20220329222514.51af6c07@gandalf.local.home>
        <1546405229.199729.1648659253425.JavaMail.zimbra@efficios.com>
        <CAHk-=wgZ0RccFsUhgKpdh130ydsY57bqaCGRQS7w3-ckgHP=OA@mail.gmail.com>
        <20220330153145.2d148b8c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022 15:31:45 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > So maybe it should be marked as
> > 
> >         depends on BROKEN || COMPILE_TEST
> > 
> > instead?  
> 
> Agreed. I'll send a v2 of the patch.

Hopefully no distros are idiotic enough to enable COMPILE_TEST to get this
feature. I could add "panic" to each of the API calls ;-)

-- Steve
