Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D202740C1
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 13:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgIVLZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 07:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgIVLZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 07:25:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A390C061755;
        Tue, 22 Sep 2020 04:25:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600773954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KbPR/HCKRHyAv5LTQZ0qDPTMbhu34/nFtP5pay1MXIE=;
        b=4RDnNluOdohF63P9pPZrHwj1wDlIRBfjyDPphUeZ+gMiycbrE9qGozP86vvLQDznBLcWWw
        E3JbF48GowdKJ+0KtrS6wp9zuKfPyuCGD9f3J97BB4VFEJZxNqENQ0ufNmGe4zESYpk+FE
        V7yaEKtObrg6hgvTx4QC/Fw9iGukTXoFvmpmsbt/hp/7wJMU2frz884bjtxB8P/dIOdxdB
        7qRd1thtPWbBRwOwqyX69CRb378VkaShhOW8tw2342dKJUbj2ZwcHmx3y7j/smkTL2Ylnp
        ToJ5yrQoik5JJ7HNHboQAbD8kCfP4K4vro6U0Lhznx5Y7pEuhznsnhpkZJmHEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600773954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KbPR/HCKRHyAv5LTQZ0qDPTMbhu34/nFtP5pay1MXIE=;
        b=zD1mgRKFMrwiNzhJeBhRUMy6UoOF3ScfHKbU8u6UziFewfFMX7YJBqERAF+oK7eIypMqJu
        pupIfA0KgQkeomBg==
To:     Abdul Anshad Azeez <aazees@vmware.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86\@kernel.org" <x86@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Cc:     "rostedt\@goodmis.org" <rostedt@goodmis.org>
Subject: Re: Performance regressions in networking & storage benchmarks in Linux kernel 5.8
In-Reply-To: <BYAPR05MB4839189DFC487A1529D6734CA63B0@BYAPR05MB4839.namprd05.prod.outlook.com>
References: <BYAPR05MB4839189DFC487A1529D6734CA63B0@BYAPR05MB4839.namprd05.prod.outlook.com>
Date:   Tue, 22 Sep 2020 13:25:53 +0200
Message-ID: <87h7rqaw8u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Abdul,

On Tue, Sep 22 2020 at 08:51, Abdul Anshad Azeez wrote:
> Part of VMware's performance regression testing for Linux Kernel upstream rele
> ases we compared Linux kernel 5.8 against 5.7. Our evaluation revealed perform
> ance regressions mostly in networking latency/response-time benchmarks up to 6
> 0%. Storage throughput & latency benchmarks were also up by 8%.
> In order to find the fix commit, we bisected again between 5.8 and 5.9-rc4 and
>  identified that regressions were fixed from a commit made by the same author 
> Thomas Gleixner, which unbreaks the interrupt affinity settings - "e027fffff79
> 9cdd70400c5485b1a54f482255985(x86/irq: Unbreak interrupt affinity setting)".
>
> We believe these findings would be useful to the Linux community and wanted to
>  document the same.

thanks for letting us know, but the issue is known already and the fix
has been backported to the stable kernel version 5.8.6 as of Sept. 3rd.

Please always check the latest stable version.

Thanks,

        tglx
