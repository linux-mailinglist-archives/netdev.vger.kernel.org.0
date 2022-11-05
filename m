Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7120361D772
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 06:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiKEF0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 01:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKEF0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 01:26:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BD810B6;
        Fri,  4 Nov 2022 22:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DDA86B82F6C;
        Sat,  5 Nov 2022 05:25:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB688C433D6;
        Sat,  5 Nov 2022 05:25:56 +0000 (UTC)
Date:   Sat, 5 Nov 2022 01:25:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chengfeng Ye <cyeaa@connect.ust.hk>, Lin Ma <linma@zju.edu.cn>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org
Subject: Re: [RFC][PATCH v3 23/33] timers: nfc: pn533: Use
 timer_shutdown_sync() before freeing timer
Message-ID: <20221105012555.2b065c4a@rorschach.local.home>
In-Reply-To: <2f80c103-4b35-122d-b30f-4bdd8f643a31@linaro.org>
References: <20221104054053.431922658@goodmis.org>
        <20221104054916.096085393@goodmis.org>
        <2f80c103-4b35-122d-b30f-4bdd8f643a31@linaro.org>
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

On Fri, 4 Nov 2022 11:46:26 -0400
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> On 04/11/2022 01:41, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > Before a timer is freed, timer_shutdown_sync() must be called.
> > 
> > Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.home/  
> 
> I think link has to be updated.

Yes, I was lazy on that. My next patch series will point to 00 of this series.

Thanks,

-- Steve

