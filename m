Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026E3243B74
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgHMOVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:21:40 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59000 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgHMOVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:21:38 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597328496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I/ezJHDDZVX9t5zh6Wo6ZZ3cdPlLiUU7pzdzZ1d6E98=;
        b=Da9toYaR3y7FnnYf0Hf+1boCEfHgY6PtfUGPL0a/nvE12SNAZYuYKihUZmoLg3gltcP9jv
        Rz8wa0Nx0ruJbqM87OL/TASd9LhGLj5EtXrOngk6+TFQKiCXBX8IzTbWX2QfxkjORcDvo6
        8t9v9fqnV9EKhjcRri9SP3LOZ4R0VFCJNQfySYe1QcfrvxMSJTcNVWyV1PIBSGiXEm5eiK
        Cl06MMU0/12ac3iLghAYDa4M3sqJqzuNT1GXspSwY9cfU+g1Uqk6k+1FvzPLLzwb8aaQPn
        g0VAynzzFFUADw61U11BEjU6dduM6oPqWiLoyOM2duOuQZkvlVWnN0gQjBjNiA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597328496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I/ezJHDDZVX9t5zh6Wo6ZZ3cdPlLiUU7pzdzZ1d6E98=;
        b=kXca4NHSAmoLO5u1eMw1X42SCZNzhGMNhbyfiFwJRU1QKgScP/BpBm/7juKZPeeEIm3wt8
        n2dur2vPzXo0BJAg==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Adams <jwadams@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq information through metricfs
In-Reply-To: <ffeac3eb-fbd5-a605-c6a5-0456813bd918@redhat.com>
References: <20200807212916.2883031-1-jwadams@google.com> <20200807212916.2883031-7-jwadams@google.com> <87mu2yluso.fsf@nanos.tec.linutronix.de> <2500b04e-a890-2621-2f19-be08dfe2e862@redhat.com> <87a6yylp4x.fsf@nanos.tec.linutronix.de> <ffeac3eb-fbd5-a605-c6a5-0456813bd918@redhat.com>
Date:   Thu, 13 Aug 2020 16:21:34 +0200
Message-ID: <87v9hmtymp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:
> On 13/08/20 14:13, Thomas Gleixner wrote:
>>>>>    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values
>>>> What is 'TLB'? I'm not aware of any vector which is named TLB.
>>> There's a "TLB" entry in /proc/interrupts.
>> It's TLB shootdowns and not TLB.
>
> Yes but it's using the shortcut name on the left of the table.

Fair enough, that's the first column in /proc/interrupts. I totally
missed the explanation in the elaborate changelog.

Thanks,

        tglx
