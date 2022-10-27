Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2C060FD45
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236371AbiJ0Qiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiJ0Qit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:38:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ADF18E716;
        Thu, 27 Oct 2022 09:38:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B207B82707;
        Thu, 27 Oct 2022 16:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155DEC433D6;
        Thu, 27 Oct 2022 16:38:43 +0000 (UTC)
Date:   Thu, 27 Oct 2022 12:38:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ian Rogers <irogers@google.com>,
        Menglong Dong <menglong8.dong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Menglong Dong <imagedong@tencent.com>,
        David Ahern <dsahern@kernel.org>,
        Hao Peng <flyingpeng@tencent.com>,
        Dongli Zhang <dongli.zhang@oracle.com>, robh@kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Vasily Averin <vasily.averin@linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: skb: export skb drop reaons to user by
 TRACE_DEFINE_ENUM
Message-ID: <20221027123858.326aa218@gandalf.local.home>
In-Reply-To: <CANn89iL7EvdBhZGtxDOATeznLUwVaFm2gf4XCYeMPXE5CR=BTw@mail.gmail.com>
References: <20220902141715.1038615-1-imagedong@tencent.com>
        <CANn89iK7Mm4aPpr1-VM5OgicuHrHjo9nm9P9bYgOKKH9yczFzg@mail.gmail.com>
        <20220905103808.434f6909@gandalf.local.home>
        <CANn89i+qp=gmhx_1b+=hEiHA7yNGkfh46YPKhUc9GFbtNYBZrA@mail.gmail.com>
        <20221027114407.6429a809@gandalf.local.home>
        <CANn89iL7EvdBhZGtxDOATeznLUwVaFm2gf4XCYeMPXE5CR=BTw@mail.gmail.com>
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

On Thu, 27 Oct 2022 09:28:42 -0700
Eric Dumazet <edumazet@google.com> wrote:

> I tried a more recent perf binary we have, but it is also not right.
> 
> I guess I will have to request a new perf binary at Google :/

You could always use trace-cmd ;-)

-- Steve
