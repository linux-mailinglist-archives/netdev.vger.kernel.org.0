Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F5924E42B
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 02:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHVAgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 20:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgHVAgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 20:36:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC3CC061573;
        Fri, 21 Aug 2020 17:36:40 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598056598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+9a3mf/q/JMj3Y9x7eS8acHlvm0J/m2YZlY/YdpgDy0=;
        b=vg5p/dx2INR0j8znwa3K27r3b4zu28Hsa9xXi6lLxZbDpdWcmppg2Aoq8oCrV6h6gf8kgi
        7+HL3V0i+w7EtRQc3MNc5xKHxxtQtcO3Pp4zG48fqeMxZhwCqQfSaej/9jtLQppKa8IOkO
        fntpM0TZIqjSqbJoxyi19hITAIYNn0Y2RaKyVdGB4b8x0a6unmP74HXfQxTK+kIyxz/LZT
        BrfCFYbdgq3iX53S8ditdDYu7EirnWbnm9IOOJkdmoUEbYAIAU1JQUmji06lBOC6Y/ZjvH
        XWiiDsc8RaAyIUynR/XTBpr/r7ymQNJtFRcJAxWgHrC0+cTGBAe6M3j3/xAlig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598056598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+9a3mf/q/JMj3Y9x7eS8acHlvm0J/m2YZlY/YdpgDy0=;
        b=0uoozM+OCFPFNY8VcifwCpSHilI8H+z53Cv2AoAC4G9VRmdubjD0W/m48XtmoN9alpxXox
        95aZkLMTuewu1jDw==
To:     mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        linux-pm@vger.kernel.org, linux-mm@kvack.org, kamatam@amazon.com,
        sstabellini@kernel.org, konrad.wilk@oracle.com,
        roger.pau@citrix.com, axboe@kernel.dk, davem@davemloft.net,
        rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        peterz@infradead.org, eduval@amazon.com, sblbir@amazon.com,
        anchalag@amazon.com, xen-devel@lists.xenproject.org,
        vkuznets@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw@amazon.co.uk,
        benh@kernel.crashing.org
Subject: Re: [PATCH v3 05/11] genirq: Shutdown irq chips in suspend/resume during hibernation
In-Reply-To: <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com>
References: <cover.1598042152.git.anchalag@amazon.com> <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com>
Date:   Sat, 22 Aug 2020 02:36:37 +0200
Message-ID: <87h7svqzxm.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21 2020 at 22:27, Thomas Gleixner wrote:
> Add a new quirk flag IRQCHIP_SHUTDOWN_ON_SUSPEND and add support for
> it the core interrupt suspend/resume paths.
>
> Changelog:
> v1->v2: Corrected the author's name to tglx@

Can you please move that Changelog part below the --- seperator next
time because that's really not part of the final commit messaage and the
maintainer has then to strip it off manually
 
> Signed-off-by: Anchal Agarwal <anchalag@amazon.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

These SOB lines are just wrongly ordered as they suggest:

     Anchal has authored the patch and Thomas transported it

which is clearly not the case. So the right order is:

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anchal Agarwal <anchalag@amazon.com>

And that needs another tweak at the top of the change log. The first
line in the mail body wants to be:

From: Thomas Gleixner <tglx@linutronix.de>

followed by an empty new line before the actual changelog text
starts. That way the attribution of the patch when applying it will be
correct.

Documentation/process/ is there for a reason and following the few
simple rules to get that straight is not rocket science.

Thanks,

        tglx


