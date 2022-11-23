Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054536366AC
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239252AbiKWRJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239052AbiKWRJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:09:37 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4077E5BD69;
        Wed, 23 Nov 2022 09:09:36 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669223374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=emB+iXli2K14p1fLywmYz4u6q5gZrpX+yrCo0Lm/JxM=;
        b=vlcKj/roGj/uIjrnqmrI3gds3DmiRYaWqPQN+LmOQCzue232QraapV3E/elU5JwaQO2zuC
        y02JeTz2MbFDXmdYuOOOQK25Rpzi4Fo1O7f1JK4d3ZM0W9rYX2MzoaJUjaxTJad86j+XE2
        1+j+zUHAOzp5TncHZZvbz7MoLuJeOn01ZFOkX9s4/ypJpIn+wlJtwbT8hCNyB0Sthj53I/
        3+iAqN5L2/KelMjAqbroSlKnlERDlxLuvFn7jSN7Mijg6CiuJXmM6bRkVw3bZOfV9Y1528
        XJNP8VWo+aaiyzV5s5nKSzkhbGJELNER3BF9eL/pPznieTJ0rAgMHPg006qB3Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669223374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=emB+iXli2K14p1fLywmYz4u6q5gZrpX+yrCo0Lm/JxM=;
        b=4a2X0x1RX72mpHDImJjTL7xgB4XsHmhyUvOFgVuC0WHbNZtLrUn1h4QWEFVNcHUbiV7FBx
        l0Ri4PKJIDtsJqDw==
To:     Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [patch V2 07/17] timers: Update kernel-doc for various functions
In-Reply-To: <c3e79ef-a9c4-bee8-cf4-1bea9ad85920@linutronix.de>
References: <20221122171312.191765396@linutronix.de>
 <20221122173648.501792201@linutronix.de>
 <c3e79ef-a9c4-bee8-cf4-1bea9ad85920@linutronix.de>
Date:   Wed, 23 Nov 2022 18:09:33 +0100
Message-ID: <87bkoxegxe.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 23 2022 at 11:23, Anna-Maria Behnsen wrote:
>>  /**
>> - * add_timer_on - start a timer on a particular CPU
>> - * @timer: the timer to be added
>> - * @cpu: the CPU to start it on
>> + * add_timer_on - Start a timer on a particular CPU
>> + * @timer:	The timer to be started
>> + * @cpu:	The CPU to start it on
>>   *
>> - * This is not very scalable on SMP. Double adds are not possible.
>> + * This can only operate on an inactive timer. Attempts to invoke this on
>> + * an active timer are rejected with a warning.
>
> This is also true for add_timer(). Is it possible to add this to
> add_timer() function description and just referencing to add_timer()
> function description in add_timer_on()? They behave the same, only
> difference is the CPU where the timer is enqueued.

Indeed.

