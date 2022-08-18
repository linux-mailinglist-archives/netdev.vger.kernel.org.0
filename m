Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E3598774
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344318AbiHRP1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242310AbiHRP1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:27:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BF64C00D6;
        Thu, 18 Aug 2022 08:27:09 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:27:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1660836427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1FQ2tATvf/dDVyHdDPo+vAooOikPuiluYLzRpHSjO4=;
        b=vxSPYUrYsojDEq4V0OGbtW3RrUdA6SCtW8LFIyaHU9FFQDWsikS3U+9Rf8G10qoGAfyJj3
        AQJk++o2IVeP2zzk3yVGQ5n+GFZ/QFeZrnfThg1JQCKBxSg61+wJY6BM4gckxypsXhXozJ
        D6+5B2I8YmQ4ogIMUcq1O7MYOBEe2a+WkT6H3iUZwN8A+PQ/S48eXV8cPh7g/Ni34tgswj
        kQZy99NsT/fn30A3fSlXyCjYHPuN8QK//22J4CbRwDFtAiEX+WO31cByHUBz/YfQbGlRvX
        puqaXMmrVfT618DMtQttA7/GvwARSee+Y4p0N3TQtaqG8LHKtOjoSACiitS/tA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1660836427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x1FQ2tATvf/dDVyHdDPo+vAooOikPuiluYLzRpHSjO4=;
        b=pS9dtmaq3NuF79olp0GRxyWtC1dkIVeg6Nr/cG5Oa3ySV2jWhcc1DDm8HwwUWEZjydWxdt
        vAp/GRF4hz9g0XBA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org
Subject: Re: [PATCH 9/9] u64_stat: Remove the obsolete fetch_irq() variants
Message-ID: <Yv5aSquR9S2KxUr2@linutronix.de>
References: <20220817162703.728679-1-bigeasy@linutronix.de>
 <20220817162703.728679-10-bigeasy@linutronix.de>
 <20220817112745.4efd8217@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220817112745.4efd8217@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-08-17 11:27:45 [-0700], Jakub Kicinski wrote:
> What's the thinking on merging? 8 and 9 will get reposted separately 
> for net-next once the discussions are over?

It depends on 2/9. So either it gets routed via -tip with your blessing
or a feature branch containing 2/9 on top of -rc1 so you can pull that
change and apply 8+9.
Just say what works best for you and I let tglx know ;)

Sebastian
