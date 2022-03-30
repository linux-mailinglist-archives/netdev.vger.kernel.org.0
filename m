Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3164ED059
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 01:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351867AbiC3XtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 19:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242691AbiC3XtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 19:49:22 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3F4657AF;
        Wed, 30 Mar 2022 16:47:36 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648684054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3E8NcHrNrNsPkSEV84HA25Bns8De57zMh9PpkBtYC/Y=;
        b=XvQVXaQvP8hHy1ARK8ZQ2tTfm5s5KjwFEFBKhu6a1dDJoXPsgHhJPu8PyUEsmCbhiG/eaq
        aasIpDHuO8yV0CH+zUH4bjq/WfRhIDTZpeFfqmFbLGG23Rh6revGEIApjJkB7qPg3XNLT4
        yzeSafSfL/2qJRChRrRC/8MOswOyfkzpdkcBJCAbY9kN74MHYTmzFhW4hh/goj5mHai3ex
        khy50GZPGzxkB6Giml3tCI+PNK/+WOa8sa2/X27brzAsWggLuf6I4WsLIjB/bml/s6Yl8a
        uLvKqme8ix+vcBw3uAf1D1d4QxOLQQzyR3H0bE7Bca9e6lFR6uYR6FGt16C2CA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648684054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3E8NcHrNrNsPkSEV84HA25Bns8De57zMh9PpkBtYC/Y=;
        b=ShqkK/GBRqw4U/FYN0uoJrvHHIeVeg2jypwfLQeO7e9cPqhKQxtUD51mEb5CThM8282FkC
        fMZpTWvqtBaPaaCg==
To:     Song Liu <song@kernel.org>, linux-mm@kvack.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, x86@kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kernel-team@fb.com, akpm@linux-foundation.org,
        pmenzel@molgen.mpg.de, rick.p.edgecombe@intel.com,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf 1/4] x86: disable HAVE_ARCH_HUGE_VMALLOC
In-Reply-To: <20220330225642.1163897-2-song@kernel.org>
References: <20220330225642.1163897-1-song@kernel.org>
 <20220330225642.1163897-2-song@kernel.org>
Date:   Thu, 31 Mar 2022 01:47:34 +0200
Message-ID: <87wngbm295.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30 2022 at 15:56, Song Liu wrote:
> We cannot savely enable HAVE_ARCH_HUGE_VMALLOC for X86_64 yet. See [1]
> and [2] for more details. Disable it for now.

This is not a proper changelog.

A changelog has to be self contained and provide all necessary
information. Links are there to provide supplementary information, but
are not the primary source of information for well documented reasons.

Aside of that, please read and follow:

      https://www.kernel.org/doc/html/latest/process/maintainer-tip.html

and update the CC list to comply with the general rules.

Thanks,

        tglx


