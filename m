Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596874EDC0F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 16:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237787AbiCaOuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 10:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236576AbiCaOuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 10:50:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A213222A2;
        Thu, 31 Mar 2022 07:48:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4229B82147;
        Thu, 31 Mar 2022 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E70BC340ED;
        Thu, 31 Mar 2022 14:48:21 +0000 (UTC)
Date:   Thu, 31 Mar 2022 10:48:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] tracing: do not export user_events uapi
Message-ID: <20220331104820.4506c8ba@gandalf.local.home>
In-Reply-To: <CAK7LNAR_2jJWJbaUfLDaDJOuJTx_RHj_Ow5coK1k4Y5HGLRQrA@mail.gmail.com>
References: <20220330201755.29319-1-mathieu.desnoyers@efficios.com>
        <20220330162152.17b1b660@gandalf.local.home>
        <CAK7LNATm5FjZsXL6aKUMhXwQAqTuO9+LmAk3LGjpAib7NZBDmg@mail.gmail.com>
        <20220331081337.07ddf251@gandalf.local.home>
        <CAK7LNAR_2jJWJbaUfLDaDJOuJTx_RHj_Ow5coK1k4Y5HGLRQrA@mail.gmail.com>
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

On Thu, 31 Mar 2022 23:41:34 +0900
Masahiro Yamada <masahiroy@kernel.org> wrote:

> Either 1 or 2 is OK
> if  you are sure this will be fixed sooner or later.

Thanks,

Then I'll go and pull in Mathieu's patch.

I want this done too, and I believe Beau has a vested interest to get this
correctly done as well, thus it should be worked on and hopefully we will
have something solid by the next merge window.

-- Steve
