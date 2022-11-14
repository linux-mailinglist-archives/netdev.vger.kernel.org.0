Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6644628731
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237238AbiKNRfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbiKNRf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:35:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41BF5F69;
        Mon, 14 Nov 2022 09:35:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8059A6131D;
        Mon, 14 Nov 2022 17:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91ACC433C1;
        Mon, 14 Nov 2022 17:35:24 +0000 (UTC)
Date:   Mon, 14 Nov 2022 12:36:05 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     olsajiri@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn@kernel.org, toke@redhat.com,
        David.Laight@aculab.com
Subject: Re: [PATCH 2/2] bpf: Convert BPF_DISPATCHER to use static_call()
 (not ftrace)
Message-ID: <20221114123605.6d9a399f@gandalf.local.home>
In-Reply-To: <20221103120647.796772565@infradead.org>
References: <20221103120012.717020618@infradead.org>
        <20221103120647.796772565@infradead.org>
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

On Thu, 03 Nov 2022 13:00:14 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> The dispatcher function is currently abusing the ftrace __fentry__
> call location for its own purposes -- this obviously gives trouble
> when the dispatcher and ftrace are both in use.

Awesome! Thanks for doing this Peter!

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
