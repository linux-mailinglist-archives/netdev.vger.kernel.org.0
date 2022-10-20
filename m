Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D96606A4C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiJTV3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiJTV3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44986229E5C;
        Thu, 20 Oct 2022 14:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C173961D32;
        Thu, 20 Oct 2022 21:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD56C433D6;
        Thu, 20 Oct 2022 21:29:03 +0000 (UTC)
Date:   Thu, 20 Oct 2022 17:29:08 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, senozhatsky@chromium.org,
        stern@rowland.harvard.edu, tglx@linutronix.de, vgoyal@redhat.com,
        vkuznets@redhat.com, will@kernel.org, xuqiang36@huawei.com,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>
Subject: Re: [PATCH V3 06/11] tracing: Improve panic/die notifiers
Message-ID: <20221020172908.25c6e3a5@gandalf.local.home>
In-Reply-To: <20220819221731.480795-7-gpiccoli@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
        <20220819221731.480795-7-gpiccoli@igalia.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 19:17:26 -0300
"Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> Currently the tracing dump_on_oops feature is implemented through
> separate notifiers, one for die/oops and the other for panic;
> given they have the same functionality, let's unify them.
> 
> Also improve the function comment and change the priority of the
> notifier to make it execute earlier, avoiding showing useless trace
> data (like the callback names for the other notifiers); finally,
> we also removed an unnecessary header inclusion.
> 
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Sorry for the late reply.

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
