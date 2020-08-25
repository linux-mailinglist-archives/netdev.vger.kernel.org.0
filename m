Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551AE251C3E
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHYPZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 11:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgHYPZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 11:25:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB1AC061574;
        Tue, 25 Aug 2020 08:25:29 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598369126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PAump9L0LM6bJcSU7K51HCc/4/nx2NUvs/nMFC8fAoI=;
        b=iIVCOMdB9YLLRkw6woY3g270WXgQxEdxkShajzznnvUFeM+ajn1ICA9VgSf2sjfhOy1/aH
        NzT3gZL7wQXldhx9K073ykAv3Wb7sXPphzCm9kMO3SfGv6L8Vs2i2fp8zQNsFon+RVDyj8
        jjCWIm0SFHjjAU8hbJscrOv16Ka/B9sfvEMRJxWzMQtqFRPjHa7pf/Bowq6upsdc/UPTNe
        IHrpfq3zBDLe6nxxRzS5OV4Xdw5OZX/jdQRmOPwy1J0RgvW3oFRwIBp0cNRkVrXeV2fWZl
        X/LtjzHlkojohJFRuf6qBiKFaCOSIa3rsXQ61bQMxNQaT3OQEBPjACAPNMFTtg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598369126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PAump9L0LM6bJcSU7K51HCc/4/nx2NUvs/nMFC8fAoI=;
        b=fvX+yFvs42lpxH0z2dBFAN5Yh2RS7EDQV+nzx1Bme+X14FyneOzVV0qM8LqcuV4cA/sK6d
        H2iabTe1VcvQXBDw==
To:     Christoph Hellwig <hch@infradead.org>
Cc:     mingo@redhat.com, bp@alien8.de, hpa@zytor.com, x86@kernel.org,
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
In-Reply-To: <20200825132002.GA25009@infradead.org>
References: <cover.1598042152.git.anchalag@amazon.com> <d9bcd552c946ac56f3f17cc0c1be57247d4a3004.1598042152.git.anchalag@amazon.com> <87h7svqzxm.fsf@nanos.tec.linutronix.de> <20200825132002.GA25009@infradead.org>
Date:   Tue, 25 Aug 2020 17:25:26 +0200
Message-ID: <87imd6ycgp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 25 2020 at 14:20, Christoph Hellwig wrote:
> On Sat, Aug 22, 2020 at 02:36:37AM +0200, Thomas Gleixner wrote:
>> From: Thomas Gleixner <tglx@linutronix.de>
>> 
>> followed by an empty new line before the actual changelog text
>> starts. That way the attribution of the patch when applying it will be
>> correct.
>
> The way he sent it attribution will be correct as he managed to get his
> MTU to send out the mail claiming to be from you.

Which is even worse as that spammed my inbox with mail delivery rejects
for SPF and whatever violations. And those came mostly from Amazon
servers which sent out that wrong stuff in the first place ....

> But yes, it needs the second From line, _and_ the first from line
> needs to be fixed to be from him.

Thanks,

        tglx
