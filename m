Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAED606B35
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiJTWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJTWWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:22:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6E3220F90;
        Thu, 20 Oct 2022 15:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28A15CE258D;
        Thu, 20 Oct 2022 22:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0BAC433D6;
        Thu, 20 Oct 2022 22:22:45 +0000 (UTC)
Date:   Thu, 20 Oct 2022 18:22:49 -0400
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
Message-ID: <20221020182249.691bb82a@gandalf.local.home>
In-Reply-To: <6e2396d1-d0b2-0d1e-d146-f3ad7f2b39f8@igalia.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
        <20220819221731.480795-7-gpiccoli@igalia.com>
        <20221020172908.25c6e3a5@gandalf.local.home>
        <6e2396d1-d0b2-0d1e-d146-f3ad7f2b39f8@igalia.com>
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

On Thu, 20 Oct 2022 18:53:43 -0300
"Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> Could you pick it in your tree? Or do you prefer that I re-send as a
> solo patch, with your ACK?

I wasn't sure there were any dependencies on this. If not, I can take it.

-- Steve
